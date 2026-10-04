CREATE OR ALTER PROCEDURE GetAllPatients
AS
BEGIN
    SELECT *
    FROM Patient;
END;
GO

EXEC GetAllPatients;
GO
CREATE OR ALTER PROCEDURE GetAllConsultants
AS
BEGIN
    SELECT *
    FROM Consultant;
END;
GO

EXEC GetAllConsultants;
GO
CREATE OR ALTER PROCEDURE GetPatientsWithWards
AS
BEGIN
    SELECT P.*, W.WardName
    FROM Patient P
    INNER JOIN Ward W
        ON P.WardID = W.WardID;
END;
GO

EXEC GetPatientsWithWards;
GO
CREATE OR ALTER PROCEDURE GetPatientByID
    @PatientID INT
AS
BEGIN
    SELECT *
    FROM Patient
    WHERE PatientID = @PatientID;
END;
GO

EXEC GetPatientByID @PatientID = 1;
GO
CREATE OR ALTER PROCEDURE GetConsultantsByMinimumSalary
    @MinimumSalary DECIMAL(10,2)
AS
BEGIN
    SELECT *
    FROM Consultant
    WHERE Salary >= @MinimumSalary;
END;
GO

EXEC GetConsultantsByMinimumSalary
    @MinimumSalary = 50000;
GO
CREATE OR ALTER PROCEDURE GetPatientsByWard
    @WardID INT
AS
BEGIN
    SELECT *
    FROM Patient
    WHERE WardID = @WardID;
END;
GO

EXEC GetPatientsByWard @WardID = 1;
GO
CREATE OR ALTER PROCEDURE GetPatientCount
    @TotalPatients INT OUTPUT
AS
BEGIN
    SELECT @TotalPatients = COUNT(*)
    FROM Patient;
END;
GO

DECLARE @Count INT;

EXEC GetPatientCount
    @TotalPatients = @Count OUTPUT;

SELECT @Count AS TotalPatients;
GO
CREATE OR ALTER PROCEDURE GetAverageConsultantSalary
    @AverageSalary DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @AverageSalary = AVG(Salary)
    FROM Consultant;
END;
GO

DECLARE @Average DECIMAL(10,2);

EXEC GetAverageConsultantSalary
    @AverageSalary = @Average OUTPUT;

SELECT @Average AS AverageSalary;
GO
CREATE OR ALTER PROCEDURE GetPatientMedicationQuantity
    @PatientID INT,
    @TotalQuantity INT OUTPUT
AS
BEGIN
    SELECT @TotalQuantity = ISNULL(SUM(Quantity), 0)
    FROM MedicationAdministration
    WHERE PatientID = @PatientID;
END;
GO

DECLARE @Quantity INT;

EXEC GetPatientMedicationQuantity
    @PatientID = 1,
    @TotalQuantity = @Quantity OUTPUT;

SELECT @Quantity AS TotalMedicationQuantity;
GO
CREATE OR ALTER PROCEDURE IncreaseSalary
    @Salary DECIMAL(10,2) OUTPUT,
    @Percentage DECIMAL(5,2)
AS
BEGIN
    SET @Salary = @Salary * (1 + @Percentage / 100.0);
END;
GO

DECLARE @Salary DECIMAL(10,2) = 10000;

EXEC IncreaseSalary
    @Salary = @Salary OUTPUT,
    @Percentage = 10;

SELECT @Salary AS NewSalary;
GO
CREATE OR ALTER PROCEDURE IncreaseMedicationQuantity
    @Quantity INT OUTPUT,
    @AdditionalQuantity INT
AS
BEGIN
    SET @Quantity = @Quantity + @AdditionalQuantity;
END;
GO

DECLARE @Quantity INT = 20;

EXEC IncreaseMedicationQuantity
    @Quantity = @Quantity OUTPUT,
    @AdditionalQuantity = 5;

SELECT @Quantity AS NewQuantity;
GO
CREATE OR ALTER PROCEDURE ConvertMonthlyToAnnualSalary
    @Salary DECIMAL(10,2) OUTPUT
AS
BEGIN
    SET @Salary = @Salary * 12;
END;
GO

DECLARE @Salary DECIMAL(10,2) = 5000;

EXEC ConvertMonthlyToAnnualSalary
    @Salary = @Salary OUTPUT;

SELECT @Salary AS AnnualSalary;
GO
CREATE OR ALTER PROCEDURE InsertPatientWithErrorHandling
    @PatientID INT,
    @PatientName VARCHAR(100),
    @DateOfBirth DATE,
    @WardID INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Patient
            (PatientID, PatientName, DateOfBirth, WardID)
        VALUES
            (@PatientID, @PatientName, @DateOfBirth, @WardID);

        PRINT 'Patient inserted successfully.';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO
