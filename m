From: Jan Kara <jack@suse.cz>
Subject: Re: bdi has dirty inode after umount of ext4 fs in 3.4.83
Date: Sun, 23 Mar 2014 14:14:16 +0100
Message-ID: <20140323131416.GD2813@quack.suse.cz>
References: <20140321152541.GA23173@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaCWOJg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Mar 2014 10:09:36 -0400
Content-Disposition: inline
In-Reply-To: <20140321152541.GA23173@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 21-03-14 11:25:41, Benjamin LaHaise wrote:
  Hello,

> After adding some debugging code in an application to check for dirty 
> buffers on a bdi after umount, I'm seeing instances where b_dirty has 
> exactly 1 dirty inode listed on a 3.4.83 kernel after umount() of a 
> filesystem.  Roughly what the application does is to umount an ext3 
> filesystem (using the ext4 codebase), perform an fsync() of the block 
> device, then check the bdi stats in /sys/kernel/debug/252:4/stats (this 
> is a dm partition on top of a dm multipath device for an FC LUN).  I've 
> found that if I add a sync() call instead of the fsync(), the b_dirty 
> count usually drops to 0, but not always.  I've added some debugging 
> code to the bdi stats dump, and the inode on the b_dirty list shows up as:
> 
> 	inode=ffff88081beaada0, i_ino=0, i_nlink=1 i_sb=ffff88083c03e400
> 	i_state=0x00000004 i_data.nrpages=4 i_count=3
> 	i_sb->s_dev=0x00000002
> 
> The fact that the inode number is 0 looks very odd.
  So the dirty inode is almost certainly a block device inode. Another clue
is that fsync(2) actually doesn't clean inode dirty state (especially not
for block device inodes since that inode is a special one and fs usually
doesn't get to inspecting it). sync(2) does in general clear inode dirty
state because that's handled by flusher thread. However if ->sync_fs()
dirties the block device inode, subsequent sync_blockdev() call only writes
the data but doesn't clean the inode state. So even with sync(2) it can
happen the block device inode remains dirty.

In general inode dirty state isn't reliable. I_DIRTY_DATA can be set when
inode is in fact clean. You have to use mapping_tagged(inode->i_mapping,
PAGECACHE_TAG_DIRTY) to determine whether the inode has actually any dirty
data.

> Testing the application on top of a newer kernel is a bit of a challenge 
> as other parts of the system have yet to be forward ported from the 3.4 
> kernel, but I'll try to come up with a test case that shows the issue.  
> In the meantime, is anyone aware of any umount()/sync related issues that 
> might be affecting ext4 in 3.4.83?  Thanks in advance for any ideas on 
> how to track this down.  Cheers,
  Newer kernels don't bring anything substantially new to the picture...

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
