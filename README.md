## What is FMT().
FMT() is a simple Vertica User Defined SQL Function to format numbers... with thousand/decimal separators according to the server locale definition and round them... * the right way*. 

I know the standard ```TO_CHAR``` is implemented by several databases (including Vertica):
```sql
SELECT TO_CHAR(1234555677789.12345, '9G999G999G999G999D99') FROM DUAL;

        TO_CHAR
-----------------------
1,234,555,677,789.12

(1 row)
```
but...
1. it is too long to type for my taste
2. they pretend me to know in advance the format of the output string and put the thousand **group separators** (G) in the right places
3. it convert input numbers to FLOAT which can introduce approximations for very large numbers

 ```FMT()``` overcomes all these issues:
 - it's short to type
 - it will automatically insert a thousand separators every three digits *on its own*
 - it does not introduce approximations and can work with arbitrary long numbers.

## What FMT() can be used for.
```FMT()``` can be used to format numbers in output and you can call it using three different syntaxes:

- ```FMT(number)``` will format the number adding thousand separators without decimals
- ```FMT(number, #decimals)``` will add thousand separators and round to the specified decimals
- ```FMT(number, #decimals, format)```will add thousand separators and round to the specified number of decimals using one of the following formats:
	-  ```N``` for numbers
	- ```P``` for percentages
	- ```T``` for per thousands 

## FMT() examples.
Here you have a few examples:
```SQL
SELECT FMT(-1234);
  FMT   
--------
 -1,234
(1 row)

SELECT FMT(1234567890.98765);
      FMT      
---------------
 1,234,567,890
(1 row)

SELECT FMT(1234567890.98765, 3);
        FMT        
-------------------
 1,234,567,890.988
(1 row)

SELECT FMT(-1234566666666666677777777777777778888888888888889999999999999999.7896543, 4);
                                             FMT                                             
---------------------------------------------------------------------------------------------
 -1,234,566,666,666,666,677,777,777,777,777,778,888,888,888,888,889,999,999,999,999,999.7897
(1 row)

SELECT FMT(0.1234, 0, 'P');
 FMT 
-----
 12%
(1 row)

SELECT FMT(0.1234621, 2, 'P');
  FMT   
--------
 12.35%
(1 row)

SELECT FMT(0.00345432, 3, 'T');
  FMT   
--------
 3.454‰
(1 row)

SELECT FMT(126.987654, 3, 'P');
     FMT     
-------------
 12,698.765%
(1 row)
```
## How to install FMT()
- **First**... have a look to the ```Makefile```
- **Second**, as dbadmin, deploy the code in Vertica: ```make deploy```
- And, **finally**, you can ```make test``` and check everything is ok by comparing the output with the expected one here below...

Expected output:
```bash
$ make deploy
vsql -U dbadmin -X -f fmt.sql
CREATE FUNCTION
CREATE FUNCTION
CREATE FUNCTION
GRANT EXECUTE ON FUNCTION FMT(n NUMERIC) TO PUBLIC;
GRANT EXECUTE ON FUNCTION FMT(n NUMERIC, d INTEGER) TO PUBLIC;
GRANT EXECUTE ON FUNCTION FMT(n NUMERIC, d INTEGER, f VARCHAR) TO PUBLIC;

$ make test
SELECT FMT(-1234);
   FMT
--------
-1,234

(1 row) 

SELECT FMT(-1234567890);
      FMT
----------------
-1,234,567,890

(1 row)

SELECT FMT(1234567890.98765);
      FMT
---------------
1,234,567,890

(1 row)

SELECT FMT(1234567890.98765, 3);
        FMT
-------------------
1,234,567,890.988

(1 row)

SELECT FMT(1234567890.98765, 3, 'N');
        FMT
-------------------
1,234,567,890.988

(1 row)

SELECT FMT(-1234566666666666677777777777777778888888888888889999999999999999.7896543);
                                         FMT
----------------------------------------------------------------------------------------
-1,234,566,666,666,666,677,777,777,777,777,778,888,888,888,888,889,999,999,999,999,999

(1 row)

SELECT FMT(-1234566666666666677777777777777778888888888888889999999999999999.7896543, 4, 'N');
                                             FMT
---------------------------------------------------------------------------------------------
-1,234,566,666,666,666,677,777,777,777,777,778,888,888,888,888,889,999,999,999,999,999.7897

(1 row)

SELECT FMT(0.1234, 0, 'P');
 FMT
-----
 12%

(1 row)

SELECT FMT(0.1234621, 2, 'P');
  FMT
--------
12.35%

(1 row)
 

SELECT FMT(0.00345432, 3, 'T');
  FMT
--------
3.454‰

(1 row)

SELECT FMT(126.987654, 3, 'P');
     FMT
-------------
12,698.765%

(1 row)

$ make clean
DROP FUNCTION FMT(n NUMERIC) ;
DROP FUNCTION
DROP FUNCTION FMT(n NUMERIC, d INTEGER) ;
DROP FUNCTION
DROP FUNCTION FMT(n NUMERIC, d INTEGER, f VARCHAR) ;
DROP FUNCTION
```

## Aknowledgments
Many thanks to my colleagues :
- Dinq-Qiang Liu (DQ)
- Gianluigi Viganò (GG)
- Maciej Paliwoda
- Marco Gessner

for their suggestions.
