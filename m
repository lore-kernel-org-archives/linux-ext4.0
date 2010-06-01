From: Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
Date: Tue, 01 Jun 2010 17:23:07 +0200
Message-ID: <4C0525DB.7000103@uni-konstanz.de>
References: <4C001888.8020006@jaysonking.com> <4C0018E1.5060007@jaysonking.com> <20100529004913.GL26177@thunk.org> <4C0070D8.8060500@jaysonking.com> <20100530212502.GQ26177@thunk.org> <4C0358B1.1050605@uni-konstanz.de> <AANLkTin3rfw04Shsmmd2O0URjWqbUhf-HOw4r2dXaprH@mail.gmail.com> <070DAF41-4DD5-4F20-B9F1-3B472147C499@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms060000090708070008050709"
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	"Jayson R. King" <dev@jaysonking.com>,
	Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pyrimidin.rz.uni-konstanz.de ([134.34.240.46]:10627 "EHLO
	pyrimidin.rz.uni-konstanz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756322Ab0FAPXJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jun 2010 11:23:09 -0400
In-Reply-To: <070DAF41-4DD5-4F20-B9F1-3B472147C499@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060000090708070008050709
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Theodore Tso schrieb:
> On Jun 1, 2010, at 9:54 AM, Greg Freemyer wrote:
>> It has always been marked experimental in 2.6.27, not stable so I'm
>> totally lost about this effort.
>>
>> See http://lxr.linux.no/#linux+v2.6.27.47/fs/Kconfig
> 
> This is one of the things that confuses me, actually.  Why is it that there are a number of people who want to use ext4 on 2.6.27?   Even the enterprise distro's have moved on; SLES 11 SP1 upgraded their users from 2.6.27 to 2.6.32, for example.  I wonder if it's time to start a new "stable anchor point" around 2.6.32, given that Ubuntu's latest Long-Term Stable (Lucid LTS) is based on 2.6.32, as is SLES 11 SP1.  The RHEL 6 beta is also based on 2.6.32.  (And I just spent quite a bit of time over the past week backporting a lot of ext4 bug fixes to 2.6.32.y :-)
> 
> If there are people who want to work on trying to backport more ext4 fixes to 2.6.27, they're of course free to do so.  I am really curious  as to *why*, though.
> 
> Regards,
> 
> -- Ted
> 

The answer is: because 2.6.27.y is supposed to be a _stable_ kernel. If
it were e.g. 2.6.28 or 2.6.29, nobody would care. But as long as there
is a flow of backported fixes (and there have been quite a few ext4
fixes in 2.6.27) I have the expectation that known bugs get fixed sooner
or later.

If a subsystem maintainer says "I'm not going to support this old stable
thing any longer" then things change. But I hear this from you for the
first time - I may have missed earlier announcements to this effect, though.

best,

Kay

--------------ms060000090708070008050709
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOlTCC
BM8wggQ4oAMCAQICDwCUsAABAAJijbUfbuxyZDANBgkqhkiG9w0BAQUFADCBvDELMAkGA1UE
BhMCREUxEDAOBgNVBAgTB0hhbWJ1cmcxEDAOBgNVBAcTB0hhbWJ1cmcxOjA4BgNVBAoTMVRD
IFRydXN0Q2VudGVyIGZvciBTZWN1cml0eSBpbiBEYXRhIE5ldHdvcmtzIEdtYkgxIjAgBgNV
BAsTGVRDIFRydXN0Q2VudGVyIENsYXNzIDEgQ0ExKTAnBgkqhkiG9w0BCQEWGmNlcnRpZmlj
YXRlQHRydXN0Y2VudGVyLmRlMB4XDTA4MDcxODExMzg1NFoXDTEwMTIzMTIyNTk1OVowfDEL
MAkGA1UEBhMCREUxHDAaBgNVBAoTE1RDIFRydXN0Q2VudGVyIEdtYkgxJTAjBgNVBAsTHFRD
IFRydXN0Q2VudGVyIENsYXNzIDEgTDEgQ0ExKDAmBgNVBAMTH1RDIFRydXN0Q2VudGVyIENs
YXNzIDEgTDEgQ0EgVkkwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAJQFP39OlsR+FrO6
sIC5tx+k3aTjsL4oCLrsrd2Z9nVMzrHxnvShlmxLhgElFThIoRzo7gr1mZbx2/Gu3X51SEBN
TkP3bV2U0jn9yxGo97oYWA/+cRUKEEsxfvbPX5DL992EupcEptQAVutm32so3dGi+nqe2mFX
wx8wpDAnCkDRAgMBAAGjggIQMIICDDCBjgYIKwYBBQUHAQEEgYEwfzBMBggrBgEFBQcwAoZA
aHR0cDovL3d3dy50cnVzdGNlbnRlci5kZS9jZXJ0c2VydmljZXMvY2FjZXJ0cy90Y19jbGFz
c18xX2NhLmNydDAvBggrBgEFBQcwAYYjaHR0cDovL29jc3AudGNjbGFzczEudHJ1c3RjZW50
ZXIuZGUwDwYDVR0TAQH/BAUwAwEB/zBKBgNVHSAEQzBBMD8GCSqCFAAsAQEBATAyMDAGCCsG
AQUFBwIBFiRodHRwOi8vd3d3LnRydXN0Y2VudGVyLmRlL2d1aWRlbGluZXMwDgYDVR0PAQH/
BAQDAgGGMB0GA1UdDgQWBBROm/Wy+91qa9xKB6/Ju2T/FksmnzCB7AYDVR0fBIHkMIHhMIHe
oIHboIHYhjtodHRwOi8vY3JsLnRjY2xhc3MxLnRydXN0Y2VudGVyLmRlL2NybC92Mi90Y19j
bGFzc18xX2NhLmNybIaBmGxkYXA6Ly93d3cudHJ1c3RjZW50ZXIuZGUvQ049VEMlMjBUcnVz
dENlbnRlciUyMENsYXNzJTIwMSUyMENBLE89VEMlMjBUcnVzdENlbnRlciUyMEFHLG91PXJv
b3RjZXJ0cyxkYz10cnVzdGNlbnRlcixkYz1kZT9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
P2Jhc2U/MA0GCSqGSIb3DQEBBQUAA4GBAG4ApLln3RLqDiymjdk8SFs8S6acQryrkZB/DJ2Q
H6n+6LYqEjirh+/Zj8uweQL6p6d9g/dl4S1wpIGCVC33AdcM8qer/Cn0qcQ6bdduesfTcdQv
5uZlSsyEdKNa44DVtOh3IkTLtFdcDiY4tQFriM7kVC5Xuhyfxo58V1vOM8r+MIIE3TCCBEag
AwIBAgIPAMYpAAEAAi4JCW7o2XnMMA0GCSqGSIb3DQEBBQUAMHwxCzAJBgNVBAYTAkRFMRww
GgYDVQQKExNUQyBUcnVzdENlbnRlciBHbWJIMSUwIwYDVQQLExxUQyBUcnVzdENlbnRlciBD
bGFzcyAxIEwxIENBMSgwJgYDVQQDEx9UQyBUcnVzdENlbnRlciBDbGFzcyAxIEwxIENBIFZJ
MB4XDTA5MDYxMTA3MzM1NVoXDTEwMDYxMjA3MzM1NVowWTELMAkGA1UEBhMCREUxGzAZBgNV
BAMTEkRyLiBLYXkgRGllZGVyaWNoczEtMCsGCSqGSIb3DQEJARYea2F5LmRpZWRlcmljaHNA
dW5pLWtvbnN0YW56LmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAq8l+Wnxi
cqMo9KicOd1kqdaq3pAymwWO/J7ejbVjKChe10XnaITas8R1k9FrF54FsvssThDwmwsDWFjh
eE0Fyegt+fk2tpXX4YnjqUcrlHkO5YHGQ0ogcrhvaMEKYoKLriH/Nip0o8ljtMesL33gSPeV
BOpyFwngqYUCt0rZPBytI+wxpN+SAEAO6erxvC4pASYpGTU5KBYPi5o5yf+9damc3flRF6Jl
tbX+5aBFkra8CiWjH3q44DnnPn/DI+0HZs5goQWPmvzLA5GMy5T+3oXCGOKNFYFp7Y2AFdDf
2NyqSAo5KSd1D5qhCGWVedTeot435M5lqYWPJDFJj8Ew5QIDAQABo4IB/jCCAfowgZcGCCsG
AQUFBwEBBIGKMIGHMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3LnRydXN0Y2VudGVyLmRlL2Nl
cnRzZXJ2aWNlcy9jYWNlcnRzL3RjX2NsYXNzMV9MMV9DQV9WSS5jcnQwMgYIKwYBBQUHMAGG
Jmh0dHA6Ly9vY3NwLlZJLnRjY2xhc3MxLnRydXN0Y2VudGVyLmRlMB8GA1UdIwQYMBaAFE6b
9bL73Wpr3EoHr8m7ZP8WSyafMAwGA1UdEwEB/wQCMAAwSgYDVR0gBEMwQTA/BgkqghQALAEB
AQEwMjAwBggrBgEFBQcCARYkaHR0cDovL3d3dy50cnVzdGNlbnRlci5kZS9ndWlkZWxpbmVz
MA4GA1UdDwEB/wQEAwIE8DAdBgNVHQ4EFgQUac6i+TKOEt89dgE1SZwkDGCIPEcwVAYDVR0f
BE0wSzBJoEegRYZDaHR0cDovL2NybC5WSS50Y2NsYXNzMS50cnVzdGNlbnRlci5kZS9jcmwv
djIvdGNfY2xhc3MxX0wxX0NBX1ZJLmNybDAzBgNVHSUELDAqBggrBgEFBQcDAgYIKwYBBQUH
AwQGCCsGAQUFBwMHBgorBgEEAYI3FAICMCkGA1UdEQQiMCCBHmtheS5kaWVkZXJpY2hzQHVu
aS1rb25zdGFuei5kZTANBgkqhkiG9w0BAQUFAAOBgQBxO9sd6s4Lh9a2S70xvqvPkMZE6im+
kI61FLhAhJqOqY3okJuO6xIdMjgbwblAuoEkHRaDTSna/2clqwH1k/PiHn0TLHwWRCLIW3iO
WjwkIewI1Jn3xsmxrvc3TLec69BcKHDwcsuE2rSv2GzM9qH0Vx7EuVehRrCa1oZNgQsEZzCC
BN0wggRGoAMCAQICDwDGKQABAAIuCQlu6Nl5zDANBgkqhkiG9w0BAQUFADB8MQswCQYDVQQG
EwJERTEcMBoGA1UEChMTVEMgVHJ1c3RDZW50ZXIgR21iSDElMCMGA1UECxMcVEMgVHJ1c3RD
ZW50ZXIgQ2xhc3MgMSBMMSBDQTEoMCYGA1UEAxMfVEMgVHJ1c3RDZW50ZXIgQ2xhc3MgMSBM
MSBDQSBWSTAeFw0wOTA2MTEwNzMzNTVaFw0xMDA2MTIwNzMzNTVaMFkxCzAJBgNVBAYTAkRF
MRswGQYDVQQDExJEci4gS2F5IERpZWRlcmljaHMxLTArBgkqhkiG9w0BCQEWHmtheS5kaWVk
ZXJpY2hzQHVuaS1rb25zdGFuei5kZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
AKvJflp8YnKjKPSonDndZKnWqt6QMpsFjvye3o21YygoXtdF52iE2rPEdZPRaxeeBbL7LE4Q
8JsLA1hY4XhNBcnoLfn5NraV1+GJ46lHK5R5DuWBxkNKIHK4b2jBCmKCi64h/zYqdKPJY7TH
rC994Ej3lQTqchcJ4KmFArdK2TwcrSPsMaTfkgBADunq8bwuKQEmKRk1OSgWD4uaOcn/vXWp
nN35UReiZbW1/uWgRZK2vAolox96uOA55z5/wyPtB2bOYKEFj5r8ywORjMuU/t6FwhjijRWB
ae2NgBXQ39jcqkgKOSkndQ+aoQhllXnU3qLeN+TOZamFjyQxSY/BMOUCAwEAAaOCAf4wggH6
MIGXBggrBgEFBQcBAQSBijCBhzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy50cnVzdGNlbnRl
ci5kZS9jZXJ0c2VydmljZXMvY2FjZXJ0cy90Y19jbGFzczFfTDFfQ0FfVkkuY3J0MDIGCCsG
AQUFBzABhiZodHRwOi8vb2NzcC5WSS50Y2NsYXNzMS50cnVzdGNlbnRlci5kZTAfBgNVHSME
GDAWgBROm/Wy+91qa9xKB6/Ju2T/FksmnzAMBgNVHRMBAf8EAjAAMEoGA1UdIARDMEEwPwYJ
KoIUACwBAQEBMDIwMAYIKwYBBQUHAgEWJGh0dHA6Ly93d3cudHJ1c3RjZW50ZXIuZGUvZ3Vp
ZGVsaW5lczAOBgNVHQ8BAf8EBAMCBPAwHQYDVR0OBBYEFGnOovkyjhLfPXYBNUmcJAxgiDxH
MFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly9jcmwuVkkudGNjbGFzczEudHJ1c3RjZW50ZXIu
ZGUvY3JsL3YyL3RjX2NsYXNzMV9MMV9DQV9WSS5jcmwwMwYDVR0lBCwwKgYIKwYBBQUHAwIG
CCsGAQUFBwMEBggrBgEFBQcDBwYKKwYBBAGCNxQCAjApBgNVHREEIjAggR5rYXkuZGllZGVy
aWNoc0B1bmkta29uc3RhbnouZGUwDQYJKoZIhvcNAQEFBQADgYEAcTvbHerOC4fWtku9Mb6r
z5DGROopvpCOtRS4QISajqmN6JCbjusSHTI4G8G5QLqBJB0Wg00p2v9nJasB9ZPz4h59Eyx8
FkQiyFt4jlo8JCHsCNSZ98bJsa73N0y3nOvQXChw8HLLhNq0r9hszPah9FcexLlXoUawmtaG
TYELBGcxggPBMIIDvQIBATCBjzB8MQswCQYDVQQGEwJERTEcMBoGA1UEChMTVEMgVHJ1c3RD
ZW50ZXIgR21iSDElMCMGA1UECxMcVEMgVHJ1c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQTEoMCYG
A1UEAxMfVEMgVHJ1c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQSBWSQIPAMYpAAEAAi4JCW7o2XnM
MAkGBSsOAwIaBQCgggIGMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTEwMDYwMTE1MjMwN1owIwYJKoZIhvcNAQkEMRYEFEwgNVBjr1N0GHw2bMT0cLCCiNzg
MF8GCSqGSIb3DQEJDzFSMFAwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMC
AgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBoAYJKwYBBAGC
NxAEMYGSMIGPMHwxCzAJBgNVBAYTAkRFMRwwGgYDVQQKExNUQyBUcnVzdENlbnRlciBHbWJI
MSUwIwYDVQQLExxUQyBUcnVzdENlbnRlciBDbGFzcyAxIEwxIENBMSgwJgYDVQQDEx9UQyBU
cnVzdENlbnRlciBDbGFzcyAxIEwxIENBIFZJAg8AxikAAQACLgkJbujZecwwgaIGCyqGSIb3
DQEJEAILMYGSoIGPMHwxCzAJBgNVBAYTAkRFMRwwGgYDVQQKExNUQyBUcnVzdENlbnRlciBH
bWJIMSUwIwYDVQQLExxUQyBUcnVzdENlbnRlciBDbGFzcyAxIEwxIENBMSgwJgYDVQQDEx9U
QyBUcnVzdENlbnRlciBDbGFzcyAxIEwxIENBIFZJAg8AxikAAQACLgkJbujZecwwDQYJKoZI
hvcNAQEBBQAEggEADMpBhgZ7FwnUTf1KpHCVkRSkLRdRGeBor51o13/WvN8xSTwWH6E7Nsci
Q4k3wHRxJZiaVR+NLoVi4QtS7Mip+bPF3lpHIqb2+KP9fHmUYFnmy4abgo5f2DMsshd3REMq
AN0Hsevaa4Kr4QYREFyyOSOnLM/QAbyuxwoF6aFA5N81Fuuz+a5i4QqwgCyM5iADkHiwAQ0C
i+9MMTR1SI5NUEfvDbE6+wAG+2R8FW1zaSpw7x9HSmcz7+iwDOYZakqSK3pkwuXW+TdM1pP1
lHDgiec0oIRHtK0o36s36W1pcoaooGqj8tJ4D1Yw642aAdn+w/q0R3Vm1sD2mXu41dYOewAA
AAAAAA==
--------------ms060000090708070008050709--
