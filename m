From: Eric Anopolsky <erpo41@gmail.com>
Subject: Re: Porting Zfs features to ext2/3
Date: Mon, 28 Jul 2008 21:58:32 -0600
Message-ID: <1217303912.7887.20.camel@telesto>
References: <18674437.post@talk.nabble.com>
	 <1217199281.6992.0.camel@telesto> <20080727233855.GB9378@mit.edu>
	 <1217218559.28825.12.camel@telesto>  <20080728124055.GD9378@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eZ7n0hSHyxzLiNgVe1YO"
Cc: postrishi <postrishi@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:24852 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbYG2D6g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 23:58:36 -0400
Received: by wf-out-1314.google.com with SMTP id 27so6156454wfd.4
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2008 20:58:35 -0700 (PDT)
In-Reply-To: <20080728124055.GD9378@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-eZ7n0hSHyxzLiNgVe1YO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Please let me know if I'm getting off topic for the ext4-devel list. My
point is not to advocate ZFS over ext3/4 since ZFS still has its share
of issues. No resizing raidz vdevs, for example, and performance in
certain areas. My only point is to make it clear that ZFS on Linux is
available (and not necessarily a bad choice) to people reading the
ext4-devel mailing list looking for ZFS-like features like the original
poster.

On Mon, 2008-07-28 at 08:40 -0400, Theodore Tso wrote:
> On Sun, Jul 27, 2008 at 10:15:59PM -0600, Eric Anopolsky wrote:
> > It's true that ZFS on FUSE performance isn't all it could be right now.
> > However, ZFS on FUSE is currently not taking advantage of mechanisms
> > FUSE provides to improve performance. For an example of what can be
> > achieved, check out http://www.ntfs-3g.org/performance.html .
>=20
> Yes... and take a look at the metadata operations numbers.  FUSE can
> do things to accellerate bulk read/write, but metadata-intensive
> operations will (I suspect) always be slow. =20

It doesn't seem too much worse than the other non-ext3 filesystems in
the comparison. I'm sure everyone would prefer a non-FUSE implementation
and the licensing issues aren't going to go away, but this post on Jeff
Bonwick's blog gives some hope:
http://blogs.sun.com/bonwick/entry/casablanca . Even so, not everyone
needs a whole lot of speed in the metadata operations area.=20

> I also question whether
> the FUSE implementation will have the safety that has always been the
> Raison d'=C3=AAtre of ZFS.  Have you or the ZFS/FUSE developers done test=
s
> where you are writing to the filesystem, and then someone pulls the
> plug on the fileserver while ZFS is writing?  Does the filesystem
> recovery cleanly from such a scenario?

I haven't personally tried pulling the plug, but I've tried holding down
the power button on my laptop until it powers off. Everything works fine
and scrubs (the closest ZFS gets to fsck) don't report any checksum
errors. The filesystem driver updates the on-disk filesystem atomically
every five seconds (less time in special circumstances) so there's never
any point at which the filesystem would need recovery. The next time the
filesystem is mounted the system sees the state the filesystem was in up
to five seconds before the power went out. The FUSEness of the
filesystem driver doesn't seem to affect this.

Cheers,
Eric


--=-eZ7n0hSHyxzLiNgVe1YO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIjpVoe2L37HVup3ARAnX4AJ9DH3Xu8Xi5L7yoDuAfqx6kr846MgCgpq0r
a56NWvJspUrJPTbNJBESmKU=
=k8aO
-----END PGP SIGNATURE-----

--=-eZ7n0hSHyxzLiNgVe1YO--

