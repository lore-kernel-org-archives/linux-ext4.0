From: Jan Kara <jack@suse.cz>
Subject: Re: question about jbd2 abnormal handle
Date: Thu, 16 Mar 2017 09:48:25 +0100
Message-ID: <20170316084825.GO12989@quack2.suse.cz>
References: <58CA0879.4050405@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.com
To: piaojun <piaojun@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751204AbdCPIse (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 16 Mar 2017 04:48:34 -0400
Content-Disposition: inline
In-Reply-To: <58CA0879.4050405@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Thu 16-03-17 11:37:29, piaojun wrote:
> I found a problem that 'ls /mnt/ocfs2/' failed, error log as below:
> 
> # ls: /mnt/ocfs2: Input/output error
> 
> kernel log as below:
> Mar 16 10:27:45 linux-yxqzUv kernel: [169213.398778] (ls,19875,0):ocfs2_read_blocks:388 ERROR: E9854523FF8343F9AF043F1A5505B1E1: iblock(17), bh->state(0x44828)
> Mar 16 10:27:45 linux-yxqzUv kernel: [169213.398787] (ls,19875,0):ocfs2_assign_bh:776 ERROR: status = -5
> Mar 16 10:27:45 linux-yxqzUv kernel: [169213.398795] (ls,19875,0):ocfs2_dlm_inode_lock_full_nested:1937 ERROR: status = -5
> Mar 16 10:27:45 linux-yxqzUv kernel: [169213.398799] (ls,19875,0):ocfs2_xattr_get:1334 ERROR: status = -5
> Mar 16 10:27:45 linux-yxqzUv kernel: [169213.402691] (ls,19875,0):ocfs2_read_blocks:388 ERROR: E9854523FF8343F9AF043F1A5505B1E1: iblock(17), bh->state(0x44828)
> Mar 16 10:27:45 linux-yxqzUv kernel: [169213.402704] (ls,19875,0):ocfs2_dir_foreach_blk_id:1789 ERROR: E9854523FF8343F9AF043F1A5505B1E1: Unable to read inode block for dir 17
> 
> Test Environment:
> OS: suse11 sp3
> kernel: 3.0.93-0.8.2
> filesystem: ocfs2

So this is very old kernel (from upstream point of view) so people
generally don't care. Furthermore it is heavily patched kernel of an
enterprise distribution which is another reason why upstream people don't
care. So handle such issues through standard channels for reporting
problems with SLES please - SUSE Customer Care -> bugzilla.suse.com ...

> test step:
> 1. mount device to /mnt/ocfs2/
> 2. cut down the storage link of device
> 3. mkdir /mnt/ocfs2/123
> 4. recover the storage link of device
> 5. ls /mnt/ocfs2/123, then failed
> 
> The 'bh' is submitted to jbd2 after 'mkdir', and then the write-back
> thread of device submit the 'bh' to disk and failed due to bad storage
> link. At last 'bh' state is marked as BH_Write_EIO. the jbd2 won't
> release 'bh' in this case. so when ocfs2_read_blocks() is called, found
> 'bh' still in jbd2 but marked as BH_Write_EIO and return fail.
> 
> I wonder if jbd2 should handle this problem or ocfs2 filesystem should
> do it?

Once the IO error propagates to the filesystem, you have bad luck and
generally it is not expected you will be able to recover from that
situation. You can deal with link flaps by properly configuring multipath
or whatever but let's deal with that in bugzilla...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
