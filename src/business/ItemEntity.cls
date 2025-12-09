
USING Progress.Lang.*.
USING OpenEdge.BusinessLogic.BusinessEntity.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS business.ItemEntity INHERITS BusinessEntity USE-WIDGET-POOL:

    {business/ItemDataset.i}

    DEFINE DATA-SOURCE srcItem FOR Item.

    CONSTRUCTOR PUBLIC ItemEntity():
        SUPER(DATASET dsItem:HANDLE).

        VAR HANDLE[1] hDataSourceArray.
        VAR CHARACTER[1] cSkipListArray.

        hDataSourceArray[1] = DATA-SOURCE srcItem:HANDLE.
        cSkipListArray[1]   = "".

        THIS-OBJECT:ProDataSource = hDataSourceArray.
        THIS-OBJECT:SkipList      = cSkipListArray.
    END CONSTRUCTOR.

    /* Read Operation */
    METHOD PUBLIC LOGICAL GetItemByNum(INPUT ipiItemNum AS INTEGER,
                                       OUTPUT DATASET dsItem):
        VAR CHARACTER cFilter.
        VAR LOGICAL lFound = FALSE.

        cFilter = "WHERE Item.ItemNum = " + STRING(ipiItemNum).

        THIS-OBJECT:ReadData(cFilter).

        lFound = CAN-FIND(FIRST ttItem).

        RETURN lFound.
    END METHOD.

    /* Validation Logic */
    METHOD PUBLIC LOGICAL ValidateItem(INPUT-OUTPUT DATASET dsItem,
                                       OUTPUT errorMessage AS CHARACTER):
        VAR LOGICAL isValid = TRUE.
        VAR DECIMAL dTotal.

        FIND FIRST ttItem NO-ERROR.
        IF AVAILABLE ttItem THEN DO:
            IF ttItem.Price = 0 THEN DO:
                isValid = FALSE.
                errorMessage = "Price cannot be empty".
                RETURN isValid.
            END.

            dTotal = ttItem.OnHand * ttItem.Price.
            IF dTotal > 6000 THEN DO:
                isValid = FALSE.
                errorMessage = "Total value onhand will be " + STRING(dTotal) + ", should not be larger than 6000".
                RETURN isValid.
            END.
        END.

        RETURN isValid.
    END METHOD.

    /* Update Operation */
    METHOD PUBLIC VOID UpdateItem(INPUT-OUTPUT DATASET dsItem):
        THIS-OBJECT:UpdateData(DATASET dsItem BY-REFERENCE).
    END METHOD.

END CLASS.
