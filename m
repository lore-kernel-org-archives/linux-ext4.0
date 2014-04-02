From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] fs/ext4: increase parallelism in updating ext4 orphan
 list
Date: Wed, 2 Apr 2014 19:41:09 +0200
Message-ID: <20140402174109.GD8657@quack.suse.cz>
References: <1380728283-61038-1-git-send-email-tmac@hp.com>
 <1396456148-20455-1-git-send-email-tmac@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	aswin@hp.com
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1396456148-20455-1-git-send-email-tmac@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 02-04-14 10:29:08, T Makphaibulchoke wrote:
> Instead of allowing only a single atomic update (both in memory and on disk
> orphan lists) of an ext4's orphan list via the s_orphan_lock mutex, this patch
> allows multiple updates of the orphan list, while still maintaing the
> integrity of both the in memory and on disk orphan lists of each update.
> 
> This is accomplished by using a mutex from an array of mutexes, indexed by
> hashing of an inode, to serialize oprhan list updates of a single inode, and
> a mutex and a spinlock to serialize the on disk and in memory orphan list
> respectively.
  Thanks for the patches and measurements! So I agree we contend a lot on
orphan list changes in ext4. But what you do seems to be unnecessarily
complicated and somewhat hiding the real substance of the patch. If I
understand your patch correctly, all it does is that it does the
preliminary work (ext4_reserve_inode_write(),
ext4_journal_get_write_access()) without the global orphan mutex (under the
hashed mutex).

However orphan operations on a single inode are already serialized by
i_mutex so there's no need to introduce any new hashed lock. Just add
assertion mutex_locked(&inode->i_mutex) to ext4_orphan_add() and
ext4_orphan_del() - you might need to lock i_mutex around the code in
fs/ext4/migrate.c and in ext4_tmpfile() but that should be fine.

