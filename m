From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [GIT PULL] Ext3 removal, quota & udf fixes
Date: Wed, 2 Sep 2015 09:28:37 -0400
Message-ID: <55E6F985.3080105@gmail.com>
References: <20150831061920.GA2751@quack.suse.cz>
 <CA+55aFweA1J+a5MYxgWDOAg0p+UdqfP+Z1aFKs1c8n0hWUiBDw@mail.gmail.com>
 <55E4D5DE.2030709@gmail.com>
 <CAMu38x+4V2JbGfCB_BxgbMOfR7QtQHFY_ebac1h1WY6wspjWFA@mail.gmail.com>
 <55E5FF01.2000304@gmail.com>
 <CAMu38xK8gEpWurPsV=ViYgZ+Sa50id0P501W3ZY4Z4R=z5PNhQ@mail.gmail.com>
 <55E68D49.5000404@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010004060509090707060600"
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Raymond Jennings <shentino@gmail.com>,
	Albino B Neto <bino@riseup.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55E68D49.5000404@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010004060509090707060600
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-02 01:46, Raymond Jennings wrote:
> On 09/01/15 20:30, Albino B Neto wrote:
>> 2015-08-31 23:53 GMT-03:00 Theodore Ts'o <tytso@mit.edu>:
>>> Yes, you can go back to ext3-only.  In fact, we do *not* automaticall=
y
>>> upgrade the file system to use ext4-specific features.
>>>> So it's not just a "you can use ext4 instead" issue. Can you do that=

>>>> *without* then forcing an upgrade forever on that partition? I'm not=

>>>> sure the ext4 people are really even willing to guarantee that kind =
of
>>>> backwards compatibility.
>>> Actually, we do guarantee this.  It's considered poor form to
>>> automatically change the superblock to add new file system features i=
n
>>> a way that would break the ability for the user to roll back to an
>>> older kernel.  This isn't just for ext3->ext4, but for new ext4
>>> features such as metadata checksumming.  The user has to explicitly
>>> enable the feature using "tune2fs -O new_feature /dev/sdXX".
>> Yeah!
>>
>> 2015-09-01 16:39 GMT-03:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:=

>>> NO, it is not logical.  A vast majority of Android smartphones in the=

>>> wild
>>> use ext2, as do a very significant portion of embedded systems that
>>> don't
>>> have room for the few hundred kilobytes of extra code that the ext4
>>> driver
>>> has in comparison to ext2.
>> Ext2 portion embedded and Ext3 many machines.
>
> So basically the game plan is gutting ext3 because code-dupe with ext4,=

> but keep ext2 because ext4 is too big for embedded to outright replace
> ext2?
>
> Hmm...are there any embedded systems out there that use ext3 and can fi=
t
> its code ext3 but not ext4?
Probably, but I don't know of any myself.  TBH, the systems that use=20
ext2 because of space savings are usually ones with less than 64M of=20
RAM, which is becoming a smaller and smaller market share.



--------------ms010004060509090707060600
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTAyMTMyODM3WjBPBgkq
hkiG9w0BCQQxQgRAGoys1azm3Yahhi/kStQRrrI9N0xW7etEwKNHyXhSpuZnnjdHuJaKKQ5N
DvIIM4TsPUMlg7qyOqh+QTGpcUcUhTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBjlUR/j0FnLYhhfsDMVKkUFZNk/p4PmTOOW7JR7LLzuAfOvZo/
1LwqlqGwnBOTqvhmlI7ZDuHEDpIrS18zInYNUI5232I4VHuSI+VU1MlwUvmST9BoS+Cnlql3
SvkaqymHs5DUHDagXVg4uVWvPZ3DRbJHJZb+p/riCXZLbJwW0shlkcA8sk9VsawvD3k8R9rK
5f8g+5aykwiv2Z6xzuyP8RvtXygt08UuYtrChgZU9u78pNRmE92ZJ1S4CpH7IiJDa6OyUZ/x
L6QQmNd6d5MKAPDnvrrngEaogBRREFpqxLYJzAzyFXBqIK34pOC1h2ANT8tCvq7EVrw7OKd5
CPVmFMX3WvYfdbGZJxqdAz85/g4Ewg54lAZPiIP7/NEjapBW7jHRn50s1keUn6uGAa8bOXP5
SNDp0CpF/giOfPGlQpEStlZWBw0DvDk/c2g4f08crdC8B5dKwCQ/OSQaXYKYJ7KudW8MXX9M
nYN2/LRFNsuOqFh0wgyWe8ycDIo4PtJSbLxVOWIVCzCcI50iFiaZXPkunpVdUVR91N9FXEgj
m0/vXG4hZTlVh9qPPJHZRrMp+5J/gdqu2V24NmuaH3SkqvpweMF8wrJ7AV2NrifKtFTpqxiA
VTS6SS6SoLFZU7CDOXe635MxgVh5BlNJ5RkkA7ghIv3vw8vtmux3i3F80gAAAAAAAA==
--------------ms010004060509090707060600--
