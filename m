From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC 0/2] ext4: zero uninitialized inode tables
Date: Tue, 25 Nov 2008 01:35:33 -0700
Message-ID: <20081125083533.GS3186@webber.adilger.int>
References: <20081121102309.182113793@bull.net> <20081125053226.GE20928@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Solofo.Ramangalahy@bull.net, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64217 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYKYIfi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 03:35:38 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAP8Za2t014695
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 00:35:36 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAV00401RQZS100@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 25 Nov 2008 00:35:36 -0800 (PST)
In-reply-to: <20081125053226.GE20928@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 25, 2008  00:32 -0500, Theodore Ts'o wrote:
> I would recommend doing the first 32k of the inode table
> first, and once it completes, you can update inode_bg_unavaile so that
> an additional (32k / EXT4_INODE_SIZE(sb)) inodes are available.

I agree with everything Ted says, though I would zero the itable in
chunks of 64kB or even 128kB.  Two reasons are because 64kB is the
maximum blocksize for the filesystem, and it doesn't make sense to zero
less than a whole block at once.  Secondly, 64kB is more likely to
match with the internal track size of spinning disks, and 128kB is more
likely to match the erase block size of SSDs.

> In terms of how quickly the itable initializer should work, in between
> each block group, as we discussed on the call, the simplest thing for
> it do is to wait for some time period to go by (say, 5 seconds) before
> working on the next block group.  The next, slightly more complicated
> scheme would be to set a "last ext4 operation time" field in
> EXT4_SB(sb) which is set any time the ext4 code paths are entered

That would be "s_wtime" already in the on-disk superblock.  It wouldn't
kill us to update this occasionally in ext4, though not on disk all
the time.

> (basically, any function in ext4's inode operations, super operations
> or file operations).  The itable initalizer would sample that time,
> and before starting to initialize the next block group where
> BG_ITABLE_ZERO is not set, it would check the last ext4 operation time
> field, and if there had been an ext4 operation in the last 5 seconds,
> it would sleep 5 seconds and check again.

Well, I'd say if it has slept 5s then it should submit a block regardless
of whether the filesystem was in use or not.  Otherwise the itable may
never be zeroed out if the filesystem is always in use.  Adding a rare
64kB write to disk is unlikely to hurt anything, and if people REALLY care
about it they can avoid formatting with "lazy_itable_init".

> This would prevent the itable initializer from running if the filesystem
> is in use, although it will not detect the case where there is a lot
> of mmap'ed I/O going on, but no other ext4 operations.

Wouldn't even mmap operations cause some ext4 methods to be called?

> In the long run, we would really want some kind of I/O activity
> indication from the block device elevator, but that would require
> changes to the core kernel, and the last ext4 operation time is almost
> just as good.

Alternately we could check the journal tid?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

