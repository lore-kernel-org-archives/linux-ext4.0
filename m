From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure
 FITRIM.
Date: Wed, 18 Jun 2014 11:48:12 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406181047480.3406@localhost.localdomain>
References: <1402625647-31439-1-git-send-email-jpa@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, gcondra@google.com
To: JP Abgrall <jpa@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965822AbaFRJsR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Jun 2014 05:48:17 -0400
In-Reply-To: <1402625647-31439-1-git-send-email-jpa@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 12 Jun 2014, JP Abgrall wrote:

> Date: Thu, 12 Jun 2014 19:14:07 -0700
> From: JP Abgrall <jpa@google.com>
> To: linux-ext4@vger.kernel.org
> Cc: jpa@google.com, gcondra@google.com
> Subject: [PATCH] ext4: Add support for SFITRIM, an ioctl for secure FITRIM.
> 
> This provides an interface for issuing secure trims to parallel
> the existing interface for non-secure trim.
> 
> Signed-off-by: Geremy Condra <gcondra@google.com>
> Signed-off-by: JP Abgrall <jpa@google.com>
> ---
>  fs/ext4/ext4.h          |  3 ++-
>  fs/ext4/ioctl.c         | 14 +++++++++++++-
>  fs/ext4/mballoc.c       | 29 +++++++++++++++++++----------
>  include/uapi/linux/fs.h |  1 +
>  4 files changed, 35 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 7cc5a0e..cf2ddad 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2082,7 +2082,8 @@ extern int ext4_mb_add_groupinfo(struct super_block *sb,
>  		ext4_group_t i, struct ext4_group_desc *desc);
>  extern int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
>  				ext4_fsblk_t block, unsigned long count);
> -extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
> +extern int ext4_trim_fs(struct super_block *, struct fstrim_range *,
> +				bool secure);

int flags would be much better in case we want to add other things
later.

>  
>  /* inode.c */
>  struct buffer_head *ext4_getblk(handle_t *, struct inode *,
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 0f2252e..0a0b483 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -580,11 +580,13 @@ resizefs_out:
>  		return err;
>  	}
>  
> +	case SFITRIM:

As I said in a different email. Do not call it secure, How about
"deep discard"  - FIDTRIM ?

>  	case FITRIM:
>  	{
>  		struct request_queue *q = bdev_get_queue(sb->s_bdev);
>  		struct fstrim_range range;
>  		int ret = 0;
> +		bool secure_trim = cmd == SFITRIM;

If we're going to introduce "int flags" for the ext4_trim_fs() we
have to come up with our own flags for this.

>  
>  		if (!capable(CAP_SYS_ADMIN))
>  			return -EPERM;
> @@ -592,13 +594,23 @@ resizefs_out:
>  		if (!blk_queue_discard(q))
>  			return -EOPNOTSUPP;
>  
> +		if (secure_trim && !blk_queue_secdiscard(q))
> +			return -EOPNOTSUPP;
> +
> +		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
> +			ext4_msg(sb, KERN_ERR,
> +				 "FITRIM not supported with bigalloc");
> +			return -EOPNOTSUPP;
> +		}

Why ? I have not noticed that it ever stopped working. Have you seen
any problems with this ?

> +
>  		if (copy_from_user(&range, (struct fstrim_range __user *)arg,
>  		    sizeof(range)))
>  			return -EFAULT;
>  
>  		range.minlen = max((unsigned int)range.minlen,
>  				   q->limits.discard_granularity);
> -		ret = ext4_trim_fs(sb, &range);
> +		ret = ext4_trim_fs(sb, &range, secure_trim);
>  		if (ret < 0)
>  			return ret;
>  
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 59e3162..b470efe 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2734,16 +2734,18 @@ int ext4_mb_release(struct super_block *sb)
>  }
>  
>  static inline int ext4_issue_discard(struct super_block *sb,
> -		ext4_group_t block_group, ext4_grpblk_t cluster, int count)
> +		ext4_group_t block_group, ext4_grpblk_t cluster, int count,
> +		bool secure)

again int flags would be better.


