From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: ext4 fails on ext2 filesystems
Date: Sat, 17 Jan 2009 21:38:41 -0500
Message-ID: <20090118023841.GD25943@mit.edu>
References: <20090118013516.GA4876@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34587 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162AbZARCis (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 21:38:48 -0500
Content-Disposition: inline
In-Reply-To: <20090118013516.GA4876@alea.gnuu.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 18, 2009 at 02:35:16AM +0100, J=F6rg Sommer wrote:
>=20
> But when remounting the filesystem read/write and changing a file, th=
e
> changes are written to the filesystem, but it's remounted readonly
> immediatly. I've set the mount option remount-ro.
>=20
> [  203.082300] EXT4 FS on hda3, no journal
> [  205.746713] EXT4-fs error (device hda3): ext4_free_data: circular =
indirect block detected, inode=3D165056, block=3D184476
>=20

Can you do me a favor?  Can you run debugfs /dev/hda3, and then run
the debugfs command: "stat <165056>"? =20

Any thanks!!

					- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
