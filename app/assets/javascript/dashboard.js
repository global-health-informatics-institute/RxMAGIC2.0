function reloadTable(section, data, keys, container)
{
    if (container.trim() == "" )
    {
        container = "main";
    }
    var table = document.getElementById(section);
    var html = "";
    var count = 0;
    constant = document.getElementById('heading').offsetHeight + document.getElementById('footer').offsetHeight;
    var height = document.getElementById('heading').offsetHeight + document.getElementById('footer').offsetHeight;
    var maxHeight = window.innerHeight;
    while (table.hasChildNodes()) {
        table.removeChild(table.lastChild);
    }

    patientKeys = Object.keys(data);

    totalCount = 0;
    for (e = 0; e < patientKeys.length;e++ )
    {
        for( i=0 ; i < data[patientKeys[e]].length ; i++)
        {
            if ((height + 40) <= maxHeight) {

                html = html + "<div style='display: table-row' class='"+ ((e % 2 == 0) ? 'odd' : 'even') +"'>"
                for(w = 0; w < keys.length ; w++)
                {
                    html = html + "<div class='base-cell'>"+
                        data[patientKeys[e]][i][keys[w]] +"</div>"
                }
                html += "</div>"
                height += 35;
            }
            else
            {
                break;
            }
            count += 1
        }
        totalCount += data[patientKeys[e]].length;
    }

    table.innerHTML = html
    document.getElementById('footer').innerHTML = "Showing " + count + " of " + totalCount + " Prescriptions"

}

function updateRecords() {
    url = "/ajax_prescriptions.json";
    $.ajax({
      url: url,
      success: function(response) {
        console.log(response)
        reloadTable('dataSection',response,['name','item','prescribed_by','quantity','type'], "main")                           
      },
      error: function() {
          console.log('failure')
      }
    });
}