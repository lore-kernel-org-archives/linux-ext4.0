From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 fails on ext2 filesystems
Date: Tue, 20 Jan 2009 07:30:59 +0800
Message-ID: <20090119233059.GH3286@webber.adilger.int>
References: <20090118013516.GA4876@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?Su+/vXJn?= Sommer <joerg@alea.gnuu.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:37211 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbZASXbI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jan 2009 18:31:08 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n0JNV2dl021763
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 15:31:02 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KDQ00501RU8P400@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 19 Jan 2009 15:31:01 -0800 (PST)
In-reply-to: <20090118013516.GA4876@alea.gnuu.de>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 18, 2009  02:35 +0100, J=EF=BF=BDrg Sommer wrote:
> I've an ext2 filesystem as root filesystem, because it's mounted read=
only
> for the most part. I've built in the support for ext[234] in the kern=
el.
> Ext4 takes precedence over ext2 and it mounts the root filesystem:

Hmm, probably an unintended consequence of the newly-added patch to
allow ext4 to mount ext2 filesystems.

> But when remounting the filesystem read/write and changing a file, th=
e
> changes are written to the filesystem, but it's remounted readonly
> immediatly. I've set the mount option remount-ro.
>=20
> [  203.082300] EXT4 FS on hda3, no journal
> [  205.746713] EXT4-fs error (device hda3): ext4_free_data: circular =
indirect block detected, inode=3D165056, block=3D184476

> motherboard	: PowerBook6,3 MacRISC3 Power Macintosh

Hmm, looks like it might be a bug in the endian conversion?


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
