From: Mala Iyer <malaiyer@gmail.com>
Subject: Re: [PATCH]: icount: Replace the icount list by a two-level tree
Date: Mon, 1 Nov 2010 22:49:08 +0000 (UTC)
Message-ID: <loom.20101101T234449-996@post.gmane.org>
References: <20100818140422.GL27457@skl-net.de> <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca> <20100819130123.GU16603@skl-net.de> <ABE19F5B-74C8-47E9-B359-D3FB2C137087@dilger.ca> <20100820143943.GZ16603@skl-net.de> <20100823155259.GD16603@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39907 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab0KAWzI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Nov 2010 18:55:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1PD3HN-0005X9-Iv
	for linux-ext4@vger.kernel.org; Mon, 01 Nov 2010 23:55:06 +0100
Received: from 12-149-171-231.datarobotics.com ([98.129.239.68])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 01 Nov 2010 23:55:05 +0100
Received: from malaiyer by 12-149-171-231.datarobotics.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 01 Nov 2010 23:55:05 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andre Noll <maan <at> systemlinux.org> writes:

> 
> Here is a patch against the next branch that implements your idea. It
> compiles without (additional) warnings on Linux/i386 and Linux/x86_64
> even with "make gcc-wall", and checkpatch.pl is also happy with
> it. Moreover, it passes the test suite though this does probably not
> prove much because the icount tests insert less than 8192 inodes, so
> only one sub-array is created by these tests. I also ran the patched
> e2fsck against a 100M toy file system containing many directories
> and hard links and it seems to work fine.
> 
> Most importantly, this version no longer exits due to failing memory
> allocations while checking my problematic file system on the 32bit
> box. Instead memory and swap usage increase steadily as new icount
> sub-arrays are being allocated. Therefore I think the patch has real
> benefits and is worth considering for inclusion. Please review.
> 
> Note: Although the two-level tree approach avoids large reallocations,
> for insertions it is as inefficient as the old sorted list method
> because both the old and the new code move large amounts of memory
> around in insert_icount_el(). This could be avoided by replacing the
> sorted lists by a hash table, with open addressing and maybe double
> hashing to deal with collisions. But for this to work out we'd need an
> upper bound on the number of inodes to be inserted. So I like Ted's
> proposal to store some information in the superblock that allows to
> allocate a suitably sized structure up front.
> 
> Thanks
> Andre
> ---


Hi Andre

We are trying to use e2fsck on a embedded system with almost 3GB of swap and
200MB of physical memory. e2fsck on a 16TB ext3 filesystem always appears to
fail with the following error

Pass 1D: Reconciling multiply-claimed blocks
e2fsck: Memory allocation failed while retrying to read bitmaps for /dev/sda1

We have tried the patch you proposed, but still seeing the same failure.
How can we get e2fsck to work on our memory constrained system.

Thanks
Mala.