CREATE OR ALTER PROCEDURE UpdateConsultantWithErrorHandling
    @ConsultantID INT,
    @Salary DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        UPDATE Consultant
        SET Salary = @Salary
        WHERE ConsultantID = @ConsultantID;

        IF @@ROWCOUNT = 0
            THROW 50001, 'Consultant not found.', 1;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO
CREATE OR ALTER PROCEDURE DeletePatientWithErrorHandling
    @PatientID INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Patient
        WHERE PatientID = @PatientID;

        IF @@ROWCOUNT = 0
            THROW 50002, 'Patient not found.', 1;
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;
GO
CREATE OR ALTER PROCEDURE AddNewPatient
    @PatientID INT,
    @PatientName VARCHAR(100),
    @DateOfBirth DATE,
    @WardID INT
AS
BEGIN
    INSERT INTO Patient
        (PatientID, PatientName, DateOfBirth, WardID)
    VALUES
        (@PatientID, @PatientName, @DateOfBirth, @WardID);
END;
GO
CREATE OR ALTER PROCEDURE AddNewConsultant
    @ConsultantID INT,
    @ConsultantName VARCHAR(100),
    @Salary DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Consultant
        (ConsultantID, ConsultantName, Salary)
    VALUES
        (@ConsultantID, @ConsultantName, @Salary);
END;
GO
CREATE OR ALTER PROCEDURE RecordMedicationAdministration
    @PatientID INT,
    @MedicationID INT,
    @Quantity INT,
    @AdministrationDate DATE
AS
BEGIN
    INSERT INTO MedicationAdministration
        (PatientID, MedicationID, Quantity, AdministrationDate)
    VALUES
        (@PatientID, @MedicationID, @Quantity, @AdministrationDate);
END;
GO
CREATE OR ALTER PROCEDURE UpdatePatientInformation
    @PatientID INT,
    @PatientName VARCHAR(100),
    @DateOfBirth DATE,
    @WardID INT
AS
BEGIN
    UPDATE Patient
    SET PatientName = @PatientName,
        DateOfBirth = @DateOfBirth,
        WardID = @WardID
    WHERE PatientID = @PatientID;
END;
GO
CREATE OR ALTER PROCEDURE UpdateConsultantSalary
    @ConsultantID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    UPDATE Consultant
    SET Salary = @NewSalary
    WHERE ConsultantID = @ConsultantID;
END;
GO
CREATE OR ALTER PROCEDURE IncreaseNurseSalary
    @NurseID INT,
    @Percentage DECIMAL(5,2)
AS
BEGIN
    UPDATE Nurse
    SET Salary = Salary * (1 + @Percentage / 100.0)
    WHERE NurseID = @NurseID;
END;
GO
CREATE OR ALTER PROCEDURE DeletePatient
    @PatientID INT
AS
BEGIN
    DELETE FROM Patient
    WHERE PatientID = @PatientID;
END;
GO
CREATE OR ALTER PROCEDURE DeleteConsultant
    @ConsultantID INT
AS
BEGIN
    DELETE FROM Consultant
    WHERE ConsultantID = @ConsultantID;
END;
GO
CREATE OR ALTER PROCEDURE DeleteMedicationAdministration
    @PatientID INT,
    @MedicationID INT,
    @AdministrationDate DATE
AS
BEGIN
    DELETE FROM MedicationAdministration
    WHERE PatientID = @PatientID
      AND MedicationID = @MedicationID
      AND AdministrationDate = @AdministrationDate;
END;
GO
CREATE TABLE PatientResults
(
    PatientID INT,
    PatientName VARCHAR(100),
    DateOfBirth DATE,
    WardID INT
);
GO

INSERT INTO PatientResults
EXEC GetAllPatients;
GO

SELECT * FROM PatientResults;
GO
CREATE TABLE HighSalaryConsultants
(
    ConsultantID INT,
    ConsultantName VARCHAR(100),
    Salary DECIMAL(10,2)
);
GO

INSERT INTO HighSalaryConsultants
EXEC GetConsultantsByMinimumSalary
    @MinimumSalary = 50000;
GO

SELECT * FROM HighSalaryConsultants;
GO
CREATE TABLE PatientsFromWard
(
    PatientID INT,
    PatientName VARCHAR(100),
    DateOfBirth DATE,
    WardID INT
);
GO

INSERT INTO PatientsFromWard
EXEC GetPatientsByWard
    @WardID = 1;
GO

SELECT * FROM PatientsFromWard;
GO