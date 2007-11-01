From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: + forbid-user-to-change-file-flags-on-quota-files.patch added
	to -mm tree
Date: Thu, 01 Nov 2007 15:02:25 -0500
Message-ID: <1193947345.9503.9.camel@norville.austin.ibm.com>
References: <200711011755.lA1HtQJ4008301@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: mm-commits@vger.kernel.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, lioupayphone@gmail.com,
	reiserfs-dev@namesys.com
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37519 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744AbXKAUCc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Nov 2007 16:02:32 -0400
In-Reply-To: <200711011755.lA1HtQJ4008301@imap1.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-11-01 at 10:55 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      Forbid user to change file flags on quota files
> has been added to the -mm tree.  Its filename is
>      forbid-user-to-change-file-flags-on-quota-files.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: Forbid user to change file flags on quota files
> From: Jan Kara <jack@suse.cz>
> 
> Forbid user from changing file flags on quota files.  User has no bussiness
> in playing with these flags when quota is on.  Furthermore there is a
> remote possibility of deadlock due to a lock inversion between quota file's
> i_mutex and transaction's start (i_mutex for quota file is locked only when
> trasaction is started in quota operations) in ext3 and ext4.

This looks reasonable.

> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> Cc: LIOU Payphone <lioupayphone@gmail.com>
> Cc: <linux-ext4@vger.kernel.org>

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> Cc: <reiserfs-dev@namesys.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ext2/ioctl.c     |    5 +++++
>  fs/ext3/ioctl.c     |    5 +++++
>  fs/ext4/ioctl.c     |    5 +++++
>  fs/jfs/ioctl.c      |    3 +++
>  fs/reiserfs/ioctl.c |    3 +++
>  5 files changed, 21 insertions(+)
> 
> diff -puN fs/ext2/ioctl.c~forbid-user-to-change-file-flags-on-quota-files fs/ext2/ioctl.c
> --- a/fs/ext2/ioctl.c~forbid-user-to-change-file-flags-on-quota-files
> +++ a/fs/ext2/ioctl.c
> @@ -47,6 +47,11 @@ int ext2_ioctl (struct inode * inode, st
>  			flags &= ~EXT2_DIRSYNC_FL;
>  
>  		mutex_lock(&inode->i_mutex);
> +		/* Is it quota file? Don't allow user mess with it */
> +		if (IS_NOQUOTA(inode)) {
> +			mutex_unlock(&inode->i_mutex);
> +			return -EPERM;
> +		}
>  		oldflags = ei->i_flags;
>  
>  		/*
> diff -puN fs/ext3/ioctl.c~forbid-user-to-change-file-flags-on-quota-files fs/ext3/ioctl.c
> --- a/fs/ext3/ioctl.c~forbid-user-to-change-file-flags-on-quota-files
> +++ a/fs/ext3/ioctl.c
> @@ -51,6 +51,11 @@ int ext3_ioctl (struct inode * inode, st
>  			flags &= ~EXT3_DIRSYNC_FL;
>  
>  		mutex_lock(&inode->i_mutex);
> +		/* Is it quota file? Don't allow user mess with it */
> +		if (IS_NOQUOTA(inode)) {
> +			mutex_unlock(&inode->i_mutex);
> +			return -EPERM;
> +		}
>  		oldflags = ei->i_flags;
>  
>  		/* The JOURNAL_DATA flag is modifiable only by root */
> diff -puN fs/ext4/ioctl.c~forbid-user-to-change-file-flags-on-quota-files fs/ext4/ioctl.c
> --- a/fs/ext4/ioctl.c~forbid-user-to-change-file-flags-on-quota-files
> +++ a/fs/ext4/ioctl.c
> @@ -51,6 +51,11 @@ int ext4_ioctl (struct inode * inode, st
>  			flags &= ~EXT4_DIRSYNC_FL;
>  
>  		mutex_lock(&inode->i_mutex);
> +		/* Is it quota file? Don't allow user mess with it */
> +		if (IS_NOQUOTA(inode)) {
> +			mutex_unlock(&inode->i_mutex);
> +			return -EPERM;
> +		}
>  		oldflags = ei->i_flags;
>  
>  		/* The JOURNAL_DATA flag is modifiable only by root */
> diff -puN fs/jfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files fs/jfs/ioctl.c
> --- a/fs/jfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files
> +++ a/fs/jfs/ioctl.c
> @@ -79,6 +79,9 @@ int jfs_ioctl(struct inode * inode, stru
>  		if (!S_ISDIR(inode->i_mode))
>  			flags &= ~JFS_DIRSYNC_FL;
>  
> +		/* Is it quota file? Don't allow user mess with it */
> +		if (IS_NOQUOTA(inode))
> +			return -EPERM;
>  		jfs_get_inode_flags(jfs_inode);
>  		oldflags = jfs_inode->mode2;
>  
> diff -puN fs/reiserfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files fs/reiserfs/ioctl.c
> --- a/fs/reiserfs/ioctl.c~forbid-user-to-change-file-flags-on-quota-files
> +++ a/fs/reiserfs/ioctl.c
> @@ -57,6 +57,9 @@ int reiserfs_ioctl(struct inode *inode, 
>  			if (get_user(flags, (int __user *)arg))
>  				return -EFAULT;
>  
> +			/* Is it quota file? Don't allow user mess with it. */
> +			if (IS_NOQUOTA(inode))
> +				return -EPERM;
>  			if (((flags ^ REISERFS_I(inode)->
>  			      i_attrs) & (REISERFS_IMMUTABLE_FL |
>  					  REISERFS_APPEND_FL))
> _

> 
-- 
David Kleikamp
IBM Linux Technology Center
