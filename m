From: Marc MERLIN <marc@merlins.org>
Subject: Re: du -s src is a lot slower on SSD than spinning disk in the same laptop
Date: Wed, 25 Jul 2012 16:38:59 -0700
Message-ID: <20120725233859.GA6752@merlins.org>
References: <20120725154521.GA3398@merlins.org> <alpine.LFD.2.00.1207252023080.4340@(none)>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, axboe@kernel.dk,
	Milan Broz <mbroz@redhat.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56511 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2GYXjD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jul 2012 19:39:03 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1207252023080.4340@(none)>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 25, 2012 at 08:40:28PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> yesterday Milan Broz pointed me to the other problem of yours where
> by reading from dm_crypt target on the SSD was much slower than on
> the spinning disk. I am not sure if he already shared some
> information he managed to gather, but we saw that reading from SSD
> was much slower probably because reads were divided into tons of
> small (page size) bios as opposed to bigger chunks on spinning
> disk.
=20
Yes, indeed. To make things simpler, I'm not using dmcrypt here.

> This is probably the same reason here. The reason is most likely
> that we handle SSD differently than spinning disk (turn off
> elevator, different io scheduler and possibly other things I am not
> aware of). Also IIRC bio merging should be less "aggressive" on SSD
> than spinning disk (or maybe even turned off?), because SSD should
> supposedly handle much more iops than than spinning drive, hence
> waiting for a merge might slow things down. However in this case it
> seems to have quite opposite effect for some reason.
>=20
> You may try to convince kernel to treat your SSD as rotational disk
> by:
>=20
> echo 1 > /sys/block/sda/queue/rotational
> and see if it improves things.

Actually I had done that, along with making the readahead 8K change, bu=
t
that didn't help:

gandalfthegreat:/mnt/mnt2# time du -sh src/
519M	src/
real	0m12.176s
gandalfthegreat:/mnt/mnt2# df -h .
=46ilesystem      Size  Used Avail Use% Mounted on
/dev/sda2        25G  3.0G   21G  13% /mnt/mnt2
gandalfthegreat:/mnt/mnt2# blockdev --report /dev/sda2
RO    RA   SSZ   BSZ   StartSec            Size   Device
rw  8192   512  4096     502272     26843283456   /dev/sda2
gandalfthegreat:/mnt/mnt2# cat /sys/block/sda/queue/rotational
1
gandalfthegreat:/mnt/mnt2#=20

> Unfortunately I think that there is not much we can do about this
> from the file system level. Someone from block level should
> definitely take a look at this issue. Jens ?

Ok, I just wanted to rule out that it was not a VFS issue.
If you're confident it's block level and basically having storage that =
is
too fast (and indeed, I just bought one of the fastest SSDs out there) =
is
actually causing problems that make the entire system much slower as a
result, I'm happy to take it up another list.

Where would you recommend I go with this?

Thanks,
Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - =
A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet=
 cooking
Home page: http://marc.merlins.org/ =20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
