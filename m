From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: HUGE slowdown when doing dpkg with ext4 over nbd
Date: Wed, 7 Dec 2016 13:14:22 -0700
Message-ID: <18255D8F-F475-44F0-81C3-5E86AE1E554C@dilger.ca>
References: <1621417488.8583313.1481030030711.JavaMail.zimbra@online.net> <78AEFE7B-685B-4B4E-A15E-E3F6D99DD343@dilger.ca> <1339224178.8897979.1481104368542.JavaMail.zimbra@online.net> <AB04C067-920D-483D-9653-FDCD3AB1B42B@dilger.ca> <53212988-1445-45A4-B56F-0F240013B64C@dilger.ca> <8760mv4mhi.fsf@turtle.gmx.de>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_DEB1CE01-E749-45D8-B872-7888CC2963D6"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Renaud Mariana <rmariana@online.net>,
 Ext4 Developers List <linux-ext4@vger.kernel.org>,
 debian-dpkg@lists.debian.org
To: Sven Joachim <svenjoac@gmx.de>
Return-path: <bounce-debian-dpkg=debian-dpkg=m.gmane.org@lists.debian.org>
In-Reply-To: <8760mv4mhi.fsf@turtle.gmx.de>
Resent-Message-ID: <_e34wo2r4oK.A.VM.72GSYB@bendel>
List-URL: <https://lists.debian.org/debian-dpkg/>
List-Post: <mailto:debian-dpkg@lists.debian.org>
List-Help: <mailto:debian-dpkg-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-dpkg-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-dpkg-request@lists.debian.org?subject=unsubscribe>
List-Archive: https://lists.debian.org/msgid-search/18255D8F-F475-44F0-81C3-5E86AE1E554C@dilger.ca
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_DEB1CE01-E749-45D8-B872-7888CC2963D6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 7, 2016, at 11:34 AM, Sven Joachim <svenjoac@gmx.de> wrote:
>=20
> On 2016-12-07 11:16 -0700, Andreas Dilger wrote:
>=20
>> Add debian-dpkg mailing list to CC.
>>=20
>> On Dec 7, 2016, at 10:58 AM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>>>=20
>>> On Dec 7, 2016, at 2:52 AM, Renaud Mariana <rmariana@online.net> =
wrote:
>>>>=20
>>>> Here are my answers, hope it will help solve this issue, thanks.
>>>>=20
>>>> Recap:
>>>> dpkg kibana on ext4 over a nbd device takes 10 minutes
>>>> with xfs it's only 30s.
>>>> with ext4 no extends only 30s.
>>>>=20
>>>>=20
>>>> kernels :
>>>> 4.5.7 has this issue as older kernel like 4.4.34
>>>> The issue is also when nbd client & server run on same host
>>>>=20
>>>>=20
>>>> How small are the files?
>>>> here is the histogram of file sizes : =
http://pasteboard.co/6HC3nKyk2.png
>>>> We can see 5000 files around 512 Bytes.
>>>=20
>>> Definitely there is no value to use fallocate for 512-byte files, or =
any
>>> of the files that can be written in a single write() syscall.  I'd =
expect
>>> any reasonable tool to be using a write buffer of at least 2-4MB =
these
>>> days to get good performance, so writes below the buffer size =
shouldn't
>>> use fallocate() at all.
>=20
> It should be noted that the latest dpkg (1.18.15) only uses fallocate
> for files which are at least 16 KiB in size[1], so it would be nice if
> Renaud could recheck with that version, or cherry-pick the patch into
> whatever version he uses.

Any particular reason you chose 16KB for the fallocate() limit?  If the
write() is being submitted in a single call and isn't outrageously large
(i.e. over tens of MB), then there isn't any real benefit from =
fallocate()
since ext4, XFS, btrfs will already do delayed block allocation based on
the file size size so it will always get a contiguous allocation on disk
if there is free space available.  I'm assuming that you aren't doing
sync writes when extracting the files from the .deb?

My recommendation would be to avoid fallocate() until the file size is
larger than 1MB or more (ext4 will automatically preallocate up to 8MB
actually, but not sure about other filesystems).  I was trying to look
through the dpkg code to see what buffer sizes are used for writes, but
that was not very easy to find.

> 1. =
https://anonscm.debian.org/cgit/dpkg/dpkg.git/commit/?id=3Da971ad91437af88=
80cad4703695dcf12ee45959b


Cheers, Andreas






--Apple-Mail=_DEB1CE01-E749-45D8-B872-7888CC2963D6
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWEhtoHKl2rkXzB/gAQi1cw//evVCaS3KRrW0hP5UR7GuL+2fNZYVhUzs
bIiLD32SSeke0OtBXGVOdzvC0JrGnifYpHcyaqbybag8wiA1YVErc3kASTBJ8FI8
eLrnyZ7hzFts0Lh1nzRUwrb0LB+ugZAdGXqsa09+x57IiCNxz4ZlRLO+F8ifCtB/
xcyX3ofwPsA4y1YlNSEsjdMk0IqLKOHOKm7nrXJk25FcsgzyNLFUNo3Hn5dxQB36
0Fp7YAObqniQ31Gn0D4+rYkU1nd+DZXXdZ2OlewYC4ukrdKvhVfksPpGEEsOsxR9
pSERQRG5DK9RiXWQ6wVVOCv4ZeSyS87oq8weqCk5fDDga6SJ89bkGAhSEQPEdZI6
Q0cHdPnxs8x/HTltgwsfwAixgt/SH1GL8oaqviGgpUydoFy/Ug2rkr8/TDZ65JMr
mZKEL0BToa87QUfUqdZb9dC+EjPlAYXk0qJlo0pEPhCBkJHB2WeYyEwmJ+D56aM3
qXwEnO12pAYDcIWUO+YRuluuOuSLxmaNQI8h6g3O6gRyy1NT9sG6+v5YwcfYMyNQ
bUTC1NdW9XA86KEUMnij/6LZfalOO772Gy0RTORz6MUpnuFgo6uYE86eZdabcy2k
vTzTpTIZySLrn7yD6iCjJ/Rq420PwE1EnbsUdafoMG9gK5fYLpL4TR4B4eX6OB+5
z5fq/7VgGFg=
=StbF
-----END PGP SIGNATURE-----

--Apple-Mail=_DEB1CE01-E749-45D8-B872-7888CC2963D6--
