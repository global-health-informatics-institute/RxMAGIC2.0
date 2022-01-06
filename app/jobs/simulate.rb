def start
    puts "Starting to create simulated data"
    create_patients    
    create_prescriber
    create_stock
    puts "Completed simulating data"
end

def create_stock
    puts "Creating general inventory"

    options = Rxnconso.where({TTY: "SCD", :SUPPRESS => "N"}).where("STR LIKE ?", "%Tablet%").limit(10)
    mfn_options = Manufacturer.all
    for item in options
        limit = rand(30)
        for i in 0..limit
            new_item = GeneralInventory.new()
            new_item.rxaui = item.RXAUI
            new_item.lot_number = (1..9).to_a.sample(3).join() + ('A'..'Z').to_a.sample(2).join()
            new_item.manufacturer_id = mfn_options[rand(mfn_options.length)].id
            new_item.expiration_date = Date.today.advance(:days => rand(450))
            new_item.date_received = Date.today.advance(:days => -rand(150))
            new_item.received_quantity = rand(15)*10
            new_item.current_quantity = new_item.received_quantity
            new_item.save()
        end
    end
end

def create_prescriptions

    pt_options = Patient.count
    pr_options = Provider.count
    options = Rxnconso.where(:TTY => "SCD").limit(20)
    puts "Creating prescriptions"

    for i in 1..35
        new_rx = Prescription.new()
        new_rx.patient_id = Patient.find(rand(pt_options))
        new_rx.rxaui = options[rand(options.length)].RXAUI
        new_rx.date_prescribed = Date.today.advance(:days => -rand(30))
        new_rx.quantity = rand(60)
        new_rx.directions = random_directions
        new_rx.provider_id = Provider.find(rand(pr_options))
        new_rx.save()
    end
end

def create_dispensations
end

def create_patients
    puts "Creating patients"

    for i in 1..100
        address = addresses
        new_patient = Patient.new()
        new_patient.gender = ['F','M'].sample()
        new_patient.first_name = (new_patient.gender == "F" ? female_names : male_names)
        new_patient.last_name = last_names
        new_patient.birthdate = Date.today.advance(:days => rand(450), :years => -rand(60))
        new_patient.mrn = "PTN" + (0..9).to_a.sample(5).join()
        new_patient.address = address[0]
        new_patient.city = address[1]
        new_patient.state = ('A'..'Z').to_a.sample(2).join()
        new_patient.zip = address[2].sub(" ", "-")
        new_patient.phone = address[3].sub(" ", "")
        new_patient.save()
    end
end

def create_prescriber
    
    puts "Creating Providers"
    for i in 1..5
        new_provider = Provider.new()
        new_provider.first_name = (['F','M'].sample() == "F" ? female_names : male_names)
        new_provider.last_name = last_names()
        new_provider.save() 
    end
end

def random_directions
    directions = ['Take 2 tablets by mouth daily','Take 3 tablets by mouth daily','Take 1 tablet by mouth 3 times a day',
                  'Take 1 tablet by mouth daily', 'Take 2 tablets by mouth 3 times a day']
  
    return directions[rand(directions.length)]
end 

