From: Dennis Gilmore <dennis@ausil.us>
Subject: Re: PATCH: use CFLAGS when linking always
Date: Sat, 5 May 2007 22:06:01 -0500
Message-ID: <200705052206.08371.dennis@ausil.us>
References: <200705050920.56558.dennis@ausil.us> <20070505192647.GC21049@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7280531.pApSiVY4uv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from anubis.ausil.us ([216.75.14.43]:35571 "EHLO mail.ausil.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbXEFDGV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 May 2007 23:06:21 -0400
In-Reply-To: <20070505192647.GC21049@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--nextPart7280531.pApSiVY4uv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Once upon a time Saturday 05 May 2007, Theodore Tso wrote:
> On Sat, May 05, 2007 at 09:20:47AM -0500, Dennis Gilmore wrote:
> > for multilib archs default CFLAGS may be inappropriate  and reslut in
> > binaries unable to be linked.  since e2fsprogs uses gcc for linking I
> > noticed this while building for sparc64.  patch has been tested and
> > applied in Aurora SPARC Linux.
>
> What options do you need, and why don't you just specify them via:
>
> configure --with-ldopts=3D"--foo-ld-flag"
>
> 					- Ted

defaults on sparc64  result in 64 bit objects  but gcc trying to create a 3=
2=20
bit binary.  as a result the build blows up horribly.  the patch ensures th=
at=20
CFLAGS is used in linking.  since gcc is used to link it is needed.

Dennis

--nextPart7280531.pApSiVY4uv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGPUYakSxm47BaWfcRAvvyAJ91bCyDZ6F0ynQpL4eh3hfItLesSQCeN2qI
75sdYiHAaomcAFsBZ3Mtwck=
=Cc6v
-----END PGP SIGNATURE-----

--nextPart7280531.pApSiVY4uv--
