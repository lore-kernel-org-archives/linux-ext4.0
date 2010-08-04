From: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Subject: Re: ext4 performance regression 2.6.27-stable versus 2.6.32 and later
Date: Wed, 04 Aug 2010 10:18:03 +0200
Message-ID: <4C59223B.1080106@uni-konstanz.de>
References: <4C508A54.7070002@uni-konstanz.de> <20100730022055.GL4506@thunk.org> <4C56E47B.8080600@uni-konstanz.de> <20100802202123.GC25653@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080005070901070208060804"
Cc: Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux <linux-kernel@vger.kernel.org>,
	Karsten Schaefer <karsten.schaefer@uni-konstanz.de>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pyrimidin.rz.uni-konstanz.de ([134.34.240.46]:37022 "EHLO
	pyrimidin.rz.uni-konstanz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753422Ab0HDISH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Aug 2010 04:18:07 -0400
In-Reply-To: <20100802202123.GC25653@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080005070901070208060804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 02.08.2010 22:21, schrieb Ted Ts'o:
> On Mon, Aug 02, 2010 at 05:30:03PM +0200, Kay Diederichs wrote:
>>
>> we pared down the benchmark to the last step (called "run xds_par in n=
fs
>> directory (reads 600M, and writes 50M)") because this captures most of=

>> the problem. Here we report kernel messages with stacktrace, and the
>> blktrace output that you requested.
>
> Thanks, I'll take a look at it.
>
> Is NFS required to reproduce the problem?  If you simply copy the 100
> files using rsync, or cp -r while logged onto the server, do you
> notice the performance regression?
>
> Thanks, regards,
>
> 						- Ted

Ted,

we've run the benchmarks internally on the file server; it turns out=20
that NFS is not required to reproduce the problem.

We also took the opportunity to try 2.6.32.17 which just came out.=20
2.6.32.17 behaves similar to 2.6.32.16-patched (i.e. with reverted=20
"ext4: Avoid group preallocation for closed files"); 2.6.32.17 has quite =

a few ext4 patches so one or a couple of those seems to have a similar=20
effect as reverting "ext4: Avoid group preallocation for closed files".

These are the times for the second (and higher) benchmark runs; the=20
first run is always slower. The last step ("run xds_par") is slower than =

in the NFS case because it's heavy in CPU usage (total CPU time is more=20
than 200 seconds); the NFS client is a 8-core (+HT) Nehalem-type=20
machine, whereas the NFS server is just a 2-core Pentium D @ 3.40GHz

Local machine: turn5 2.6.27.48 i686
Raid5: /dev/md5 /mnt/md5 ext4dev=20
rw,noatime,barrier=3D1,stripe=3D512,data=3Dwriteback 0 0
  32 seconds for preparations
  19 seconds to rsync 100 frames with 597M from raid5,ext4 directory
  17 seconds to rsync 100 frames with 595M to raid5,ext4 directory
  36 seconds to untar 24353 kernel files with 323M to raid5,ext4 director=
y
  31 seconds to rsync 24353 kernel files with 323M from raid5,ext4 direct=
ory
267 seconds to run xds_par in raid5,ext4 directory
427 seconds to run the script

Local machine: turn5 2.6.32.16 i686  (vanilla, i.e. not patched)
Raid5: /dev/md5 /mnt/md5 ext4=20
rw,seclabel,noatime,barrier=3D0,stripe=3D512,data=3Dwriteback 0 0
  36 seconds for preparations
  18 seconds to rsync 100 frames with 597M from raid5,ext4 directory
  33 seconds to rsync 100 frames with 595M to raid5,ext4 directory
  68 seconds to untar 24353 kernel files with 323M to raid5,ext4 director=
y
  40 seconds to rsync 24353 kernel files with 323M from raid5,ext4 direct=
ory
489 seconds to run xds_par in raid5,ext4 directory
714 seconds to run the script

Local machine: turn5 2.6.32.17 i686
Raid5: /dev/md5 /mnt/md5 ext4=20
rw,seclabel,noatime,barrier=3D0,stripe=3D512,data=3Dwriteback 0 0
  38 seconds for preparations
  18 seconds to rsync 100 frames with 597M from raid5,ext4 directory
  33 seconds to rsync 100 frames with 595M to raid5,ext4 directory
  67 seconds to untar 24353 kernel files with 323M to raid5,ext4 director=
y
  41 seconds to rsync 24353 kernel files with 323M from raid5,ext4 direct=
ory
266 seconds to run xds_par in raid5,ext4 directory
492 seconds to run the script

So even if the patches that went into 2.6.32.17 seem to fix the worst=20
stalls, it is obvious that untarring and rsyncing kernel files is=20
significantly slower on 2.6.32.17 than 2.6.27.48 .

HTH,

Kay


--------------ms080005070901070208060804
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIQeDCC
BUowggQyoAMCAQICDlWEAAEAAqRMpMa23uKCMA0GCSqGSIb3DQEBBQUAMHwxCzAJBgNVBAYT
AkRFMRwwGgYDVQQKExNUQyBUcnVzdENlbnRlciBHbWJIMSUwIwYDVQQLExxUQyBUcnVzdENl
bnRlciBDbGFzcyAxIEwxIENBMSgwJgYDVQQDEx9UQyBUcnVzdENlbnRlciBDbGFzcyAxIEwx
IENBIElYMB4XDTEwMDYxNTA4MDkwMVoXDTExMDYxNjA4MDkwMVowKjELMAkGA1UEBhMCREUx
GzAZBgNVBAMTEkRyLiBLYXkgRGllZGVyaWNoczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAMbAmv25QwsaAarHgt8nG5J9Dv9r7axiD28qwd686RlqZFXGTElUJlXz+AB0X+dZ
5RO+ciIWfbfrqrnQWcr8twqAvAR/wEF1qCR1UKCo9/QkRbhHKSqkr0kwJ9Wauvos4druwBjf
3ax/sv/BzwWDlcp3bC+tCvF5Nm2q/+VgNO8UFqGr4FgsaDO7yU5qLNp6yKswDvcytaOpkWe7
1jB95KvCO+FMGBsHb3nSx12NLDrBJhXiAF3+maKlBHdjT9bnaPrtTxBzuofI23vaGNbFhH0j
kS4jSSbNY/6vBfusQ/YiHjHvMSgvFxGKt32yBxOSR/TbSOWXr8RSlEeTXRXBRsUCAwEAAaOC
AhowggIWMIGlBggrBgEFBQcBAQSBmDCBlTBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy50cnVz
dGNlbnRlci5kZS9jZXJ0c2VydmljZXMvY2FjZXJ0cy90Y19jbGFzczFfTDFfQ0FfSVguY3J0
MEAGCCsGAQUFBzABhjRodHRwOi8vb2NzcC5peC50Y2NsYXNzMS50Y3VuaXZlcnNhbC1pLnRy
dXN0Y2VudGVyLmRlMB8GA1UdIwQYMBaAFOm4KB1Gz/zN+E6bxe5LYOvYOz/RMAwGA1UdEwEB
/wQCMAAwSgYDVR0gBEMwQTA/BgkqghQALAEBAQEwMjAwBggrBgEFBQcCARYkaHR0cDovL3d3
dy50cnVzdGNlbnRlci5kZS9ndWlkZWxpbmVzMA4GA1UdDwEB/wQEAwIE8DAdBgNVHQ4EFgQU
DoU//aucYNIa9+YkiJNimDHR2gcwYgYDVR0fBFswWTBXoFWgU4ZRaHR0cDovL2NybC5peC50
Y2NsYXNzMS50Y3VuaXZlcnNhbC1pLnRydXN0Y2VudGVyLmRlL2NybC92Mi90Y19DbGFzczFf
TDFfQ0FfSVguY3JsMDMGA1UdJQQsMCoGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwcG
CisGAQQBgjcUAgIwKQYDVR0RBCIwIIEea2F5LmRpZWRlcmljaHNAdW5pLWtvbnN0YW56LmRl
MA0GCSqGSIb3DQEBBQUAA4IBAQBpatYElJZQHzepSm8kKLt2hD262LpUHXqpj7kjQC0w9Lu6
HG3SV4PxuEgcXPEfcdrFsB/oJYajRdqmeLrWCreIBeYNDGGKyJq4EM9lQzNmajUFVRQsLwPS
3sWElnXXXRRYOY8ZdlWuv+GJ0FEUaGNNX0yZkkpypn/ZBigZKWkWwU7DBleBmiMBivUICOSU
89T9f56bq203R0gVcGrWm85AQP1AfGy0t33518BMHZ69Ykh6oGVyxSdRmdQMEFlyEQeHCkDb
iACoIjj/EnlrWTgSnyK1ydyyf9t8Cs8o7WNfv3wKqPLDbJhseIpj2676wFCyoBM0SfzrRU/n
rddMEt1bMIIFSjCCBDKgAwIBAgIOVYQAAQACpEykxrbe4oIwDQYJKoZIhvcNAQEFBQAwfDEL
MAkGA1UEBhMCREUxHDAaBgNVBAoTE1RDIFRydXN0Q2VudGVyIEdtYkgxJTAjBgNVBAsTHFRD
IFRydXN0Q2VudGVyIENsYXNzIDEgTDEgQ0ExKDAmBgNVBAMTH1RDIFRydXN0Q2VudGVyIENs
YXNzIDEgTDEgQ0EgSVgwHhcNMTAwNjE1MDgwOTAxWhcNMTEwNjE2MDgwOTAxWjAqMQswCQYD
VQQGEwJERTEbMBkGA1UEAxMSRHIuIEtheSBEaWVkZXJpY2hzMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAxsCa/blDCxoBqseC3ycbkn0O/2vtrGIPbyrB3rzpGWpkVcZMSVQm
VfP4AHRf51nlE75yIhZ9t+uqudBZyvy3CoC8BH/AQXWoJHVQoKj39CRFuEcpKqSvSTAn1Zq6
+izh2u7AGN/drH+y/8HPBYOVyndsL60K8Xk2bar/5WA07xQWoavgWCxoM7vJTmos2nrIqzAO
9zK1o6mRZ7vWMH3kq8I74UwYGwdvedLHXY0sOsEmFeIAXf6ZoqUEd2NP1udo+u1PEHO6h8jb
e9oY1sWEfSORLiNJJs1j/q8F+6xD9iIeMe8xKC8XEYq3fbIHE5JH9NtI5ZevxFKUR5NdFcFG
xQIDAQABo4ICGjCCAhYwgaUGCCsGAQUFBwEBBIGYMIGVMFEGCCsGAQUFBzAChkVodHRwOi8v
d3d3LnRydXN0Y2VudGVyLmRlL2NlcnRzZXJ2aWNlcy9jYWNlcnRzL3RjX2NsYXNzMV9MMV9D
QV9JWC5jcnQwQAYIKwYBBQUHMAGGNGh0dHA6Ly9vY3NwLml4LnRjY2xhc3MxLnRjdW5pdmVy
c2FsLWkudHJ1c3RjZW50ZXIuZGUwHwYDVR0jBBgwFoAU6bgoHUbP/M34TpvF7ktg69g7P9Ew
DAYDVR0TAQH/BAIwADBKBgNVHSAEQzBBMD8GCSqCFAAsAQEBATAyMDAGCCsGAQUFBwIBFiRo
dHRwOi8vd3d3LnRydXN0Y2VudGVyLmRlL2d1aWRlbGluZXMwDgYDVR0PAQH/BAQDAgTwMB0G
A1UdDgQWBBQOhT/9q5xg0hr35iSIk2KYMdHaBzBiBgNVHR8EWzBZMFegVaBThlFodHRwOi8v
Y3JsLml4LnRjY2xhc3MxLnRjdW5pdmVyc2FsLWkudHJ1c3RjZW50ZXIuZGUvY3JsL3YyL3Rj
X0NsYXNzMV9MMV9DQV9JWC5jcmwwMwYDVR0lBCwwKgYIKwYBBQUHAwIGCCsGAQUFBwMEBggr
BgEFBQcDBwYKKwYBBAGCNxQCAjApBgNVHREEIjAggR5rYXkuZGllZGVyaWNoc0B1bmkta29u
c3RhbnouZGUwDQYJKoZIhvcNAQEFBQADggEBAGlq1gSUllAfN6lKbyQou3aEPbrYulQdeqmP
uSNALTD0u7ocbdJXg/G4SBxc8R9x2sWwH+glhqNF2qZ4utYKt4gF5g0MYYrImrgQz2VDM2Zq
NQVVFCwvA9LexYSWddddFFg5jxl2Va6/4YnQURRoY01fTJmSSnKmf9kGKBkpaRbBTsMGV4Ga
IwGK9QgI5JTz1P1/npurbTdHSBVwatabzkBA/UB8bLS3ffnXwEwdnr1iSHqgZXLFJ1GZ1AwQ
WXIRB4cKQNuIAKgiOP8SeWtZOBKfIrXJ3LJ/23wKzyjtY1+/fAqo8sNsmGx4imPbrvrAULKg
EzRJ/OtFT+et10wS3VswggXYMIIEwKADAgECAg4G6AABAAJKli0kDP7FyTANBgkqhkiG9w0B
AQUFADB5MQswCQYDVQQGEwJERTEcMBoGA1UEChMTVEMgVHJ1c3RDZW50ZXIgR21iSDEkMCIG
A1UECxMbVEMgVHJ1c3RDZW50ZXIgVW5pdmVyc2FsIENBMSYwJAYDVQQDEx1UQyBUcnVzdENl
bnRlciBVbml2ZXJzYWwgQ0EgSTAeFw0wOTExMDMxNDA4MTlaFw0yNTEyMzEyMTU5NTlaMHwx
CzAJBgNVBAYTAkRFMRwwGgYDVQQKExNUQyBUcnVzdENlbnRlciBHbWJIMSUwIwYDVQQLExxU
QyBUcnVzdENlbnRlciBDbGFzcyAxIEwxIENBMSgwJgYDVQQDEx9UQyBUcnVzdENlbnRlciBD
bGFzcyAxIEwxIENBIElYMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu+aQbs9i
6ekLqrYQ1UflfF0rJ3GaaM1VbeSi7+T+8npjEcJXish9z45mH2VFS+uAYmm9Ro6LxW5alRgq
3qfxH3UaJ6ttMlPj+01YYiz/GeXHoA2aLSGIWYTNHfHDyIo+sOXeCCTP/EAsukEjlLuAEok1
SLaGBOABT4y6qZj8HIntH4qhx4aYJh5yZWv+z2XZDGRLGgn1QxFgZibjM1aayT0+NGp4xuVQ
S8jNiOQ5bFAmnkAstjt8N7Kn9d3cs1HL9NyCArjXOt7aMFwN9ULdE2lTVOmAJkIzHqXXzG7K
ZgmfhvA9vsaKYRDz0f9b5LLbLbJlDKl9F6y6J01CXM4JTwIDAQABo4ICWTCCAlUwgZoGCCsG
AQUFBwEBBIGNMIGKMFIGCCsGAQUFBzAChkZodHRwOi8vd3d3LnRydXN0Y2VudGVyLmRlL2Nl
cnRzZXJ2aWNlcy9jYWNlcnRzL3RjX3VuaXZlcnNhbF9yb290X0kuY3J0MDQGCCsGAQUFBzAB
hihodHRwOi8vb2NzcC50Y3VuaXZlcnNhbC1JLnRydXN0Y2VudGVyLmRlMB8GA1UdIwQYMBaA
FJKkdSyknr6BROt5/IrFlaXrEHVzMBIGA1UdEwEB/wQIMAYBAf8CAQAwUgYDVR0gBEswSTAG
BgRVHSAAMD8GCSqCFAAsAQEBATAyMDAGCCsGAQUFBwIBFiRodHRwOi8vd3d3LnRydXN0Y2Vu
dGVyLmRlL2d1aWRlbGluZXMwDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBTpuCgdRs/8zfhO
m8XuS2Dr2Ds/0TCB/QYDVR0fBIH1MIHyMIHvoIHsoIHphkZodHRwOi8vY3JsLnRjdW5pdmVy
c2FsLUkudHJ1c3RjZW50ZXIuZGUvY3JsL3YyL3RjX3VuaXZlcnNhbF9yb290X0kuY3JshoGe
bGRhcDovL3d3dy50cnVzdGNlbnRlci5kZS9DTj1UQyUyMFRydXN0Q2VudGVyJTIwVW5pdmVy
c2FsJTIwQ0ElMjBJLE89VEMlMjBUcnVzdENlbnRlciUyMEdtYkgsT1U9cm9vdGNlcnRzLERD
PXRydXN0Y2VudGVyLERDPWRlP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT8wDQYJ
KoZIhvcNAQEFBQADggEBADnIxJvuvpjuSHJvjedxtg6QjNOywRUhqEaQaF9KBPE6yWiEIdil
5gR1XZ/S1PJLd0My3JXLYL8CVdCsHLDFFJebZQrDD6Ud7NhJOZW1qb769B6rVuem5QEIiDVf
ZwXdRCRQEiJEY3nxm1dpzqvWM1FPjfBwO46tUToXfzWWa2hoY7YcCsn43x1ezysRpWPtzNDG
0yBvqvxoSH5tHrg6RaoShvPHvQC16/7qEp9zM3jnKDlo06Vt2nbRTuFVlYCm4Bu4zaxW70VZ
R5hS2zpuJrIxOWl1sS4k8KSdl4heMynGtbwHQDoMPbrPdIxLTnoh+hs4zcRDL2+033jumZLn
OhwxggO+MIIDugIBATCBjjB8MQswCQYDVQQGEwJERTEcMBoGA1UEChMTVEMgVHJ1c3RDZW50
ZXIgR21iSDElMCMGA1UECxMcVEMgVHJ1c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQTEoMCYGA1UE
AxMfVEMgVHJ1c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQSBJWAIOVYQAAQACpEykxrbe4oIwCQYF
Kw4DAhoFAKCCAgQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcN
MTAwODA0MDgxODAzWjAjBgkqhkiG9w0BCQQxFgQU63Mm7QLNT5Y10QnJC1eAmue2DB0wXwYJ
KoZIhvcNAQkPMVIwUDALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGfBgkrBgEEAYI3EAQx
gZEwgY4wfDELMAkGA1UEBhMCREUxHDAaBgNVBAoTE1RDIFRydXN0Q2VudGVyIEdtYkgxJTAj
BgNVBAsTHFRDIFRydXN0Q2VudGVyIENsYXNzIDEgTDEgQ0ExKDAmBgNVBAMTH1RDIFRydXN0
Q2VudGVyIENsYXNzIDEgTDEgQ0EgSVgCDlWEAAEAAqRMpMa23uKCMIGhBgsqhkiG9w0BCRAC
CzGBkaCBjjB8MQswCQYDVQQGEwJERTEcMBoGA1UEChMTVEMgVHJ1c3RDZW50ZXIgR21iSDEl
MCMGA1UECxMcVEMgVHJ1c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQTEoMCYGA1UEAxMfVEMgVHJ1
c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQSBJWAIOVYQAAQACpEykxrbe4oIwDQYJKoZIhvcNAQEB
BQAEggEAP9gqCmwUWhBX4kzl2RlbnV+BiMDykZ6A1/zC0OYlEnLGUGol9tlVZajuRAQzoW9i
qwS/RIH4RPSHNB4YLqHoPnH026W1gbyVTLB76pD0KO5GSdjkdMSrM8pyxkItZ3DAOVPz4kjv
W7EVzim2Bl165igtEjs+K8RJ6FLKJrFZzPjpbmh2wZhm6LCSMeA64Rc8+iseHInnjcytoQS/
BA+NBqNZjjaIas54xZPuxMQZkyIoBB9x8nQzdzcuz07WHzuWpPlxkvtLnGzWVOpmxu8tiVLG
d9sHhCVxEiigasmzKw6TTNx3s5O2zyaYG89tnQYtH+4+LH3MGntKpjUCvi3A9QAAAAAAAA==
--------------ms080005070901070208060804--
