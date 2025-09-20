module.exports = cds.service.impl( async function() {
// get the access of our entities
// it will look our CatalogService.cds file and get the 
//  the object of the corresponding entity so that we can 
// tell CAPM which entity we want to add generic handler
    const{ EmployeeSet,POs } = this.entities;   

    this.before(['UPDATE','CREATE'], EmployeeSet, (req,res) => {
        console.log("aa gaya"+ JSON.stringify(req.data));
        var jsonData = req.data;
        if (jsonData.hasOwnProperty("salaryAmount")){
            const salary = parseFloat(req.data.salaryAmount);
            if (salary > 1000000){
                req.error(500, "Bro, Salary cannot be greater than 1 Million USD 😊");
            }
        }
    });

    this.after('READ', EmployeeSet, (req,res) => {
        console.log(JSON.stringify(res));
        var finalData = []
        for (let i = 0; i < res.results.length; i++) {
            const element = res.results[i];
            element.salaryAmount = element.salaryAmount * 1.1;
            finalData.push(element);
        }
        finalData.push({
            'ID': 'Dummy',
            'nameFirst': 'Michael',
            'nameLast': 'Saylor'
        });
        res.results = finalData;
    });

    // implementation for the function
    this.on('getMostExpensiveOrder', async (req,res) => {
        try {
            const tx = cds.tx(req);
            const myData = await tx.read(POs).orderBy({
                "GROSS_AMOUNT": 'desc'
            }).limit(1);
            return myData;
        } catch (error) {
            return "Hey Amigo"+ error.toString();
        }

    });

    // implementation for the function
    this.on('getOrderDefault', async (req,res) => {
        try {
            return {OVERALL_STATUS : 'N' };
        } catch (error) {
            return "Hey Amigo"+ error.toString();
        }

    });

    //instance bound action
    this.on('boost',async (req,res)=>{
        try {
            // programatically check @ runtime, if the user have the Editor permission
            req.user.is('Editor') || req.reject(403)
            const POID = req.params[0];
            console.log("Bro your PO Id is "+ JSON.stringify(POID));
            const tx = cds.tx(req);
            await tx.update(POs).with({
                GROSS_AMOUNT: {'+=': 20000}
            }).where(POID);
            //after modify, read the instance
            const reply = tx.read(POs).where(POID);
            return reply;
        } catch (error) {
            return "Hey Amigo"+ error.toString();
        }
    });

        this.on('setDelivered',async (req,res)=>{
        try {
            // programatically check @ runtime, if the user have the Editor permission
            // req.user.is('Editor') || req.reject(403)
            const POID = req.params[0];
            console.log("Bro your PO Id is "+ JSON.stringify(POID));
            const tx = cds.tx(req);
            await tx.update(POs).with({
                "OVERALL_STATUS": 'D'
            }).where(POID);
            //after modify, read the instance
            const reply = tx.read(POs).where(POID);
            return reply;
        } catch (error) {
            return "Hey Amigo"+ error.toString();
        }
    });

});