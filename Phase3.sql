DROP TABLE STAYIN;
DROP TABLE EXAMINE;
DROP TABLE ADMISSION;
DROP TABLE PATIENT;
DROP TABLE ROOMACCESS;
DROP TABLE ROOMSERVICE;
DROP TABLE EQUIPMENT;
DROP TABLE CANREPAIREQUIPMENT;
DROP TABLE EQUIPMENTTECHNICIAN;
DROP TABLE DOCTOR;
DROP TABLE ROOM;
DROP TABLE EQUIPMENTTYPE;
DROP TABLE EMPLOYEE;

CREATE TABLE Employee (
eID   	 int,
FName    varchar(20),
LName   	 varchar(20),
Salary   	 int,
jobTitle   	 varchar(30),
OfficeNum    int,
empRank    varchar(10),
supervisorID    int,
AddressStreet    varchar(30),
AddressCity    varchar(30),
AddressZip    int,
PRIMARY KEY (eID),
FOREIGN KEY (supervisorID) REFERENCES Employee(eID)
);
CREATE TABLE Doctor (
EmployeeID int,
Gender VARCHAR(20) CHECK (Gender='Male' OR Gender='Female' OR Gender='Other'),
Specialty VARCHAR(20),
GraduatedFrom VARCHAR(20),
PRIMARY KEY (EmployeeID),
FOREIGN KEY (EmployeeID) REFERENCES Employee(eID)
);
CREATE TABLE EquipmentType(
eqID int,
eqDesc VARCHAR(40),
eqModel VARCHAR(40),
Instructions VARCHAR(40),
NumberOfUnits     int,
PRIMARY KEY(eqID)
);
CREATE TABLE Room(
RoomNum    int,
Occupied number(1),
PRIMARY KEY (RoomNum)
);
CREATE TABLE Equipment(
SerialNum     VARCHAR(20),
TypeID    	 int,
PurchaseYear   	  int,
LastInspection   	 DATE,
roomNum   	 int,
Primary Key(SerialNum),
FOREIGN KEY (TypeID) REFERENCES EquipmentType(eqID),
FOREIGN KEY (roomNum) REFERENCES Room(RoomNum)
);
CREATE TABLE EquipmentTechnician(
EmployeeID int,
PRIMARY KEY(EmployeeID),
FOREIGN KEY (EmployeeID) REFERENCES Employee(eID)
);

CREATE TABLE CanRepairEquipment(
EmployeeID    	 int,
EquipmentType     int,

PRIMARY KEY (EmployeeID, EquipmentType),
FOREIGN KEY (EmployeeID) REFERENCES EquipmentTechnician(EmployeeID),
FOREIGN KEY (EquipmentType) REFERENCES EquipmentType(eqID)
);
CREATE TABLE RoomService(
roomNum    int,
rService varchar(40),
FOREIGN KEY (roomNum) references Room(RoomNum),
PRIMARY KEY (roomNum, rService)
);

CREATE TABLE RoomAccess(
roomNum    int,
EmpID    int,
PRIMARY KEY (roomNum, EmpID),
FOREIGN KEY (roomNum) references Room(RoomNum),
FOREIGN KEY (EmpID) references Employee(eID)
);

CREATE TABLE Patient(
SSN int,
FirstName VARCHAR(20),
LastName VARCHAR(20),
Address VARCHAR(75),
TelNum     int,
PRIMARY KEY (SSN)
);

CREATE TABLE Admission(
aNum   		 int,
AdmissionDate    DATE,
LeaveDate   	 DATE,
TotalPayment   	 int,
InsurancePayment    int,
Patient_SSN   	 int,
FutureVisit   	 DATE,

PRIMARY KEY (aNum),
FOREIGN KEY (Patient_SSN) REFERENCES Patient(SSN)
);

