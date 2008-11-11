From: "Michael B. Trausch" <mike@trausch.us>
Subject: Re: "tune2fs -I 256" runtime---can it be interrupted safely?
Date: Tue, 11 Nov 2008 11:09:10 -0500
Message-ID: <20081111110910.4a6f7941@zest>
References: <20081101151002.4ed9be99@zest>
	<20081101194617.0dc131c3@zest>
	<20081107211643.GB3184@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rqsEhb2M/0vnnKfoPJuaC3i";
 protocol="application/pgp-signature"; micalg=PGP-RIPEMD160
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:57462 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYKKQJW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Nov 2008 11:09:22 -0500
Received: by an-out-0708.google.com with SMTP id d40so650346and.1
        for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 08:09:19 -0800 (PST)
In-Reply-To: <20081107211643.GB3184@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/rqsEhb2M/0vnnKfoPJuaC3i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 07 Nov 2008 14:16:43 -0700
Andreas Dilger <adilger@sun.com> wrote:

> If you have time, after the backup is done could you please re-try the
> "tune2fs -I 256" operation and let it go for a while, then "ltrace -p
> {pid}" on the process from another window to see what it is doing (if
> anything). You may need to have the "e2fsprogs-debuginfo" RPM
> installed to get useful data there.
>=20
> After grabbing some of the data with ltrace, also run "strace -p
> {pid}" to get disk IO information, and finally "gdb -p {pid}" and
> grab a stack trace with "bt", let it continue for a few seconds with
> "c", and then CTRL-C again and grab another stack trace with "bt".

Ugh, I forgot to do the gdb backtraces.  *headdesk*  I will do another
run with them later.

I do have an ltrace up and online at:

  http://fd0man.theunixplace.com/tune2fs.ltrace.bz2

The bzip2 file is 44 MB, and the uncompressed text is _huge_ (about 3
GB).  This is a two hour run of "tune2fs -I 256 /dev/sdb" on an
external 250 GB (235 GiB) drive formatted with the ext3 filesystem.
I aborted the tune2fs run after 2 hours, though I am sure it would have
run for far longer.  Hopefully, this will give some insight as to what
the problem might be.

I _was_ hoping that it would make a difference in runtime that the
filesystem was empty (I did this right after "mkfs.ext3 -I
128 /dev/sdb"), but it was still going very slowly...

	--- Mike

--=20
My sigfile ran away and is on hiatus.
http://www.trausch.us/

--Sig_/rqsEhb2M/0vnnKfoPJuaC3i
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREDAAYFAkkZriYACgkQ0kE/IBnFmjCs0QCfdMEZu6Q4iupTfGyRv496Z3yg
6fgAn3nNci94rUlenhHlynOWntpeJwum
=P3+L
-----END PGP SIGNATURE-----

--Sig_/rqsEhb2M/0vnnKfoPJuaC3i--
