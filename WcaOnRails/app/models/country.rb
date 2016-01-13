class Country
  attr_accessor :id, :name, :continentId, :latitude, :longitude, :zoom, :iso2

  def initialize(attributes={})
    @id = attributes[:id]
    @name = attributes[:name]
    @continentId = attributes[:continentId]
    @latitude = attributes[:latitude]
    @longitude = attributes[:longitude]
    @zoom = attributes[:zoom]
    @iso2 = attributes[:iso2]
  end

  def to_partial_path
    "country"
  end

  def self.find(id)
    ALL_COUNTRIES_BY_ID[id] or raise "Unrecognized country id"
  end

  def self.find_by_id(id)
    ALL_COUNTRIES_BY_ID[id]
  end

  def self.find_by_iso2(iso2)
    ALL_COUNTRIES_BY_ISO2[iso2]
  end

  def self.all
    ALL_COUNTRIES
  end

  def hash
    id.hash
  end

  def eql?(o)
    id == o.id
  end

  ALL_COUNTRIES = [
    {
      "id": "Afghanistan",
      "name": "Afghanistan",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AF"
    },
    {
      "id": "Albania",
      "name": "Albania",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AL"
    },
    {
      "id": "Algeria",
      "name": "Algeria",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "DZ"
    },
    {
      "id": "Andorra",
      "name": "Andorra",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AD"
    },
    {
      "id": "Angola",
      "name": "Angola",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AO"
    },
    {
      "id": "Anguilla",
      "name": "Anguilla",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AI"
    },
    {
      "id": "Antigua",
      "name": "Antigua",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AG"
    },
    {
      "id": "Argentina",
      "name": "Argentina",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AR"
    },
    {
      "id": "Armenia",
      "name": "Armenia",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AM"
    },
    {
      "id": "Aruba",
      "name": "Aruba",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AW"
    },
    {
      "id": "Australia",
      "name": "Australia",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AU"
    },
    {
      "id": "Austria",
      "name": "Austria",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AT"
    },
    {
      "id": "Azerbaijan",
      "name": "Azerbaijan",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AZ"
    },
    {
      "id": "Bahamas",
      "name": "Bahamas",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BS"
    },
    {
      "id": "Bahrain",
      "name": "Bahrain",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BH"
    },
    {
      "id": "Bangladesh",
      "name": "Bangladesh",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BD"
    },
    {
      "id": "Barbados",
      "name": "Barbados",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BB"
    },
    {
      "id": "Belarus",
      "name": "Belarus",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BY"
    },
    {
      "id": "Belgium",
      "name": "Belgium",
      "continentId": "_Europe",
      "latitude": 50503887,
      "longitude": 4469936,
      "zoom": 7,
      "iso2": "BE"
    },
    {
      "id": "Belize",
      "name": "Belize",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BZ"
    },
    {
      "id": "Benin",
      "name": "Benin",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BJ"
    },
    {
      "id": "Bhutan",
      "name": "Bhutan",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BT"
    },
    {
      "id": "Bolivia",
      "name": "Bolivia",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BO"
    },
    {
      "id": "Bosnia and Herzegovina",
      "name": "Bosnia and Herzegovina",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BA"
    },
    {
      "id": "Botswana",
      "name": "Botswana",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BW"
    },
    {
      "id": "Brazil",
      "name": "Brazil",
      "continentId": "_South America",
      "latitude": -14235004,
      "longitude": -51925280,
      "zoom": 4,
      "iso2": "BR"
    },
    {
      "id": "British Virgin Islands",
      "name": "British Virgin Islands",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "VG"
    },
    {
      "id": "Brunei",
      "name": "Brunei",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BN"
    },
    {
      "id": "Bulgaria",
      "name": "Bulgaria",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BG"
    },
    {
      "id": "Burkina Faso",
      "name": "Burkina Faso",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "BF"
    },
    {
      "id": "Cambodia",
      "name": "Cambodia",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "KH"
    },
    {
      "id": "Cameroon",
      "name": "Cameroon",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "CM"
    },
    {
      "id": "Canada",
      "name": "Canada",
      "continentId": "_North America",
      "latitude": 56130366,
      "longitude": -106346771,
      "zoom": 3,
      "iso2": "CA"
    },
    {
      "id": "Central African Republic",
      "name": "Central African Republic",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "CF"
    },
    {
      "id": "Chad",
      "name": "Chad",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "TD"
    },
    {
      "id": "Chile",
      "name": "Chile",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "CL"
    },
    {
      "id": "China",
      "name": "China",
      "continentId": "_Asia",
      "latitude": 35861660,
      "longitude": 104195397,
      "zoom": 4,
      "iso2": "CN"
    },
    {
      "id": "Colombia",
      "name": "Colombia",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "CO"
    },
    {
      "id": "Comoros",
      "name": "Comoros",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "KM"
    },
    {
      "id": "Congo",
      "name": "Congo",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "CG"
    },
    {
      "id": "Cook Islands",
      "name": "Cook Islands",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "CK"
    },
    {
      "id": "Costa Rica",
      "name": "Costa Rica",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "CR"
    },
    {
      "id": "Cote d_Ivoire",
      "name": "Cote d'Ivoire",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "CI"
    },
    {
      "id": "Croatia",
      "name": "Croatia",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "HR"
    },
    {
      "id": "Cuba",
      "name": "Cuba",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "CU"
    },
    {
      "id": "Cyprus",
      "name": "Cyprus",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "CY"
    },
    {
      "id": "Czech Republic",
      "name": "Czech Republic",
      "continentId": "_Europe",
      "latitude": 49817492,
      "longitude": 15472962,
      "zoom": 7,
      "iso2": "CZ"
    },
    {
      "id": "Denmark",
      "name": "Denmark",
      "continentId": "_Europe",
      "latitude": 56263920,
      "longitude": 9501785,
      "zoom": 6,
      "iso2": "DK"
    },
    {
      "id": "Djibouti",
      "name": "Djibouti",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "DJ"
    },
    {
      "id": "Dominica",
      "name": "Dominica",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "DM"
    },
    {
      "id": "Dominican Republic",
      "name": "Dominican Republic",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "DO"
    },
    {
      "id": "DR Congo",
      "name": "DR Congo",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "CD"
    },
    {
      "id": "Ecuador",
      "name": "Ecuador",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "EC"
    },
    {
      "id": "Egypt",
      "name": "Egypt",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "EG"
    },
    {
      "id": "El Salvador",
      "name": "El Salvador",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SV"
    },
    {
      "id": "Equatorial Guinea",
      "name": "Equatorial Guinea",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GQ"
    },
    {
      "id": "Eritrea",
      "name": "Eritrea",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "ER"
    },
    {
      "id": "Estonia",
      "name": "Estonia",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "EE"
    },
    {
      "id": "Ethiopia",
      "name": "Ethiopia",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "ET"
    },
    {
      "id": "Fiji",
      "name": "Fiji",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "FJ"
    },
    {
      "id": "Finland",
      "name": "Finland",
      "continentId": "_Europe",
      "latitude": 61924110,
      "longitude": 25748151,
      "zoom": 5,
      "iso2": "FI"
    },
    {
      "id": "France",
      "name": "France",
      "continentId": "_Europe",
      "latitude": 46227638,
      "longitude": 2213749,
      "zoom": 5,
      "iso2": "FR"
    },
    {
      "id": "French Guiana",
      "name": "French Guiana",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GF"
    },
    {
      "id": "French Polynesia",
      "name": "French Polynesia",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "PF"
    },
    {
      "id": "Gabon",
      "name": "Gabon",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GA"
    },
    {
      "id": "Gambia",
      "name": "Gambia",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GM"
    },
    {
      "id": "Georgia",
      "name": "Georgia",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GE"
    },
    {
      "id": "Germany",
      "name": "Germany",
      "continentId": "_Europe",
      "latitude": 51165691,
      "longitude": 10451526,
      "zoom": 5,
      "iso2": "DE"
    },
    {
      "id": "Ghana",
      "name": "Ghana",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GH"
    },
    {
      "id": "Greece",
      "name": "Greece",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GR"
    },
    {
      "id": "Grenada",
      "name": "Grenada",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GD"
    },
    {
      "id": "Guatemala",
      "name": "Guatemala",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GT"
    },
    {
      "id": "Guernsey",
      "name": "Guernsey",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GG"
    },
    {
      "id": "Guinea",
      "name": "Guinea",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GN"
    },
    {
      "id": "Guyana",
      "name": "Guyana",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "GY"
    },
    {
      "id": "Haiti",
      "name": "Haiti",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "HT"
    },
    {
      "id": "Honduras",
      "name": "Honduras",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "HN"
    },
    {
      "id": "Hong Kong",
      "name": "Hong Kong",
      "continentId": "_Asia",
      "latitude": 22396428,
      "longitude": 114109497,
      "zoom": 10,
      "iso2": "HK"
    },
    {
      "id": "Hungary",
      "name": "Hungary",
      "continentId": "_Europe",
      "latitude": 47162494,
      "longitude": 19503304,
      "zoom": 7,
      "iso2": "HU"
    },
    {
      "id": "Iceland",
      "name": "Iceland",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "IS"
    },
    {
      "id": "India",
      "name": "India",
      "continentId": "_Asia",
      "latitude": 20593684,
      "longitude": 78962880,
      "zoom": 4,
      "iso2": "IN"
    },
    {
      "id": "Indonesia",
      "name": "Indonesia",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "ID"
    },
    {
      "id": "Iran",
      "name": "Iran",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "IR"
    },
    {
      "id": "Iraq",
      "name": "Iraq",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "IQ"
    },
    {
      "id": "Ireland",
      "name": "Ireland",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "IE"
    },
    {
      "id": "Isle of Man",
      "name": "Isle of Man",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "IM"
    },
    {
      "id": "Israel",
      "name": "Israel",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "IL"
    },
    {
      "id": "Italy",
      "name": "Italy",
      "continentId": "_Europe",
      "latitude": 41871940,
      "longitude": 12567380,
      "zoom": 5,
      "iso2": "IT"
    },
    {
      "id": "Jamaica",
      "name": "Jamaica",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "JM"
    },
    {
      "id": "Japan",
      "name": "Japan",
      "continentId": "_Asia",
      "latitude": 36204824,
      "longitude": 138252924,
      "zoom": 5,
      "iso2": "JP"
    },
    {
      "id": "Jordan",
      "name": "Jordan",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "JO"
    },
    {
      "id": "Kazakhstan",
      "name": "Kazakhstan",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "KZ"
    },
    {
      "id": "Kenya",
      "name": "Kenya",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "KE"
    },
    {
      "id": "Kiribati",
      "name": "Kiribati",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "KI"
    },
    {
      "id": "Korea",
      "name": "Korea",
      "continentId": "_Asia",
      "latitude": 35907757,
      "longitude": 127766922,
      "zoom": 6,
      "iso2": "KR"
    },
    {
      "id": "Kosovo",
      "name": "Kosovo",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "XK"
    },
    {
      "id": "Kuwait",
      "name": "Kuwait",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "KW"
    },
    {
      "id": "Laos",
      "name": "Laos",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "LA"
    },
    {
      "id": "Latvia",
      "name": "Latvia",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "LV"
    },
    {
      "id": "Lebanon",
      "name": "Lebanon",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "LB"
    },
    {
      "id": "Lesotho",
      "name": "Lesotho",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "LS"
    },
    {
      "id": "Liberia",
      "name": "Liberia",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "LR"
    },
    {
      "id": "Libya",
      "name": "Libya",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "LY"
    },
    {
      "id": "Lithuania",
      "name": "Lithuania",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "LT"
    },
    {
      "id": "Luxembourg",
      "name": "Luxembourg",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "LU"
    },
    {
      "id": "Macau",
      "name": "Macau",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MO"
    },
    {
      "id": "Macedonia",
      "name": "Macedonia",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MK"
    },
    {
      "id": "Madagascar",
      "name": "Madagascar",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MG"
    },
    {
      "id": "Malawi",
      "name": "Malawi",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MW"
    },
    {
      "id": "Malaysia",
      "name": "Malaysia",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MY"
    },
    {
      "id": "Mali",
      "name": "Mali",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "ML"
    },
    {
      "id": "Malta",
      "name": "Malta",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MT"
    },
    {
      "id": "Marshall Islands",
      "name": "Marshall Islands",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MH"
    },
    {
      "id": "Mauritania",
      "name": "Mauritania",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MR"
    },
    {
      "id": "Mauritius",
      "name": "Mauritius",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MU"
    },
    {
      "id": "Mayotte",
      "name": "Mayotte",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "YT"
    },
    {
      "id": "Mexico",
      "name": "Mexico",
      "continentId": "_North America",
      "latitude": 23634501,
      "longitude": -102552784,
      "zoom": 5,
      "iso2": "MX"
    },
    {
      "id": "Moldova",
      "name": "Moldova",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MD"
    },
    {
      "id": "Monaco",
      "name": "Monaco",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MC"
    },
    {
      "id": "Mongolia",
      "name": "Mongolia",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MN"
    },
    {
      "id": "Montenegro",
      "name": "Montenegro",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "ME"
    },
    {
      "id": "Morocco",
      "name": "Morocco",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MA"
    },
    {
      "id": "Mozambique",
      "name": "Mozambique",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MZ"
    },
    {
      "id": "Myanmar",
      "name": "Myanmar",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "MM"
    },
    {
      "id": "Namibia",
      "name": "Namibia",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "NA"
    },
    {
      "id": "Nauru",
      "name": "Nauru",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "NR"
    },
    {
      "id": "Nepal",
      "name": "Nepal",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "NP"
    },
    {
      "id": "Netherlands",
      "name": "Netherlands",
      "continentId": "_Europe",
      "latitude": 52132633,
      "longitude": 5291266,
      "zoom": 7,
      "iso2": "NL"
    },
    {
      "id": "New Caledonia",
      "name": "New Caledonia",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "NC"
    },
    {
      "id": "New Zealand",
      "name": "New Zealand",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "NZ"
    },
    {
      "id": "Nicaragua",
      "name": "Nicaragua",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "NI"
    },
    {
      "id": "Niger",
      "name": "Niger",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "NE"
    },
    {
      "id": "Nigeria",
      "name": "Nigeria",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "NG"
    },
    {
      "id": "Niue",
      "name": "Niue",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "NU"
    },
    {
      "id": "North Korea",
      "name": "North Korea",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "KP"
    },
    {
      "id": "Norway",
      "name": "Norway",
      "continentId": "_Europe",
      "latitude": 65146114,
      "longitude": 13183593,
      "zoom": 4,
      "iso2": "NO"
    },
    {
      "id": "Oman",
      "name": "Oman",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "OM"
    },
    {
      "id": "Pakistan",
      "name": "Pakistan",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "PK"
    },
    {
      "id": "Palestine",
      "name": "Palestine",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "PS"
    },
    {
      "id": "Panama",
      "name": "Panama",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "PA"
    },
    {
      "id": "Papua New Guinea",
      "name": "Papua New Guinea",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "PG"
    },
    {
      "id": "Paraguay",
      "name": "Paraguay",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "PY"
    },
    {
      "id": "Peru",
      "name": "Peru",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "PE"
    },
    {
      "id": "Philippines",
      "name": "Philippines",
      "continentId": "_Asia",
      "latitude": 12879721,
      "longitude": 121774017,
      "zoom": 5,
      "iso2": "PH"
    },
    {
      "id": "Pitcairn Islands",
      "name": "Pitcairn Islands",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "PN"
    },
    {
      "id": "Poland",
      "name": "Poland",
      "continentId": "_Europe",
      "latitude": 51919438,
      "longitude": 19145136,
      "zoom": 6,
      "iso2": "PL"
    },
    {
      "id": "Portugal",
      "name": "Portugal",
      "continentId": "_Europe",
      "latitude": 39399872,
      "longitude": -8224454,
      "zoom": 6,
      "iso2": "PT"
    },
    {
      "id": "Puerto Rico",
      "name": "Puerto Rico",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "PR"
    },
    {
      "id": "Qatar",
      "name": "Qatar",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "QA"
    },
    {
      "id": "Romania",
      "name": "Romania",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "RO"
    },
    {
      "id": "Russia",
      "name": "Russia",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "RU"
    },
    {
      "id": "Saint Kitts and Nevis",
      "name": "Saint Kitts and Nevis",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "KN"
    },
    {
      "id": "Saint Lucia",
      "name": "Saint Lucia",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "LC"
    },
    {
      "id": "Saint Vincent and the Grenadines",
      "name": "Saint Vincent and the Grenadines",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "VC"
    },
    {
      "id": "Samoa",
      "name": "Samoa",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "WS"
    },
    {
      "id": "San Marino",
      "name": "San Marino",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SM"
    },
    {
      "id": "Sao Tome and Principe",
      "name": "Sao Tome and Principe",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "ST"
    },
    {
      "id": "Saudi Arabia",
      "name": "Saudi Arabia",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SA"
    },
    {
      "id": "Senegal",
      "name": "Senegal",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SN"
    },
    {
      "id": "Serbia",
      "name": "Serbia",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "RS"
    },
    {
      "id": "Sierra Leone",
      "name": "Sierra Leone",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SL"
    },
    {
      "id": "Singapore",
      "name": "Singapore",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SG"
    },
    {
      "id": "Slovakia",
      "name": "Slovakia",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SK"
    },
    {
      "id": "Slovenia",
      "name": "Slovenia",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SI"
    },
    {
      "id": "Solomon Islands",
      "name": "Solomon Islands",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SB"
    },
    {
      "id": "Somalia",
      "name": "Somalia",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SO"
    },
    {
      "id": "South Africa",
      "name": "South Africa",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "ZA"
    },
    {
      "id": "South Sudan",
      "name": "South Sudan",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SS"
    },
    {
      "id": "Spain",
      "name": "Spain",
      "continentId": "_Europe",
      "latitude": 40463667,
      "longitude": -3749220,
      "zoom": 6,
      "iso2": "ES"
    },
    {
      "id": "Sri Lanka",
      "name": "Sri Lanka",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "LK"
    },
    {
      "id": "Sudan",
      "name": "Sudan",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SD"
    },
    {
      "id": "Suriname",
      "name": "Suriname",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SR"
    },
    {
      "id": "Swaziland",
      "name": "Swaziland",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SZ"
    },
    {
      "id": "Sweden",
      "name": "Sweden",
      "continentId": "_Europe",
      "latitude": 60128161,
      "longitude": 18643501,
      "zoom": 4,
      "iso2": "SE"
    },
    {
      "id": "Switzerland",
      "name": "Switzerland",
      "continentId": "_Europe",
      "latitude": 46818188,
      "longitude": 8227512,
      "zoom": 7,
      "iso2": "CH"
    },
    {
      "id": "Syria",
      "name": "Syria",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "SY"
    },
    {
      "id": "Taiwan",
      "name": "Taiwan",
      "continentId": "_Asia",
      "latitude": 23697810,
      "longitude": 120960515,
      "zoom": 7,
      "iso2": "TW"
    },
    {
      "id": "Tanzania",
      "name": "Tanzania",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "TZ"
    },
    {
      "id": "Thailand",
      "name": "Thailand",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "TH"
    },
    {
      "id": "Togo",
      "name": "Togo",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "TG"
    },
    {
      "id": "Tonga",
      "name": "Tonga",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "TO"
    },
    {
      "id": "Trinidad and Tobago",
      "name": "Trinidad and Tobago",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "TT"
    },
    {
      "id": "Tunisia",
      "name": "Tunisia",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "TN"
    },
    {
      "id": "Turkey",
      "name": "Turkey",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "TR"
    },
    {
      "id": "Turks and Caicos Islands",
      "name": "Turks and Caicos Islands",
      "continentId": "_North America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "TC"
    },
    {
      "id": "Tuvalu",
      "name": "Tuvalu",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "TV"
    },
    {
      "id": "Uganda",
      "name": "Uganda",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "UG"
    },
    {
      "id": "Ukraine",
      "name": "Ukraine",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "UA"
    },
    {
      "id": "United Arab Emirates",
      "name": "United Arab Emirates",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "AE"
    },
    {
      "id": "United Kingdom",
      "name": "United Kingdom",
      "continentId": "_Europe",
      "latitude": 55378051,
      "longitude": -3435973,
      "zoom": 5,
      "iso2": "GB"
    },
    {
      "id": "Uruguay",
      "name": "Uruguay",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "UY"
    },
    {
      "id": "USA",
      "name": "USA",
      "continentId": "_North America",
      "latitude": 37090240,
      "longitude": -95712891,
      "zoom": 4,
      "iso2": "US"
    },
    {
      "id": "Vanuatu",
      "name": "Vanuatu",
      "continentId": "_Oceania",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "VU"
    },
    {
      "id": "Venezuela",
      "name": "Venezuela",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "VE"
    },
    {
      "id": "Vietnam",
      "name": "Vietnam",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "VN"
    },
    {
      "id": "XA",
      "name": "Multiple Countries (Asia)",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "XA"
    },
    {
      "id": "XE",
      "name": "Multiple Countries (Europe)",
      "continentId": "_Europe",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "XE"
    },
    {
      "id": "XS",
      "name": "Multiple Countries (South America)",
      "continentId": "_South America",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "XS"
    },
    {
      "id": "Yemen",
      "name": "Yemen",
      "continentId": "_Asia",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "YE"
    },
    {
      "id": "Zambia",
      "name": "Zambia",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "ZM"
    },
    {
      "id": "Zimbabwe",
      "name": "Zimbabwe",
      "continentId": "_Africa",
      "latitude": 0,
      "longitude": 0,
      "zoom": 0,
      "iso2": "ZW"
    },
  ].map { |e| Country.new(e) }

  ALL_COUNTRIES_BY_ID = Hash[ALL_COUNTRIES.map { |e| [e.id, e] }]
  ALL_COUNTRIES_BY_ISO2 = Hash[ALL_COUNTRIES.map { |e| [e.iso2, e] }]
end