CREATE TABLE Examine(
DoctorID   	 int,
AdmissionNum    int,
eComment   	 varchar(100),
PRIMARY KEY (DoctorID, AdmissionNum),
FOREIGN KEY (DoctorID) REFERENCES Doctor(EmployeeID),
FOREIGN KEY (AdmissionNum) REFERENCES Admission(aNum)
);
CREATE TABLE StayIn(
AdmissionNum    int,
RoomNum   	 int,
startDate   	 DATE,
endDate   	 DATE,

PRIMARY KEY (AdmissionNum, RoomNum, startDate),
FOREIGN KEY (AdmissionNum) REFERENCES Admission(aNum),
FOREIGN KEY (RoomNum) REFERENCES Room(roomNum)
);


DROP TABLE managerChain;

CREATE OR REPLACE TRIGGER autoInsurancePayment
BEFORE INSERT or UPDATE OF TotalPayment ON Admission
FOR EACH ROW
BEGIN
    IF (:new.InsurancePayment != :new.TotalPayment * .65) THEN 
        :new.InsurancePayment := (:new.TotalPayment * .65);
        END IF;
    END;
/


INSERT INTO Employee(eID, FName, LName, Salary, jobTitle, OfficeNum, empRank, supervisorID, AddressStreet, AddressCity, AddressZip)
WITH p AS (
SELECT 211, 'Marceli', 'Prince', 500000, 'Manager', 210, 'General', NULL, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 212, 'Eleanor', 'Genowefa', 500000, 'Manager', 210, 'General', NULL, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 111, 'Ajei', 'Phyllis', 100000, 'Manager', 210, 'Division', 211, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 112, 'Hugo', 'Hallstein', 100000, 'Manager', 210, 'Division', 212, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 113, 'Lucretia', 'Opal', 100000, 'Manager', 210, 'Division', 211, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 114, 'Olivia', 'Arnold', 100000, 'Manager', 210, 'Division', 212, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 1, 'April', 'Hwan', 50000, 'Nurse', 210, 'Regular', 111, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 2, 'Julio', 'Vincio', 50000, 'Nurse', 210, 'Regular', 111, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 3, 'Lea', 'Reyes', 50000, 'Nurse', 210, 'Regular', 112, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 4, 'Edith', 'Adam', 50000, 'Nurse', 210, 'Regular', 112, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 5, 'Rudolf', 'Erik', 50000, 'Nurse', 210, 'Regular', 112, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 6, 'Morgan', 'Flavienn', 50000, 'Doctor', 210, 'Regular', 113, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 7, 'Matteus', 'Dagfinn', 50000, 'Doctor', 210, 'Regular', 113, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 8, 'Marianne', 'Kornell', 50000, 'Doctor', 210, 'Regular', 113, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 9, 'Ruby', 'Bartolomeus', 50000, 'Doctor', 210, 'Regular', 113, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 10, 'Alejandra', 'Min-Seo', 50000, 'Doctor', 210, 'Regular', 113, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 11, 'Prosper', 'Meri', 50000, 'Technician', 210, 'Regular', 114, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 12, 'Martin', 'Kasjan', 50000, 'Technician', 210, 'Regular', 114, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 13, 'Luka', 'Valentin', 50000, 'Technician', 210, 'Regular', 114, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 14, 'Jolie', 'Fisher', 50000, 'Technician', 210, 'Regular', 114, 'Street', 'City', 11111 FROM dual UNION ALL
SELECT 15, 'Casey', 'Jorun', 50000, 'Technician', 210, 'Regular', 114, 'Street', 'City', 11111 FROM dual )
SELECT * FROM p;



INSERT INTO EquipmentType(eqID, eqDesc, eqModel, Instructions, NumberOfUnits)
WITH p AS (
SELECT 1, 'Surgical Light', 'MI-1000 LED Surgical Light', 'Light Instructions', 3 FROM dual UNION ALL
SELECT 2, 'Surgical Display', 'VIVIDIMAGE 4K SURGICAL DISPLAY', 'Display Instructions', 3 FROM dual UNION ALL
SELECT 3, 'EKG Machine', 'HENRY SCHIEN #A952', 'EGK Instructions', 3 FROM dual
)
SELECT * from p;

