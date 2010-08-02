From: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Subject: Re: ext4 performance regression 2.6.27-stable versus 2.6.32 and later
Date: Mon, 02 Aug 2010 23:08:13 +0200
Message-ID: <4C5733BD.3040801@uni-konstanz.de>
References: <4C508A54.7070002@uni-konstanz.de> <20100729232856.GP655@dastard> <4C56DBB0.9080405@uni-konstanz.de> <4C56EE67.4070905@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080400040803070405020309"
Cc: Dave Chinner <david@fromorbit.com>,
	linux <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Karsten Schaefer <karsten.schaefer@uni-konstanz.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from purin.rz.uni-konstanz.de ([134.34.240.45]:48525 "EHLO
	purin.rz.uni-konstanz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0HBVIS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Aug 2010 17:08:18 -0400
In-Reply-To: <4C56EE67.4070905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080400040803070405020309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 02.08.2010 18:12, schrieb Eric Sandeen:
> On 08/02/2010 09:52 AM, Kay Diederichs wrote:
>> Dave,
>>
>> as you suggested, we reverted "ext4: Avoid group preallocation for
>> closed files" and this indeed fixes a big part of the problem: after
>> booting the NFS server we get
>>
>> NFS-Server: turn5 2.6.32.16p i686
>> NFS-Client: turn10 2.6.18-194.8.1.el5 x86_64
>>
>> exported directory on the nfs-server:
>> /dev/md5 /mnt/md5 ext4
>> rw,seclabel,noatime,barrier=3D1,stripe=3D512,data=3Dwriteback 0 0
>>
>>   48 seconds for preparations
>>   28 seconds to rsync 100 frames with 597M from nfs directory
>>   57 seconds to rsync 100 frames with 595M to nfs directory
>>   70 seconds to untar 24353 kernel files with 323M to nfs directory
>>   57 seconds to rsync 24353 kernel files with 323M from nfs directory
>> 133 seconds to run xds_par in nfs directory
>> 425 seconds to run the script
>
> Interesting, I had found this commit to be a problem for small files
> which are constantly created&  deleted; the commit had the effect of
> packing the newly created files in the first free space that could be
> found, rather than walking down the disk leaving potentially fragmented=

> freespace behind (see seekwatcher graph attached).  Reverting the patch=

> sped things up for this test, but left the filesystem freespace in bad
> shape.
>
> But you seem to see one of the largest effects in here:
>
> 261 seconds to rsync 100 frames with 595M to nfs directory
> vs
>   57 seconds to rsync 100 frames with 595M to nfs directory
>
> with the patch reverted making things go faster.  So you are doing 100
> 6MB writes to the server, correct?

correct.

 >
> Is the filesystem mkfs'd fresh
> before each test, or is it aged?

it is too big to "just create it freshly". It was actually created a=20
week ago, and filled by a single ~ 10-hour rsync job run on the server=20
such that the filesystem should be filled in the most linear way=20
possible. Since then, the benchmarking has created and deleted lots of=20
files.

> If not mkfs'd, is it at least
> completely empty prior to the test, or does data remain on it?  I'm jus=
t

it's not empty: df -h reports
Filesystem            Size  Used Avail Use% Mounted on
/dev/md5              3.7T  2.8T  712G  80% /mnt/md5

e2freefrag-1.41.12 reports:
Device: /dev/md5
Blocksize: 4096 bytes
Total blocks: 976761344
Free blocks: 235345984 (24.1%)

Min. free extent: 4 KB
Max. free extent: 99348 KB
Avg. free extent: 1628 KB

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
     4K...    8K-  :          1858          1858    0.00%
     8K...   16K-  :          3415          8534    0.00%
    16K...   32K-  :          9952         54324    0.02%
    32K...   64K-  :         23884        288848    0.12%
    64K...  128K-  :         27901        658130    0.28%
   128K...  256K-  :         25761       1211519    0.51%
   256K...  512K-  :         35863       3376274    1.43%
   512K... 1024K-  :         48643       9416851    4.00%
     1M...    2M-  :        150311      60704033   25.79%
     2M...    4M-  :        244895     148283666   63.01%
     4M...    8M-  :          3970       5508499    2.34%
     8M...   16M-  :           187        551835    0.23%
    16M...   32M-  :           302       1765912    0.75%
    32M...   64M-  :           282       2727162    1.16%
    64M...  128M-  :            42        788539    0.34%


> wondering if fragmented freespace is contributing to this behavior as
> well.  If there is fragmented freespace, then with the patch I think th=
e
> allocator is more likely to hunt around for small discontiguous chunks
> of free sapce, rather than going further out in the disk looking for a
> large area to allocate from.

the last step of the benchmark, "xds_par", reads 600MB and writes 50MB.=20
It has 16 threads which might put some additional pressure on the=20
freespace hunting. That step also is fast in 2.6.27.48 but slow in 2.6.32=
+ .

>
> It might be interesting to use seekwatcher on the server to visualize
> the allocation/IO patterns for the test running just this far?
>
> -Eric

will try to install seekwatcher.

thanks,

Kay


--------------ms080400040803070405020309
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
MTAwODAyMjEwODEzWjAjBgkqhkiG9w0BCQQxFgQUxq7iA4N62D1Iyv7wPDl27CK7lK4wXwYJ
KoZIhvcNAQkPMVIwUDALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGfBgkrBgEEAYI3EAQx
gZEwgY4wfDELMAkGA1UEBhMCREUxHDAaBgNVBAoTE1RDIFRydXN0Q2VudGVyIEdtYkgxJTAj
BgNVBAsTHFRDIFRydXN0Q2VudGVyIENsYXNzIDEgTDEgQ0ExKDAmBgNVBAMTH1RDIFRydXN0
Q2VudGVyIENsYXNzIDEgTDEgQ0EgSVgCDlWEAAEAAqRMpMa23uKCMIGhBgsqhkiG9w0BCRAC
CzGBkaCBjjB8MQswCQYDVQQGEwJERTEcMBoGA1UEChMTVEMgVHJ1c3RDZW50ZXIgR21iSDEl
MCMGA1UECxMcVEMgVHJ1c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQTEoMCYGA1UEAxMfVEMgVHJ1
c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQSBJWAIOVYQAAQACpEykxrbe4oIwDQYJKoZIhvcNAQEB
BQAEggEAmTz3a8ugnlZ1cCL/PIO8LEA09YOkqFGOeYYs3QiljFNKzcdJ+yndxUK8gm0/TgZK
IQ5SyPjinngaIox44fRSN+lHTTl5DzO//AytkZw+TJhHlSv9FtSYsq3SfrRhXbDeMsP56XgD
uirXUhfAnKc9U4RFzbnBMt69TeTI1km/z085Y9JJF+bHe0vnxZiwhx8+KhCoxpxy3rg2Y+bL
cVrpYMc2yvkHCQnHsHjc6fhmp/M8h3LWD6GJvGz70iQATF3u4qMUX9gBHWtvIXPgS9uwx4mq
5RARvJGxNfGWw6elK0ZTT05pp9H5/4yIokuD7WAQ3031sY2rr7kVe3CjrO8b/gAAAAAAAA==
--------------ms080400040803070405020309--
