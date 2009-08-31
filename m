From: Andreas Dilger <adilger@sun.com>
Subject: Re: large file system & high object count testing
Date: Mon, 31 Aug 2009 17:13:31 -0600
Message-ID: <20090831231331.GJ4197@webber.adilger.int>
References: <4A9BFB88.5030409@redhat.com> <4A9C0220.1040503@redhat.com>
 <20090831205608.GE4197@webber.adilger.int> <4A9C3A7B.3050302@redhat.com>
 <150c16850908311425vbc1c0a1if2a7d8ed56f650f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	"Ted Ts'o" <tytso@thunk.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:39049 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbZHaXNe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 19:13:34 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7VNDUhe012898
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 16:13:32 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KP900000KABHY00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 31 Aug 2009 16:13:30 -0700 (PDT)
In-reply-to: <150c16850908311425vbc1c0a1if2a7d8ed56f650f5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 31, 2009  14:25 -0700, Justin Maggard wrote:
> On Aug 31, 2009 =A013:02 -0400, Ric Wheeler wrote:
> > Mount after fsck:
> > Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75):
> > ext4_check_descriptors: Checksum for group 487 failed (59799!=3D468=
27)
> > Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75): group descriptors
> > corrupted!
>=20
> Ah, so it's not just me.  It looks like you're seeing the exact same
> thing I reported a few days ago in the ">16TB issues" thread.  You
> don't even have to do anything fancy to make this happen.  My test
> case involves simply creating 5 directories on the newly-created
> 64-bit filesystem, and running e2fsck on it immediately after
> unmounting to get the same results.

Justin, could you please replicate this corruption, collecting some
additional information before & after.  My recollection is that the
corruption appears in the first few groups, so 64kB should be plenty
to capture the group descriptor tables (where the checksum is kept).

- mke2fs
- dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-new.gz
- mkdir ...
- sync
- dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-mkdir.gz
- umount
- dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-umount.gz
- e2fsck
- dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-e2fsck.gz

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
