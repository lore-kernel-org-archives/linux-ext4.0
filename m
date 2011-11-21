From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RFC][PATCH 0/8] xfstests: rework large filesystem testing
Date: Mon, 21 Nov 2011 07:10:45 -0500
Message-ID: <CF9FF112-852A-473B-99E4-3A5B790AE147@mit.edu>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:60725 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251Ab1KUMKr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Nov 2011 07:10:47 -0500
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Nov 21, 2011, at 6:31 AM, Dave Chinner wrote:

> ext4, however, still has serious issues with this - either we take
> the mkfs.ext4 time hit to initialise all the block groups, or we
> take it during the preallocation.  IOWs, the "don't do work at mkfs
> but do it after mount" hack^Wtradeoff simply does not work for
> testing large filesystems in this manner.  While it is possible to
> run large filesystem tests on ext4 using this mechanism, it is
> extremely painful to do so.

For testing, we can disable the "do it after the mount " aspect
of  ext4 by using the mount option "noinit_itable".   We basically
only need to zero the inode table to make sure e2fsck doesn't
confuse old inode tables as new ones in the event that the block
group descriptors get compromised and we can't trust them to
determine the high watermark of inodes used per block group,
something which is only a concern in the case of kernel bugs
or hardware failures (or power failures in no journal mode).
(We could also compare the inode crime with the fs mkfs time
in the superblock, but ext4 gets used on desktops and
on things like android tablets where I've learned through
bitter experience that we can't trust the system clock to be
correct.) 

In any case it's safe to turn of the inode table initialization for
testing purposes.   In the long term, once we get checksums
into  the inode table block, we won't need to zero out the inode
tables at all.

As far as xfstests are concerned, if there's a convenient way
to add mount options automatically (on a per file system 
basis) when --large-fs is specified, we should be able to 
make this work for ext4 file systems.

Regards,

-- Ted

