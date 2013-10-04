From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] fs/ext4/namei.c: reducing contention on s_orphan_lock mmutex
Date: Thu, 3 Oct 2013 18:41:45 -0600
Message-ID: <139DD231-CA27-40C1-BBB5-B66B29640DC0@dilger.ca>
References: <1380728219-60784-1-git-send-email-tmac@hp.com> <1380728219-60784-2-git-send-email-tmac@hp.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	aswin@hp.com
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:64189 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3JDAlv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Oct 2013 20:41:51 -0400
Received: by mail-pb0-f52.google.com with SMTP id wz12so3179259pbc.39
        for <linux-ext4@vger.kernel.org>; Thu, 03 Oct 2013 17:41:51 -0700 (PDT)
In-Reply-To: <1380728219-60784-2-git-send-email-tmac@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2013-10-02, at 9:36 AM, T Makphaibulchoke wrote:

> Instead of using a single per super block mutex, s_orphan_lock, to serialize
> all orphan list updates, a separate mutex and spinlock are used to
> protect the on disk and in memory orphan lists respecvitely.
> 
> At the same time, a per inode mutex is used to serialize orphan list
> updates of a single inode.
> 
> Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
> ---
> fs/ext4/namei.c | 139 ++++++++++++++++++++++++++++++++++++++++----------------
> 1 file changed, 100 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 35f55a0..d7d3d0f 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2554,12 +2554,24 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
> 	struct super_block *sb = inode->i_sb;
> 	struct ext4_iloc iloc;
> 	int err = 0, rc;
> +	struct ext4_inode_info *ext4_inode = EXT4_I(inode);
> +	struct ext4_sb_info *ext4_sb = EXT4_SB(sb);
> +	struct mutex *inode_orphan_mutex;
> +	spinlock_t *orphan_lock;
> +	struct mutex *ondisk_orphan_mutex;
> +	struct list_head *prev;
> +	unsigned int next_inum;
> +	struct inode *next_inode;

Stack space in the kernel is not so abundant that all (or any?) of these
should get their own local variable.

