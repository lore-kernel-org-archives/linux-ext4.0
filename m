From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: store EXT4_EXT_MIGRATE in i_state instead of	i_flags
Date: Thu, 17 Sep 2009 11:04:15 -0600
Message-ID: <20090917170415.GB2537@webber.adilger.int>
References: <1253193921-10914-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35515 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbZIQREY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Sep 2009 13:04:24 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8HH4RHH025113
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 10:04:28 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ400L00K4AUO00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 17 Sep 2009 10:04:27 -0700 (PDT)
In-reply-to: <1253193921-10914-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 17, 2009  09:25 -0400, Theodore Ts'o wrote:
> EXT4_EXT_MIGRATE is only intended to be used for an in-memory flag,
> and the hex value assigned to it collides with FS_DIRECTIO_FL (which
> is also stored in i_flags).  There's no reason for the
> EXT4_EXT_MIGRATE bit to be stored in i_flags, so we switch it to use
> i_state instead.
> 
> Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Reviewed-by: Andreas Dilger <adilger@sun.com>

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b558de8..98cf2b3 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -268,7 +268,6 @@ struct flex_groups {
>  #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
>  #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
>  #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
> -#define EXT4_EXT_MIGRATE		0x00100000 /* Inode is migrating */

You might consider adding in an "EXT4_DIRECTIO_FL" here as a placeholder,
to ensure it is not used for some other conflicting purpose.

>  #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
>  
>  #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
> @@ -306,6 +305,7 @@ static inline __u32 ext4_mask_flags(umode_t mode, __u32 flags)
>  #define EXT4_STATE_XATTR		0x00000004 /* has in-inode xattrs */
>  #define EXT4_STATE_NO_EXPAND		0x00000008 /* No space for expansion */
>  #define EXT4_STATE_DA_ALLOC_CLOSE	0x00000010 /* Alloc DA blks on close */
> +#define EXT4_STATE_EXT_MIGRATE		0x00000020 /* Inode is migrating */
>  
>  /* Used to pass group descriptor data when online resize is done */
>  struct ext4_new_group_input {
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5a89792..a5b4ce4 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1255,8 +1255,7 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
>  			 * i_data's format changing.  Force the migrate
>  			 * to fail by clearing migrate flags
>  			 */
> -			EXT4_I(inode)->i_flags = EXT4_I(inode)->i_flags &
> -							~EXT4_EXT_MIGRATE;
> +			EXT4_I(inode)->i_state &= ~EXT4_STATE_EXT_MIGRATE;
>  		}
>  	}
>  
> @@ -4596,8 +4595,7 @@ static int ext4_do_update_inode(handle_t *handle,
>  	if (ext4_inode_blocks_set(handle, raw_inode, ei))
>  		goto out_brelse;
>  	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
> -	/* clear the migrate flag in the raw_inode */
> -	raw_inode->i_flags = cpu_to_le32(ei->i_flags & ~EXT4_EXT_MIGRATE);
> +	raw_inode->i_flags = cpu_to_le32(ei->i_flags);
>  	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
>  	    cpu_to_le32(EXT4_OS_HURD))
>  		raw_inode->i_file_acl_high =
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 05361ad..bf519f2 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -353,17 +353,16 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
>  
>  	down_write(&EXT4_I(inode)->i_data_sem);
>  	/*
> -	 * if EXT4_EXT_MIGRATE is cleared a block allocation
> +	 * if EXT4_STATE_EXT_MIGRATE is cleared a block allocation
>  	 * happened after we started the migrate. We need to
>  	 * fail the migrate
>  	 */
> -	if (!(EXT4_I(inode)->i_flags & EXT4_EXT_MIGRATE)) {
> +	if (!(EXT4_I(inode)->i_state & EXT4_STATE_EXT_MIGRATE)) {
>  		retval = -EAGAIN;
>  		up_write(&EXT4_I(inode)->i_data_sem);
>  		goto err_out;
>  	} else
> -		EXT4_I(inode)->i_flags = EXT4_I(inode)->i_flags &
> -							~EXT4_EXT_MIGRATE;
> +		EXT4_I(inode)->i_state &= ~EXT4_STATE_EXT_MIGRATE;
>  	/*
>  	 * We have the extent map build with the tmp inode.
>  	 * Now copy the i_data across
> @@ -517,14 +516,15 @@ int ext4_ext_migrate(struct inode *inode)
>  	 * when we add extents we extent the journal
>  	 */
>  	/*
> -	 * Even though we take i_mutex we can still cause block allocation
> -	 * via mmap write to holes. If we have allocated new blocks we fail
> -	 * migrate.  New block allocation will clear EXT4_EXT_MIGRATE flag.
> -	 * The flag is updated with i_data_sem held to prevent racing with
> -	 * block allocation.
> +	 * Even though we take i_mutex we can still cause block
> +	 * allocation via mmap write to holes. If we have allocated
> +	 * new blocks we fail migrate.  New block allocation will
> +	 * clear EXT4_STATE_EXT_MIGRATE flag.  The flag is updated
> +	 * with i_data_sem held to prevent racing with block
> +	 * allocation.
>  	 */
>  	down_read((&EXT4_I(inode)->i_data_sem));
> -	EXT4_I(inode)->i_flags = EXT4_I(inode)->i_flags | EXT4_EXT_MIGRATE;
> +	EXT4_I(inode)->i_state |= EXT4_STATE_EXT_MIGRATE;
>  	up_read((&EXT4_I(inode)->i_data_sem));
>  
>  	handle = ext4_journal_start(inode, 1);
> -- 
> 1.6.3.2.1.gb9f7d.dirty
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

