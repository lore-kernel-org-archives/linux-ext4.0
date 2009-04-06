From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 06 Apr 2009 20:22:38 +0100
Message-ID: <1239045758.7486.80.camel@localhost>
References: <1212171647.7508.46.camel@localhost> <49D6C844.5070604@redhat.com>
 <49D75AD1.7060101@redhat.com> <20090404212507.GC3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Karel Zak <kzak@redhat.com>
To: Andreas Dilger <adilger@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:63949 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbZDFTgj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2009 15:36:39 -0400
Received: from fe-emea-10.sun.com (gmp-eb-lb-2-fe2.eu.sun.com [192.18.6.11])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n36JMoJS018571
	for <linux-ext4@vger.kernel.org>; Mon, 6 Apr 2009 19:23:02 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KHP004001K5ZI00@fe-emea-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 06 Apr 2009 20:22:50 +0100 (BST)
In-reply-to: <20090404212507.GC3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On S=C3=A1b, 2009-04-04 at 15:25 -0600, Andreas Dilger wrote:
> I _suppose_ there is no hard requirement that the ub_magic is present=
 in
> the first =C3=BCberblock slot at 128kB, but that does make it harder =
to find.
> In theory we would need to add 256 magic value checks, which seems
> unreasonable.  Ricardo, do you know why the zfs.img.bz2 has bad =C3=BC=
berblocks
> for the first 4 slots?

Your supposition is correct - there's no requirement that the first
uberblock that gets written to the uberblock array has to be in the
first slot.

The reason that this image has bad uberblocks in the first 4 slots is
that, in the current ZFS implementation, when you create a ZFS pool, th=
e
first uberblock that gets written to disk has txg number 4, and the slo=
t
that gets chosen for each uberblock is "txg_nr % nr_of_uberblock_slots"=
=2E

So in fact, it's not that the first 4 uberblocks are bad, it's just tha=
t
the first 4 slots don't have any uberblocks in them yet.

However, even though currently it's txg nr 4 that gets written first,
this is an implementation-specific detail that we cannot (or should not=
)
rely upon.

So I think you're (mostly) right - in theory, a correct implementation
would have to search all the uberblock slots in all the 4 labels (2 at
the beginning of the partition and 2 at the end), for a total of 512
magic offsets, but this is not easy to do with libblkid because it only
looks for the magic values at hard-coded offsets (as opposed to being
able to implement a routine to look for a filesystem, which could use a
simple "for" statement).

This is why I decided to change your patch to look for VDEV_BOOT_MAGIC,
which I assumed was always there in the same place, but apparently this
does not seem to be the case.

Eric, do you know how this ZFS pool/filesystem was created?
Specifically, which Solaris/OpenSolaris version/build, or maybe zfs-fus=
e
version? Also, details about which partitioning scheme is being used an=
d
whether this is a root pool would also help a lot.

BTW, I also agree that it would be useful for ext3's mkfs to zero-out
the first and last 512 KB of the partition, to get rid of the ZFS label=
s
and magic values, although if it detects these magic values, it would b=
e
quite useful for mkfs to refuse to format the partition, forcing the
user to specify some "--force" flag (like "zpool create" does), or at
least ask the user for confirmation (if mkfs is being used in
interactive mode), to avoid accidental data destruction.

If this is not done, then maybe leaving the ZFS labels intact could be
better, so that the user has a chance to recover (some/most) of it's
data, in case he made a mistake.

Cheers,
Ricardo


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
