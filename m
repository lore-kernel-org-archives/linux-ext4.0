From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 09/16] ext4: Use lowercase names of quota functions
Date: Tue, 27 Jan 2009 16:13:40 -0800
Message-ID: <1233101620.15581.2.camel@mingming-laptop>
References: <y> <1233074929-12277-1-git-send-email-jack@suse.cz>
	 <1233074929-12277-2-git-send-email-jack@suse.cz>
	 <1233074929-12277-3-git-send-email-jack@suse.cz>
	 <1233074929-12277-4-git-send-email-jack@suse.cz>
	 <1233074929-12277-5-git-send-email-jack@suse.cz>
	 <1233074929-12277-6-git-send-email-jack@suse.cz>
	 <1233074929-12277-7-git-send-email-jack@suse.cz>
	 <1233074929-12277-8-git-send-email-jack@suse.cz>
	 <1233074929-12277-9-git-send-email-jack@suse.cz>
	 <1233074929-12277-10-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1233074929-12277-10-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Looks good to me.

Acked-by: Mingming Cao <cmm@us.ibm.com>
=E5=9C=A8 2009-01-27=E4=BA=8C=E7=9A=84 17:48 +0100=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> Use lowercase names of quota functions instead of old uppercase ones.
>=20
> Signed-off-by: Jan Kara <jack@suse.cz>
> CC: linux-ext4@vger.kernel.org
> ---
>  fs/ext4/balloc.c  |    2 +-
>  fs/ext4/ialloc.c  |   12 ++++++------
>  fs/ext4/inode.c   |    4 ++--
>  fs/ext4/mballoc.c |    4 ++--
>  fs/ext4/namei.c   |    6 +++---
>  fs/ext4/super.c   |    6 +++---
>  fs/ext4/xattr.c   |    6 +++---
>  7 files changed, 20 insertions(+), 20 deletions(-)
>=20
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 6bba06b..0c92f26 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -536,7 +536,7 @@ void ext4_free_blocks(handle_t *handle, struct in=
ode *inode,
>  	ext4_mb_free_blocks(handle, inode, block, count,
>  			    metadata, &dquot_freed_blocks);
>  	if (dquot_freed_blocks)
> -		DQUOT_FREE_BLOCK(inode, dquot_freed_blocks);
> +		vfs_dq_free_block(inode, dquot_freed_blocks);
>  	return;
>  }
>=20
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 4fb86a0..bd39075 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -220,10 +220,10 @@ void ext4_free_inode(handle_t *handle, struct i=
node *inode)
>  	 * Note: we must free any quota before locking the superblock,
>  	 * as writing the quota to disk may need the lock as well.
>  	 */
> -	DQUOT_INIT(inode);
> +	vfs_dq_init(inode);
>  	ext4_xattr_delete_inode(handle, inode);
> -	DQUOT_FREE_INODE(inode);
> -	DQUOT_DROP(inode);
> +	vfs_dq_free_inode(inode);
> +	vfs_dq_drop(inode);
>=20
>  	is_directory =3D S_ISDIR(inode->i_mode);
>=20
> @@ -904,7 +904,7 @@ got:
>  	ei->i_extra_isize =3D EXT4_SB(sb)->s_want_extra_isize;
>=20
>  	ret =3D inode;
> -	if (DQUOT_ALLOC_INODE(inode)) {
> +	if (vfs_dq_alloc_inode(inode)) {
>  		err =3D -EDQUOT;
>  		goto fail_drop;
>  	}
> @@ -945,10 +945,10 @@ really_out:
>  	return ret;
>=20
>  fail_free_drop:
> -	DQUOT_FREE_INODE(inode);
> +	vfs_dq_free_inode(inode);
>=20
>  fail_drop:
> -	DQUOT_DROP(inode);
> +	vfs_dq_drop(inode);
>  	inode->i_flags |=3D S_NOQUOTA;
>  	inode->i_nlink =3D 0;
>  	unlock_new_inode(inode);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 29f62a3..414134d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4619,7 +4619,7 @@ int ext4_setattr(struct dentry *dentry, struct =
iattr *attr)
>  			error =3D PTR_ERR(handle);
>  			goto err_out;
>  		}
> -		error =3D DQUOT_TRANSFER(inode, attr) ? -EDQUOT : 0;
> +		error =3D vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
>  		if (error) {
>  			ext4_journal_stop(handle);
>  			return error;
> @@ -4998,7 +4998,7 @@ int ext4_mark_inode_dirty(handle_t *handle, str=
uct inode *inode)
>   * i_size has been changed by generic_commit_write() and we thus nee=
d
>   * to include the updated inode in the current transaction.
>   *
> - * Also, DQUOT_ALLOC_SPACE() will always dirty the inode when blocks
> + * Also, vfs_dq_alloc_block() will always dirty the inode when block=
s
>   * are allocated to the file.
>   *
>   * If the inode is marked synchronous, we don't honour that here - d=
oing
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 84458a5..392d689 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4576,7 +4576,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handl=
e,
>  			return 0;
>  		}
>  		reserv_blks =3D ar->len;
> -		while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
> +		while (ar->len && vfs_dq_alloc_block(ar->inode, ar->len)) {
>  			ar->flags |=3D EXT4_MB_HINT_NOPREALLOC;
>  			ar->len--;
>  		}
> @@ -4652,7 +4652,7 @@ out2:
>  	kmem_cache_free(ext4_ac_cachep, ac);
>  out1:
>  	if (inquota && ar->len < inquota)
> -		DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
> +		vfs_dq_free_block(ar->inode, inquota - ar->len);
>  out3:
>  	if (!ar->len) {
>  		if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag)
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index fec0b4c..2943bf8 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2083,7 +2083,7 @@ static int ext4_rmdir(struct inode *dir, struct=
 dentry *dentry)