>  {
>  	ext4_fsblk_t discard_block;
> +	unsigned long flags = secure ? BLKDEV_DISCARD_SECURE : 0;
>  
>  	discard_block = (EXT4_C2B(EXT4_SB(sb), cluster) +
>  			 ext4_group_first_block_no(sb, block_group));
>  	count = EXT4_C2B(EXT4_SB(sb), count);
>  	trace_ext4_discard_blocks(sb,
>  			(unsigned long long) discard_block, count);
> -	return sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
> +	return sb_issue_discard(sb, discard_block, count, GFP_NOFS, flags);
>  }
>  
>  /*
> @@ -2765,7 +2767,7 @@ static void ext4_free_data_callback(struct super_block *sb,
>  	if (test_opt(sb, DISCARD)) {
>  		err = ext4_issue_discard(sb, entry->efd_group,
>  					 entry->efd_start_cluster,
> -					 entry->efd_count);
> +					 entry->efd_count, 0);
>  		if (err && err != -EOPNOTSUPP)
>  			ext4_msg(sb, KERN_WARNING, "discard request in"
>  				 " group:%d block:%d count:%d failed"
> @@ -4804,7 +4806,8 @@ do_more:
>  		 * them with group lock_held
>  		 */
>  		if (test_opt(sb, DISCARD)) {
> -			err = ext4_issue_discard(sb, block_group, bit, count);
> +			err = ext4_issue_discard(sb, block_group, bit, count,
> +						 0);
>  			if (err && err != -EOPNOTSUPP)
>  				ext4_msg(sb, KERN_WARNING, "discard request in"
>  					 " group:%d block:%d count:%lu failed"
> @@ -5011,13 +5014,15 @@ error_return:
>   * @count:	number of blocks to TRIM
>   * @group:	alloc. group we are working with
>   * @e4b:	ext4 buddy for the group
> + * @secure:	false to issue a standard discard, true for secure discard
>   *
>   * Trim "count" blocks starting at "start" in the "group". To assure that no
>   * one will allocate those blocks, mark it as used in buddy bitmap. This must
>   * be called with under the group lock.
>   */
>  static int ext4_trim_extent(struct super_block *sb, int start, int count,
> -			     ext4_group_t group, struct ext4_buddy *e4b)
> +			    ext4_group_t group, struct ext4_buddy *e4b,
> +			    bool secure)
>  __releases(bitlock)
>  __acquires(bitlock)
>  {
> @@ -5038,7 +5043,7 @@ __acquires(bitlock)
>  	 */
>  	mb_mark_used(e4b, &ex);
>  	ext4_unlock_group(sb, group);
> -	ret = ext4_issue_discard(sb, group, start, count);
> +	ret = ext4_issue_discard(sb, group, start, count, secure);
>  	ext4_lock_group(sb, group);
>  	mb_free_blocks(NULL, e4b, start, ex.fe_len);
>  	return ret;
> @@ -5051,6 +5056,7 @@ __acquires(bitlock)
>   * @start:		first group block to examine
>   * @max:		last group block to examine
>   * @minblocks:		minimum extent block count
> + * @secure:		false for standard discard, true for secure discard
>   *
>   * ext4_trim_all_free walks through group's buddy bitmap searching for free
>   * extents. When the free block is found, ext4_trim_extent is called to TRIM
> @@ -5065,7 +5071,7 @@ __acquires(bitlock)
>  static ext4_grpblk_t
>  ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
>  		   ext4_grpblk_t start, ext4_grpblk_t max,
> -		   ext4_grpblk_t minblocks)
> +		   ext4_grpblk_t minblocks, bool secure)

Also as I already mention to maximize benefits of this type of
discard we should really not take into account the optimization and
not skip groups if it's already been discarded.

We should also sync the file system to make sure we discard as much
blocks as we can from each group. It's not perfect and certainly not
secure, but it is "best effort".

Thanks!
-Lukas

>  {
>  	void *bitmap;
>  	ext4_grpblk_t next, count = 0, free_count = 0;
> @@ -5098,7 +5104,8 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
>  
>  		if ((next - start) >= minblocks) {
>  			ret = ext4_trim_extent(sb, start,
> -					       next - start, group, &e4b);
> +					       next - start, group, &e4b,
> +					       secure);
>  			if (ret && ret != -EOPNOTSUPP)
>  				break;
>  			ret = 0;
> @@ -5140,6 +5147,7 @@ out:
>   * ext4_trim_fs() -- trim ioctl handle function
>   * @sb:			superblock for filesystem
>   * @range:		fstrim_range structure
> + * @secure:		false for standard discard, true for secure discard
>   *
>   * start:	First Byte to trim
>   * len:		number of Bytes to trim from start
> @@ -5148,7 +5156,8 @@ out:
>   * start to start+len. For each such a group ext4_trim_all_free function
>   * is invoked to trim all free space.
>   */
> -int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
> +int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range,
> +			bool secure)
>  {
>  	struct ext4_group_info *grp;
>  	ext4_group_t group, first_group, last_group;
> @@ -5204,7 +5213,7 @@ int ext4_trim_fs(struct super_block *sb, struct fstrim_range *range)
>  
>  		if (grp->bb_free >= minlen) {
>  			cnt = ext4_trim_all_free(sb, group, first_cluster,
> -						end, minlen);
> +						end, minlen, secure);
>  			if (cnt < 0) {
>  				ret = cnt;
>  				break;
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index ca1a11b..efbd8f8 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -156,6 +156,7 @@ struct inodes_stat_t {
>  #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
>  #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
>  #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
> +#define SFITRIM	_IOWR('X', 122, struct fstrim_range)	/* Secure trim */
>  
>  #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
>  #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
> 