def last_names
    names = ["Abraham","Allan","Alsop","Anderson","Arnold","Avery","Bailey","Baker","Ball","Bell","Berry","Black","Blake","Bond",
    "Bower","Brown","Buckland","Burgess","Butler","Cameron","Campbell","Carr","Chapman","Churchill","Clark","Clarkson","Coleman",
    "Cornish","Davidson","Davies","Dickens","Dowd","Duncan","Dyer","Edmunds","Ellison","Ferguson","Fisher","Forsyth","Fraser",
    "Gibson","Gill","Glover","Graham","Grant","Gray","Greene","Hamilton","Hardacre","Harris","Hart","Hemmings","Henderson","Hill",
    "Hodges","Howard","Hudson","Hughes","Hunter","Ince","Jackson","James","Johnston","Jones","Kelly","Kerr","King","Knox","Lambert",
    "Langdon","Lawrence","Lee","Lewis","Lyman","MacDonald","Mackay","Mackenzie","MacLeod","Manning","Marshall","Martin","Mathis","May",
    "McDonald","McLean","McGrath","Metcalfe","Miller","Mills","Mitchell","Morgan","Morrison","Murray","Nash","Newman","Nolan","North",
    "Ogden","Oliver","Paige","Parr","Parsons","Paterson","Payne","Peake","Peters","Piper","Poole","Powell","Pullman","Quinn","Rampling",
    "Randall","Rees","Reid","Roberts","Robertson","Ross","Russell","Rutherford","Sanderson","Scott","Sharp","Short","Simpson","Skinner",
    "Slater","Smith","Springer","Stewart","Sutherland","Taylor","Terry","Thomson","Tucker","Turner","Underwood","Vance","Vaughan","Walker",
    "Wallace","Walsh","Watson","Welch","White","Wilkins","Wilson","Wright","Young"]

    return names[rand(names.length)]
end

def female_names
    names = ["Abigail","Alexandra","Alison","Amanda","Amelia","Amy","Andrea","Angela","Anna","Anne","Audrey","Ava","Bella",
    "Bernadette","Carol","Caroline","Carolyn","Chloe","Claire","Deirdre","Diana","Diane","Donna","Dorothy","Elizabeth","Ella",
    "Emily","Emma","Faith","Felicity","Fiona","Gabrielle","Grace","Hannah","Heather","Irene","Jan","Jane","Jasmine","Jennifer",
    "Jessica","Joan","Joanne","Julia","Karen","Katherine","Kimberly","Kylie","Lauren","Leah","Lillian","Lily","Lisa","Madeleine",
    "Maria","Mary","Megan","Melanie","Michelle","Molly","Natalie","Nicola","Olivia","Penelope","Pippa","Rachel","Rebecca","Rose",
    "Ruth","Sally","Samantha","Sarah","Sonia","Sophie","Stephanie","Sue","Theresa","Tracey","Una","Vanessa","Victoria","Virginia",
    "Wanda","Wendy","Yvonne","Zoe"]

    return names[rand(names.length)]
end

def male_names
    names = ["Adam","Adrian","Alan","Alexander","Andrew","Anthony","Austin","Benjamin","Blake","Boris","Brandon","Brian","Cameron",
    "Carl","Charles","Christian","Christopher","Colin","Connor","Dan","David","Dominic","Dylan","Edward","Eric","Evan","Frank","Gavin",
    "Gordon","Harry","Ian","Isaac","Jack","Jacob","Jake","James","Jason","Joe","John","Jonathan","Joseph","Joshua","Julian","Justin",
    "Keith","Kevin","Leonard","Liam","Lucas","Luke","Matt","Max","Michael","Nathan","Neil","Nicholas","Oliver","Owen","Paul","Peter",
    "Phil","Piers","Richard","Robert","Ryan","Sam","Sean","Sebastian","Simon","Stephen","Steven","Stewart","Thomas","Tim","Trevor",
    "Victor","Warren","William"]

    return names[rand(names.length)]
end

