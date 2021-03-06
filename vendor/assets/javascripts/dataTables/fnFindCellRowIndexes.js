jQuery.fn.dataTableExt.oApi.fnFindCellRowIndexes = function ( oSettings, sSearch, iColumn )
{
    var
        i,iLen, j, jLen, val,
        aOut = [], aData,
        columns = oSettings.aoColumns;

    for ( i=0, iLen=oSettings.aoData.length ; i<iLen ; i++ )
    {
        aData = oSettings.aoData[i]._aData;

        if ( iColumn === undefined )
        {
            for ( j=0, jLen=columns.length ; j<jLen ; j++ )
            {
                val = this.fnGetData(i, j);

                if ( val == sSearch )
                {
                    aOut.push( i );
                }
            }
        }
        else if (this.fnGetData(i, iColumn) == sSearch )
        {
            aOut.push( i );
        }
    }

    return aOut;
};