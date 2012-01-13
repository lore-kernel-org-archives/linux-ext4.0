From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: working on extent locks for i_mutex
Date: Thu, 12 Jan 2012 21:01:39 -0700
Message-ID: <4161CDFC-FEEB-4AAF-A0EA-B18F9FE8B7B1@dilger.ca>
References: <4F0F9E97.1090403@linux.vnet.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>,
	Zhen Liang <liang@whamcloud.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:64787 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2AMEBl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jan 2012 23:01:41 -0500
In-Reply-To: <4F0F9E97.1090403@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-12, at 8:01 PM, Allison Henderson wrote:
> I know this is an old topic, but I am poking it again because I've had some work items wrap up, and Im planning on picking up on this one again.  I am thinking about implementing extent locks to replace i_mutex.  So I just wanted to touch base with folks and see what people are working on because I know there were some folks out there that were thing about doing similar solutions.
> 
> A while ago I had done some investigation on where i_mutex is currently used, so I did a review and updated my list.  Only one thing had been removed, but I will leave the list here since it was a while ago.  Let me know if anyone has been working on similar concept.  Thx!

The in-ext4 users appear to all be file IO related, while the VFS functions
are mostly directory related, though I don't see any mention of the callers
of ext4_mkdir() or ext4_mknod() or ext4_create()?

For Lustre we developed a patch that allows parallel metadata operations on
directories (e.g. concurrent lookup, mkdir, rmdir, create, unlink in a single
directory) which would replace i_mutex for the namespace operations.  Patch:

http://git.whamcloud.com/?p=fs/lustre-release.git;a=blob;f=ldiskfs/kernel_patches/patches/ext4_pdirop-rhel6.patch;hb=HEAD

though this in itself isn't enough to allow the VFS to do parallel directory
operations.  We're of course also interested in parallel file IO operations
through the VFS for the client, though this hasn't been a focus of ours since
we typically have a large number of clients doing IO concurrently.

> List of ext4 functions that lock i_mutex:
> ext4_sync_file
> ext4_fallocate
> ext4_move_extents via two helper routines:
>    mext_inode_double_lock and mext_inode_double_unlock
> ext4_ioctl (for the EXT4_IOC_SETFLAGS ioctl)
> ext4_quota_write
> ext4_llseek
> ext4_end_io_work
> ext4_ind_direct_IO (only while calling ext4_flush_completed_IO)
> 
> 
> Functions called by vfs with i_mutex locked:
> ext4_setattr
> ext4_da_writepages
> ext4_rmdir
> ext4_unlink
> ext4_symlink
> ext4_link
> ext4_rename
> ext4_get_block
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





