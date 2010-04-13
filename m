From: cy6erGn0m <cy6ergn0m@gmail.com>
Subject: Re: No space left on device after many files creation
Date: Tue, 13 Apr 2010 10:35:23 +0400
Message-ID: <4BC410AB.1030607@gmail.com>
References: <4BC38EB9.8080501@gmail.com> <4BC39098.4030704@redhat.com> <4BC39762.9080406@gmail.com> <4BC39805.7090807@redhat.com> <20100412224429.GN1849@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms030603020202010904090806"
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:65103 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0DMGf2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Apr 2010 02:35:28 -0400
Received: by ewy20 with SMTP id 20so2351465ewy.1
        for <linux-ext4@vger.kernel.org>; Mon, 12 Apr 2010 23:35:26 -0700 (PDT)
In-Reply-To: <20100412224429.GN1849@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030603020202010904090806
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

tytso@mit.edu wrote:
> On Mon, Apr 12, 2010 at 05:00:37PM -0500, Eric Sandeen wrote:
>  =20
>> cy6erGn0m wrote:
>>    =20
>>> In the past I have done the same test for ext3 and it was created ~10=
M
>>> files in one firectory at working filesystem (/home) and it was no
>>> issues reached.
>>>
>>> On ext4 i found inodes max size is limited as you wrote:
>>> [root@cgmachine sandbox]# df -i /e4
>>> =D0=A4=D0=B0=D0=B9=D0=BB=D0=BE=D0=B2=D0=B0=D1=8F =D1=81=D0=B8=D1=81=D1=
=82=D0=B5=D0=BC=D0=B0      =D0=98=D0=BD=D0=BE=D0=B4=D0=BE=D0=B2   =D0=98=D1=
=81=D0=BF=D0=BE=D0=BB   =D0=A1=D0=B2=D0=BE=D0=B1  =D0=98=D1=81=D0=BF % =D1=
=81=D0=BC=D0=BE=D0=BD=D1=82=D0=B8=D1=80=D0=BE=D0=B2=D0=B0=D0=BD=D0=B0 =D0=
=BD=D0=B0
>>> (file system/inodes/used/free/used%/mounted on)
>>> /dev/sda4               1,8M    1,8M       0  100% /e4
>>> [root@cgmachine sandbox]#
>>>
>>> Why inodes count limit is so small by default? Is it depends on
>>> partition size?
>>>      =20
>> it does depend on partition size; the inode_ratio =3D 16384 in mke2fs.=
conf
>> says 1 inode per 16k of filesystem space.
>>    =20
>
> 1.8 million inodes is hardly small.....  most people complain that
> we're reserving too much space for inodes. =20
>
> Cy6erGn0m, What is your use case where the average file size for your
> 20G partition is smaller that 16k?
>
> 						- Ted
>  =20
I use filysystem as Set data structure to make fast checks from scripts.
Of course I can make long long file and test it with grep but it's will
have linear performance degradation (List), at the same time file system
has efficient tree binary structures (smth. like TreeSet). So, using
filesystem is the simplest way to do this efficient. Also I always have
timestamps for every entry. In this usecase all files are always empty.

Here is simple performance comparison: list vs tree:
cy6ergn0m@cgmachine /e4/sandbox/heap $ time cat ../x | grep ^610845$ ../x=