INSERT INTO Room(RoomNum, Occupied)
WITH p AS (
SELECT 110, 0 FROM dual UNION ALL
SELECT 111, 0 FROM dual UNION ALL
SELECT 112, 0 FROM dual UNION ALL
SELECT 113, 0 FROM dual UNION ALL
SELECT 114, 0 FROM dual UNION ALL
SELECT 115, 1 FROM dual UNION ALL
SELECT 116, 1 FROM dual UNION ALL
SELECT 117, 0 FROM dual UNION ALL
SELECT 118, 0 FROM dual UNION ALL
SELECT 119, 0 FROM dual
)
SELECT * from p;



INSERT INTO Doctor(EmployeeID, Gender, Specialty, GraduatedFrom)
WITH p AS (
SELECT 6, 'Male', 'Surgeon', 'WPI' FROM dual UNION ALL
SELECT 7, 'Female', 'Cardiology', 'Brown' FROM dual UNION ALL
SELECT 8, 'Female', 'Radiology', 'WPI' FROM dual UNION ALL
SELECT 9, 'Other', 'Cardiology', 'McGill' FROM dual UNION ALL
SELECT 10, 'Male', 'Surgeon', 'WashU' FROM dual
)
SELECT * from p;


INSERT INTO EquipmentTechnician(EmployeeID)
WITH p AS (
SELECT 11 FROM dual UNION ALL
SELECT 12 FROM dual UNION ALL
SELECT 13 FROM dual UNION ALL
SELECT 14 FROM dual UNION ALL
SELECT 15 FROM dual
)
SELECT * FROM p;


INSERT INTO CanRepairEquipment(EmployeeID, EquipmentType)
WITH p AS (
SELECT 11, 1 FROM dual UNION ALL
SELECT 12, 1 FROM dual UNION ALL
SELECT 13, 1 FROM dual UNION ALL
SELECT 14, 1 FROM dual UNION ALL
SELECT 15, 1 FROM dual UNION ALL
SELECT 11, 2 FROM dual UNION ALL
SELECT 12, 2 FROM dual UNION ALL
SELECT 13, 2 FROM dual UNION ALL
SELECT 14, 3 FROM dual
)
SELECT * FROM p;

INSERT INTO Equipment(SerialNum, TypeID, PurchaseYear, LastInspection, RoomNum)
WITH p AS (
SELECT 'A01-02X', 1, 1995, Date '2023-08-01', 113 FROM dual UNION ALL
SELECT 'A01-05B', 1, 2010, DATE '2023-07-28', 114 FROM dual UNION ALL
SELECT 'A01-18C', 1, 2012, DATE '2023-07-26', 114 FROM dual UNION ALL
SELECT 'B15-5XY', 2, 2010, DATE '2024-02-01', 113 FROM dual UNION ALL
SELECT 'B15-4BY', 2, 2010, DATE '2024-02-02', 114 FROM dual UNION ALL
SELECT 'B15-0WX', 2, 2011, DATE '2024-02-05', 114 FROM dual UNION ALL
SELECT 'C0-1123', 3, 2022, DATE '2024-01-13', 112 FROM dual UNION ALL
SELECT 'C0-5023', 3, 2011, DATE '2024-01-13', 112 FROM dual UNION ALL
SELECT 'C0-3024', 3, 2022, DATE '2024-01-13', 115 FROM dual
)
SELECT * from p;



INSERT INTO RoomService(roomNum, rService)
WITH p AS (
SELECT 110, 'Emergency Services' FROM dual UNION ALL
SELECT 110, 'ICU' FROM dual UNION ALL
SELECT 112, 'Cardiology Lab' FROM dual UNION ALL
SELECT 112, 'Haematology Lab' FROM dual UNION ALL
SELECT 113, 'Operating Theatre' FROM dual UNION ALL
SELECT 114, 'Operating Theatre' FROM dual UNION ALL
SELECT 115, 'Inpatient Ward' FROM dual UNION ALL
SELECT 116, 'Inpatient Ward' FROM dual
)
SELECT * from p;

