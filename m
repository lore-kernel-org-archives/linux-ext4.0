From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Wed, 15 Jul 2015 11:20:55 -0400
Message-ID: <55A67A57.8010502@gmail.com>
References: <1436955987-7305-1-git-send-email-jack@suse.com> <20150715141836.GA18400@thunk.org> <55A676BF.8020903@infradead.org> <55A67790.80802@infradead.org> <55A6780E.2040702@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020403030504010409020501"
To: Eric Sandeen <sandeen@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55A6780E.2040702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms020403030504010409020501
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-15 11:11, Eric Sandeen wrote:
> On 7/15/15 10:09 AM, Randy Dunlap wrote:
>> On 07/15/15 08:05, Randy Dunlap wrote:
>>> On 07/15/15 07:18, Theodore Ts'o wrote:
>>>> On Wed, Jul 15, 2015 at 12:26:24PM +0200, Jan Kara wrote:
>>>>>
>>>>>    so I have created this patch set which removes ext3 driver (and =
some related support
>>>>> code) from the kernel. See changelog of patch 2/3 for more details.=
 If noone objects,
>>>>> I will queue the series in my tree for the next merge window.
>>>>>
>>>>> Jens, are you OK with me merging patch 3/3 or do you want me to sen=
d it to you once
>>>>> the first two patches get merged?
>>>>>
>>>>> Ted, this also touches ext4 driver so that it always handles ext3 f=
ilesystems so ack
>>>>> from you would be nice.
>>>>
>>>> Got tired of maintaining ext3, eh?   :-)
>>>>
>>>> As a minor nit, I wonder if it's worth while to put in some hackery =
in
>>>> fs/Kconfig so that if someone only has CONFIG_FS_EXT3 defined, but n=
ot
>>>> CONFIG_FS_EXT4 defined, that it will automatically enable
>>>> CONFIG_FS_EXT4 instead?  Otherwise someone upgrading their kernel
>>>> might accidentally end up getting a non-functional kernel.
>>>>
>>>> i.e., something like this? (not tested!)
>>>>
>>>> config FS_EXT3
>>>>         def_bool n
>>>>         select FS_EXT4
>>>
>>>
>>> Yes, if someone is going to force us to use ext4, some automation wou=
ld
>>> be helpful.
>>>
>>> Thanks,
>>>
>>
>> Are there any other changes required, e.g., to /etc/fstab ?
>>
>> btw, this looks like an April 1 joke to me.
>
> no fstab changes required.  The ext4 driver has been able to register
> itself as ext[23] for quite some time now, so it's transparent.
>
> Many/most distros have been using the ext4.ko driver for ext3 & ext2 fo=
r
> years.  You may already be using that on some boxes, and not even know =
it.
> ;)
Yeah, 99% of the systems I've seen in the past 2 years have been using=20
either the ext4 driver, or using exclusively ext2 (mostly embedded=20
systems, and they usually choose ext2 because it's _very_ lightweight=20
compared to ext[34] and the other alternatives).

There really isn't much of a clear distinction between ext3 and ext4 (at =

least from an end user standpoint), other than the fact that there are=20
some options that only the ext4 driver understands (like extent based=20
allocation).


