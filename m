From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Plan for reducing i_mutex in ext4
Date: Tue, 04 Oct 2011 12:57:54 +0400
Message-ID: <87ehyt3zhp.fsf@dmbot.sw.ru>
References: <4E8A0630.7060605@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>
To: Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61154 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab1JDIyD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Oct 2011 04:54:03 -0400
Received: by bkbzt4 with SMTP id zt4so426343bkb.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Oct 2011 01:54:01 -0700 (PDT)
In-Reply-To: <4E8A0630.7060605@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 03 Oct 2011 12:00:00 -0700, Allison Henderson <achender@linux.vnet.ibm.com> wrote:
> Hi all,
> 
> I've been working on locating all the existing uses of i_mutex in the 
> current ext4 code because I know we are planning to reduce the usage of 
> i_mutex in ext4.  So I've gone through the ext4 code and also the vfs 
> code and come up with a list of ext4 items that appear to be protected 
> under i_mutex.  I'm thinking about doing a patch to replace i_mutex with 
> a private ext4 mutex, and I wanted to update folks on this idea and pick 
> up any feed back people might have.
> 
> I'm thinking maybe we can have a separate mutex for functions that only 
> modify meta data like ext4_ioctl and ext4_setattr to help relieve 
> unneeded contention.
Are you going to change vfs core locking?
>  And then the rest of functions that are modifying 
> data can go under a data mutex (including truncate since sometimes 
> ext4_ioctl and ext4_setattr will call ext4_truncate if they modify i_size).
> 
> So these are ext4 functions that currently lock i_mutex:
> 
> ext4_sync_file
> ext4_fallocate
> ext4_move_extents via two helper routines:
> 	mext_inode_double_lock and mext_inode_double_unlock
> ext4_ioctl (for the EXT4_IOC_SETFLAGS ioctl)
> ext4_quota_write 
We can easily avoid i_mutex on quota write because quota file can not
be truncated, and grows only in case of new dquot added.
I'll send you a patch.
> ext4_llseek
> ext4_end_io_work
> ext4_evict_inode (only while calling ext4_flush_completed_IO)
> ext4_ind_direct_IO (only while calling ext4_flush_completed_IO)
> 
> 
> And these are ext4 functions that have i_mutex locked by the vfs layer. 
>   So we will need to lock the new private mutex here too if we want them 
> to be synchronous with the above functions.
> 
> ext4_setattr
> ext4_da_writepages
> ext4_rmdir
> ext4_unlink
> ext4_symlink
> ext4_link
> ext4_rename
> 
> And one unique case:
> ext4_fiemap calls generic_block_fiemap and passes it a function pointer 
> to ext4_get_block.  generic_block_fiemap will lock i_mutex before 
> calling the pointer.  I dont think ext4_get_block needs i_mutex locked 
> all the time, so I think we can just make a wrapper for ext4_get_block 
> that locks the new private mutex and then we can pass a pointer to the 
> wrapper.
> 
> 
> That's my list so far, if anyone knows of one I missed please let me 
> know, and also if you spot any other places where we can reduce unneeded 
> contention by using a separate lock.  Thx!
> 
> Allison Henderson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