INSERT INTO RoomAccess(roomNum, EmpID)
WITH p AS (
SELECT 113, 11 FROM dual UNION ALL
SELECT 113, 12 FROM dual UNION ALL
SELECT 113, 13 FROM dual UNION ALL
SELECT 113, 14 FROM dual UNION ALL
SELECT 114, 12 FROM dual UNION ALL
SELECT 114, 14 FROM dual UNION ALL
SELECT 114, 15 FROM dual UNION ALL
SELECT 112, 11 FROM dual UNION ALL
SELECT 112, 12 FROM dual UNION ALL
SELECT 112, 7 FROM dual UNION ALL
SELECT 112, 9 FROM dual UNION ALL
SELECT 113, 6 FROM dual UNION ALL
SELECT 113, 8 FROM dual UNION ALL
SELECT 113, 10 FROM dual UNION ALL
SELECT 114, 6 FROM dual UNION ALL
SELECT 114, 8 FROM dual UNION ALL
SELECT 115, 1 FROM dual UNION ALL
SELECT 115, 2 FROM dual UNION ALL
SELECT 115, 3 FROM dual UNION ALL
SELECT 115, 4 FROM dual UNION ALL
SELECT 115, 5 FROM dual UNION ALL
SELECT 115, 6 FROM dual UNION ALL
SELECT 116, 4 FROM dual UNION ALL
SELECT 116, 5 FROM dual UNION ALL
SELECT 116, 6 FROM dual UNION ALL
SELECT 116, 7 FROM dual UNION ALL
SELECT 116, 8 FROM dual
)
SELECT * FROM p;

INSERT INTO Patient(SSN, FirstName, LastName, Address, TelNum)
WITH p AS (
SELECT 123456789, 'First', 'Last', 'Address', 1111111111 FROM dual UNION ALL
SELECT 333445555, 'Real', 'Person', 'Your Address', 1112223333 FROM dual UNION ALL
SELECT 333446666, 'Realer', 'Person', 'Your Address', 1112223333 FROM dual UNION ALL
SELECT 239341823, 'I Broke', 'EveryBone', '123 Flower Street', 6182321643 FROM dual UNION ALL
SELECT 111223333, 'Maria', 'de la Cruz', '1143 8th Street', 9146634512 FROM dual UNION ALL
SELECT 394662345, 'Rita', 'Lukas', '410 Stockdale St Flint, Michigan, 48503', 8102391806 FROM dual UNION ALL
SELECT 883253417, 'Heidi', 'Winston', '4861 Saint Paul Rd Leitchfield, Kentucky(KY), 42754', 2702423650 FROM dual UNION ALL
SELECT 104803392, 'Gordon', 'Callan', '2204 County Rd #103 Newville, Alabama(AL), 36353', 3346932221 FROM dual UNION ALL
SELECT 623491632, 'Ruben', 'Stone', '716 Way Cir Alvin, Texas(TX), 77511', 2815856697 FROM dual UNION ALL
SELECT 409223384, 'Joy', 'Lessie', '425 N Swain St Ingalls, Indiana(IN), 46048', 7654857538 FROM dual
)
SELECT * FROM p;

INSERT INTO Admission(aNum, AdmissionDate, LeaveDate, TotalPayment, InsurancePayment, Patient_SSN, FutureVisit)
WITH p AS (
SELECT 1, DATE '2019-08-08', DATE '2019-08-09', 1000, 900, 333445555, null FROM dual UNION ALL
SELECT 2, DATE '2022-01-05', DATE '2022-01-10', 3000, 2500, 111223333, DATE '2022-04-01' FROM dual UNION ALL
SELECT 3, DATE '2022-04-02', DATE '2022-04-03', 3000, 2500, 111223333, null FROM dual UNION ALL
SELECT 4, DATE '2022-05-18', DATE '2022-05-30', 15000, 7500, 111223333, DATE '2022-06-12' FROM dual UNION ALL
SELECT 5, DATE '2022-01-01', DATE '2022-01-02', 1000, 900, 333445555, null FROM dual UNION ALL
SELECT 6, DATE '2022-12-12', DATE '2022-12-13', 1000, 900, 333446666, DATE '2011-06-15' FROM dual UNION ALL
SELECT 7, DATE '2023-06-15', DATE '2023-06-16', 1000, 900, 333446666, DATE '2024-01-05' FROM dual UNION ALL
SELECT 8, DATE '2023-11-13', DATE '2023-11-14', 1000, 900, 104803392, DATE '2024-01-06' FROM dual UNION ALL
SELECT 9, DATE '2022-05-18', DATE '2022-06-03', 60000, 4500, 239341823, DATE '2022-06-15' FROM dual UNION ALL
SELECT 10, DATE '2022-06-15', DATE '2022-06-16', 1000, 1000, 239341823, null FROM dual UNION ALL
SELECT 11, DATE '2024-01-04', DATE '2024-01-05', 1000, 900, 104803392, DATE '2024-07-12' FROM dual
)
SELECT * FROM p;

