From: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
Date: Mon, 31 May 2010 08:35:29 +0200
Message-ID: <4C0358B1.1050605@uni-konstanz.de>
References: <4C001888.8020006@jaysonking.com> <4C0018E1.5060007@jaysonking.com> <20100529004913.GL26177@thunk.org> <4C0070D8.8060500@jaysonking.com> <20100530212502.GQ26177@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040103020008070002020202"
To: tytso@mit.edu, "Jayson R. King" <dev@jaysonking.com>,
	Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Aneesh Kumar K.V" <a
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from purin.rz.uni-konstanz.de ([134.34.240.45]:23300 "EHLO
	purin.rz.uni-konstanz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab0EaGpT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 May 2010 02:45:19 -0400
In-Reply-To: <20100530212502.GQ26177@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040103020008070002020202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 30.05.2010 23:25, schrieb tytso@mit.edu:
> On Fri, May 28, 2010 at 08:41:44PM -0500, Jayson R. King wrote:
>>
>> The difference is that, 2.6.27's write_cache_pages() in
>> page-writeback.c still updates wbc->nr_to_write, since the patch
>> which changed that behavior was dropped from .27-rc2 due to the XFS
>> regression it causes on mainline. ext4 appears to want the behavior
>> of write_cache_pages which does not update wbc->nr_to_write. This
>> write_cache_pages_da() does what ext4 wants, without introducing the
>> XFS regression. So I believe it is needed.
>
> Ah, OK.  So I understand the motivation now, and that's a valid
> concern.  The question is now: how much the goal of the 2.6.27 stable
> branch to fix bugs, and how much is it to get the best possible
> performance, at least with respect to ext4?  It's going to be harder
> and harder to backport fixes to 2.6.27, and I can speak from
> experience that it's very easy to introduce regressions while trying
> to do backports, since sometimes an individual upstream commit can end
> up introducing a regression, and while we do try to document
> regression fixes in later commits, sometimes the documentation isn't
> complete.
>
> I just spent the better part of a day trying to fix up a backport
> series for 2.6.32.  When I was engaged in this particular exercise, it
> turns out a particular commit to fix a quota deadlock introduced a
> regression, and the fix to that introduced yet another, and there were
> three or four patches that all needed to be pulled in at once.  Except
> initially I missed one, and that caused an i_blocks corruption issue
> when using fallocate() that took me several hours and a reverse
> git-bisection to find.  (And this is one set of fixes that will
> probably never be able to go into 2.6.27.y, since these changes also
> interlock with probably a dozen or so quota changes that have also
> gone in over the last couple of kernel releases.)
>
> I'll also add that simply testing using dbench, as you said you used
> in another e-mail message, really isn't good enough to find all
> possible regressions (it wouldn't have found the i_blocks corruption
> problem in my initial set of 2.6.32 ext4 backports patches, for
> example, since dbench only tests a very limited set of fs operations,
> which doesn't include fallocate, or quotas, or mmap for that matter.)
>
> What I would recommend is using the XFSQA (also sometimes known
> xfstests) test suite to make sure that your changes are sound.  Dbench
> will sometimes find issues, yes, but in my experience it's not the
> best tool.  The fsstress program, which is called in a number of
> different configurations by xfstests, has found all sorts of problems
> that other thing shaven't been able to find.  Run it on at least a
> 2-core system, or preferably a 4-core or 8-core system if you have it.
> I generally run tests using both 4k and 1k blocksize file systems to
> make sure there aren't problems where the fs blocksize is less than
> the pagesize.
>
> If you are willing to take on the support burden of ext4 for 2.6.27,
> and do a lot of testing, I at least wouldn't have any objection to
> these patches.  It's really a question of risk vs. reward for the
> users of the 2.6.27 stable tree, plus a question of someone willing to
> take on the support/debugging burden, and how much testing is done to
> appropriate tilt the risk/reward balance.
>
> Regards,
>
> 						- Ted

For what it's worth: my 2.6.27.45 fileservers deadlock reproducibly=20
after 1 to 2 minutes of heavy NFS load, when using ext4 (never had a=20
problem with ext3). Jayson King's patch series (posted Feb 27) fixed=20
this, and I've been running it since May 1 without problems.

 From my experience, I'd say that the ext4 deadlock needs to be fixed;=20
otherwise ext4 in 2.6.27 should not be called stable.

best wishes,
Kay


--------------ms040103020008070002020202
Content-Type: application/pkcs7-signature; name="smime.p7s"
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
MQ8XDTEwMDUzMTA2MzUyOVowIwYJKoZIhvcNAQkEMRYEFKXaSbpCMmI2WvAh2mB6CJgse9MW
MF8GCSqGSIb3DQEJDzFSMFAwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMC
AgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBoAYJKwYBBAGC
NxAEMYGSMIGPMHwxCzAJBgNVBAYTAkRFMRwwGgYDVQQKExNUQyBUcnVzdENlbnRlciBHbWJI
MSUwIwYDVQQLExxUQyBUcnVzdENlbnRlciBDbGFzcyAxIEwxIENBMSgwJgYDVQQDEx9UQyBU
cnVzdENlbnRlciBDbGFzcyAxIEwxIENBIFZJAg8AxikAAQACLgkJbujZecwwgaIGCyqGSIb3
DQEJEAILMYGSoIGPMHwxCzAJBgNVBAYTAkRFMRwwGgYDVQQKExNUQyBUcnVzdENlbnRlciBH
bWJIMSUwIwYDVQQLExxUQyBUcnVzdENlbnRlciBDbGFzcyAxIEwxIENBMSgwJgYDVQQDEx9U
QyBUcnVzdENlbnRlciBDbGFzcyAxIEwxIENBIFZJAg8AxikAAQACLgkJbujZecwwDQYJKoZI
hvcNAQEBBQAEggEAFT8SsilS6ROAqq5+UNZN6B8mpHPIh+tsn+rwf+XWn2sipM4FU4+HxaT3
ehJtCbLN2oLFh5bPPDcXpxk28CWBBj+SZ4eErwiT/fcNRnWg6XZtIYYR4T4W/Eh0xeNnRxwZ
qdT+bl61DWzZ2zKUJ8JS0fiPZHaDtCsKsqpuUF58CNMVUeEX+7zRIFoMijr8CdRGoa+gG6II
ogQUHkuyAzCxngBbUYTH4Had5jnPB7oFsIlzuf6G4lgCTGxgrGSdmoHHEkKP5pLpFGJsVSmo
GG9H7pwEPNbin29UiVfCReOUbRepw2HXC3m1XRcd8HRNAn4Ft76VPGOf97zP0p2Kn2H3+AAA
AAAAAA==
--------------ms040103020008070002020202--
