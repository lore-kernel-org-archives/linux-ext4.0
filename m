From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 4][PATCH 4/5] i_version:ext4 inode version update
Date: Tue, 10 Jul 2007 16:31:33 -0700
Message-ID: <20070710163133.030ddba7.akpm@linux-foundation.org>
References: <1183275465.4010.130.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41669 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762899AbXGJXbo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 19:31:44 -0400
In-Reply-To: <1183275465.4010.130.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 01 Jul 2007 03:37:45 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> This patch is on top of i_version_update_vfs.
> The i_version field of the inode is set on inode creation and incremented when
> the inode is being modified.
> 

Again, I don't think I've ever seen this patch before.  It is at least a
month old.

> 
> Index: linux-2.6.22-rc4/fs/ext4/ialloc.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/ialloc.c	2007-06-13 17:16:28.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/ialloc.c	2007-06-13 17:24:45.000000000 -0700
> @@ -565,6 +565,7 @@ got:
>  	inode->i_blocks = 0;
>  	inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
>  						       ext4_current_time(inode);
> +	inode->i_version = 1;
>  
>  	memset(ei->i_data, 0, sizeof(ei->i_data));
>  	ei->i_dir_start_lookup = 0;
> Index: linux-2.6.22-rc4/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/inode.c	2007-06-13 17:21:29.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/inode.c	2007-06-13 17:24:45.000000000 -0700
> @@ -3082,6 +3082,7 @@ int ext4_mark_iloc_dirty(handle_t *handl
>  {
>  	int err = 0;
>  
> +	inode->i_version++;
>  	/* the do_update_inode consumes one bh->b_count */
>  	get_bh(iloc->bh);
>  
> Index: linux-2.6.22-rc4/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-13 17:19:11.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-13 17:24:45.000000000 -0700
> @@ -2846,8 +2846,8 @@ out:
>  		i_size_write(inode, off+len-towrite);
>  		EXT4_I(inode)->i_disksize = inode->i_size;
>  	}
> -	inode->i_version++;
>  	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	inode->i_version = 1;
>  	ext4_mark_inode_dirty(handle, inode);
>  	mutex_unlock(&inode->i_mutex);
>  	return len - towrite;

ext4 already has code to update i_version on directories.  Here we appear
to be udpating it on regular files?

But for what reason?  The changelog doesn't say?

AFAICT the code forgets to update i_version during file overwrites (unless
the overwrite was over a hole).  But without a decent description of this
change I cannot tell whether this was a bug.
