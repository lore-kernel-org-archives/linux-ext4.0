From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: uuidgen question/proposal
Date: Tue, 25 Apr 2017 13:06:25 -0600
Message-ID: <F0C36833-9DBC-4467-9FC4-C49240E9F804@dilger.ca>
References: <6af6c8df-7b1c-bd77-327e-851e4fdf3b39@gmx.net>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_DB9BEF0E-FDD3-49D3-96D8-1E75E83431CC";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Alexander Pohoyda <alexander.pohoyda@gmx.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36427 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943015AbdDYTGa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Apr 2017 15:06:30 -0400
Received: by mail-io0-f172.google.com with SMTP id p80so103610516iop.3
        for <linux-ext4@vger.kernel.org>; Tue, 25 Apr 2017 12:06:30 -0700 (PDT)
In-Reply-To: <6af6c8df-7b1c-bd77-327e-851e4fdf3b39@gmx.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_DB9BEF0E-FDD3-49D3-96D8-1E75E83431CC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Apr 24, 2017, at 2:03 PM, Alexander Pohoyda =
<alexander.pohoyda@gmx.net> wrote:
>=20
> Hi Andreas,
>=20
> one option is IMHO missing in uuidgen(1) tool -- to dump the GUID in =
binary form (so that it could be easily Base64-encoded)
>=20
> It is as simple as this:
> printf("%.16s\n", uuid);
>=20
> Base64-encoding of GUIDs is very popular these days and there are a =
number of online tools to do this, but since uuidgen only dumps a =
serialized string, this could not be Base64 encoded easily.
>=20
> What's your take on this?  Thanks!

I've CC'd your question to linux-ext4@vger.kernel.org, since that is
the mailing list for discussing e2fsprogs changes.

My suggestion would be to add a "-b" (or similar) option directly to =
uuidgen
so that it can do the base64 encoding itself, rather than dumping the =
UUID
in binary and having to pipe it to another utility.

Cheers, Andreas






--Apple-Mail=_DB9BEF0E-FDD3-49D3-96D8-1E75E83431CC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY/54ypIg59Q01vtYRAkGaAJ9RR+xUbgABbw6bRK0sXCmFnIxkSwCfeiRq
uQHCtw6ye6jhcstW4du2kQc=
=KZVH
-----END PGP SIGNATURE-----

--Apple-Mail=_DB9BEF0E-FDD3-49D3-96D8-1E75E83431CC--
