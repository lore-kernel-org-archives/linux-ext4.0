From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [patch 2/2] i_version update - ext4 part
Date: Tue, 29 May 2007 12:44:13 -0700
Message-ID: <1180467854.4204.15.camel@localhost.localdomain>
References: <46570E16.5040006@bull.net>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org,
	linux-fsdevel@vger.kernel.org
To: jean-noel.cordenner@bull.net
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <46570E16.5040006@bull.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-05-25 at 18:25 +0200, Jean noel Cordenner wrote:
> The patch is on top of the ext4 tree:
> http://repo.or.cz/w/ext4-patch-queue.git
> 
> In this part, the i_version counter is stored into 2 32bit fields of
> the ext4_inode structure osd1.linux1.l_i_version and i_version_hi.
> 
> I included the ext4_expand_inode_extra_isize patch, which does part of 
> the job, checking if there is enough room for extra fields in the inode 
> (i_version_hi). The other patch increments the counter on inode 
> modifications and set it on inode creation.
> plain text document attachment (i_version_update_ext4)
> This patch is on top of i_version_update_vfs.
> The i_version field of the inode is set on inode creation and incremented when
> the inode is being modified.
> 

I am a little bit confused about the two patches. 

It appears in the ext4_expand_inode_extra_isize patch by Kalpak, there a
new 64 bit i_fs_version field is added to ext4 inode structure for inode
versioning support. read/store of this counter are properly handled, but
missing the inode versioning counter update.

But later in the second patch by Jean Noel, he re-used the VFS inode-
>i_version for ext4 inode versioning, the counter is being updated every
time the file is being changed. 

To me, i_fs_version and inode_version are the same thing, right?
Shouldn't we choose one(I assume inode i_version?), and combine these
two patch together? How about split the inode versioning part from the
ext4_expand_inode_extra_isize patch(it does multiple things, and
i_versioning doesn't longs there) and put it together with the rest of
i_version update patches?


BTW, how could NFS/user space to access the inode version counter?

Thanks,
Mingming


> Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
> 
> Index: linux-2.6.22-rc2-ext4-1/fs/ext4/ialloc.c
> ===================================================================
> --- linux-2.6.22-rc2-ext4-1.orig/fs/ext4/ialloc.c	2007-05-25 18:05:28.000000000 +0200
> +++ linux-2.6.22-rc2-ext4-1/fs/ext4/ialloc.c	2007-05-25 18:05:40.000000000 +0200
> @@ -565,6 +565,7 @@
>  	inode->i_blocks = 0;
>  	inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
>  						       ext4_current_time(inode);
> +	inode->i_version = 1;
> 
>  	memset(ei->i_data, 0, sizeof(ei->i_data));
>  	ei->i_dir_start_lookup = 0;
> Index: linux-2.6.22-rc2-ext4-1/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.22-rc2-ext4-1.orig/fs/ext4/inode.c	2007-05-25 18:05:28.000000000 +0200
> +++ linux-2.6.22-rc2-ext4-1/fs/ext4/inode.c	2007-05-25 18:05:40.000000000 +0200
> @@ -3082,6 +3082,7 @@
>  {
>  	int err = 0;
> 
> +	inode->i_version++;
>  	/* the do_update_inode consumes one bh->b_count */
>  	get_bh(iloc->bh);
> 
> Index: linux-2.6.22-rc2-ext4-1/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.22-rc2-ext4-1.orig/fs/ext4/super.c	2007-05-25 18:05:28.000000000 +0200
> +++ linux-2.6.22-rc2-ext4-1/fs/ext4/super.c	2007-05-25 18:05:40.000000000 +0200
> @@ -2839,8 +2839,8 @@
>  		i_size_write(inode, off+len-towrite);
>  		EXT4_I(inode)->i_disksize = inode->i_size;
>  	}
> -	inode->i_version++;
>  	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	inode->i_version = 1;
>  	ext4_mark_inode_dirty(handle, inode);
>  	mutex_unlock(&inode->i_mutex);
>  	return len - towrite;

