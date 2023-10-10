# ----------------------
#  This script contains function to create volume queries.
# ----------------------

# Making function to create volume queries.
vol_qry <- function(id, from, to) {
  qry <- paste0(
    '{
      trafficData(trafficRegistrationPointId: "', id, '") {
        volume {
          byHour(from:"', from, '", to:"', to, '") {
            edges {
              node {
                from
                to
                total {
                  volumeNumbers {
                    volume
                  }
                }
              }
            }
          }
        }
      }
    }'
  )
  return(qry)
}




