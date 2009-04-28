From: "Michael B. Trausch" <mbt@zest.trausch.us>
Subject: Re: ext4 undeletion question
Date: Tue, 28 Apr 2009 13:26:09 -0400
Message-ID: <20090428132609.7628940e@zest.trausch.us>
References: <alpine.DEB.2.00.0904281037240.5262@zest.trausch.us>
	<20090428161106.GB24043@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U=Q4a0XosOaHWXuNiKUMMTy";
 protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org, mike-mobile@trausch.us
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-15-213-186-BusName-Atlanta.hfc.comcastbusiness.net ([173.15.213.186]:38494
	"EHLO zest.trausch.us" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762915AbZD1R0Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Apr 2009 13:26:16 -0400
In-Reply-To: <20090428161106.GB24043@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/U=Q4a0XosOaHWXuNiKUMMTy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Apr 2009 12:11:06 -0400
Theodore Tso <tytso@mit.edu> wrote:
> There is the program "ext3grep" which will look for older versions of
> the directory and inode table blocks in the journal.  This can work,
> but unfortunately I don't think it's been extended to understand about
> the ext4 extent data structure.

Eh.  Thanks for the mention... gave it a shot, but it seems to fail
nearly immediately:

Tuesday, 2009-Apr-28 at 13:21:41 - mbt@zest - Linux v2.6.29.1
Ubuntu Jaunty:[0-9/10014-0]:undel> sudo ext3grep --restore-all /dev/zestvg/=
home-retain-undelete
Running ext3grep version 0.10.1
WARNING: I don't know what EXT3_FEATURE_COMPAT_EXT_ATTR is.
ext3grep: ext3grep.cc:119: void run_program(): Assertion `be2le(journal_sup=
er_block.s_header.h_magic) =3D=3D 0xc03b3998U' failed.
zsh: abort      sudo ext3grep --restore-all /dev/zestvg/home-retain-undelete

I guess that means it won't work on an ext4 fs.  :-)

I did create a snapshot of it using LVM (durr, I didn't think of that
before) so the FS is preserved as it was... I just don't know how to go
about digging through it to get the directory that I deleted out.
Hopefully I can figure that out before terribly long, as I am stuck
until I do...

	--- Mike

--=20
Don't fix bugs later; fix them now.
                            --- Steve Maguire

--Sig_/U=Q4a0XosOaHWXuNiKUMMTy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn3PDEACgkQ0kE/IBnFmjDz0QCeLBwXBuXWAiQ4CE5AjxqubXEl
TqoAnR/thLmtWefsHMr4x1/5Ik9MHh7x
=aiLS
-----END PGP SIGNATURE-----

--Sig_/U=Q4a0XosOaHWXuNiKUMMTy--
