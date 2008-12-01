From: Andres Freund <andres@anarazel.de>
Subject: Re: EXT4 ENOSPC Bug
Date: Mon, 1 Dec 2008 21:16:04 +0100
Message-ID: <200812012116.08510.andres@anarazel.de>
References: <200811291418.24672.andres@anarazel.de> <200812011335.00366.andres@anarazel.de> <20081201194204.GZ3186@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4842100.BYZtyiQdPY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.anarazel.de ([217.115.131.40]:56403 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbYLAUQM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Dec 2008 15:16:12 -0500
In-Reply-To: <20081201194204.GZ3186@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart4842100.BYZtyiQdPY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Andreas, Hi all,

On Monday 01 December 2008 20:42:04 Andreas Dilger wrote:
> On Dec 01, 2008  13:34 +0100, Andres Freund wrote:
> > Are there any additional informations you could use?
> > The filesystem is a bit big for you to download unfortunately (and the
> > testdata  it contains a bit to sensitive).
> - did you run "e2fsck -f" to see if there were any errors in the
> filesystem?
Yes, no errors.

> - do you run any specific applications that seem to trigger the
> problem (e.g.  Vuze (formerly azureus) as was reported by another user)
No. The Problem occured sometimes shortly after boot (Once even before X wa=
s=20
up) sometimes only after days of full usage.
Boot starts postgres, thats the only thing that propably always ran. But I=
=20
have seen it while postgres was idle - i.e. just some polls and stats.

> - do the applications writing to this file have any unusual IO pattern
>   (e.g. mmap IO, lots of write+truncate+write on the same file, etc)
Its not a single file, but the whole filesystem, having problems.

> We discussed the creation of a debugging patch to help diagnose this
> problem.  It looks like you have already compiled your own kernel, so
> I assume it would be possible for you to run with an additional patch?
Sure, no problem.
At least if the patch is not expensive during run time. The system produces=
=20
test-data for testing our development software and I cant take it down for =
too=20
long.
Thats the reason why I can use something like ext4 on such a system at all =
;-)

It sometimes takes quite a while to reproduce the problem though. The syste=
m=20
ran stable for 4 days so far.
Same kernel as the last time the error occured though.

Any specific debug options I should enable?

Andres

--nextPart4842100.BYZtyiQdPY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk0RgUACgkQporPraT14ijpBACeL4fJ3Xi8zLD4ziCK/7xYNp4m
0+AAnjCyFYvwab/cethWOQSUxdckupm4
=+1Uk
-----END PGP SIGNATURE-----

--nextPart4842100.BYZtyiQdPY--
