From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: small .de translation fix
Date: Thu, 20 Feb 2014 23:24:41 -0800
Message-ID: <A628A2EB-A172-4B59-80F2-EDBAA32A9751@dilger.ca>
References: <52C704EC.8000501@redhat.com> <5306D3D9.4040303@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_10EEDA93-D9A4-41CC-AF30-4635B1AB27CD"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: ext4 development <linux-ext4@vger.kernel.org>, pth@suse.de
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49750 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbaBUHYr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Feb 2014 02:24:47 -0500
Received: by mail-pa0-f49.google.com with SMTP id hz1so3069204pad.36
        for <linux-ext4@vger.kernel.org>; Thu, 20 Feb 2014 23:24:46 -0800 (PST)
In-Reply-To: <5306D3D9.4040303@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_10EEDA93-D9A4-41CC-AF30-4635B1AB27CD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Feb 20, 2014, at 8:19 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 1/3/14, 12:43 PM, Eric Sandeen wrote:
>> This was reported in RH bugzilla.  I think my German is good enough
>> that the fix is correct, but I don't mind a double-check.  :)
>>=20
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>=20
> ping on this one, while it seems that Ted is processing old patches :)
>=20
> But maybe this one is for Philipp...

My German is also good enough to give a:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

on this.

Amusingly, Google translate translates "B=F6cke" to "blocks" when
it is in the exact form of the error message, but translates it to
"goats" in isolation.  I speculate this is because it is using existing
cases of e2fsprogs translation messages as part of its translation
learning dictionary.

Cheers, Andreas

>> diff --git a/po/de.po b/po/de.po
>> index d1ed005..d0b357a 100644
>> --- a/po/de.po
>> +++ b/po/de.po
>> @@ -1840,7 +1840,7 @@ msgid ""
>> "  has %r @m @b(s), shared with %N file(s):\n"
>> msgstr ""
>> "Datei %Q (@i #%i, =C4nderungszeit %IM) \n"
>> -"  hat %r mehrfach belegte(n) Block/B=F6cke, gemeinsam genutzt mit =
%N Datei(en):\n"
>> +"  hat %r mehrfach belegte(n) Block/Bl=F6cke, gemeinsam genutzt mit =
%N Datei(en):\n"
>>=20
>> #. @-expanded: \t%Q (inode #%i, mod time %IM)\n
>> #: e2fsck/problem.c:1011
>> @@ -5274,7 +5274,7 @@ msgstr "Das Intervall zwischen zwei Checks wird =
auf %lu Sekunden gesetzt\n"
>> #: misc/tune2fs.c:2016
>> #, c-format
>> msgid "Setting reserved blocks percentage to %g%% (%llu blocks)\n"
>> -msgstr "Der Prozentsatz reservierter B=F6cke wird auf %g%% (%llu =
Bl=F6cke) gesetzt\n"
>> +msgstr "Der Prozentsatz reservierter Bl=F6cke wird auf %g%% (%llu =
Bl=F6cke) gesetzt\n"
>>=20
>> #: misc/tune2fs.c:2022
>> #, c-format
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_10EEDA93-D9A4-41CC-AF30-4635B1AB27CD
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUwb/OXKl2rkXzB/gAQI67A//XFFrHGDh6S72p+m9zOs5oGO80lwQkEis
Fv0LJTY0lK11HdmuJV5R7DjtwKtTiojnZkZ/h90ELm1K5t/7AiPgc/4gBGbkobSG
avzdHTZHE0zfFCE0nu0yliQ/lbZeFIxVHvtDGmBhcp0JoRsvnr1aQd4F/2kRpD9c
UJG0MRJywNPkKcgbI09An2xG+8d1lLgT7LlEJRKZPVXKBvYeAj26AwBQdG/x6MEj
vRLXkR329hN4lAlZ6ATNTwYtkLtOCaho1Xs4evQmeHrWkaMuc78awswviQsI+gxz
YAuPgLJH3KmnMO22nlZEjxGHskkgH01Ni4Wy1D5bemijKacsXw9kbTt/ZJ2LO3i7
myhyPeGnKwwvqt/Q5GIhsljv+bWqzNZpWwKSXJ6u5+YoP8nrayLo0zhu3mvxloY8
gYqpFs4o1d8ZBIU3TaWnQ20024FDykTcL2fnkPvzHyoWjw83fLhBxgwN0S2vbj0P
zvyyiNak8AbRRKl3r59RbGAnjpNDjfLVExLCC7vYBoLn3jE/lzMZ7h+h1B+1qOdU
2FjaT5KeMmtl0kvh2xseTCM88FF5VJIpJ0jgIr4cY/pAdkhwCzqn3WSoUtAg10BO
BWtSImkHHE5J+wvFXRtE4yzMHCYCGuzMU1SzYvLG/+9LfZi0zaK3RbON++8552fy
Q5e5qgC0M38=
=u01p
-----END PGP SIGNATURE-----

--Apple-Mail=_10EEDA93-D9A4-41CC-AF30-4635B1AB27CD--
