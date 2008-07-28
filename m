From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: Porting Zfs features to ext2/3
Date: Sun, 27 Jul 2008 22:15:59 -0600
Message-ID: <1217218559.28825.12.camel@telesto>
References: <18674437.post@talk.nabble.com>
	 <1217199281.6992.0.camel@telesto>  <20080727233855.GB9378@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-l259mWJRmZxtFgThA/Pz"
Cc: postrishi <postrishi@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:48100 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYG1EQL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 00:16:11 -0400
Received: by py-out-1112.google.com with SMTP id p76so3181365pyb.10
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jul 2008 21:16:10 -0700 (PDT)
In-Reply-To: <20080727233855.GB9378@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-l259mWJRmZxtFgThA/Pz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-07-27 at 19:38 -0400, Theodore Tso wrote:
> On Sun, Jul 27, 2008 at 04:54:41PM -0600, Eric Anopolsky wrote:
> > On Sun, 2008-07-27 at 01:49 -0700, postrishi wrote:
> > > Hello
> > >=20
> > > I want to know that has any work been done to port the Zfs features t=
o
> > > ext2/3
> >=20
> > Did you know that ZFS is available for Linux?
>=20
> ZFS is available in a FUSE filesystem.  As a userspace filesystem, it
> means a huge number of context switches to get data between the disk,
> to the kernel, to the FUSE userspace, back to the kernel, and to the
> process trying to access the ZFS file.  That's not going to be high
> performance.  For someone who wants to migrate from Solaris to Linux,
> it might be useful, but I'm not sure you would really want to use a
> ZFS/FUSE implementation in production.

It's true that ZFS on FUSE performance isn't all it could be right now.
However, ZFS on FUSE is currently not taking advantage of mechanisms
FUSE provides to improve performance. For an example of what can be
achieved, check out http://www.ntfs-3g.org/performance.html .

FWIW, I am satisfied with its performance for backups of my home
directory and for my fileserver, which is limited by a 100Mbps
connection to the rest of the network. I do not recommend it as a root
filesystem yet.

Cheers,
Eric


--=-l259mWJRmZxtFgThA/Pz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIjUf/e2L37HVup3ARAvm4AKDcmwv7rFUK6ekezZiU+3/SX/nGfwCfaPa2
4YdrxZw8cRU/MarZKNw5hOs=
=Fdct
-----END PGP SIGNATURE-----

--=-l259mWJRmZxtFgThA/Pz--