INSERT INTO Examine(DoctorID, AdmissionNum, eComment)
WITH p AS (
SELECT 6, 2, 'comment' FROM dual UNION ALL
SELECT 6, 3, null FROM dual UNION ALL
SELECT 8, 3, null FROM dual UNION ALL
SELECT 7, 3, null FROM dual UNION ALL
SELECT 7, 4, 'comment' FROM dual UNION ALL
SELECT 7, 5, null FROM dual
)
SELECT * FROM p;

INSERT INTO StayIn(AdmissionNum, RoomNum, startDate, endDate)
WITH p AS (
SELECT 2, 110, DATE '2022-01-05', DATE '2022-01-10' FROM dual UNION ALL
SELECT 2, 110, DATE '2022-01-10', DATE '2022-01-10' FROM dual UNION ALL
SELECT 4, 110, DATE '2022-05-18', DATE '2022-05-28' FROM dual UNION ALL
SELECT 4, 110, DATE '2022-05-29', DATE '2022-05-30' FROM dual UNION ALL
SELECT 4, 110, DATE '2022-05-30', DATE '2022-05-31' FROM dual UNION ALL
SELECT 9, 110, DATE '2022-05-18', DATE '2022-06-01' FROM dual UNION ALL
SELECT 9, 110, DATE '2022-06-02', DATE '2022-06-03' FROM dual
)
SELECT * FROM p;

/* Report the id, specialty, gender and school of graduation for doctors that have
graduated from WPI. */
SELECT *
FROM Doctor
WHERE GraduatedFrom = 'WPI';
/* For a given division manager (say, ID = 10), report all regular employees that are
supervised by this manager. Display the employees ID, names, and salary. */
SELECT eID, FName, LName, Salary
FROM Employee
WHERE supervisorID = 112;
/* For each patient, report the sum of amounts paid by the insurance company for that
Patient. */
SELECT Patient_SSN, sum(InsurancePayment) AS SUM
FROM Admission
GROUP BY Patient_SSN;

/* Report the number of visits done for each patient, i.e., for each patient, report the
patient SSN, first and last names, and the count of visits done by this patient. */
SELECT Patient.SSN, Patient.FirstName, Patient.LastName, count(Admission.aNum) AS NumOfVisits
FROM Admission, Patient
WHERE Patient.SSN = Admission.Patient_SSN
GROUP BY SSN, FirstName, LastName;

/* Report the room number that has an equipment unit with serial number 'A01-02X'. */
SELECT roomNum
FROM Equipment
WHERE SerialNum = 'A01-02X';
/* Report the employee who has access to the largest number of rooms. We need the
employee ID, and the number of rooms they can access. */

Select empID, NumOfRoomAccess
    	FROM (Select empID, count(roomNum) as NumOfRoomAccess
        	FROM RoomAccess
        	GROUP BY empID)
    	WHERE NumOfRoomAccess = (Select MAX(NumOfRoomAccess) FROM
    	(Select empID, count(roomNum) as NumOfRoomAccess
        	FROM RoomAccess
        	GROUP BY empID));


/* Report the number of regular employees, division managers, and general managers in
the hospital. */
SELECT empRank AS Type, COUNT(*) AS number_of_employees
FROM Employee
GROUP BY empRank
ORDER BY number_of_employees DESC;


