-- INSERT XML data into AddressTable

DECLARE @xmlData XML

SET @xmlData = 
'<xml>
    <record id="1" name="Daffy" city="Anaheim" zip="94551"/>
    <record id="2" name="Pluto" city="Anaheim" zip="94551"/>
</xml>'

INSERT INTO dbo.AddressTable (fName, City, Zip)
SELECT 
    X.field.value('@name', 'VARCHAR(20)') AS fName,
    X.field.value('@city', 'VARCHAR(20)') AS City,
    X.field.value('@zip', 'VARCHAR(20)') AS Zip
FROM 
    @xmlData.nodes('/xml/record') AS X(field);

--Validation of data insert
SELECT * FROM dbo.AddressTable

