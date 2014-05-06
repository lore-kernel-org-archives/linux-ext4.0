From: Nathaniel W Filardo <nwf@cs.jhu.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Tue, 6 May 2014 11:51:59 -0400
Message-ID: <20140506155159.GY5136@gradx.cs.jhu.edu>
References: <20140420163211.GT10985@gradx.cs.jhu.edu>
 <20140423072311.GD10163@dot.freshdot.net>
 <20140423143642.GA29925@thunk.org>
 <20140501162503.GL5136@gradx.cs.jhu.edu>
 <20140506154239.GA5012@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GcSOTaE82DYSpZPK"
Cc: linux-ext4@vger.kernel.org, admins@acm.jhu.edu
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blaze.cs.jhu.edu ([128.220.13.50]:52183 "EHLO blaze.cs.jhu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbaEFPwC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 11:52:02 -0400
Content-Disposition: inline
In-Reply-To: <20140506154239.GA5012@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--GcSOTaE82DYSpZPK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 11:42:39AM -0400, Theodore Ts'o wrote:
> On Thu, May 01, 2014 at 12:25:03PM -0400, Nathaniel W Filardo wrote:
> > Here's another kernel report, this time from /dev/sda1, which is a QEMU=
-IDE
> > view of a local LVM volume and is only 4060864 blocks big, so it falls =
into
> > neither the "Ceph's fault" nor "8TB is special" bins:

Ack, oops; my bad.  So I just checked the configuration and realized that,
while /dev/sda1 was in fact once upon a time a local view of LVM, it is now
in Ceph.  So it does eliminate the "8TB is special" bin but "Ceph's fault"
is still in play.

> > [922646.672586] EXT4-fs error (device sda1): ext4_mb_generate_buddy:756=
: group 17, 24652 clusters in bitmap, 24651 in gd; block bitmap corrupt.
>=20
> So this is a different report from the ones where we see this error:
>=20
> [817576.492468] EXT4-fs error (device vdd): ext4_mb_release_inode_pa:3729=
: group 59035, free 14, pa_free 12
>=20
> Have you seen any more of these errors?

I think so, yes; I recall seeing bugs in both the allocation and the free
side of things, but I will keep an eye out.

> > [922646.712017] BUG: unable to handle kernel NULL pointer dereference a=
t 0000000000000028
> > [922646.712017] IP: [<ffffffffa014a7cc>] __ext4_error_inode+0x2c/0x150 =
[ext4]
>=20
> FYI, this BUG (which can happens after certain jbd2 errors, which in
> your case happened after the journal was aborted) is fixed with commit
> 66a4cb187b9 which will be in v3.15.

Excellent; I look forward to the new release and will stop nagging you with
these. :)

--nwf;

--GcSOTaE82DYSpZPK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlNpBR4ACgkQTeQabvr9Tc8O1ACfazabnE7GFhQa2pJ0hTiVjSqh
G/UAnjitOWQhk8etMVV7NsUw0CmFNCVr
=9hY2
-----END PGP SIGNATURE-----

--GcSOTaE82DYSpZPK--