def addresses
    address_list = [["11 Kerr Close"," Knebworth","SG3 6AL","+438672685"],["18 Oak Grove"," Barnetby","DN38 6DB","+652721217"],
    ["1 Maes Tegid"," Prestatyn","LL19 8ST","+745124518"],["4 Hermitage Court"," Poundbury","DT1 3SR","+305634550"],
    ["99 Leeds Road"," Liversedge","WF15 6AB","+484576482"],["17 Skiddaw Close"," Worcester","WR4 9HU","+905517313"],
    ["147 Abercynon Road"," Abercynon","CF45 4LY","+443383074"],["7 Ashfield Mews"," Hazlerigg","NE13 7FD","+946774585"],
    ["Herons Lodge"," Llangyndeyrn","SA17 5EN","+267521528"],["29 Beacon Lough Road"," Gateshead","NE9 6YS","+91280 0036"],
    ["5 The Drive"," Buckhurst Hill","IG9 5RB","+708865764"],["23 Jerome Close"," Eastbourne","BN23 7QY","+323278115"],
    ["1 Hackett Close"," Stoke-On-Trent","ST3 1LP","+782211037"],["8 The Bricky"," Peacehaven","BN10 8PQ","+273468460"],
    ["3 The Pickerings"," Lostock Hall","PR5 5UZ","+772358518"],["10 Plover Close"," Alcester","B49 6AF","+527754341"],
    ["6 Oaks Dene"," Chatham","ME5 9HN","+622430012"],["78 Ramsbury Drive"," Liverpool","L24 1WB","+928403814"],
    ["180 Hersham Road"," Hersham","KT12 5QE","+372706255"],["8 White Elm Road"," Woolpit","IP30 9SQ","+359053465"],
    ["33 St Johns Avenue"," Northampton","NN2 8QZ","+604837345"],["7 Etloe Road"," Bristol","BS6 7PG","+17663 5652"],
    ["27 Town Lane"," Little Neston","CH64 4DE","+352486574"],["82 Bramley Way"," Mayland","CM3 6ET","+621166175"],
    ["183 Prebendal Avenue"," Aylesbury","HP21 8LD","+296534145"],["6 Forge Lane"," Whitfield","CT16 3LB","+304773667"],
    ["18 Twickenham Close"," Hull","HU8 9FA","+482333228"],["17 Bell Street"," Crook","DL15 8NQ","+388323368"],
    ["39 Palgrave Road"," Great Yarmouth","NR30 1QA","+493158508"],["1 Archway Cottages"," Hassocks","BN6 8HQ","+444033478"],
    ["4 Havelock Mews"," East Sleekburn","NE22 7DP","+670075300"],["6 Manor Road"," Burscough","L40 7TN","+695013686"],
    ["31 Hatfield Road"," Thorne","DN8 5RA","+405427223"],["77 Marlborough Place"," Eynsham","OX29 4NE","+993174424"],
    ["2 Langdon Shaw"," Sidcup","DA14 6AU","+689215328"],["8 Berwick Road"," Bristol","BS5 6NG","+177254566"],
    ["11 Hall Lane"," Coventry","CV2 2AU","+2425861460"],["4 Clay Acre"," Chesham","HP5 3BL","+442728070"],
    ["152 Starling Road"," Bury","BL8 2HJ","+204888473"],["3 Goodwins Close"," Littlebury","CB11 4TU","+799624088"],
    ["4 Ringwood Road"," Headington","OX3 8JA","+865333814"],["2 Rosewarne Gate"," Camborne","TR14 0AB","+209247256"],
    ["3 Rose Bank Close"," Little Corby","CA4 8QZ","+697063663"],["18 Acton Close"," Redditch","B98 9HP","+527780237"],
    ["3 Meadow Lane"," Southrepps","NR11 8NX","+263515744"],["16 London Road"," Brentwood","CM14 4QG","+277166332"],
    ["26 Church Gate"," Horsforth","LS18 5TL","+943744511"],["3 Rodney Close"," Solihull","B92 8RU","+675088508"],
    ["1 Eastford Road"," Warrington","WA4 6EX","+925401627"],["8 Bosley Drive"," Poynton","SK12 1UX","+663513237"],
    ["13 Tentelow Lane"," Southall","UB2 4LQ","+895701173"],["44 Cranbrook Road"," Bexleyheath","DA7 5EY","+322154123"],
    ["1 Sunnymead"," Bridgwater","TA6 6JR","+278605828"],["46 Moorgate"," London","EC2R 6EL","+202061 0684"],
    ["15 Broadmoor Road"," Bilston","WV14 0RN","+902318531"],["Mead House"," Houghton","SO20 6LY","+794621558"],
    ["95 Wellhouse Lane"," Mirfield","WF14 0NS","+484620237"],["75 Selby Road"," Liverpool","L9 8EB","+51751 1220"],
    ["34 Water Lane"," Purfleet","RM19 1GS","+322633543"],["12 Regency Road"," Mirfield","WF14 8AJ","+484038303"],
    ["84 Richard Williams Road"," Wednesbury","WS10 0QS","+922135053"],["63 Hassop Road"," Birmingham","B42 2SD","+21215 3512"],
    ["311 Ashford Road"," Staines","TW18 1QJ","+784206742"],["23 The Crescent"," Rowlands Gill","NE39 1JL","+661443081"],
    ["18 Aspen Gardens"," Poole","BH12 4DE","+202062621"],["49 Woolsbridge Road"," St Leonards","BH24 2LT","+425415716"],
    ["6 The Beachings"," Pevensey Bay","BN24 6JF","+323768571"],["72 Christchurch Road"," Tilbury","RM18 7RD","+474544437"],
    ["2 Hancox Farm Cottages"," Whatlington","TN33 0NX","+424783050"],["11 Waterfall Close"," London","N14 7JR","+2025714072"],
    ["8 Morpeth Avenue"," Wideopen","NE13 6ND","+946723076"],["4 Moorlands Close"," Melbourn","SG8 6FF","+763213422"],
    ["10 Bathurst Walk"," Iver","SL0 9AZ","+895565187"],["2 Dove Bank"," Kirkby-In-Furness","LA17 7XD","+229870438"],
    ["Tynewyddysgellog"," Rhosgoch","LL66 0AP","+407068506"],["89 Almondbury Bank"," Huddersfield","HD5 8HA","+484050832"],
    ["161 Severne Road"," Acocks Green","B27 7HP","+21278 8571"],["Tollgate Cottage"," Ladbroke","CV47 2BY","+926415216"],
    ["49 The Garstons"," Bookham","KT23 3DT","+306728557"],["88 Westons Hill Drive"," Emersons Green","BS16 7DN","+454604347"],
    ["42 Westhead Road"," Croston","PR26 9RR","+257274034"],["4B Queens Place"," Chester","CH1 3LN","+244470508"],
    ["8 Burlington Street"," Manchester","M15 6HQ","+61214 6335"],["23B Moor End"," Spondon","DE21 7ED","+332676248"],
    ["10 Gilpin Road"," London","E5 0HL","(0203113 8361"],["2 Farm Way"," Buckhurst Hill","IG9 5AH","+708451138"],
    ["5 Chestnut Walk"," Groby","LE6 0EU","+16030 2085"],["131 Hoyle Street"," Warrington","WA5 0LP","+925128162"],
    ["33 Western Way"," Whitley Bay","NE26 1JE","+946775662"],["84 Brackendale Avenue"," Basildon","SS13 3BE","+268647086"],
    ["518 Durham Road"," Gateshead","NE9 6HU","+91886 5182"],["3 Ransom Road"," Nottingham","NG3 3LH","+15455 6784"],
    ["6 Onslow Mews West"," London","SW7 3AF","+207185 8038"],["8 Barclay Avenue"," Tonbridge","TN10 4LN","+892817453"],
    ["36 Wentworth Close"," Ripley","GU23 6DB","+932724313"],["5 Leslie Yoxall Drive"," Loughborough","LE11 2GH","+509763626"],
    ["5 Scoldens Close"," Modbury","PL21 0SN","+548078381"],["21 Broadway Street"," Oldham","OL8 1LP","+706703521"],
    ["77 Biscot Road"," Luton","LU3 1XS","+582802584"],["Ashlea"," Ashampstead","RG8 8RT","+635883770"],
    ["202 Crossley Lane"," Mirfield","WF14 0PA","+484421213"],["30 Heaton Grove"," Bradford","BD9 4DZ","+274486288"],
    ["189 Bramley Road"," London","N14 4XA","+992865358"],["95 Maltings Way"," Bury St Edmunds","IP32 6EZ","+284680670"],
    ["Royal Oak"," Rushton Spencer","SK11 0SE","+260210532"],["52 Parliament Road"," Middlesbrough","TS1 4LA","+642242453"],
    ["4 Rivermead Walk"," Godalming","GU7 1GL","+483381035"],["50 Cunningham Crescent"," Birchington","CT7 9LF","+843383408"],
    ["27 Wavendon Close"," Walsgrave On Sowe","CV2 2TJ","+2444655060"],["167 Weelsby Road"," Grimsby","DN32 9RX","+472462485"],
    ["Hill Grove"," Shobdon","HR6 9NQ","+568436573"],["12 Selby Chase"," Ruislip","HA4 9AX","+895348788"],
    ["290A Essex Road"," London","N1 3AR","(0204312 6086"],["79 Farringdon Road"," North Shields","NE30 3EZ","+946730274"],
    ["21 Seabrook Gardens"," Romford","RM7 0EU","+708607423"],["2 Woodstock Rise"," Hasland","S41 0HT","+246227365"],
    ["10 Briery Close"," Windermere","LA23 1NB","+539432501"],["1 Birley Close"," Timperley","WA15 6LA","+61014 2380"],
    ["16 Chumleigh Walk"," Surbiton","KT5 8BW","+372871575"],["The Old Post Office"," Laverton","WR12 7NA","+386340645"],
    ["Glebe House"," Nolton Haven","SA62 3NW","+646480354"],["9 Meadow Drive"," Gressenhall","NR20 4LR","+362636554"],
    ["83 High Street"," Arlesey","SG15 6SW","+462627035"],["66 Boxtree Road"," Harrow","HA3 6TH","+923404002"],
    ["198 High Street"," Street","BA16 0NH","+458542378"],["83 Morehall Avenue"," Folkestone","CT19 4EE","+303300625"],
    ["8 Kimmerstone Road"," Newcastle Upon Tyne","NE13 9AS","+946744711"],["98 Newport Road"," Barnstaple","EX32 9BA","+271811013"],
    ["1 Brook House"," Dolau","LD1 5TB","+597011154"],["10 Longacre"," Clevedon","BS21 7YX","+275381067"],
    ["18 Athos Road"," Canvey Island","SS8 8EQ","+702005764"],["3 Willowherb Close"," Liverpool","L26 7XR","+928308125"],
    ["48 Clyfton Crescent"," Immingham","DN40 2BN","+469241046"],["15 Sandringham Close"," Towcester","NN12 6TE","+280381645"],
    ["14 Kesteven Way"," Corby","NN18 8GG","+536808375"],["77 Ellesmere Road"," Berkhamsted","HP4 2ET","+442005025"],
    ["18 Fleury Crescent"," Sheffield","S14 1QR","+14468 8266"],["43 Breach Road"," Coalville","LE67 3SB","+530285470"],
    ["14 Heol Fach"," Caerbryn","SA18 3DJ","+269852475"],["24 Crouch Lane"," Seaford","BN25 1PU","+323101017"],
    ["64 Moordown Avenue"," Solihull","B92 8QN","+21467 3103"],["7 Appleby Avenue"," Middlesbrough","TS3 8EZ","+642771661"],
    ["35 Oxlip Way"," Stowupland","IP14 4DT","+449107363"],["1 Yarrow Close"," Emersons Green","BS16 7NN","+454278866"],
    ["90 Shakespeare Crescent"," London","E12 6LP","+708747036"],["121 Steyning Road"," Birmingham","B26 1JD","+21151 2773"],
    ["1 Peakdale Road"," Marple","SK6 7HW","+663435150"],["16 Star Close"," Tipton","DY4 7LP","+384871481"],
    ["7 Ridley Avenue"," Sunderland","SR2 0SF","+91077 2311"],["19 Stad Bryn Goleu"," Tyn-Y-Gongl","LL74 8QF","+248471482"],
    ["Tynyraelgerth"," Llanberis","LL55 4SS","+286041133"],["6 Maree Close"," Sunderland","SR3 2QZ","+91725 6370"],
    ["2 Ramsey Close"," Luton","LU4 0PN","+582131202"],["24 Hazel Grove"," Marton In Cleveland","TS7 8DJ","+642131486"],
    ["41 James Watt Avenue"," Corby","NN17 1BU","+536683165"],["13 Chapel Lane"," Carlton","S71 3LE","+226787403"],
    ["91 Raynel Drive"," Leeds","LS16 6BP","+13867 0067"],["43 Main Street"," Hemington","DE74 2SQ","+509800827"],
    ["26 Dellsome Lane"," Welham Green","AL9 7NF","+727774756"],["21 Tuppenney Close"," Hastings","TN35 5QJ","+424128882"],
    ["16 Court Green Close"," Cloughton","YO13 0AP","+723315643"],["65 Lower Compton Road"," Plymouth","PL3 5DN","+752212652"],
    ["2 Brayton Gardens"," Enfield","EN2 7LL","+992730372"],["2 Idlerocks"," Moddershall","ST15 8RR","+782812712"],
    ["Unit 2 Oakengrove Road"," Hazlemere","HP15 7LH","+494717721"],["18 Croft House Road"," Morley","LS27 8PB","+13543 1518"],
    ["74 Fore Street"," Ilfracombe","EX34 9ED","+271435423"],["44 Archers Close"," Birmingham","B23 5XW","+21532 1641"],
    ["25 Bishops Gate"," Lytham St. Annes","FY8 4FR","+253068532"],["40 Ringley Road West"," Radcliffe","M26 1DJ","+204851188"],
    ["23 Stourton Road"," Witham","CM8 2EZ","+621147007"],["9 Farm Avenue"," Adlington","PR6 9ND","+257765432"],
    ["4 Oakfield Drive"," South Walsham","NR13 6EH","+603344648"],["16 Lower Terrace"," Treorchy","CF42 6HP","+443715041"],
    ["68 Manor Road"," Stretford","M32 9JB","+61648 2856"],["10 Courtfield Avenue"," Chatham","ME5 8QT","+622247250"],
    ["19 Lower Parc Estate"," Gweek","TR12 7AG","+326154010"],["3 Prinstead Close"," Winchester","SO23 9NS","+962046372"],
    ["1285 Greenford Road"," Greenford","UB6 0HY","+895235413"],["1 Preston Court Cottages"," Preston","CT3 1DH","+227332153"],
    ["11 Grange Avenue"," Hatfield","DN7 6QP","+302842105"],["17 Kyle Close"," Tollerton","YO61 1QU","+347658856"],
    ["17 Kendon Grove"," Denton","M34 2AZ","+61738 1645"],["23 Tuxton Close"," Plymouth","PL7 1QH","+752142415"],
    ["17 Jockey Field"," Upper Gornal","DY3 1UH","+384662357"],["7 Shirehall Park"," London","NW4 2QJ","(0202144 8002"],
    ["5 Pinfold Lane"," Thorne","DN8 5EX","+405567181"],["23 Victoria Road"," Kenfig Hill","CF33 6ER","+656558426"],
    ["26 Wordsworth Avenue West"," Houghton Le Spring","DH5 8LJ","+91608 2610"],["9 Eldon Street"," South Shields","NE33 5EJ","+946743108"],
    ["4 Sea Close"," Bognor Regis","PO22 7RU","+243083857"],["1 The Homestead"," Thame","OX9 2PP","+844620300"],
    ["32 Pwllcarn Terrace"," Blaengarw","CF32 8AS","+656024652"],["33 High Street"," Llanidloes","SY18 6BY","+686130116"],
    ["22 Church Road"," Wiggenhall St Mary Magdalen","PE34 3DG","+366758072"],["9 Kiln Croft"," Etwall","DE65 6HW","+283708385"],
    ["31 Cherry Tree Avenue"," Scarborough","YO12 5DX","+723113050"],["4 Bramble Close"," Barns Green","RH13 0AW","+403202832"],
    ["134 Water Lane"," Totton","SO40 3GS","+794877603"],["33 Augustus Drive"," Alcester","B49 5HH","+527178208"],
    ["58 Carlton Road"," Seaford","BN25 2LS","+323805742"],["27 Chapel Street"," Mexborough","S64 9RE","+709782810"],
    ["11 Marquis Close"," Bishop's Stortford","CM23 4PH","+279374332"],["122 Station Road"," Ackworth","WF7 7HH","+977646047"],
    ["31 Riccall Close"," Hull","HU6 8EH","+482637243"],["38 Trinity Street"," Oldham","OL1 2DD","+706316458"],
    ["11 Lime Road"," Alresford","SO24 9LD","+962544288"],["46 Park Drive"," Northampton","NN5 7JU","+604252871"],
    ["14 Harbourne Close"," Worsley","M28 7UA","+204203517"],["55 Draycott Road"," Long Eaton","NG10 3BB","+15234 4481"],
    ["41 Given Wilson Walk"," London","E13 0EB","(0204313 4701"],["13 Halifax Road"," Sheffield","S6 1LA","+14774 2071"],
    ["1 Frances Row"," Queenborough","ME11 5DH","+795610527"],["1 Beulah Villas"," Crowborough","TN6 2PJ","+435855737"],
    ["175 Ravenstone Drive"," Greetland","HX4 8DY","+422473262"],["5 Hurst Lane"," Bollington","SK10 5LN","+625817565"],
    ["13 Hawth Crescent"," Seaford","BN25 2RR","+323321817"],["6 Wykeham Close"," Queenborough","ME11 5JY","+795127853"],
    ["93 Main Road"," Bilton","HU11 4AQ","+482118013"],["80 Pansy Street North"," Accrington","BB5 4BJ","+254572813"],
    ["111 Ferriby High Road"," North Ferriby","HU14 3LA","+482883842"],["84 Wells Road"," Fakenham","NR21 9HH","+328063335"],
    ["29 Wrights Lane"," Cradley Heath","B64 6QY","+384210645"],["14 Newland Street"," High Wycombe","HP11 2BY","+494861482"],
    ["20 Templenewsam View"," Leeds","LS15 0LW","+13165 8106"],["34 Gipsy Lane"," Buckfastleigh","TQ11 0DL","+364764883"],
    ["189 Lyndhurst Avenue"," Twickenham","TW2 6BN","+372207141"],["40 Catisfield Road"," Enfield","EN3 6BD","+992347885"],
    ["21 Claygate Lane"," Thames Ditton","KT7 0DT","+372038380"],["17 Goldfields Avenue"," Greetland","HX4 8LE","+422061212"],
    ["25 St Whites Road"," Cinderford","GL14 3DB","+594224003"],["Pheasant Croft"," Collington","HR7 4NE","+886784554"],
    ["22 Falcon Road"," Enfield","EN3 4LY","+992055343"],["90 Knowle Drive"," Exeter","EX4 2EH","+392533336"],
    ["102 Boundary Road"," Carshalton","SM5 4AB","+883357567"],["21 Maple Close"," Sonning Common","RG4 9NG","+491514571"],
    ["5 South Street"," Montacute","TA15 6XD","+935721467"],["3 Walden Drive"," Bradford","BD9 6JR","+274555403"],
    ["1 Smelterwood Close"," Sheffield","S13 8RD","+14447 7658"],["43 Parklands Road"," Wellington","TA21 8SA","+823078661"],
    ["58 Romney Close"," London","SE14 5JH","(0200215 8272"],["13 Station Road"," Herne Bay","CT6 5QJ","+227785412"],
    ["11 Chicory Close"," Mickleover","DE3 0FL","+332258322"],["106 Derek Avenue"," Warrington","WA2 0EX","+925445062"],
    ["1 Alma Villas"," New Holland","DN19 7PL","+482718863"],["1 Gibraltar Cottages"," East Knighton","DT2 8LJ","+929007004"],
    ["34 Monmouth Street"," Bridgwater","TA6 5EJ","+278722325"],["75 Oxford Road"," Waterloo","L22 7RE","+51028 0754"],
    ["42 Francis Street"," Thomastown","CF39 8DS","+443547605"],["St Illtyd Cottage"," Aberbeeg","NP13 2AY","+495165324"],
    ["11 Grimsby Grove"," London","E16 2RH","+708404015"],["6 Chesfield Road"," Kingston Upon Thames","KT2 5TH","+372334468"],
    ["44 Pilgrim Avenue"," Immingham","DN40 1DH","+469581678"],["4 Chestnut Close"," St. Ives","PE27 6UQ","+480346785"],
    ["1 Redcote Manor"," Walton Park","MK7 7HF","+908436843"],["113 Kenyon Lane"," Middleton","M24 2ES","+706708558"],
    ["9 The Alders"," London","N21 1AR","+992262263"],["1 The Meadows"," Leek Wootton","CV35 7QQ","+926427287"],
    ["16 Croft Close"," Prenton","CH43 9QN","+51211 7727"],["6 Willow Mead"," Chalgrove","OX44 7TD","+844467886"],
    ["75 Welholme Avenue"," Grimsby","DN32 0PL","+472820402"],["26 Tenbury Way"," Rothwell","NN14 6BG","+536558367"],
    ["1 High Street"," Criccieth","LL52 0RN","+766614372"],["1 Grove Avenue"," West Mersea","CO5 8AE","+206166007"],
    ["14 Cedar Court"," Grimsby","DN37 9LP","+472811032"],["17 Orchard Road"," Lydney","GL15 5QL","+594786812"],
    ["30 Reservoir Road"," Woolton","L25 6HR","+51363 7065"],["3 Victory Crescent"," Southampton","SO15 8RA","+794550556"],
    ["6 Tryfer Terrace"," Harlech","LL46 2YR","+766344141"],["21 Swinhoe Road"," Newcastle Upon Tyne","NE13 9BF","+946786418"],
    ["53 Rutherglen Road"," London","SE2 0YA","+322682536"],["52 Grays Lane"," Hitchin","SG5 2HJ","+462012460"],["Chapel Farm"," Oakhanger","GU35 9JB","+420003664"],
    ["5 Hazel Brook Gardens"," Bristol","BS10 7FL","+17104 8503"],["29 Cobwells Close"," Fleckney","LE8 8UF","+858564243"],
    ["138 Springfield Road"," Sheffield","S7 2GF","+14282 7863"],["9 Kearsley Drive"," Worthing","BN14 0AN","+903544551"],
    ["13 Heol Maenofferen"," Blaenau Ffestiniog","LL41 3DH","+690222444"],["4 Well Street"," Forsbrook","ST11 9BZ","+782634618"],
    ["43 Dorset Street"," Bolton","BL2 1HP","+204106324"],["2A Dobbinetts Lane"," Manchester","M23 9NB","+565145747"],
    ["190 Feenan Highway"," Tilbury","RM18 8HD","+375605388"],["16 Kensington Close"," Beeston","NG9 6GR","+15225 2314"],
    ["4 Hatherley Road"," Reading","RG1 5QA","+18844 0161"],["18 Troedyrhiw"," Meifod","SY22 6DQ","+938462441"]]

    return address_list[rand(address_list.length)]

end
start