610845
cat ../x  0,00s user 0,00s system 2% cpu 0,127 total
grep --color ^610845$ ../x  0,08s user 0,03s system 87% cpu 0,136 total
cy6ergn0m@cgmachine /e4/sandbox/heap $ time stat 610845           =20
  File: `610845'
  Size: 0               Blocks: 0          IO Block: 4096   =D0=BF=D1=83=D1=
=81=D1=82=D0=BE=D0=B9
=D0=BE=D0=B1=D1=8B=D1=87=D0=BD=D1=8B=D0=B9 =D1=84=D0=B0=D0=B9=D0=BB
Device: 804h/2052d      Inode: 1520242     Links: 1
Access: (0644/-rw-r--r--)  Uid: (  500/cy6ergn0m)   Gid: (  500/cy6ergn0m=
)
Access: 2010-04-13 10:17:58.119477521 +0400
Modify: 2010-04-13 10:17:58.119477521 +0400
Change: 2010-04-13 10:17:58.119477521 +0400
stat 610845  0,00s user 0,00s system 75% cpu 0,005 total
cy6ergn0m@cgmachine /e4/sandbox/heap $


I know that filesystems is not targeted for this usecase, but inodes
limit looks strange.. why they are can't be allocated dinamically? Can I
enlarge this limit on the fly?

=20


--------------ms030603020202010904090806
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIKcDCC
BTQwggMcoAMCAQICAwhTxTANBgkqhkiG9w0BAQUFADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xMDAz
MDgyMjMzMjdaFw0xMDA5MDQyMjMzMjdaMD4xGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEi
MCAGCSqGSIb3DQEJARYTY3k2ZXJHbjBtQGdtYWlsLmNvbTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAKl2G6TMtz2i5t40UoH8NB7kx5/x8ng5CHYiL3YYDnB/6CDEKpSrSujP
kDkZhM3senhPNqN6WEwIOu+T1HWhatvIymxy6XxlnpOLzAZsdSslfX5klkjLKDrpqAPQ64fd
/pR1GNKTNmJ9OwmnHkRaIx6pMt182kV3K6Isbfexa27DnDpYsN2W/Or7+ncGBRe4cPL5RuKa
0tHhlmxlaveK4kx3g5BvtUDbECd3vOI+jQe/nArlNUecKSihCPU58r7pdrIdNng1+R6vkvJy
KSLF7uFStCvk1U+dgJHvjYrvbiQwCCu4WUS0bucpkwJtHDnJrwha1iuuFph3r4RK5pGJHp0C
AwEAAaOB/zCB/DAMBgNVHRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBv
d24gY2VydGlmaWNhdGUgZm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0
Lm9yZzBABgNVHSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisGAQQB
gjcKAwMGCWCGSAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9v
Y3NwLmNhY2VydC5vcmcwHgYDVR0RBBcwFYETY3k2ZXJHbjBtQGdtYWlsLmNvbTANBgkqhkiG
9w0BAQUFAAOCAgEAKUjhQKealtXCVJ5eAbAKWmhSVT5On/pVtpDrdzT36xZ5iKfHruB25ieQ
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
dCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0
IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcC
AwhTxTAJBgUrDgMCGgUAoIIB6DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0xMDA0MTMwNjM1MjNaMCMGCSqGSIb3DQEJBDEWBBTjCss+oU05JVu1EnkyfFI/
gMJpUjBfBgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG
9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsG
AQQBgjcQBDGBgzCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3
LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkq
hkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDCFPFMIGTBgsqhkiG9w0BCRACCzGBg6CB
gDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcx
IjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1
cHBvcnRAY2FjZXJ0Lm9yZwIDCFPFMA0GCSqGSIb3DQEBAQUABIIBAEvR6VWRCOfWH09YRjfj
h9wYRxPpdSwL4OxxBa9Ugr6wJscRlj8bY7DDhOFkYMSRqWdARcDuuevIPkpf/H74etKIaE7I
bUpDjtArz91npdz5mKsm+AhiCIXyFasqCvVMjVVpSHQiyyNo5hbrUcT9ZmLh9WrldLCPYWo0
0XnSy4ohEvF3V9ZGXpF619CS0S3tu5pqqZ3nCb6yaFeP/j954JNqB7xJgnKWkeybq+Ee/vsI
mb+/z1FmAYpUcSurlg8P1MAQzQQ45n/DpA4k38qQOQTsh0eS1M8LBZSftKNYAarze4dv8o1Q
MGbopDvocU1tTqaXCT0P2TxOU6RzsCRFUggAAAAAAAA=
--------------ms030603020202010904090806--
