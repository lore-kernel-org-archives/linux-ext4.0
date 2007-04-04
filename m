From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: Re: (un)lock_kernel() ?
Date: Wed, 4 Apr 2007 12:52:07 -0400 (EDT)
Message-ID: <alpine.DEB.0.83.0704041244560.4770@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704040853450.28216@sigma.j-a-k-j.com>
 <1175701002.6489.4.camel@shaggy>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from seahorse.shentel.net ([204.111.1.244]:35445 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXDDQwS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Apr 2007 12:52:18 -0400
In-Reply-To: <1175701002.6489.4.camel@shaggy>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> According to Documentation/filesystems/Locking, ->get_sb() is called
> with the BKL held, but looking through the code, I'm not able to find
> where it is being taken.

I noticed that too. Unless I'm just dumb and can't see it, I'm not able to 
find any BKL references during filesystem mounting until you get into 
FS-specific code. I looked through everything from sys_mount through to 
vfs_kern_mount. Documentation/filesystems/porting talks about several 
situations where the VFS code was modified to not take the BKL, and BLK 
calls were added by FS non-maintainers for safety until each FS could be 
audited independently, but that wouldn't be the case, would it?

The ext2 code takes the BKL in three places: ext2_update_inode, 
write_super, and ext2_compat_ioctl. Starting with ext3, it's in 
ext3_compat_ioctl and ext3_fill_super, and the same with ext4.

I suppose the BKL does have to be held, somehow, somewhere, during 
mounting, or anybody using ext3 on a multiprocessor box would lock their 
system from unmatched locking calls. Unless the first unlock_kernel() 
would make the count -1 and the lock would bring it back to zero?
