From: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] ext2: Don't export ext2_mask_flags() to user space
Date: Thu, 22 Mar 2012 17:47:51 +0100
Message-ID: <20120322164751.GA17885@avionic-0098.adnet.avionic-design.de>
References: <1332366608-2695-1-git-send-email-thierry.reding@avionic-design.de>
 <20120321222357.GB24330@quack.suse.cz>
 <20120321231651.GC32041@thunk.org>
 <20120322055354.GA3942@avionic-0098.mockup.avionic-design.de>
 <1332396053.3058.2.camel@koala>
 <20120322162825.GA4028@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
To: Ted Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60571 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2CVQsk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 12:48:40 -0400
Content-Disposition: inline
In-Reply-To: <20120322162825.GA4028@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Ted Ts'o wrote:
> On Thu, Mar 22, 2012 at 08:00:41AM +0200, Artem Bityutskiy wrote:
> > On Thu, 2012-03-22 at 06:53 +0100, Thierry Reding wrote:
> > > What's the recommended fix for packages that cannot or will not use
> > > libext2fs, like busybox? Copy the required parts into a private header
> > > and use that instead?
> >=20
> > The normal way is to just keep a private copy of the whole header file.
> > Because the on-disk format stays compatible, those programs do not have
> > to update the header very often - only rarely if they want to support
> > some new feature.
>=20
> Even if they're not iwlling to use libext2fs (for space reasons, I
> would assume?  It can't be because of license compatibility issues
> since they are both GPLv2), they could just simply grab the ext2_fs.h
> from e2fsprogs.  That has all of the file system definitions for ext2,
> ext3, and ext4.

In fact there is already a file, e2fs_defs.h, that seems to be based on the
contents of the ext2_fs.h from the kernel. I've posted two patches to the
busybox mailing list that fix the build without using linux/ext2_fs.h. For
reference, they can be found here:

	http://lists.busybox.net/pipermail/busybox/2012-March/077563.html
	http://lists.busybox.net/pipermail/busybox/2012-March/077562.html

Do you still want me to prepare a patch to unexport ext2_fs.h or will you
take care of it?

Thierry

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9rV7cACgkQZ+BJyKLjJp8ezACcDWZGEuBwWcNpoayziNPZeHt3
l/sAn1n8pBb2zDyCfkhuRoq+4BdzZ5J7
=teNS
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
