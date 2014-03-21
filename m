From: Benjamin LaHaise <bcrl@kvack.org>
Subject: bdi has dirty inode after umount of ext4 fs in 3.4.83
Date: Fri, 21 Mar 2014 11:25:41 -0400
Message-ID: <20140321152541.GA23173@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:45104 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbaCUPZm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2014 11:25:42 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Al and folks,

After adding some debugging code in an application to check for dirty 
buffers on a bdi after umount, I'm seeing instances where b_dirty has 
exactly 1 dirty inode listed on a 3.4.83 kernel after umount() of a 
filesystem.  Roughly what the application does is to umount an ext3 
filesystem (using the ext4 codebase), perform an fsync() of the block 
device, then check the bdi stats in /sys/kernel/debug/252:4/stats (this 
is a dm partition on top of a dm multipath device for an FC LUN).  I've 
found that if I add a sync() call instead of the fsync(), the b_dirty 
count usually drops to 0, but not always.  I've added some debugging 
code to the bdi stats dump, and the inode on the b_dirty list shows up as:

	inode=ffff88081beaada0, i_ino=0, i_nlink=1 i_sb=ffff88083c03e400
	i_state=0x00000004 i_data.nrpages=4 i_count=3
	i_sb->s_dev=0x00000002

The fact that the inode number is 0 looks very odd.

Testing the application on top of a newer kernel is a bit of a challenge 
as other parts of the system have yet to be forward ported from the 3.4 
kernel, but I'll try to come up with a test case that shows the issue.  
In the meantime, is anyone aware of any umount()/sync related issues that 
might be affecting ext4 in 3.4.83?  Thanks in advance for any ideas on 
how to track this down.  Cheers,

		-ben
-- 
"Thought is the essence of where you are now."