--------------ms020403030504010409020501
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAxBuVTANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNTAz
MjUxOTM0MzhaFw0xNTA5MjExOTM0MzhaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCdD/zW
2rRAFCLnDfXpWxU1+ODqRVUgzHvrRO7ADUxRo1CBDc3JSX5TIW2OGmQ3DAKGOACp8Z0sgxMc
B05tzAZ/M7m4jajVrwwdVCdrwVGxTdAai7Kwg4ZCVfyMVhcwo8R2eW3QahBx34G0RKumK9sZ
ZQSQ+zULAzpY6uz7T1sAk/erMoivRXF6u8WvOsLkOD1F/Xyv1ZccSUG5YeDgZgc0nZUBvyIp
zXSHjgWerFkrxEM3y2z/Ff3eL1sgGYecV/I1F+I5S01V7Kclt/qRW10c/4JEGRcI1FmrJBPu
BtMYPbg/3Y9LZROYN+mVIFxZxOfrmjfFZ96xt/TaMXo8vcEKtWcNEjhGBjEbfMUEm4aq8ygQ
4MuEcpJc8DJCHBkg2KBk13DkbU2qNepTD6Uip1C+g+KMr0nd6KOJqSH27ZuNY4xqV4hIxFHp
ex0zY7mq6fV2o6sKBGQzRdI20FDYmNjsLJwjH6qJ8laxFphZnPRpBThmu0AjuBWE72GnI1oA
aO+bs92MQGJernt7hByCnDO82W/ykbVz+Ge3Sax8NY0m2Xdvp6WFDY/PjD9CdaJ9nwQGsUSa
N54lrZ2qMTeCI9Vauwf6U69BA42xgk65VvxvTNqji+tZ4aZbarZ7el2/QDHOb/rRwlCFplS/
z4l1f1nOrE6bnDl5RBJyW3zi74P6GwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAGvl7xb42JMRH5D/vCIDYvFY3dR2FPd5kmOqpKU/fvQ8ovmJa
p5N/FDrsCL+YdslxPY+AAn78PYmL5pFHTdRadT++07DPIMtQyy2qd+XRmz6zP8Il7vGcEDmO
WmMLYMq4xV9s/N7t7JJp6ftdIYUcoTVChUgilDaRWMLidtslCdRsBVfUjPb1bF5Ua31diKDP
e0M9/e2CU36rbcTtiNCXhptMigzuL3zJXUf2B9jyUV8pnqNEQH36fqJ7YTBLcpq3aYa2XbAH
Hgx9GehJBIqwspDmhPCFZ/QmqUXCkt+XfvinQ2NzKR6P3+OdYbwqzVX8BdMeojh7Ig8x/nIx
mQ+/ufstL1ZYp0bg13fyK/hPYSIBpayaC76vzWovkIm70DIDRIFLi20p/qTd7rfDYy831Hjm
+lDdCECF9bIXEWFk33kA97dgQIMbf5chEmlFg8S0e4iw7LMjvRqMX3eCD8GJ2+oqyZUwzZxy
S0Mx+rBld5rrN7LsXwZ671HsGqNeYbYeU25e7t7/Gcc6Bd/kPfA+adEuUGFcvUKH3trDYqNq
6mOkAd8WO/mQadlc3ztS++XDMhmIpfBre9MPAr6usqf+wc+R8Nk9KLK39kEgrqVfzc/fgf8L
MaD4rHnusdg4gca6Yi+kNrm99anw7SwaBrBvULYBp7ixNRUhaYiNW4YjTrYxggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5VMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MDcxNTE1MjA1NVowIwYJKoZIhvcNAQkE
MRYEFGJ7I9Av6iyBenlHKINEi8ZjfCeCMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDEG5VMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDEG5V
MA0GCSqGSIb3DQEBAQUABIICAGwuq1Ej4AZCUSBm1DyN5SxsOOzkFJpixwFPilZoqRZLfCrl
zY7fDtnFoOTFadJ9vgfl7dbG3BbeahT5ENl2AMrDxLp8vTpiBU/6vbtyYx64Pgvf8uxYGxu2
54jzTOSp4eM4zQOCNda3IvuvWeo1t5TfIfbasNYdbUj/iWnjR6DWPc32iRxOfb25H/Y/iM4U
Mion2+UmZfGftBeeNcmKohnkVLHWJq1Qld4aD5ocA9ubrX810QA4HWZixrmZ7t1z6GlAc0o4
AnJBR5UF9IMHdHKGOyGwWQyoya7RS+pGYlyBCNjr7W7it51IV6RSsfEZgf1Z11OU3BpX/mRL
dBCWqQ+rdKl4inKBnWeaSd9XBWsSZZor9+gEJdSLvczVNoZWFihj2TnVQ9EgRBkg1Qi9JDTr
vv9rLkIu7KgUiRGBMhYe6Z8A7BFILD9wXpy+bO98cw8gUEYVmM75TP09OuCcnTwO/vbs6K0E
bcmpSgxlHf/JK7Gx9loHvM1c7y2ZUz/1zlar/oCffGRLHeLXYbqNV5Ed5p6vM5cmWrtZ+idj
x9TTDZs212+OJaTlm2W/oz4LNj0yjT/IulLhKPs+0F0BJR0WuhPgpCfu160vz3sh4DjaqjdM
OjVygHsWGkGREL9qwYjuisRc5yHMNp7hmvxTqHGxU+C7A8zmE3S6On04S1I5AAAAAAAA
--------------ms020403030504010409020501--
