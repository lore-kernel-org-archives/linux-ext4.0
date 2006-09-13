From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Wed, 13 Sep 2006 13:31:30 -0600
Message-ID: <20060913193130.GJ6441@schatzie.adilger.int>
References: <20060913164202.GA14838@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:43149 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1750934AbWIMTbi
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Sep 2006 15:31:38 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060913164202.GA14838@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 13, 2006  18:42 +0200, Alexandre Ratchov wrote:
> the change attribute is a simple counter that is reset to zero on
> inode creation and that is incremented every time the inode data is
> modified (similarly to the "ctime" time-stamp).

To start, I'm supportive of this concept, my comments are only to
get the most efficient implementation.

This appears to be very similar to the i_version field that is already
in the inode (which is also modified only by ext3), so instead of
increasing the size of the inode further we could use that field and
just make it persistent on disk.  The i_version field is incremented
in mkdir/rmdir/create/rename.  For Lustre it would also be desirable
to modify the version field for regular files when they are modified
(e.g. setattr, write), and it appears NFS v4 also wants the same
(assumed from use of file_update_time()).  The question is whether
this should be handled internal to the filesystem (as ext3 does now)
or if it should be part of the VFS.

> The patch also adds a new ``st_change_attribute'' field in the stat
> structure, and modifies the stat(2) syscall accordingly. Currently the
> change is only visible on i386 and x86_64 archs.

Is this really necessary for knfsd?

> @@ -511,6 +511,7 @@ static struct inode *bm_get_inode(struct
>  		inode->i_blocks = 0;
>  		inode->i_atime = inode->i_mtime = inode->i_ctime =
>  			current_fs_time(inode->i_sb);
> +		inode->i_change_attribute = 0;

Initializing to zero is more dangerous than any non-zero number,
since this is the most likely outcome of corruption...  The current
ext3 code initializes i_version to a random number, and we can use
comparisons similar to jiffies as long as we don't expect > 2^31
changes between comparisons.

> +++ fs/inode.c	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
> @@ -1232,16 +1232,10 @@ void file_update_time(struct file *file)
>  		return;
>  
>  	now = current_fs_time(inode->i_sb);
> -	if (!timespec_equal(&inode->i_mtime, &now))
> -		sync_it = 1;
>  	inode->i_mtime = now;
> -
> -	if (!timespec_equal(&inode->i_ctime, &now))
> -		sync_it = 1;
>  	inode->i_ctime = now;
> -
> -	if (sync_it)
> -		mark_inode_dirty_sync(inode);
> +	inode->i_change_attribute++;
> +	mark_inode_dirty_sync(inode);

Ugh, this would definitely hurt performance, because ext3_dirty_inode()
packs-for-disk the whole inode each time.  I believe Stephen had patches
at one time to do the inode packing at transaction commit time instead
of when it is changed, so we only do the packing once.  Having a generic
mechanism to do pre-commit callbacks from jbd (i.e. to pack a dirty
inode to the buffer) would also be useful for other things like doing
the inode or group descriptor checksum only once per transaction...

> Index: include/linux/ext3_fs.h
> ===================================================================
> RCS file: /home/ratchova/cvs/linux/include/linux/ext3_fs.h,v
> retrieving revision 1.1.1.3
> retrieving revision 1.1.1.3.2.1
> diff -u -p -r1.1.1.3 -r1.1.1.3.2.1
> --- include/linux/ext3_fs.h	13 Sep 2006 17:45:20 -0000	1.1.1.3
> +++ include/linux/ext3_fs.h	13 Sep 2006 18:15:43 -0000	1.1.1.3.2.1
> @@ -286,7 +286,7 @@ struct ext3_inode {
>  			__u16	i_pad1;
>  			__le16	l_i_uid_high;	/* these 2 fields    */
>  			__le16	l_i_gid_high;	/* were reserved2[0] */
> -			__u32	l_i_reserved2;
> +			__le32	l_i_change_attribute;

There was some other use of the reserved fields for ext4 64-bit-blocks
support.  One was for i_file_acl_hi (I think this is using the i_pad1
above), one was for i_blocks_hi (I believe this was proposed to use the
i_frag and i_fsize bytes).  Is this conflicting with anything else?
There were a lot of proposals for these fields, and I don't recall which
ones are still out there.

> @@ -280,6 +280,7 @@ typedef void (dio_iodone_t)(struct kiocb
> +#define ATTR_CHANGE_ATTRIBUTE  16384

Do you need a setattr interface for this, or is it sufficient to use
the i_version field from the inode, and let the filesystem manage
i_version updates as it is doing now?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