>=20
>  	/* Initialize quotas before so that eventual writes go in
>  	 * separate transaction */
> -	DQUOT_INIT(dentry->d_inode);
> +	vfs_dq_init(dentry->d_inode);
>  	handle =3D ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_=
sb));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
> @@ -2142,7 +2142,7 @@ static int ext4_unlink(struct inode *dir, struc=
t dentry *dentry)
>=20
>  	/* Initialize quotas before so that eventual writes go
>  	 * in separate transaction */
> -	DQUOT_INIT(dentry->d_inode);
> +	vfs_dq_init(dentry->d_inode);
>  	handle =3D ext4_journal_start(dir, EXT4_DELETE_TRANS_BLOCKS(dir->i_=
sb));
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
> @@ -2309,7 +2309,7 @@ static int ext4_rename(struct inode *old_dir, s=
truct dentry *old_dentry,
>  	/* Initialize quotas before so that eventual writes go
>  	 * in separate transaction */
>  	if (new_dentry->d_inode)
> -		DQUOT_INIT(new_dentry->d_inode);
> +		vfs_dq_init(new_dentry->d_inode);
>  	handle =3D ext4_journal_start(old_dir, 2 *
>  					EXT4_DATA_TRANS_BLOCKS(old_dir->i_sb) +
>  					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 439ab9d..a7b8cb1 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1804,7 +1804,7 @@ static void ext4_orphan_cleanup(struct super_bl=
ock *sb,
>  		}
>=20
>  		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
> -		DQUOT_INIT(inode);
> +		vfs_dq_init(inode);
>  		if (inode->i_nlink) {
>  			printk(KERN_DEBUG
>  				"%s: truncating inode %lu to %lld bytes\n",
> @@ -3367,8 +3367,8 @@ static int ext4_statfs(struct dentry *dentry, s=
truct kstatfs *buf)
>   * is locked for write. Otherwise the are possible deadlocks:
>   * Process 1                         Process 2
>   * ext4_create()                     quota_sync()
> - *   jbd2_journal_start()                   write_dquot()
> - *   DQUOT_INIT()                        down(dqio_mutex)
> + *   jbd2_journal_start()                  write_dquot()
> + *   vfs_dq_init()                         down(dqio_mutex)
>   *     down(dqio_mutex)                    jbd2_journal_start()
>   *
>   */
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 157ce65..62b31c2 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -490,7 +490,7 @@ ext4_xattr_release_block(handle_t *handle, struct=
 inode *inode,
>  		error =3D ext4_handle_dirty_metadata(handle, inode, bh);
>  		if (IS_SYNC(inode))
>  			ext4_handle_sync(handle);
> -		DQUOT_FREE_BLOCK(inode, 1);
> +		vfs_dq_free_block(inode, 1);
>  		ea_bdebug(bh, "refcount now=3D%d; releasing",
>  			  le32_to_cpu(BHDR(bh)->h_refcount));
>  		if (ce)
> @@ -784,7 +784,7 @@ inserted:
>  				/* The old block is released after updating
>  				   the inode. */
>  				error =3D -EDQUOT;
> -				if (DQUOT_ALLOC_BLOCK(inode, 1))
> +				if (vfs_dq_alloc_block(inode, 1))
>  					goto cleanup;
>  				error =3D ext4_journal_get_write_access(handle,
>  								      new_bh);
> @@ -860,7 +860,7 @@ cleanup:
>  	return error;
>=20
>  cleanup_dquot:
> -	DQUOT_FREE_BLOCK(inode, 1);
> +	vfs_dq_free_block(inode, 1);
>  	goto cleanup;
>=20
>  bad_block:

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
