From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: ignore EXT4_INODE_JOURNAL_DATA flag with delalloc
Date: Wed, 11 Jan 2012 02:20:54 -0700
Message-ID: <A9D735A4-4DC8-4599-96BD-77E3AA9E1133@dilger.ca>
References: <1326266607-15211-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:42653 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab2AKJU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jan 2012 04:20:56 -0500
In-Reply-To: <1326266607-15211-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-11, at 12:23 AM, Lukas Czerner wrote:
> Ext4 does not support data journalling with delayed allocation enabled.
> We even do not allow to mount the file system with delayed allocation
> and data journalling enabled, however it can be set via FS_IOC_SETFLAGS
> so we can hit the inode with EXT4_INODE_JOURNAL_DATA set even on file
> system mounted with delayed allocation (default) and that's where
> problem arises.

The question is whether it is better to ignore the JOURNAL_DATA flag on
the inode, or to ignore delayed allocation on the file in that case and
honour the JOURNAL_DATA flag?  Since JOURNAL_DATA set on an individual
file is an uncommon case (i.e. had to be set by the admin) it probably
makes more sense to ignore the default delalloc option and instead use
the JOURNAL_DATA flag as specified.

> The easies way to reproduce this problem is with the
> following set of commands:
> 
> mkfs.ext4 /dev/sdd
> mount /dev/sdd /mnt/test1
> dd if=/dev/zero of=/mnt/test1/file bs=1M count=4
> chattr +j /mnt/test1/file
> dd if=/dev/zero of=/mnt/test1/file bs=1M count=4 conv=notrunc
> chattr -j /mnt/test1/file
> 
> Additionally it can be reproduced quite reliably with xfstests 272 and
> 269. In fact the above reproducer is a part of test 272.
> 
> To fix this we should ignore the EXT4_INODE_JOURNAL_DATA inode flag if
> the file system is mounted with delayed allocation. This can be easily
> done by fixing ext4_should_*_data() functions do ignore data journal
> flag when delalloc is set (suggested by Ted). We also have to set the
> appropriate address space operations for the inode (again, ignoring data
> journal flag if delalloc enabled).
> 
> Additionally this commit introduces ext4_inode_journal_mode() function
> because ext4_should_*_data() has already had a lot of common code and
> this change is putting it all into one function so it is easier to
> read.
> 
> Successfully tested with xfstest in following configurations:
> 
> delalloc + data=ordered
> delalloc + data=writeback
> data=journal
> nodelalloc + data=ordered
> nodelalloc + data=writeback
> nodelalloc + data=journal
> 
> (I wish we can get rid of the data=journal mode)
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> fs/ext4/ext4_jbd2.h |   55 ++++++++++++++++++++++++++-------------------------
> fs/ext4/inode.c     |   36 ++++++++++++++++++++-------------
> 2 files changed, 50 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
> index 5802fa1..8a1982a 100644
> --- a/fs/ext4/ext4_jbd2.h
> +++ b/fs/ext4/ext4_jbd2.h
> @@ -261,43 +261,44 @@ static inline void ext4_update_inode_fsync_trans(handle_t *handle,
> /* super.c */
> int ext4_force_commit(struct super_block *sb);
> 
> -static inline int ext4_should_journal_data(struct inode *inode)
> +/*
> + * Ext4 inode journal modes
> + */
> +#define EXT4_INODE_JOURNAL_DATA_MODE	0x01 /* journal data mode */
> +#define EXT4_INODE_ORDER_DATA_MODE	0x02 /* ordered data mode */
> +#define EXT4_INODE_WRITEBACK_DATA_MODE	0x04 /* writeback data mode */
> +
> +static inline int ext4_inode_journal_mode(struct inode *inode)
> {
> 	if (EXT4_JOURNAL(inode) == NULL)
> -		return 0;
> -	if (!S_ISREG(inode->i_mode))
> -		return 1;
> -	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
> -		return 1;
> -	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
> -		return 1;
> -	return 0;
> +		return EXT4_INODE_WRITEBACK_DATA_MODE;	/* writeback */
> +	/* We do not support data journalling with delayed allocation */
> +	if ((!S_ISREG(inode->i_mode)) ||
> +	   (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) ||
> +	   (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA) &&
> +	   (!test_opt(inode->i_sb, DELALLOC))))
> +		return EXT4_INODE_JOURNAL_DATA_MODE;	/* journal data */
> +	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
> +		return EXT4_INODE_ORDER_DATA_MODE;		/* ordered */
> +	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
> +		return EXT4_INODE_WRITEBACK_DATA_MODE;	/* writeback */
> +	else
> +		BUG();
> +}
> +
> +static inline int ext4_should_journal_data(struct inode *inode)
> +{
> +	return ext4_inode_journal_mode(inode) & EXT4_INODE_JOURNAL_DATA_MODE;
> }
> 
> static inline int ext4_should_order_data(struct inode *inode)
> {
> -	if (EXT4_JOURNAL(inode) == NULL)
> -		return 0;
> -	if (!S_ISREG(inode->i_mode))
> -		return 0;
> -	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
> -		return 0;
> -	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
> -		return 1;
> -	return 0;
> +	return ext4_inode_journal_mode(inode) & EXT4_INODE_ORDER_DATA_MODE;
> }
> 
> static inline int ext4_should_writeback_data(struct inode *inode)
> {
> -	if (EXT4_JOURNAL(inode) == NULL)
> -		return 1;
> -	if (!S_ISREG(inode->i_mode))
> -		return 0;
> -	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
> -		return 0;
> -	if (test_opt(inode->i_sb, DATA_FLAGS) == EXT4_MOUNT_WRITEBACK_DATA)
> -		return 1;
> -	return 0;
> +	return ext4_inode_journal_mode(inode) & EXT4_INODE_WRITEBACK_DATA_MODE;
> }
> 
> /*
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index aa8efa6..3b07d22 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2479,13 +2479,14 @@ static int ext4_da_write_end(struct file *file,
> 	int write_mode = (int)(unsigned long)fsdata;
> 
> 	if (write_mode == FALL_BACK_TO_NONDELALLOC) {
> -		if (ext4_should_order_data(inode)) {
> +		switch (ext4_inode_journal_mode(inode)) {
> +		case EXT4_INODE_ORDER_DATA_MODE:
> 			return ext4_ordered_write_end(file, mapping, pos,
> 					len, copied, page, fsdata);
> -		} else if (ext4_should_writeback_data(inode)) {
> +		case EXT4_INODE_WRITEBACK_DATA_MODE:
> 			return ext4_writeback_write_end(file, mapping, pos,
> 					len, copied, page, fsdata);
> -		} else {
> +		default:
> 			BUG();
> 		}
> 	}
> @@ -3083,18 +3084,25 @@ static const struct address_space_operations ext4_da_aops = {
> 
> void ext4_set_aops(struct inode *inode)
> {
> -	if (ext4_should_order_data(inode) &&
> -		test_opt(inode->i_sb, DELALLOC))
> -		inode->i_mapping->a_ops = &ext4_da_aops;
> -	else if (ext4_should_order_data(inode))
> -		inode->i_mapping->a_ops = &ext4_ordered_aops;
> -	else if (ext4_should_writeback_data(inode) &&
> -		 test_opt(inode->i_sb, DELALLOC))
> -		inode->i_mapping->a_ops = &ext4_da_aops;
> -	else if (ext4_should_writeback_data(inode))
> -		inode->i_mapping->a_ops = &ext4_writeback_aops;
> -	else
> +	switch (ext4_inode_journal_mode(inode)) {
> +	case EXT4_INODE_ORDER_DATA_MODE:
> +		if (test_opt(inode->i_sb, DELALLOC))
> +			inode->i_mapping->a_ops = &ext4_da_aops;
> +		else
> +			inode->i_mapping->a_ops = &ext4_ordered_aops;
> +		break;
> +	case EXT4_INODE_WRITEBACK_DATA_MODE:
> +		if (test_opt(inode->i_sb, DELALLOC))
> +			inode->i_mapping->a_ops = &ext4_da_aops;
> +		else
> +			inode->i_mapping->a_ops = &ext4_writeback_aops;
> +		break;
> +	case EXT4_INODE_JOURNAL_DATA_MODE:
> 		inode->i_mapping->a_ops = &ext4_journalled_aops;
> +		break;
> +	default:
> +		BUG();
> +	}
> }
> 
> 
> -- 
> 1.7.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





