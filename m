From: Andreas Dilger <adilger@sun.com>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm
	patch]
Date: Thu, 17 Jan 2008 04:36:05 -0700
Message-ID: <20080117113605.GT3351@webber.adilger.int>
References: <200801140839.01986.abhishekrai@google.com> <20080114163412.83a8b18d.akpm@linux-foundation.org> <20080115030441.a0270609.akpm@linux-foundation.org> <25815.1200457538@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Abhishek Rai <abhishekrai@google.com>,
	linux-kernel@vger.kernel.org, rohitseth@google.com,
	linux-ext4@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:54909 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYAQLgJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jan 2008 06:36:09 -0500
Content-Disposition: inline
In-Reply-To: <25815.1200457538@turing-police.cc.vt.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 15, 2008  23:25 -0500, Valdis.Kletnieks@vt.edu wrote:
> I've got multiple boxes across the hall that have 50T of disk on them, in one
> case as one large filesystem, and the users want *more* *bigger* still (damned
> researchers - you put a 15 teraflop supercomputer in the room, and then they
> want someplace to *put* all the numbers that come spewing out of there.. ;)
> 
> There comes a point where that downtime gets too long to be politically
> expedient.  6->2 may not be a biggie, because you can likely get a 6 hour
> window.  24->8 suddenly looks a lot different.
> 
> (Having said that, I'll admit the one 52T filesystem is an SGI Itanium box
> running Suse and using XFS rather than ext3).
> 
> Has anybody done a back-of-envelope of what this would do for fsck times for
> a "max realistically achievable ext3 filesystem" (i.e. 100T-200T or ext3
> design limit, whichever is smaller)?

This is exactly the kind of environment that Lustre is designed for.
Not only do you get parallel IO performance, but you can also do parallel
e2fsck on the individual filesystems when you need it.  Not that we aren't
also working on improving e2fsck performance, but 100 * 4TB e2fsck in
parallel is much better than 1 * 400TB e2fsck (probably not possible on
a system today due to RAM constraints though I haven't really done any
calculations either way).  I know customers were having RAM problems with
3 * 2TB e2fsck in parallel on a 2GB node.

Most customers these days use 2-4 4-8TB filesystems per server
(inexpensive SMP node with 2-4GB RAM instead of a single monstrous SGI box).

We have many Lustre filesystems in the 100-200TB range today, some over 1PB
already and much larger ones being planned.

> (And one of the research crew had a not-totally-on-crack proposal to get a
> petabyte of spinning oxide.  Figuring out how to back that up would probably
> have landed firmly in my lap.  Ouch. ;)

Charge them for 2PB of storage, and use rsync :-).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