/* For patients who have a scheduled future visit (which is part of their most recent visit),
report that patient's SSN, first name, and last name, and the visit date. Do not report patients who do not have a scheduled visit.*/
/* For patients who have a scheduled future visit (which is part of their most recent visit),
report that patient's SSN, first name, and last name, and the visit date. Do not report patients who do not have a scheduled visit.*/
SELECT SSN, FirstName, LastName, FutureVisit FROM
    (SELECT Patient_SSN as SSN, Max(AdmissionDate) as AdmissionDate
    FROM Admission
    GROUP BY Patient_SSN)
NATURAL JOIN
    (SELECT SSN, FirstName , LastName, AdmissionDate, FutureVisit
    FROM Admission, Patient
    WHERE SSN = Patient_SSN)
WHERE FutureVisit IS NOT NULL;

/* Report all equipment types that have less than two technicians that can maintain them. */
SELECT EquipmentType
FROM (Select EquipmentType, count(EmployeeID) AS NumOfTechnicians
From CanRepairEquipment
GROUP BY EquipmentType)
WHERE NumOfTechnicians < 2;
/* Report the date of the coming future visit for patient with SSN = 111-22-3333. */
SELECT Max(FutureVisit) AS ComingFutureVisit
FROM Admission
WHERE Patient_SSN = 111223333;
/* For patient with SSN = 111-22-3333, report the doctors (only ID) who have examined
this patient more than 2 times. */
SELECT DoctorID
FROM (Select DoctorID, count(aNum) AS NumOfExamines
FROM (SELECT aNum FROM Admission WHERE Patient_SSN = 111223333)H, Examine WHERE H.aNum = Examine.AdmissionNum
GROUP BY DoctorID
)    
WHERE NumOfExamines >= 2;


/* Report the equipment types (only the ID) for which the hospital has purchased
equipment (units) in both 2010 and 2011. Do not report duplication. */
/* Report the equipment types (only the ID) for which the hospital has purchased
equipment (units) in both 2010 and 2011. Do not report duplication. */
SELECT DISTINCT TypeID
FROM (SELECT TypeID from Equipment
WHERE PurchaseYear = 2010)
    INTERSECT
    (SELECT TypeID from Equipment
WHERE PurchaseYear = 2011);

CREATE OR REPLACE VIEW CriticalCases (Patient_SSN, firstName, lastName, numberOfAdmissionsToICU) AS
SELECT * FROM (SELECT SSN, firstName, lastName, count(roomNum) as numberOfAdmissionsToICU
            	FROM (SELECT SSN, firstName, lastName, aNum FROM Patient, Admission WHERE Patient.SSN = Admission.Patient_SSN)
            	NATURAL JOIN
                	(SELECT Admission.aNum, StayIn.roomNum FROM Admission, StayIn, RoomService WHERE StayIn.AdmissionNum = Admission.aNum AND RoomService.roomNum = StayIn.roomNum AND RoomService.rService = 'ICU') group by SSN, firstName, lastName)
WHERE numberOfAdmissionsToICU > 1;

SELECT * FROM CriticalCases;

CREATE OR REPLACE TRIGGER doctorVisitICU
BEFORE INSERT ON Examine
FOR EACH ROW
DECLARE
x_1 Examine.AdmissionNum%TYPE;
BEGIN
	SELECT DISTINCT StayIn.AdmissionNum INTO x_1 FROM StayIn, RoomService WHERE StayIn.AdmissionNum = :new.AdmissionNum AND RoomService.roomNum = StayIn.roomNum AND RoomService.rService = 'ICU';
	IF :new.AdmissionNum IN (x_1) THEN
    	IF :new.eComment IS NULL THEN
        	RAISE_APPLICATION_ERROR(-20004, 'ICU PATIENTS MUST HAVE DOCTOR COMMENT');
    	end IF;
	end IF;
END;
/




CREATE TABLE managerChain(eid int PRIMARY KEY, supID int, rank VARCHAR(10));

CREATE OR REPLACE TRIGGER managementChain
BEFORE INSERT or UPDATE OR DELETE on Employee
FOR EACH ROW
BEGIN
IF INSERTING THEN INSERT INTO managerChain(eid, supID, rank) VALUES (:new.eID, :new.supervisorID, :new.empRank);
ELSIF UPDATING THEN UPDATE managerChain SET supID = :new.supervisorID, rank = :new.empRank WHERE eid = :new.eID;
ELSIF DELETING THEN DELETE FROM managerChain WHERE eid = :new.eID;
END IF;
END;
/

