From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Plan for reducing i_mutex in ext4
Date: Tue, 4 Oct 2011 10:38:29 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110041024470.7833@dhcp-27-109.brq.redhat.com>
References: <4E8A0630.7060605@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Ted Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab1JDIin (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 04:38:43 -0400
In-Reply-To: <4E8A0630.7060605@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 3 Oct 2011, Allison Henderson wrote:

> Hi all,
> 
> I've been working on locating all the existing uses of i_mutex in the current
> ext4 code because I know we are planning to reduce the usage of i_mutex in
> ext4.  So I've gone through the ext4 code and also the vfs code and come up
> with a list of ext4 items that appear to be protected under i_mutex.  I'm
> thinking about doing a patch to replace i_mutex with a private ext4 mutex, and
> I wanted to update folks on this idea and pick up any feed back people might
> have.
> 
> I'm thinking maybe we can have a separate mutex for functions that only modify
> meta data like ext4_ioctl and ext4_setattr to help relieve unneeded
> contention.  And then the rest of functions that are modifying data can go
> under a data mutex (including truncate since sometimes ext4_ioctl and
> ext4_setattr will call ext4_truncate if they modify i_size).

Just the other day I was talking with Christoph (adding him to cc) about
this, but unfortunately I still did not have time to look at this, but I
am glad that someone did.

His suggestion was a bit more general than creating separate ext4
specific mutex. His idea was to change i_mutex to union of plain mutex
for directories and a rwlock for regular files. Then this union can be
used in other file systems as well, for example to replace xfs_iolock in
xfs.

Also it might be nice to do something smarter than just a rwlock for
regular files. It would be nice to have an structure of extent locks, so
we can use it for file system using extents, which will improve
scalability while hammering a single file from different processes.

Note that currently ext4 concurrent read/write are atomic only wrt
individual pages, but not on the system call as the whole. This might
cause read() to return data mixed from several different writes, which
is not posix conform. That could be solved with the generic rwlock for
files, or even better with the system of extent locking.

But Christoph, can probably describe hi idea a bit better.

Thanks!
-Lukas

> 
> So these are ext4 functions that currently lock i_mutex:
> 
> ext4_sync_file
> ext4_fallocate
> ext4_move_extents via two helper routines:
> 	mext_inode_double_lock and mext_inode_double_unlock
> ext4_ioctl (for the EXT4_IOC_SETFLAGS ioctl)
> ext4_quota_write
> ext4_llseek
> ext4_end_io_work
> ext4_evict_inode (only while calling ext4_flush_completed_IO)
> ext4_ind_direct_IO (only while calling ext4_flush_completed_IO)
> 
> 
> And these are ext4 functions that have i_mutex locked by the vfs layer.  So we
> will need to lock the new private mutex here too if we want them to be
> synchronous with the above functions.
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
> ext4_fiemap calls generic_block_fiemap and passes it a function pointer to
> ext4_get_block.  generic_block_fiemap will lock i_mutex before calling the
> pointer.  I dont think ext4_get_block needs i_mutex locked all the time, so I
> think we can just make a wrapper for ext4_get_block that locks the new private
> mutex and then we can pass a pointer to the wrapper.
> 
> 
> That's my list so far, if anyone knows of one I missed please let me know, and
> also if you spot any other places where we can reduce unneeded contention by
> using a separate lock.  Thx!
> 
> Allison Henderson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
