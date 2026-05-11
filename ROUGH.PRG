SET CONSOLE OFF
RETU
PartyCode=pcod
sele c
set order to ord
seek PartyCode
Xmobile=''
    if substr(setup_mf5,59,1)='Y'
    	Xmobile=patient_code
    else
	    Xmobile=invopho
    endif
	Xmobile=iif(empty(xmobile),c.phone4,xmobile)
	
	*wait wind xmobile
	*retu
LOCAL loHttp, lcURL, lcJSON, lcResponse
LOCAL m.phone, lnPos, lcBalance
m.phone = xmobile   && use your variable
lcURL = "https://billfree.in/m-api/get-balance-points"
*-----------------------------
* JSON REQUEST
*-----------------------------
TEXT TO lcJSON NOSHOW TEXTMERGE
{
"auth_token":"40667435d8be58976551be3c8f82d8eb",
"user_phone":"<<m.phone>>",
"dial_code":"91"
}
ENDTEXT
*-----------------------------
* API CALL
*-----------------------------
loHttp = CREATEOBJECT("WinHttp.WinHttpRequest.5.1")
loHttp.Open("POST", lcURL, .F.)
loHttp.SetRequestHeader("Content-Type","application/json")
loHttp.Send(lcJSON)
lcResponse = loHttp.ResponseText
*-----------------------------
* EXTRACT BALANCE (FIXED)
*-----------------------------
lnPos = AT('"balance":', lcResponse)
IF lnPos > 0
    lnPos = lnPos + LEN('"balance":')
    lcBalance = SUBSTR(lcResponse, lnPos, 20)
    IF AT(",", lcBalance) > 0
        lcBalance = LEFT(lcBalance, AT(",", lcBalance)-1)
    ENDIF
    lcBalance = STRTRAN(lcBalance, '"', "")
    lcBalance = STRTRAN(lcBalance, "}", "")
    lcBalance = ALLTRIM(lcBalance)
ELSE
    lcBalance = "0"
ENDIF
*-----------------------------
* BIG FONT POPUP (NO FORM)
*-----------------------------
DEFINE WINDOW winBal FROM 10,20 TO 20,70 TITLE "BillFree Loyalty" FLOAT
ACTIVATE WINDOW winBal
@ 3,8 SAY "Loyalty Points Balance" FONT "Arial",12 STYLE "B"
@ 6,20 SAY lcBalance FONT "Arial",22 STYLE "B"
@ 9,10 SAY "Press any key to continue..." FONT "Arial",9
INKEY(0)
*!*	SELECT SUPPORT
*!*	SET ORDER TO SUPP
*!*	SEEK 'F'+'MYHOOK  '+pcod+STR(0,9)+STR(0,9)+str(2,3)
*!*	lcRemark=SUPPORT.REMARK
*!*	* Replace balance at position 53
*!*	*lcRemark = STUFF(lcRemark,53,7,TRANSFORM(lcBalance))
*!*	REPLACE SUPPORT.REMARK WITH lcRemark
*!*	brow
RELEASE WINDOW winBal
*!*	RETURN










*****FOTTER END
*!*	myv_date=padr(strinvalueonpos("|",marg_bill_saveon,0),10)
*!*	myv_value=val(strinvalueonpos("|",marg_bill_saveon,1))
*!*	myv_remark=padr(strinvalueonpos("|",marg_bill_saveon,2),25)
*!*	colofhed="MY OWN HEADING SAVEON"
*!*	=colofil(10,20,14,57,10)
*!*	@ 11,21 say "DATE   :" get myv_date valid checkmrgdt("myv_date",0,firstdate,lastdate) func "@K"
*!*	@ 12,21 say "VALUE  :" get myv_value pict "999999.99"
*!*	@ 13,21 say "REMARK :" get myv_remark
*!*	=margread(1)
*!*	if lastkey()=27
*!*		retu .f.
*!*	endif
*!*	marg_bill_saveon=trim(myv_date)+"|"+ltrim(str(myv_value,12,self_amcdisw))+"|"+trim(chrtran(myv_remark,"|",","))
*!*	retu .t.
PartyCode=pcod
sele c
set order to ord
seek PartyCode
Xmobile=''
    if substr(setup_mf5,59,1)='Y'
    	Xmobile=patient_code
    else
	    Xmobile=invopho
    endif
	Xmobile=iif(empty(xmobile),c.phone4,xmobile)
	sele (mewsale)
	sum rateamt+staamo to Tinvvalue
LOCAL loHttp, lcURL, lcJSON, lcResponse
LOCAL m.phone, m.billamt, m.invno,m.invdt
LOCAL lnPos, lcMaxAmt
m.phone   = XMOBILE   && your mobile
m.billamt = tInvvalue      && your bill amount
m.invno   = invo      && your invoice no
m.invdt=repdat1		&&inv date
lcURL = "https://billfree.in/m-api/get-points-discount"
*-----------------------------
* JSON REQUEST
*-----------------------------
TEXT TO lcJSON NOSHOW TEXTMERGE
{
"auth_token":"40667435d8be58976551be3c8f82d8eb",
"user_phone":"<<m.phone>>",
"dial_code":"91",
"inv_no":"<<m.invno>>",
"bill_date":"<<m.invdt>>",
"bill_amt":"<<m.billamt>>"
}
ENDTEXT
*-----------------------------
* API CALL
*-----------------------------
loHttp = CREATEOBJECT("WinHttp.WinHttpRequest.5.1")
loHttp.Open("POST", lcURL, .F.)
loHttp.SetRequestHeader("Content-Type","application/json")
loHttp.Send(lcJSON)
lcResponse = loHttp.ResponseText
*-----------------------------
* EXTRACT maxRedeemableAmt
*-----------------------------
lnPos = AT('"maxRedeemableAmt":', lcResponse)
IF lnPos > 0
    lnPos = lnPos + LEN('"maxRedeemableAmt":')
    lcMaxAmt = SUBSTR(lcResponse, lnPos, 20)
    IF AT(",", lcMaxAmt) > 0
        lcMaxAmt = LEFT(lcMaxAmt, AT(",", lcMaxAmt)-1)
    ENDIF
    lcMaxAmt = STRTRAN(lcMaxAmt, '"', "")
    lcMaxAmt = STRTRAN(lcMaxAmt, "}", "")
    lcMaxAmt = ALLTRIM(lcMaxAmt)
