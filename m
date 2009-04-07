From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Tue, 07 Apr 2009 00:40:33 -0700
Message-ID: <20090407074033.GM3204@webber.adilger.int>
References: <1212171647.7508.46.camel@localhost> <49D6C844.5070604@redhat.com>
 <49D75AD1.7060101@redhat.com> <20090404212507.GC3199@webber.adilger.int>
 <1239045758.7486.80.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Karel Zak <kzak@redhat.com>
To: "Ricardo M. Correia" <Ricardo.M.Correia@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64125 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZDGHkm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2009 03:40:42 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n377eZf1026705
	for <linux-ext4@vger.kernel.org>; Tue, 7 Apr 2009 00:40:36 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KHP00J00ZOBJD00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 07 Apr 2009 00:40:35 -0700 (PDT)
In-reply-to: <1239045758.7486.80.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 06, 2009  20:22 +0100, Ricardo Correia wrote:
> On S=E1b, 2009-04-04 at 15:25 -0600, Andreas Dilger wrote:
> > I _suppose_ there is no hard requirement that the ub_magic is prese=
nt in
> > the first =FCberblock slot at 128kB, but that does make it harder t=
o find.
> > In theory we would need to add 256 magic value checks, which seems
> > unreasonable.  Ricardo, do you know why the zfs.img.bz2 has bad =FC=
berblocks
> > for the first 4 slots?
>=20
> Your supposition is correct - there's no requirement that the first
> uberblock that gets written to the uberblock array has to be in the
> first slot.
>=20
> The reason that this image has bad uberblocks in the first 4 slots is
> that, in the current ZFS implementation, when you create a ZFS pool, =
the
> first uberblock that gets written to disk has txg number 4, and the s=
lot
> that gets chosen for each uberblock is "txg_nr % nr_of_uberblock_slot=
s".
>=20
> So in fact, it's not that the first 4 uberblocks are bad, it's just t=
hat
> the first 4 slots don't have any uberblocks in them yet.
>=20
> However, even though currently it's txg nr 4 that gets written first,
> this is an implementation-specific detail that we cannot (or should n=
ot)
> rely upon.

So my proposal to check the 0th, 4th, and 8th =FCberblock in both
the first and second VDEV label should be pretty safe.

> BTW, I also agree that it would be useful for ext3's mkfs to zero-out
> the first and last 512 KB of the partition, to get rid of the ZFS lab=
els
> and magic values, although if it detects these magic values, it would=
 be
> quite useful for mkfs to refuse to format the partition, forcing the
> user to specify some "--force" flag (like "zpool create" does), or at
> least ask the user for confirmation (if mkfs is being used in
> interactive mode), to avoid accidental data destruction.
>=20
> If this is not done, then maybe leaving the ZFS labels intact could b=
e
> better, so that the user has a chance to recover (some/most) of it's
> data, in case he made a mistake.

Well, if ZFS is currently using this filesystem, then the kernel will
have the block device open O_EXCL, which will prevent the mkfs from
happening.

Whether it will be a feature to "--force" mkfs to overwrite an ext3
superblock or ZFS superblock is questionable.  The problem with needing
"--force" is that people tend to hard-code this into their scripts
(so that their script always works) and then due to only having a singl=
e
"--force" flag it also forces other, possibly more destructive, behavio=
ur
(e.g. --force is needed to mke2fs on a file so that it can be mounted
via loopback, but will also force mke2fs on a filesystem that actually
IS in use, etc).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