CREATE OR REPLACE TRIGGER employeeManagerCheck
BEFORE INSERT or UPDATE on Employee
FOR EACH ROW
FOLLOWS managementChain
DECLARE
x_1 Employee.empRank%type;
BEGIN
	SELECT rank INTO x_1 FROM managerChain WHERE eid = :new.supervisorID;
	IF :new.empRank = 'Regular' AND 'Regional' NOT IN (x_1) THEN
    	RAISE_APPLICATION_ERROR(-20004, 'NEW EMPLOYEE MUST HAVE REGIONAL MANAGER');
	END IF;
	IF :new.empRank = 'Regional' AND 'General' NOT IN (x_1) THEN
    	RAISE_APPLICATION_ERROR(-20004, 'NEW REGIONAL MANAGER MUST HAVE GENERAL MANAGER');
	END IF;
	IF :new.empRank = 'General' AND :new.supervisorID IS NOT NULL THEN
    	RAISE_APPLICATION_ERROR(-20004, 'NEW GENERAL MANAGER MAY NOT HAVE MANAGER');
	END IF;
END;
/

CREATE OR REPLACE TRIGGER changeManagerCheck
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
FOLLOWS employeeManagerCheck
WHEN (new.empRank != old.empRank)
DECLARE x_i int;
BEGIN
	SELECT count(eid) INTO x_i FROM managerChain WHERE supID = :new.eid;
	IF :new.empRank = 'Regular' AND x_i > 0 THEN
    	RAISE_APPLICATION_ERROR(-20004, 'THIS EMPLOYEE MAY NOT MANAGE OTHER EMPLOYEES');
	END IF;
	SELECT count(eid) INTO x_i FROM managerChain WHERE rank = 'Regular' AND supID = :new.eid;
	IF :new.empRank = 'General' AND x_i > 0 THEN
    	RAISE_APPLICATION_ERROR(-20004, 'THIS EMPLOYEE MAY NOT MANAGE REGULAR EMPLOYEES');
	END IF;
END;
/

CREATE OR REPLACE TRIGGER deleteManagerCheck
BEFORE DELETE on Employee
FOR EACH ROW
FOLLOWS managementChain
DECLARE
x_1 Integer;
BEGIN
	SELECT count(eid) INTO x_1 FROM managerChain WHERE supID = :old.eid;
	IF :old.empRank = 'General' AND :old.eID IN (x_1) THEN
    	RAISE_APPLICATION_ERROR(-20004, 'REGIONAL MANAGERS MISSING A MANAGER');
	END IF;
	IF :old.empRank = 'Regional' AND :old.eID IN (x_1) THEN
    	RAISE_APPLICATION_ERROR(-20004, 'REGULAR EMPLOYEES MISSING A MANAGER');
	END IF;
END;
/

CREATE OR REPLACE TRIGGER emergencyScheduler
BEFORE INSERT or UPDATE on StayIn
FOR EACH ROW
DECLARE
rID StayIn.roomNum%TYPE;
BEGIN
	SELECT roomNum into rID FROM RoomService WHERE rService = 'ICU' AND roomNum = :new.roomNum;
	IF :new.roomNum IN (rID) THEN
    	UPDATE Admission
    	SET FutureVisit = ADD_MONTHS(:new.startDate, 2)
    	WHERE Admission.aNum in (:new.AdmissionNum);
	END IF;
END;
/

CREATE OR REPLACE TRIGGER inspectionCheck
BEFORE INSERT on Equipment
FOR EACH ROW
WHEN (new.LastInspection < ADD_MONTHS(sysdate, -1))
DECLARE
canRepair Integer;
BEGIN
	SELECT count(EquipmentType) INTO canRepair FROM CanRepairEquipment WHERE EquipmentType = :new.TypeID;
	IF canRepair > 0 THEN
     	:new.LastInspection := sysdate;
	END IF;
END;
/