ELSE
    lcMaxAmt = "0"
ENDIF
*-----------------------------
* SIMPLE BIG POPUP
*-----------------------------
DEFINE WINDOW winDisc FROM 10,20 TO 20,70 TITLE "Loyalty Discount" FLOAT
ACTIVATE WINDOW winDisc
@ 3,5 SAY "Max Redeemable Amount" FONT "Arial",12 STYLE "B"
@ 6,20 SAY lcMaxAmt FONT "Arial",22 STYLE "B"
@ 9,8 SAY "Press any key to continue..." FONT "Arial",9
INKEY(0)
*mtotaldis=VAL(lcMaxAmt)
RELEASE WINDOW winDisc
do verifyOtp
RETURN
Proc verifyOtp
	LOCAL loHttp, lcURL, lcJSON, lcResponse
	LOCAL m.phone, lcToken, m.otp, lnPos
	m.phone =xMobile
	wait wind m.phone
	*=============================
	* STEP 1: CREATE OTP
	*=============================
	lcURL = "https://billfree.in/m-api/create-otp"
	TEXT TO lcJSON NOSHOW TEXTMERGE
	{
	"auth_token":"40667435d8be58976551be3c8f82d8eb",
	"user_phone":"<<m.phone>>",
	"dial_code":"91",
	"data":{"auth_token":"40667435d8be58976551be3c8f82d8eb"},
	"purpose":"custVerify"
	}
	ENDTEXT
	loHttp = CREATEOBJECT("WinHttp.WinHttpRequest.5.1")
	loHttp.Open("POST", lcURL, .F.)
	loHttp.SetRequestHeader("Content-Type","application/json")
	loHttp.Send(lcJSON)
	lcResponse = loHttp.ResponseText
	WAIT WIND lcResponse
	*-----------------------------
	* EXTRACT TOKEN
	*-----------------------------
	lnPos = AT('"token":"', lcResponse)
	IF lnPos > 0
	    lnPos = lnPos + LEN('"token":"')
	    lcToken = SUBSTR(lcResponse, lnPos, 50)
	    lcToken = LEFT(lcToken, AT('"', lcToken)-1)
	ELSE
	    MESSAGEBOX("Failed to send OTP","Error")
	    RETURN
	ENDIF
	*=============================
	* STEP 2: ASK USER OTP INPUT
	*=============================
	m.otp = SPACE(6)
	DEFINE WINDOW winOtp FROM 10,20 TO 18,60 TITLE "Enter OTP" FLOAT
	ACTIVATE WINDOW winOtp
	@ 3,5 SAY "Enter OTP received on mobile:" FONT "Arial",10
	@ 5,10 GET m.otp SIZE 10,1
	READ
	RELEASE WINDOW winOtp
	m.otp = ALLTRIM(m.otp)
	IF EMPTY(m.otp)
	    MESSAGEBOX("OTP cannot be empty","Error")
	    RETURN
	ENDIF
	*=============================
	* STEP 3: VERIFY OTP
	*=============================
	lcURL = "https://billfree.in/m-api/verify-otp"
	TEXT TO lcJSON NOSHOW TEXTMERGE
	{
	"auth_token":"40667435d8be58976551be3c8f82d8eb",
	"user_phone":"<<m.phone>>",
	"dial_code":"91",
	"token":"<<lcToken>>",
	"otp":"<<m.otp>>"
	}
	ENDTEXT
	loHttp = CREATEOBJECT("WinHttp.WinHttpRequest.5.1")
	loHttp.Open("POST", lcURL, .F.)
	loHttp.SetRequestHeader("Content-Type","application/json")
	loHttp.Send(lcJSON)
	lcResponse = loHttp.ResponseText
	*-----------------------------
	* CHECK SUCCESS
	*-----------------------------
	IF AT('"error":false', lcResponse) > 0
		mtotaldis=VAL(lcMaxAmt)
	    MESSAGEBOX("OTP Verified Successfully",64,"Success")
	ELSE
	    MESSAGEBOX("Invalid OTP","Error")
	ENDIF
RETURN
retu




*******************




{
  "error": false,
  "response": "l5",
  "maxRedeemablePts": 2399,
  "maxRedeemableAmt": 1199.4,
  "net_payable": 799.6,
  "otpFlag": "n",
  "pointFactorValue": "1" // its denotation of 1 point value in currency value; eg. 1 point = 1 rupees
  "scheme_message": "1. Maximum 50% of the bill value can be paid by loyalty points\n2. Minimum 1 point has to be redeemed on a single bill\n3. You can redeem a max of 2399 points on this bill Equivalent to 1199.4.\n4. 1 point is equal to Rs. 0.5"
}