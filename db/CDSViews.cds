namespace anubhav.myviews;
using { anubhav.db.master, anubhav.db.transaction } from './data-model';

context CDSViews {
    // if we want the object name and column name alias to be exact same
    //  respecting the case then we use ![ObjectName]
    define view ![POWorklist] as
    select from transaction.purchaseorder{
        key PO_ID as ![PurchaseOrderID],
        key Items.PO_ITEM_POS as ![ItemPosition],
        PARTNER_GUID.BP_ID as ![PartneId],
        PARTNER_GUID.COMPANY_NAME as ![CompanyName],
        Items.GROSS_AMOUNT as ![GrossAmount],
        Items.NET_AMOUNT as ![NetAmount],
        Items.TAX_AMOUNT as ![TaxAmount],
        Items.CURRENCY as ![CurrencyCode],
        OVERALL_STATUS as ![Status],
        Items.PRODUCT_GUID.CATEGORY as ![Category],
        Items.PRODUCT_GUID.DESCRIPTION as ![ProductName],   
        PARTNER_GUID.ADDRESS_GUID.COUNTRY as ![Country] ,
        PARTNER_GUID.ADDRESS_GUID.CITY as ![City]
       };

    define  view ![ProductHelpView] as 
    select from master.product {
        @EndUserText.label: [
            {language: 'EN', text: 'Product ID' },
            {language: 'HI', text: 'उत्पादन आईडी' }
        ]
        key PRODUCT_ID as ![ProductID],
        @EndUserText.label: [
            {language: 'EN', text: 'Description' },
            {language: 'HI', text: 'विवरण' }
        ]
        DESCRIPTION as ![ProductName],
        @EndUserText.label: [
            {language: 'EN', text: 'Category' },
            {language: 'HI', text: 'श्रेणी' }
        ]
        CATEGORY as ![Category],
        PRICE as ![Price],
        CURRENCY_CODE as ![CurrencyCode],
        SUPPLIER_GUID.COMPANY_NAME as ![SupplierName]    
    };

    define view ![ItemView] as
    select from transaction.poitems{
        key PARENT_KEY.PARTNER_GUID.NODE_KEY as ![SupplierID],
        key PRODUCT_GUID.NODE_KEY as ![ProductKey],
        GROSS_AMOUNT as ![GrossAmount],
        NET_AMOUNT as ![NetAmount],
        TAX_AMOUNT as ![TaxAmount],
        CURRENCY as ![CurrencyCode],
        PARENT_KEY.OVERALL_STATUS as ![Status]
    };

    //view on view with lady loading
    define view ![ProductView] as
    select from master.product
    //Mixin - is a keyword to define lose coupling of dependent data
    //which tells framework to never load the dependent data until requested
    mixin {
        //$projection - predicate to indicate the selection list of defined fields with alias name
        PO_TEMS: Association to many ItemView on PO_TEMS.ProductKey = $projection.ProductId
    } into {
        key NODE_KEY as ![ProductId],
        DESCRIPTION as ![ProductName],
        CATEGORY as ![Category],
        SUPPLIER_GUID.BP_ID as ![SupplierId],
        SUPPLIER_GUID.COMPANY_NAME as ![SupplierName],
        SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
        //exposed association, @Runtime data will be loaded on-demand - lazy loading
        PO_TEMS as ![To_Items]
    };

    // crate a consumption view  - view on view, aggregation
    define view ![CProductSalesAnalytics] as
    select from ProductView{
        key ProductName,
        Country,
        round(sum(To_Items.GrossAmount), 2) as ![TotalPurchaseAmount]: Decimal(15,2),
        To_Items.CurrencyCode
    } group by ProductName, Country, To_Items.CurrencyCode;
}
