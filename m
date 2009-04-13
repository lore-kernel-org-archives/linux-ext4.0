From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 13 Apr 2009 20:29:22 +0100
Message-ID: <1239650962.18123.44.camel@localhost>
References: <1212171647.7508.46.camel@localhost> <49D6C844.5070604@redhat.com>
 <49D75AD1.7060101@redhat.com> <20090404212507.GC3199@webber.adilger.int>
 <1239045758.7486.80.camel@localhost> <20090407074033.GM3204@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Karel Zak <kzak@redhat.com>
To: Andreas Dilger <adilger@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:46709 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbZDMT3a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Apr 2009 15:29:30 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe3.eu.sun.com [192.18.6.12])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3DJTOjI023810
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2009 19:29:26 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KI200I000QA4C00@fe-emea-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 13 Apr 2009 20:29:24 +0100 (BST)
In-reply-to: <20090407074033.GM3204@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Ter, 2009-04-07 at 00:40 -0700, Andreas Dilger wrote:
> > However, even though currently it's txg nr 4 that gets written firs=
t,
> > this is an implementation-specific detail that we cannot (or should=
 not)
> > rely upon.
>=20
> So my proposal to check the 0th, 4th, and 8th =C3=BCberblock in both
> the first and second VDEV label should be pretty safe.

Yes, that should be relatively safe :)

Where should I be sending patches for this? e2fsprogs, util-linux-ng,
libvolume_id in udev, ... all of them?

> > If this is not done, then maybe leaving the ZFS labels intact could=
 be
> > better, so that the user has a chance to recover (some/most) of it'=
s
> > data, in case he made a mistake.
>=20
> Well, if ZFS is currently using this filesystem, then the kernel will
> have the block device open O_EXCL, which will prevent the mkfs from
> happening.

Not if the pool is exported :)

> Whether it will be a feature to "--force" mkfs to overwrite an ext3
> superblock or ZFS superblock is questionable.  The problem with needi=
ng
> "--force" is that people tend to hard-code this into their scripts
> (so that their script always works) and then due to only having a sin=
gle
> "--force" flag it also forces other, possibly more destructive, behav=
iour
> (e.g. --force is needed to mke2fs on a file so that it can be mounted
> via loopback, but will also force mke2fs on a filesystem that actuall=
y
> IS in use, etc).

What about '--force-overwrite' or something similar?

It wasn't scripts that I was so concerned about. I think this filesyste=
m
detection would be more useful when running mkfs in a shell, where it i=
s
more likely for the user to make mistakes (e.g. mistype /dev/sdd1
as /dev/sde1 or /dev/sda1 as /dev/sda2).

Thanks,
Ricardo

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