Also I'm somewhat failing to see what the spinlock s_orphan_lock brings us.
I'd guess that the mutex could still protect also the in-memory list and we
have to grab it in all the relevant cases anyway (in some rare cases we
could avoid taking the mutex and spinlock would be enough but these
shouldn't be performance relevant). Please correct me if I'm wrong here, I
didn't look at the code for that long.

Finally (and I somewhat miss this in your patch), I'd think we might need
to use list_empty_careful() when checking inode's orphan list without
global orphan list lock.

								Honza

> 
> Here are some of the benchmark results with the changes.
> 
> On a 120 core machine,
> 
> ---------------------------
> |             | % increase |
> ---------------------------
> | alltests    |     19.29  |
> ---------------------------
> | custom      |     11.10  |
> ---------------------------
> | disk        |      5.09  |
> ---------------------------
> | fserver     |     12.47  |
> ---------------------------
> | new_dbase   |      7.49  |
> ---------------------------
> | shared      |     16.55  |
> ---------------------------
> 
> On a 80 core machine,
> 
> ---------------------------
> |             | % increase |
> ---------------------------
> | alltests    |     30.09  |
> ---------------------------
> | custom      |     22.66  |
> ---------------------------
> | dbase       |      3.28  |
> ---------------------------
> | disk        |      3.15  |
> ---------------------------
> | fserver     |     24.28  |
> ---------------------------
> | high_systime|      6.79  |
> ---------------------------
> | new_dbase   |      4.63  |
> ---------------------------
> | new_fserver |     28.40  |
> ---------------------------
> | shared      |     20.42  |
> ---------------------------
> 
> On a 8 core machine:
> 
> ---------------------------
> |             | % increase |
> ---------------------------
> | fserver     |      9.11  |
> ---------------------------
> | new_fserver |      3.45  |
> ---------------------------
> 
> For Swingbench dss workload,
> 
> -----------------------------------------------------------------------------
> | Users      | 100  | 200  | 300  | 400  | 500  | 600  | 700  | 800  |  900 |
> -----------------------------------------------------------------------------
> | % improve- | 6.15 | 5.49 | 3.13 | 1.06 | 2.31 | 6.29 | 6.50 |-0.6  | 1.72 |
> | ment with  |      |      |      |      |      |      |      |      |      |
> | out using  |      |      |      |      |      |      |      |      |      |
> | /dev/shm   |      |      |      |      |      |      |      |      |      |
> -----------------------------------------------------------------------------
> 
> Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
> ---
> Changed in v2:
> 	- New performance data
> 	- Fixed problem in v1
> 	- No changes in ext4_inode_info size
> 	- Used an array of mutexes, indexed by hashing of an inode, to serialize
> 	  operations within a single inode
> 	- Combined multiple patches into one.
> ---
>  fs/ext4/ext4.h  |   5 ++-
>  fs/ext4/namei.c | 128 +++++++++++++++++++++++++++++++++++---------------------
>  fs/ext4/super.c |  12 +++++-
>  3 files changed, 95 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index d3a534f..cb962d6 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -77,6 +77,7 @@
>  #define EXT4_ERROR_FILE(file, block, fmt, a...)				\
>  	ext4_error_file((file), __func__, __LINE__, (block), (fmt), ## a)
>  
> +#define	EXT4_ORPHAN_OP_BITS	7
>  /* data type for block offset of block group */
>  typedef int ext4_grpblk_t;
>  
> @@ -1223,7 +1224,9 @@ struct ext4_sb_info {
>  	/* Journaling */
>  	struct journal_s *s_journal;
>  	struct list_head s_orphan;
> -	struct mutex s_orphan_lock;
> +	spinlock_t s_orphan_lock;
> +	struct mutex s_ondisk_orphan_lock;
> +	struct mutex *s_orphan_op_mutex;
>  	unsigned long s_resize_flags;		/* Flags indicating if there
>  						   is a resizer */
>  	unsigned long s_commit_interval;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index d050e04..c7db475 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -48,6 +48,13 @@
>  #define NAMEI_RA_BLOCKS  4
>  #define NAMEI_RA_SIZE	     (NAMEI_RA_CHUNKS * NAMEI_RA_BLOCKS)
>  
> +#define	ORPHAN_OP_INDEX(ext4_i)				\
> +	(hash_long((unsigned long)ext4_i, EXT4_ORPHAN_OP_BITS))
> +#define	LOCK_EXT4I_ORPHAN(ext4_sb, ext4_i)		\
> +	mutex_lock(&ext4_sb->s_orphan_op_mutex[ORPHAN_OP_INDEX(ext4_i)])
> +#define	UNLOCK_EXT4I_ORPHAN(ext4_sb, ext4_i)		\
> +	mutex_unlock(&ext4_sb->s_orphan_op_mutex[ORPHAN_OP_INDEX(ext4_i)])
> +
>  static struct buffer_head *ext4_append(handle_t *handle,
>  					struct inode *inode,
>  					ext4_lblk_t *block)
> @@ -2556,7 +2563,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
>  	if (!EXT4_SB(sb)->s_journal)
>  		return 0;
>  
> -	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
> +	LOCK_EXT4I_ORPHAN(EXT4_SB(sb), EXT4_I(inode));
>  	if (!list_empty(&EXT4_I(inode)->i_orphan))
>  		goto out_unlock;
>  
> @@ -2582,9 +2589,21 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
>  	 * orphan list. If so skip on-disk list modification.
>  	 */
>  	if (NEXT_ORPHAN(inode) && NEXT_ORPHAN(inode) <=
> -		(le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count)))
> -			goto mem_insert;
> -
> +		(le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))) {
> +			brelse(iloc.bh);
> +			spin_lock(&EXT4_SB(sb)->s_orphan_lock);
> +			list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->
> +				s_orphan);
> +			spin_unlock(&EXT4_SB(sb)->s_orphan_lock);
> +			jbd_debug(4, "superblock will point to %lu\n",
> +				inode->i_ino);
> +			jbd_debug(4, "orphan inode %lu will point to %d\n",
> +				inode->i_ino, NEXT_ORPHAN(inode));
> +			goto out_unlock;
> +	}
> +
> +	mutex_lock(&EXT4_SB(sb)->s_ondisk_orphan_lock);
> +	spin_lock(&EXT4_SB(sb)->s_orphan_lock);
>  	/* Insert this inode at the head of the on-disk orphan list... */
>  	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
>  	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
> @@ -2592,24 +2611,25 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
>  	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
>  	if (!err)
>  		err = rc;
> -
> -	/* Only add to the head of the in-memory list if all the
> -	 * previous operations succeeded.  If the orphan_add is going to
> -	 * fail (possibly taking the journal offline), we can't risk
> -	 * leaving the inode on the orphan list: stray orphan-list
> -	 * entries can cause panics at unmount time.
> -	 *
> -	 * This is safe: on error we're going to ignore the orphan list
> -	 * anyway on the next recovery. */
> -mem_insert:
> -	if (!err)
> +	if (!err) {
> +		/* Only add to the head of the in-memory list if all the
> +		 * previous operations succeeded.  If the orphan_add is going to
> +		 * fail (possibly taking the journal offline), we can't risk
> +		 * leaving the inode on the orphan list: stray orphan-list
> +		 * entries can cause panics at unmount time.
> +		 *
> +		 * This is safe: on error we're going to ignore the orphan list
> +		 * anyway on the next recovery. */
>  		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
> -
> -	jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
> -	jbd_debug(4, "orphan inode %lu will point to %d\n",
> +		spin_unlock(&EXT4_SB(sb)->s_orphan_lock);
> +		jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
> +		jbd_debug(4, "orphan inode %lu will point to %d\n",
>  			inode->i_ino, NEXT_ORPHAN(inode));
> +	}
> +	mutex_unlock(&EXT4_SB(sb)->s_ondisk_orphan_lock);
> +
>  out_unlock:
> -	mutex_unlock(&EXT4_SB(sb)->s_orphan_lock);
> +	UNLOCK_EXT4I_ORPHAN(EXT4_SB(sb), EXT4_I(inode));
>  	ext4_std_error(inode->i_sb, err);
>  	return err;
>  }
> @@ -2622,45 +2642,56 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
>  {
>  	struct list_head *prev;
>  	struct ext4_inode_info *ei = EXT4_I(inode);
> -	struct ext4_sb_info *sbi;
> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  	__u32 ino_next;
>  	struct ext4_iloc iloc;
>  	int err = 0;
>  
> -	if ((!EXT4_SB(inode->i_sb)->s_journal) &&
> -	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
> +	if ((!sbi->s_journal) &&
> +		!(sbi->s_mount_state & EXT4_ORPHAN_FS))
>  		return 0;
>  
> -	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
> -	if (list_empty(&ei->i_orphan))
> -		goto out;
> -
> -	ino_next = NEXT_ORPHAN(inode);
> -	prev = ei->i_orphan.prev;
> -	sbi = EXT4_SB(inode->i_sb);
> -
> -	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
> +	LOCK_EXT4I_ORPHAN(sbi, ei);
> +	if (list_empty(&ei->i_orphan)) {
> +		UNLOCK_EXT4I_ORPHAN(sbi, ei);
> +		return 0;
> +	}
>  
> -	list_del_init(&ei->i_orphan);
>  
>  	/* If we're on an error path, we may not have a valid
>  	 * transaction handle with which to update the orphan list on
>  	 * disk, but we still need to remove the inode from the linked
>  	 * list in memory. */
> -	if (!handle)
> -		goto out;
> +	if (!handle) {
> +		jbd_debug(4, "remove inode %lu from orphan list\n",
> +			inode->i_ino);
> +		spin_lock(&sbi->s_orphan_lock);
> +		list_del_init(&ei->i_orphan);
> +		spin_unlock(&sbi->s_orphan_lock);
> +	} else
> +		err = ext4_reserve_inode_write(handle, inode, &iloc);
>  
> -	err = ext4_reserve_inode_write(handle, inode, &iloc);
> -	if (err)
> -		goto out_err;
> +	if (!handle || err) {
> +		UNLOCK_EXT4I_ORPHAN(sbi, ei);
> +		goto out_set_err;
> +	}
>  
> +	mutex_lock(&sbi->s_ondisk_orphan_lock);
> +	ino_next = NEXT_ORPHAN(inode);
> +	spin_lock(&sbi->s_orphan_lock);
> +	prev = ei->i_orphan.prev;
> +	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
> +	list_del_init(&ei->i_orphan);
> +	spin_unlock(&sbi->s_orphan_lock);
>  	if (prev == &sbi->s_orphan) {
>  		jbd_debug(4, "superblock will point to %u\n", ino_next);
>  		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
>  		err = ext4_journal_get_write_access(handle, sbi->s_sbh);
> +		if (!err)
> +			sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
> +		mutex_unlock(&sbi->s_ondisk_orphan_lock);
>  		if (err)
> -			goto out_brelse;
> -		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
> +			goto brelse;
>  		err = ext4_handle_dirty_super(handle, inode->i_sb);
>  	} else {
>  		struct ext4_iloc iloc2;
> @@ -2670,25 +2701,26 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
>  		jbd_debug(4, "orphan inode %lu will point to %u\n",
>  			  i_prev->i_ino, ino_next);
>  		err = ext4_reserve_inode_write(handle, i_prev, &iloc2);
> +		if (!err)
> +			NEXT_ORPHAN(i_prev) = ino_next;
> +		mutex_unlock(&sbi->s_ondisk_orphan_lock);
>  		if (err)
> -			goto out_brelse;
> -		NEXT_ORPHAN(i_prev) = ino_next;
> +			goto brelse;
>  		err = ext4_mark_iloc_dirty(handle, i_prev, &iloc2);
>  	}
>  	if (err)
> -		goto out_brelse;
> +		goto brelse;
>  	NEXT_ORPHAN(inode) = 0;
> +	UNLOCK_EXT4I_ORPHAN(sbi, ei);
>  	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
> -
> -out_err:
> +out_set_err:
>  	ext4_std_error(inode->i_sb, err);
> -out:
> -	mutex_unlock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
>  	return err;
>  
> -out_brelse:
> +brelse:
> +	UNLOCK_EXT4I_ORPHAN(sbi, ei);
>  	brelse(iloc.bh);
> -	goto out_err;
> +	goto out_set_err;
>  }
>  
>  static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 710fed2..b8d4298 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3921,7 +3921,17 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
>  
>  	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
> -	mutex_init(&sbi->s_orphan_lock);
> +	spin_lock_init(&sbi->s_orphan_lock);
> +	mutex_init(&sbi->s_ondisk_orphan_lock);
> +	sbi->s_orphan_op_mutex = kmalloc(sizeof(struct mutex) <<
> +		EXT4_ORPHAN_OP_BITS, GFP_KERNEL);
> +	BUG_ON(!sbi->s_orphan_op_mutex);
> +	if (sbi->s_orphan_op_mutex) {
> +		int n = 1 << EXT4_ORPHAN_OP_BITS;
> +
> +		while (n-- > 0)
> +			mutex_init(&sbi->s_orphan_op_mutex[n]);
> +	}
>  
>  	sb->s_root = NULL;
>  
> -- 
> 1.7.11.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
