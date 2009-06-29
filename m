From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Massive corruption on RAID0
Date: Sun, 28 Jun 2009 22:30:37 -0500
Message-ID: <4A48355D.5040001@redhat.com>
References: <298610bb0906281738u2e1ce91fnc753acc145d759bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?UTF-8?B?S3J6eXN6dG9mIEtvc2nFhHNraQ==?= <tweenk.pl@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52899 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZF2Daj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Jun 2009 23:30:39 -0400
In-Reply-To: <298610bb0906281738u2e1ce91fnc753acc145d759bb@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Krzysztof Kosi=C5=84ski wrote:
> Hello
>=20
> Here is my story: I recently migrated a server from Windows to Ubuntu
> 9.04. I formatted all disks with ext4. The server has 5 disks: three
> SCSI (9GB for /, 2x18GB for /data/small and /home) and two IDE
> (2x300GB). I put the IDE disks in a RAID0: each had a single partitio=
n
> with type set to "fd", and the entire resulting device (/dev/md0) was
> formatted with ext4 as:
>=20
> mkfs.ext4 -b 4096 -E stride=3D16 /dev/md0
>=20
> All was well until a power outage that left the filesystem on /dev/md=
0
> unmountable (the others were fine after an fsck). I made a backup of
> the corrupted array to another disk and ran fsck, but it ended up in
> an infinite loop. After some unsuccessful tinkering, I restored the
> backup and found out that large portions of the group descriptor tabl=
e
> are filled with random junk. Moreover, all backup superblocks are
> either corrupted or zeroed, and I found partial copies of an
> identically corrupted table at various weird offsets (including
> 176888, 600344, 1036536, 1462520, 1887256 and 5326832); neither of
> these copies were preceded by anything resembling a superblock. Here
> is a copy of first 39 blocks of the corrupted disk:
> http://tweenk.artfx.pl/super.bin

It's awfully hard to say what went wrong given this information.
However, power failures mean that write caches on drives go away and
without barriers (which md raid0 won't pass, IIRC), that means that
journal ordering guarantees are shot, and so corruption can happen - bu=
t
I would not expect huge swaths of crud sprinkled over the drive.

Is the super.bin above from before the fiddling you did (i.e. right
after the power loss?)  The superblock is marked with errors, I wonder
if there were other errors reported on the filesystem prior to the powe=
r
loss; you might check your logs ...

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
