import re
import string

class rotex_solaris

	var language
	var rx_pin
	var baud_rate
	var ser
	var values
	var array_mapping
	var translations

  # intialize the serial port, if unspecified Tx/Rx are GPIO 21/25
  def init()
    self.language = "de"
	self.rx_pin = 25
	self.baud_rate = 19200
	
	self.ser = serial(self.rx_pin, -1, self.baud_rate, serial.SERIAL_8N1)
	
	self.array_mapping = {	"solaris_ha":0,
							"solaris_bk":1,
							"solaris_p1":2,
							"solaris_p2":3,
							"solaris_tk":4,
							"solaris_tr":5,
							"solaris_ts":6,
							"solaris_tv":7,
							"solaris_v":8,
							"solaris_error":9,
							"solaris_p":10
						}
# enable this for de								
	self.translations = {
							"solaris_ha":"Ha Manual to Automatic return (Ha)", 
							"solaris_bk":"Brennerkontakt aktiv (Bk)", 
							"solaris_p1":"Zirkulationspumpe Leistungsstufe (P1)",
							"solaris_p2":"Booster Pumpe aktiv (P2)",
							"solaris_tk":"Solaris Kollektortemperatur (Tk)",
							"solaris_tr":"Temperatur Rücklauf (Tr)",
							"solaris_ts":"Temperatur Speicher (Ts)",
							"solaris_tv":"Temperatur Fluss (Tv)",
							"solaris_v":"Durchfluss (V)",
							"solaris_error":"Fehler Ort",
							"solaris_p":"Leistung"
						}
# enable this for en						
#	self.translations = {
#							"solaris_ha":"Ha Manual to Automatic return (Ha)", 
#							"solaris_bk":"Burner Contact Enable (Bk)", 
#							"solaris_p1":"Circulation Pump Rate (P1)",
#							"solaris_p2":"Booster Pump Enabled (P2)",
#							"solaris_tk":"Temperature collector (Tk)",
#							"solaris_tr":"Temperature Return(Tk)",
#							"solaris_ts":"Temperature Storage (Ts)",
#							"solaris_tv":"Temperature Flow (Tv)",
#							"solaris_v":"Flow Rate (V)",
#							"solaris_error":"Error Location",
#							"solaris_p":"Power"
#						}
	
	
  end


  #- add sensor value to teleperiod -#
  def json_append()
    if !self.values return nil end  #- exit if not initialized -#

    var msg = string.format(",\"SOLARIS\":{"..
											"\"ha\":%.2f,"..
											"\"bk\":%i,"..
											"\"p1\":%.2f,"..
											"\"p2\":%.2f,"..
											"\"tk\":%.2f,"..
											"\"tr\":%.2f,"..
											"\"ts\":%.2f,"..
											"\"tv\":%.2f,"..
											"\"v\":%.2f,"..
											"\"p\":%i"..
											"}",
											self.values[self.array_mapping['solaris_ha']],
											self.values[self.array_mapping['solaris_bk']],
											self.values[self.array_mapping['solaris_p1']],
											self.values[self.array_mapping['solaris_p2']],
											self.values[self.array_mapping['solaris_tk']],
											self.values[self.array_mapping['solaris_tr']],
											self.values[self.array_mapping['solaris_ts']],
											self.values[self.array_mapping['solaris_tv']],
											self.values[self.array_mapping['solaris_v']],
											self.values[self.array_mapping['solaris_p']])
    tasmota.response_append(msg)
  end

  #- display sensor value in the web UI -#
  def web_sensor()
    if !self.values return nil end  #- exit if not initialized -#

    var msg = string.format(
             "{s}"..self.translations['solaris_tk'].."{m}%.2f °C{e}"..
             "{s}"..self.translations['solaris_p1'].."{m}%.2f {e}"..
             "{s}"..self.translations['solaris_p2'].."{m}%.2f {e}"..
			 "{s}"..self.translations['solaris_v'].."{m}%.2f l/min{e}"..
			 "{s}"..self.translations['solaris_tv'].."{m}%.2f °C{e}"..
             "{s}"..self.translations['solaris_ts'].."{m}%.2f °C{e}"..
             "{s}"..self.translations['solaris_tr'].."{m}%.2f °C{e}"..
			 "{s}"..self.translations['solaris_p'].."{m}%i W{e}",
              self.values[self.array_mapping['solaris_tk']],
			  self.values[self.array_mapping['solaris_p1']],
			  self.values[self.array_mapping['solaris_p2']],
			  self.values[self.array_mapping['solaris_v']],
			  self.values[self.array_mapping['solaris_tv']],
			  self.values[self.array_mapping['solaris_ts']],
			  self.values[self.array_mapping['solaris_tr']],
			  self.values[self.array_mapping['solaris_p']] 
			  )
    tasmota.web_send_decimal(msg)
  end


  def read_data()
	var msg = self.ser.read()   # read bytes from serial as bytes
	if size(msg) > 0
		self.values = re.split(';', string.replace(msg.asstring(),"\r\n",""))
		self.ser.flush()
	end
  end

  def every_second()
	self.read_data()
  end
end


d1 = rotex_solaris()
d1.init()
tasmota.add_driver(d1)
