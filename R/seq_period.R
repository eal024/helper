


seq_period <- function( return = "string", fra = NULL, ...){

    # input from
    if( !is.null(fra) ){

        y = fra %/% 100
        m = sprintf("%02d", fra %% 100)
        from = as.Date( paste0( y, "-", m, "-01"))
    }


    # seq.Date
    seqq <- seq.Date( from = from , ... )

    # Format returning
    if( return == "string"){
        paste0( format(seqq, "%Y"), format(seqq, "%m"))
    } else if( return == "df"){
        data.frame( date = seqq)
    } else if( return == "df_period"){
        data.frame( period = paste0( format(seqq, "%Y"), format(seqq, "%m")) )
    }

}




