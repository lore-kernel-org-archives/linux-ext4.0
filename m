From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4-fs error - ext4_mb_generate_buddy
Date: Thu, 10 Sep 2009 15:19:35 -0400
Message-ID: <20090910191935.GD23700@mit.edu>
References: <72dbd3150909101156qa2c4e3dnfef02d509f63330f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Rees <drees76@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42570 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbZIJTTj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Sep 2009 15:19:39 -0400
Content-Disposition: inline
In-Reply-To: <72dbd3150909101156qa2c4e3dnfef02d509f63330f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 10, 2009 at 11:56:42AM -0700, David Rees wrote:
> Running ext4 on Fedora 10, kernel 2.6.29.6-93.fc10.x86_64.  Partition
> in question is an 8 disk software RAID10 with mostly SATA disks and
> one IDE disk.  We've never seen any hardware or filesystem corruption
> issues on this machine in the past, though the RAID10 setup is new -
> was put into service the same time we migrated the partition from ext3
> to ext4 (fresh filesystem created and data copied over).
> 
> Earlier today, we saw this message in the logs:
> 
> EXT4-fs error (device md0): ext4_mb_generate_buddy: EXT4-fs: group
> 586: 19635 blocks in bitmap, 19636 in gd
> 
> It looks rather ominous and we will be scheduling a reboot to force a
> fsck as well as to upgrade to kernel-2.6.29.6-99.fc10.x86_64 (which
> doesn't appear to have any ext4 related changes in it).  Looking in
> the archives, I'm not quite sure what to make of the message, but it
> does seem to indicate that we may have filesystem corruption.  Any
> suggestions?

We need to fix up this message so it's more understandable.  What this
means is that when the ext4 block allocator loaded block group #586
block allocation bitmap, it found that there were 19,635 free blocks
in the block group, but the block group descriptors had on record that
there were 19,636 free blocks.  If this is the only file system
corruption, it's harmless.  For example, it could be caused by a bit
flip such that block that is not in use was actually marked as being
in use, which is the harmless direction --- a bit flip in the opposite
direction, where an in-use block is marked as free could cause data
corruption.

Ext4 has more sanity checks to catch file system corruptions, compared
to ext3, and this is one such example.  So this doesn't necessarily
mean that ext4 is less reliable, assuming that the cause of the file
system corruption was caused by cosmic rays, or some kind of hardware
hiccup.  Of course, it is possible that it might be caused by some
kind of software bug, too.  If you can reliably reproduce it, and
there are no indications of hardware problems (no errors in the system
log, nothing reported by smartctl), we definitely want to know about
it.  I can say that it seems to be relatively rare and it's not
something that's shown up in any of my QA testing.  On the other hand,
I personally don't not to run my tests on big RAID arrays, since I
don't have access to such fun toys, and sometimes race conditions will
only show up on that kind of hardware.  Other ext4 developers, such as
Eric Sandeen at Red Hat, and some testers at IBM, do have access to
such big storage hardware, and they are running QA tests as well; as
far as I know they haven't see any evidence of this kind of failure.

If you can characterize the application workload running on your
system if you can get this to fail repeatedly, that would be most
useful.

Thanks, regards,

						- Ted
