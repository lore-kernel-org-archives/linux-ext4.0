From: Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
Subject: Re: ext4 performance regression 2.6.27-stable versus 2.6.32 and later
Date: Mon, 02 Aug 2010 12:47:28 +0200
Message-ID: <4C56A240.1040506@uni-konstanz.de>
References: <4C508A54.7070002@uni-konstanz.de> <AANLkTimh3eKc-M4xphq0djnSa=4W4hUf7KRf=icdF9Rk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms030107090905010805010403"
Cc: linux <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Karsten Schaefer <karsten.schaefer@uni-konstanz.de>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTimh3eKc-M4xphq0djnSa=4W4hUf7KRf=icdF9Rk@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms030107090905010805010403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Greg Freemyer schrieb:
> On Wed, Jul 28, 2010 at 3:51 PM, Kay Diederichs
> <Kay.Diederichs@uni-konstanz.de> wrote:
>> Dear all,
>>
>> we reproducibly find significantly worse ext4 performance when our
>> fileservers run 2.6.32 or later kernels, when compared to the
>> 2.6.27-stable series.
>>
>> The hardware is RAID5 of 5 1TB WD10EACS disks (giving almost 4TB) in an
>> external eSATA enclosure (STARDOM ST6600); disks are not partitioned but
>> rather the complete disks are used:
>> md5 : active raid5 sde[0] sdg[5] sdd[3] sdc[2] sdf[1]
>>    3907045376 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5]
>> [UUUUU]
>>
>> The enclosure is connected using a Silicon Image (supported by
>> sata_sil24) PCIe-X1 adapter to one of our fileservers (either the backup
>> fileserver, 32bit desktop hardware with Intel(R) Pentium(R) D CPU
>> 3.40GHz, or a production-fileserver 64bit Precision WorkStation 670 w/ 2
>> Xeon 3.2GHz).
>>
>> The ext4 filesystem was created using
>> mke2fs -j -T largefile -E stride=128,stripe_width=512 -O extent,uninit_bg
>> It is mounted with noatime,data=writeback
>>
>> As operating system we usually use RHEL5.5, but to exclude problems with
>> self-compiled kernels, we also booted USB sticks with latest Fedora12
>> and FC13 .
>>
>> Our benchmarks consist of copying 100 6MB files from and to the RAID5,
>> over NFS (NVSv3, GB ethernet, TCP, async export), and tar-ing and
>> rsync-ing kernel trees back and forth. Before and after each individual
>> benchmark part, we "sync" and "echo 3 > /proc/sys/vm/drop_caches" on
>> both the client and the server.
>>
>> The problem:
>> with 2.6.27.48 we typically get:
>>  44 seconds for preparations
>>  23 seconds to rsync 100 frames with 597M from nfs directory
>>  33 seconds to rsync 100 frames with 595M to nfs directory
>>  50 seconds to untar 24353 kernel files with 323M to nfs directory
>>  56 seconds to rsync 24353 kernel files with 323M from nfs directory
>>  67 seconds to run xds_par in nfs directory (reads and writes 600M)
>> 301 seconds to run the script
>>
>> with 2.6.32.16 we find:
>>  49 seconds for preparations
>>  23 seconds to rsync 100 frames with 597M from nfs directory
>> 261 seconds to rsync 100 frames with 595M to nfs directory
>>  74 seconds to untar 24353 kernel files with 323M to nfs directory
>>  67 seconds to rsync 24353 kernel files with 323M from nfs directory
>> 290 seconds to run xds_par in nfs directory (reads and writes 600M)
>> 797 seconds to run the script
>>
>> This is quite reproducible (times varying about 1-2% or so). All times
>> include reading and writing on the client side (stock CentOS5.5 Nehalem
>> machines with fast single SATA disks). The 2.6.32.16 times are the same
>> with FC12 and FC13 (booted from USB stick).
>>
>> The 2.6.27-versus-2.6.32+ regression cannot be due to barriers because
>> md RAID5 does not support barriers ("JBD: barrier-based sync failed on
>> md5 - disabling barriers").
>>
>> What we tried: noop and deadline schedulers instead of cfq;
>> modifications of /sys/block/sd[c-g]/queue/max_sectors_kb; switching
>> on/off NCQ; blockdev --setra 8192 /dev/md5; increasing
>> /sys/block/md5/md/stripe_cache_size
>>
>> When looking at the I/O statistics while the benchmark is running, we
>> see very choppy patterns for 2.6.32, but quite smooth stats for
>> 2.6.27-stable.
>>
>> It is not an NFS problem; we see the same effect when transferring the
>> data using an rsync daemon. We believe, but are not sure, that the
>> problem does not exist with ext3 - it's not so quick to re-format a 4 TB
>> volume.
>>
>> Any ideas? We cannot believe that a general ext4 regression should have
>> gone unnoticed. So is it due to the interaction of ext4 with md-RAID5 ?
>>
>> thanks,
>>
>> Kay
> 
> Kay,
> 
> I didn't read your whole e-mail, but 2.6.27 has known issues with
> barriers not working in many raid configs.  Thus it is more likely to
> experience data loss in the event of a power failure.
> 
> With newer kernels, If you prefer to have performance over robustness,
> you can mount with the "nobarrier" option.
> 
> So now you have your choice whereas with 2.6.27, with raid5 you
> effectively had nobarriers as your only choice.
> 
> Greg

Greg,

2.6.33 and later support md5 write barriers, whereas 2.6.27-stable
doesn't. I looked thru the 2.6.32.* Changelogs at
http://kernel.org/pub/linux/kernel/v2.6/ but could not find anything
indicating that md5 write barriers were backported to 2.6.32-stable.

Anyway, we do not get the message "JBD: barrier-based sync failed on md5
- disabling barriers" when using 2.6.32.16 which might indicate that
write barriers are indeed active when specifying no options in this respect.

Performance-wise, we tried mounting with barrier versus nobarrier (or
barrier=1 versus barrier=0) and re-did the 2.6.32+ benchmarks. It turned
out that the benchmark difference with and without barrier is less than
the variation between runs (which is much higher with 2.6.32+ than with
2.6.27-stable), so the influence seems to be minor.

best,

Kay

--------------ms030107090905010805010403
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
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
MTAwODAyMTA0NzI4WjAjBgkqhkiG9w0BCQQxFgQUCiSwGfnNAPezRZ3IO9ekxAlwScQwXwYJ
KoZIhvcNAQkPMVIwUDALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCA
MA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGfBgkrBgEEAYI3EAQx
gZEwgY4wfDELMAkGA1UEBhMCREUxHDAaBgNVBAoTE1RDIFRydXN0Q2VudGVyIEdtYkgxJTAj
BgNVBAsTHFRDIFRydXN0Q2VudGVyIENsYXNzIDEgTDEgQ0ExKDAmBgNVBAMTH1RDIFRydXN0
Q2VudGVyIENsYXNzIDEgTDEgQ0EgSVgCDlWEAAEAAqRMpMa23uKCMIGhBgsqhkiG9w0BCRAC
CzGBkaCBjjB8MQswCQYDVQQGEwJERTEcMBoGA1UEChMTVEMgVHJ1c3RDZW50ZXIgR21iSDEl
MCMGA1UECxMcVEMgVHJ1c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQTEoMCYGA1UEAxMfVEMgVHJ1
c3RDZW50ZXIgQ2xhc3MgMSBMMSBDQSBJWAIOVYQAAQACpEykxrbe4oIwDQYJKoZIhvcNAQEB
BQAEggEARAla5z+/d5M6roUizlKXzMFUgr0e86BXjaCEZ+VFKn+qFZdaP72DN5z6CiXKh1A9
H//dhjjVVAMeW+S+kR06d7AudhzSoySBTCn1hP7wTeL9ycYErZmT2LcCZ88urZGUxSMYytX8
/5Cw2bgEWb8l143TaMa/04Zom2hObMXWaa8JY+cIv7SnB8jsviLlO0A+ZZ0rzo2lpi2rnTsG
RL3laZeg/qfQitwvOAyQiguLTuxnR/yTeh7mcW9bqmb8PY89TgBNtyo743SSs9xr64R5+x4w
Uaba7RH34FnhCjjrUtE5bxX+W4r5zVLXfUFLLW+egWHIYu/E8lEHGzkzOP7GYAAAAAAAAA==
--------------ms030107090905010805010403--