> 
> -	if (!EXT4_SB(sb)->s_journal)
> +	if (ext4_sb->s_journal)
> 		return 0;
> 
> -	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
> -	if (!list_empty(&EXT4_I(inode)->i_orphan))
> +	inode_orphan_mutex = &ext4_inode->i_orphan_mutex;
> +	orphan_lock = &ext4_sb->s_orphan_lock;
> +	ondisk_orphan_mutex = &ext4_sb->s_ondisk_orphan_lock;
> +	mutex_lock(inode_orphan_mutex);
> +	prev = ext4_inode->i_orphan.prev;
> +	if (prev != &ext4_inode->i_orphan)
> 		goto out_unlock;
> 
> 	/*
> @@ -2579,17 +2591,28 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
> 	err = ext4_reserve_inode_write(handle, inode, &iloc);
> 	if (err)
> 		goto out_unlock;
> +	mutex_lock(ondisk_orphan_mutex);
> 	/*
> 	 * Due to previous errors inode may be already a part of on-disk
> 	 * orphan list. If so skip on-disk list modification.
> 	 */
> 	if (NEXT_ORPHAN(inode) && NEXT_ORPHAN(inode) <=
> -		(le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count)))
> +		(le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count))) {
> +			mutex_unlock(ondisk_orphan_mutex);
> 			goto mem_insert;
> +	}
> 
> 	/* Insert this inode at the head of the on-disk orphan list... */
> -	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
> -	EXT4_SB(sb)->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
> +	next_inum = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
> +	NEXT_ORPHAN(inode) = next_inum;
> +	next_inode = ilookup(sb, next_inum);
> +	if (next_inode)
> +		EXT4_I(next_inode)->i_prev_orphan = inode->i_ino;
> +	ext4_sb->s_es->s_last_orphan = cpu_to_le32(inode->i_ino);
> +	ext4_inode->i_prev_orphan = 0;
> +	mutex_unlock(ondisk_orphan_mutex);
> +	if (next_inode)
> +		iput(next_inode);
> 	err = ext4_handle_dirty_super(handle, sb);
> 	rc = ext4_mark_iloc_dirty(handle, inode, &iloc);
> 	if (!err)
> @@ -2604,14 +2627,17 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
> 	 * This is safe: on error we're going to ignore the orphan list
> 	 * anyway on the next recovery. */
> mem_insert:
> -	if (!err)
> -		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
> +	if (!err) {
> +		spin_lock(orphan_lock);
> +		list_add(&ext4_inode->i_orphan, &ext4_sb->s_orphan);
> +		spin_unlock(orphan_lock);
> +	}
> 
> 	jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
> 	jbd_debug(4, "orphan inode %lu will point to %d\n",
> 			inode->i_ino, NEXT_ORPHAN(inode));
> out_unlock:
> -	mutex_unlock(&EXT4_SB(sb)->s_orphan_lock);
> +	mutex_unlock(inode_orphan_mutex);
> 	ext4_std_error(inode->i_sb, err);
> 	return err;
> }
> @@ -2624,71 +2650,106 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
> {
> 	struct list_head *prev;
> 	struct ext4_inode_info *ei = EXT4_I(inode);
> -	struct ext4_sb_info *sbi;
> +	struct inode *i_next = NULL;
> +	struct inode *i_prev = NULL;
> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> 	__u32 ino_next;
> +	unsigned int ino_prev;
> 	struct ext4_iloc iloc;
> 	int err = 0;
> +	struct mutex *inode_orphan_mutex;
> +	spinlock_t *orphan_lock;
> +	struct mutex *ondisk_orphan_mutex;

Same here.

> -	if ((!EXT4_SB(inode->i_sb)->s_journal) &&
> -	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
> +	if ((!sbi->s_journal) &&
> +	    !(sbi->s_mount_state & EXT4_ORPHAN_FS))
> 		return 0;
> 
> -	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
> -	if (list_empty(&ei->i_orphan))
> -		goto out;
> -
> -	ino_next = NEXT_ORPHAN(inode);
> +	inode_orphan_mutex = &ei->i_orphan_mutex;
> +	orphan_lock = &sbi->s_orphan_lock;
> +	ondisk_orphan_mutex = &sbi->s_ondisk_orphan_lock;
> +	mutex_lock(inode_orphan_mutex);
> 	prev = ei->i_orphan.prev;
> -	sbi = EXT4_SB(inode->i_sb);
> +	if (prev == &ei->i_orphan) {
> +		mutex_unlock(inode_orphan_mutex);
> +		return err;
> +	}
> 
> 	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
> 
> +	spin_lock(orphan_lock);
> 	list_del_init(&ei->i_orphan);
> +	spin_unlock(orphan_lock);
> 
> 	/* If we're on an error path, we may not have a valid
> 	 * transaction handle with which to update the orphan list on
> 	 * disk, but we still need to remove the inode from the linked
> 	 * list in memory. */
> -	if (!handle)
> -		goto out;
> +	if (!handle) {
> +		mutex_unlock(inode_orphan_mutex);
> +		return err;
> +	}
> 
> 	err = ext4_reserve_inode_write(handle, inode, &iloc);
> -	if (err)
> +	if (err) {
> +		mutex_unlock(inode_orphan_mutex);
> 		goto out_err;
> +	}
> 
> -	if (prev == &sbi->s_orphan) {
> +	mutex_lock(ondisk_orphan_mutex);
> +	ino_next = NEXT_ORPHAN(inode);
> +	if (ino_next > 0) {
> +		i_next = ilookup(inode->i_sb, ino_next);
> +		assert(i_next);
> +	}
> +	ino_prev = ei->i_prev_orphan;
> +	if (!ino_prev) {
> 		jbd_debug(4, "superblock will point to %u\n", ino_next);
> 		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
> 		err = ext4_journal_get_write_access(handle, sbi->s_sbh);
> -		if (err)
> -			goto out_brelse;
> -		sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
> -		err = ext4_handle_dirty_super(handle, inode->i_sb);
> +		if (!err) {
> +			sbi->s_es->s_last_orphan = cpu_to_le32(ino_next);
> +			if (i_next)
> +				EXT4_I(i_next)->i_prev_orphan = 0;
> +		}
> +		mutex_unlock(ondisk_orphan_mutex);
> +		if (!err)
> +			err = ext4_handle_dirty_super(handle, inode->i_sb);
> 	} else {
> 		struct ext4_iloc iloc2;
> -		struct inode *i_prev =
> -			&list_entry(prev, struct ext4_inode_info, i_orphan)->vfs_inode;
> -
> -		jbd_debug(4, "orphan inode %lu will point to %u\n",
> -			  i_prev->i_ino, ino_next);
> -		err = ext4_reserve_inode_write(handle, i_prev, &iloc2);
> -		if (err)
> -			goto out_brelse;
> -		NEXT_ORPHAN(i_prev) = ino_next;
> -		err = ext4_mark_iloc_dirty(handle, i_prev, &iloc2);
> +		i_prev = ilookup(inode->i_sb, ino_prev);
> +
> +		assert(i_prev);
> +		if (i_prev) {
> +			jbd_debug(4, "orphan inode %lu will point to %u\n",
> +				i_prev->i_ino, ino_next);
> +			err = ext4_reserve_inode_write(handle, i_prev, &iloc2);
> +		} else
> +			err = -ENOENT;
> +		if (!err) {
> +			NEXT_ORPHAN(i_prev) = ino_next;
> +			if (i_next)
> +				EXT4_I(i_next)->i_prev_orphan = ino_prev;
> +		}
> +		mutex_unlock(ondisk_orphan_mutex);
> +		if (i_prev && !err)
> +			err = ext4_mark_iloc_dirty(handle, i_prev, &iloc2);
> 	}
> 	if (err)
> 		goto out_brelse;
> 	NEXT_ORPHAN(inode) = 0;
> +	mutex_unlock(inode_orphan_mutex);
> 	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
> -
> out_err:
> +	if (i_next)
> +		iput(i_next);
> +	if (i_prev)
> +		iput(i_prev);
> 	ext4_std_error(inode->i_sb, err);
> -out:
> -	mutex_unlock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
> 	return err;
> 
> out_brelse:
> +	mutex_unlock(inode_orphan_mutex);
> 	brelse(iloc.bh);
> 	goto out_err;
> }
> -- 
> 1.7.11.3
> 


Cheers, Andreas





