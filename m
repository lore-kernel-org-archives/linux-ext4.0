From: Nathaniel W Filardo <nwf@cs.jhu.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Sun, 20 Apr 2014 12:32:12 -0400
Message-ID: <20140420163211.GT10985@gradx.cs.jhu.edu>
References: <20140409223820.GU10985@gradx.cs.jhu.edu>
 <CAGagf4eEzY4+3cfNWSEENTo1PKe40nq1Ne6ZzOLGm-O78W7RcA@mail.gmail.com>
 <20140410050428.GV10985@gradx.cs.jhu.edu>
 <20140410140316.GD15925@thunk.org>
 <20140410163350.GW10985@gradx.cs.jhu.edu>
 <20140410221702.GD31614@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3/Wm4stOzDzLYPbq"
Cc: Mike Rubin <mrubin@google.com>, Frank Mayhar <fmayhar@google.com>,
	admins@acm.jhu.edu, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blaze.cs.jhu.edu ([128.220.13.50]:51676 "EHLO blaze.cs.jhu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaDTQcQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Apr 2014 12:32:16 -0400
Content-Disposition: inline
In-Reply-To: <20140410221702.GD31614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--3/Wm4stOzDzLYPbq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

We just got

> [817576.492013] EXT4-fs (vdd): pa ffff88000dea9b90: logic 0, phys.  1934464544, len 32
> [817576.492468] EXT4-fs error (device vdd): ext4_mb_release_inode_pa:3729: group 59035, free 14, pa_free 12
> [817576.492987] Aborting journal on device vdd-8.
> [817576.493919] EXT4-fs (vdd): Remounting filesystem read-only

Upon unmount, further

> [825457.072206] EXT4-fs error (device vdd): ext4_put_super:791: Couldn't clean up the journal

fscking generated

> fsck from util-linux 2.20.1
> e2fsck 1.42.9 (4-Feb-2014)
> /dev/vdd: recovering journal
> /dev/vdd contains a file system with errors, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  +(1934464544--1934464545)
> Fix<y>? yes
> Free blocks count wrong (1379876836, counted=1386563079).
> Fix<y>? yes
> Free inodes count wrong (331897442, counted=331912336).
> Fix<y>? yes
>
> /dev/vdd: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/vdd: 3631984/335544320 files (1.6% non-contiguous), 1297791481/2684354560 blocks

The particular error reported by the kernel seems to be the first of the
three, but the other two look like leaks?  A huge number of inodes (14894)
and blocks (6686243, or 3.2Gi of storage!) were marked busy in a way that
fsck didn't believe, if I am reading that right?

/dev/vdd is virtio on Ceph RBD, using write-through caching.  We have had a
crash on one of the Ceph OSDs recently in a way that seems to have generated
inconsistent data in Ceph, but subsequent repair commands seem to have made
everything happy again, at least so far as Ceph tells us.

The guest `uname -a` sayeth

> Linux afsscratch-kvm 3.13-1-amd64 #1 SMP Debian 3.13.7-1 (2014-03-25) x86_64 GNU/Linux

And in case it's relevant, host QEMU emulator is version 1.7.0 (Debian
1.7.0+dfsg-3) [modified locally to include rbd]; guest ceph, librbd, etc.
are Debian package 0.72.2-1~bpo70+1 .

Cheers,
--nwf;

--3/Wm4stOzDzLYPbq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlNT9osACgkQTeQabvr9Tc9ptgCdFGHaM4eN3UFf7mIICVUDNZtq
TygAn3jq0FDmM6HDvboSTkspKK2pfj4C
=4cCf
-----END PGP SIGNATURE-----

--3/Wm4stOzDzLYPbq--
