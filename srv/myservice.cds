    // definition
    using { anubhav.db.master.employees } from '../db/data-model';

    service MyService {

        function bd( input:String(80)) returns String;
        entity EmployeeSrv as projection on employees;
    }