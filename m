Return-Path: <SRS0=njA7=PY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36547 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729244AbfAPO2F (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jan 2019 09:28:05 -0500
Received: by mail-lf1-f67.google.com with SMTP id a16so5037185lfg.3
        for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2019 06:28:03 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] ext4: shrink directory when last block is empty
From: Alexey Lyashkov <umka@cloudlinux.com>
In-Reply-To: <20190115225546.206730-1-harshadshirwadkar@gmail.com>
Date: Wed, 16 Jan 2019 17:27:57 +0300
Cc: linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <36865E63-1C46-4F26-8EF0-D6372A7743E7@cloudlinux.com>
References: <20190115225546.206730-1-harshadshirwadkar@gmail.com>
To: harshadshirwadkar@gmail.com
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Harshad,

I quickly look to the patch, but as i see you have called a =
count_dentries - it have called on each delete entry.
If you have lots create/delete in loop for one block it=E2=80=99s costly =
and decrease a delete performance.
as i see it have used just for checking against zero, so can it be =
replaced with more simple check like is first dir entry cover a whole =
block ?


> 16 =D1=8F=D0=BD=D0=B2. 2019 =D0=B3., =D0=B2 1:55, =
harshadshirwadkar@gmail.com =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=
=B0):
>=20
> From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
>=20
> This patch is the first step towards shrinking htree based directories
> when files are deleted. We truncate directory inode when a directory
> entry removal causes last directory block to be empty. This patch just
> removes the last block. We may end up in a situation where many
> intermediate dirent blocks in directory inode are empty. Removing
> those blocks would be handled later.
>=20
> Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
> ---
> fs/ext4/namei.c | 146 +++++++++++++++++++++++++++++++++++++++++-------
> 1 file changed, 125 insertions(+), 21 deletions(-)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 2a4c25c4681d..bbcbd59c44ce 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -273,7 +273,8 @@ static int ext4_htree_next_block(struct inode =
*dir, __u32 hash,
> 				 __u32 *start_hash);
> static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
> 		struct ext4_filename *fname,
> -		struct ext4_dir_entry_2 **res_dir);
> +		struct ext4_dir_entry_2 **res_dir,
> +		struct dx_frame *dx_frame);
> static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename =
*fname,
> 			     struct inode *dir, struct inode *inode);
>=20
> @@ -380,6 +381,7 @@ static void ext4_dirent_csum_set(struct inode =
*inode,
> 					   (void *)t - (void *)dirent);
> }
>=20
> +
> int ext4_handle_dirty_dirent_node(handle_t *handle,
> 				  struct inode *inode,
> 				  struct buffer_head *bh)
> @@ -797,7 +799,7 @@ dx_probe(struct ext4_filename *fname, struct inode =
*dir,
> 	dxtrace(printk("Look up %x", hash));
> 	while (1) {
> 		count =3D dx_get_count(entries);
> -		if (!count || count > dx_get_limit(entries)) {
> +		if (count > dx_get_limit(entries)) {
> 			ext4_warning_inode(dir,
> 					   "dx entry: count %u beyond =
limit %u",
> 					   count, =
dx_get_limit(entries));
> @@ -866,6 +868,42 @@ dx_probe(struct ext4_filename *fname, struct =
inode *dir,
> 	return ret_err;
> }
>=20
> +static void
> +ext4_dx_delete_entry(handle_t *handle, struct inode *dir,
> +		     struct dx_frame *dx_frame, __le64 block)
> +{
> +	struct dx_entry *entries;
> +	unsigned int count, limit;
> +	int err, i;
> +
> +	entries =3D dx_frame->entries;
> +	count =3D dx_get_count(entries);
> +	limit =3D dx_get_limit(entries);
> +
> +	for (i =3D 0; i < count; i++)
> +		if (entries[i].block =3D=3D block)
> +			break;
> +
> +	if (i >=3D count)
> +		return;
> +
> +	err =3D ext4_journal_get_write_access(handle, dx_frame->bh);
> +	if (err) {
> +		ext4_std_error(dir->i_sb, err);
> +		return;
> +	}
> +
> +	for (; i < count - 1; i++)
> +		entries[i] =3D entries[i + 1];
> +
> +	dx_set_count(entries, count - 1);
> +	dx_set_limit(entries, limit);
> +
> +	err =3D ext4_handle_dirty_dx_node(handle, dir, dx_frame->bh);
> +	if (err)
> +		ext4_std_error(dir->i_sb, err);
> +}
> +
> static void dx_release(struct dx_frame *frames)
> {
> 	struct dx_root_info *info;
> @@ -1309,6 +1347,28 @@ int ext4_search_dir(struct buffer_head *bh, =
char *search_buf, int buf_size,
> 	return 0;
> }
>=20
> +static int count_dentries(char *search_buf, int buf_size,
> +			  unsigned int blocksize)
> +{
> +	struct ext4_dir_entry_2 *de;
> +	char *dlimit;
> +	int de_len;
> +	int count =3D 0;
> +
> +	de =3D (struct ext4_dir_entry_2 *)search_buf;
> +	dlimit =3D search_buf + buf_size;
> +	while ((char *)de < dlimit) {
> +		de_len =3D ext4_rec_len_from_disk(de->rec_len, =
blocksize);
> +		if (de_len <=3D 0)
> +			return count;
> +		if (de->inode !=3D 0)
> +			count++;
> +		de =3D (struct ext4_dir_entry_2 *)((char *)de + de_len);
> +	}
> +
> +	return count;
> +}
> +
> static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
> 			       struct ext4_dir_entry *de)
> {
> @@ -1339,7 +1399,8 @@ static int is_dx_internal_node(struct inode =
*dir, ext4_lblk_t block,
> static struct buffer_head * ext4_find_entry (struct inode *dir,
> 					const struct qstr *d_name,
> 					struct ext4_dir_entry_2 =
**res_dir,
> -					int *inlined)
> +					int *inlined,
> +					struct dx_frame *dx_frame)
> {
> 	struct super_block *sb;
> 	struct buffer_head *bh_use[NAMEI_RA_SIZE];
> @@ -1388,7 +1449,7 @@ static struct buffer_head * ext4_find_entry =
(struct inode *dir,
> 		goto restart;
> 	}
> 	if (is_dx(dir)) {
> -		ret =3D ext4_dx_find_entry(dir, &fname, res_dir);
> +		ret =3D ext4_dx_find_entry(dir, &fname, res_dir, =
dx_frame);
> 		/*
> 		 * On success, or if the error was file not found,
> 		 * return.  Otherwise, fall back to doing a search the
> @@ -1486,9 +1547,10 @@ static struct buffer_head * ext4_find_entry =
(struct inode *dir,
> 	return ret;
> }
>=20
> -static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
> -			struct ext4_filename *fname,
> -			struct ext4_dir_entry_2 **res_dir)
> +static struct buffer_head *ext4_dx_find_entry(
> +			struct inode *dir, struct ext4_filename *fname,
> +			struct ext4_dir_entry_2 **res_dir,
> +			struct dx_frame *dx_frame)
> {
> 	struct super_block * sb =3D dir->i_sb;
> 	struct dx_frame frames[EXT4_HTREE_LEVEL], *frame;
> @@ -1502,6 +1564,10 @@ static struct buffer_head * =
ext4_dx_find_entry(struct inode *dir,
> 	frame =3D dx_probe(fname, dir, NULL, frames);
> 	if (IS_ERR(frame))
> 		return (struct buffer_head *) frame;
> +	if (dx_frame) {
> +		*dx_frame =3D *frame;
> +		get_bh(dx_frame->bh);
> +	}
> 	do {
> 		block =3D dx_get_block(frame->at);
> 		bh =3D ext4_read_dirblock(dir, block, DIRENT);
> @@ -1553,7 +1619,7 @@ static struct dentry *ext4_lookup(struct inode =
*dir, struct dentry *dentry, unsi
> 	if (dentry->d_name.len > EXT4_NAME_LEN)
> 		return ERR_PTR(-ENAMETOOLONG);
>=20
> -	bh =3D ext4_find_entry(dir, &dentry->d_name, &de, NULL);
> +	bh =3D ext4_find_entry(dir, &dentry->d_name, &de, NULL, NULL);
> 	if (IS_ERR(bh))
> 		return (struct dentry *) bh;
> 	inode =3D NULL;
> @@ -1597,7 +1663,7 @@ struct dentry *ext4_get_parent(struct dentry =
*child)
> 	struct ext4_dir_entry_2 * de;
> 	struct buffer_head *bh;
>=20
> -	bh =3D ext4_find_entry(d_inode(child), &dotdot, &de, NULL);
> +	bh =3D ext4_find_entry(d_inode(child), &dotdot, &de, NULL, =
NULL);
> 	if (IS_ERR(bh))
> 		return (struct dentry *) bh;
> 	if (!bh)
> @@ -2337,9 +2403,13 @@ int ext4_generic_delete_entry(handle_t *handle,
> static int ext4_delete_entry(handle_t *handle,
> 			     struct inode *dir,
> 			     struct ext4_dir_entry_2 *de_del,
> -			     struct buffer_head *bh)
> +			     struct buffer_head *bh,
> +			     struct dx_frame *dx_frame)
> {
> +	struct ext4_map_blocks map;
> 	int err, csum_size =3D 0;
> +	int should_truncate =3D 0;
> +
>=20
> 	if (ext4_has_inline_data(dir)) {
> 		int has_inline_data =3D 1;
> @@ -2363,11 +2433,37 @@ static int ext4_delete_entry(handle_t *handle,
> 	if (err)
> 		goto out;
>=20
> +	if (dx_frame && dx_frame->bh &&
> +	    count_dentries(bh->b_data, bh->b_size,
> +			   dir->i_sb->s_blocksize) =3D=3D 0) {
> +
> +		map.m_lblk =3D (dir->i_size - 1) >>
> +			     (dir->i_sb->s_blocksize_bits);
> +		map.m_len =3D 1;
> +		err =3D ext4_map_blocks(handle, dir, &map, 0);
> +
> +		if ((err > 0) && (bh->b_blocknr =3D=3D map.m_pblk)) {
> +			ext4_dx_delete_entry(handle, dir, dx_frame,
> +					     cpu_to_le64(map.m_lblk));
> +			should_truncate =3D 1;
> +		}
> +	}
> +
> 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
> +
> 	err =3D ext4_handle_dirty_dirent_node(handle, dir, bh);
> 	if (unlikely(err))
> 		goto out;
>=20
> +	if (should_truncate) {
> +		dir->i_size -=3D dir->i_sb->s_blocksize;
> +		ext4_truncate(dir);
> +		if (dir->i_size =3D=3D dir->i_sb->s_blocksize) {
> +			ext4_clear_inode_flag(dir, EXT4_INODE_INDEX);
> +			ext4_mark_inode_dirty(handle, dir);
> +		}
> +	}
> +
> 	return 0;
> out:
> 	if (err !=3D -ENOENT)
> @@ -2923,7 +3019,7 @@ static int ext4_rmdir(struct inode *dir, struct =
dentry *dentry)
> 		return retval;
>=20
> 	retval =3D -ENOENT;
> -	bh =3D ext4_find_entry(dir, &dentry->d_name, &de, NULL);
> +	bh =3D ext4_find_entry(dir, &dentry->d_name, &de, NULL, NULL);
> 	if (IS_ERR(bh))
> 		return PTR_ERR(bh);
> 	if (!bh)
> @@ -2950,7 +3046,7 @@ static int ext4_rmdir(struct inode *dir, struct =
dentry *dentry)
> 	if (IS_DIRSYNC(dir))
> 		ext4_handle_sync(handle);
>=20
> -	retval =3D ext4_delete_entry(handle, dir, de, bh);
> +	retval =3D ext4_delete_entry(handle, dir, de, bh, NULL);
> 	if (retval)
> 		goto end_rmdir;
> 	if (!EXT4_DIR_LINK_EMPTY(inode))
> @@ -2985,6 +3081,9 @@ static int ext4_unlink(struct inode *dir, struct =
dentry *dentry)
> 	struct buffer_head *bh;
> 	struct ext4_dir_entry_2 *de;
> 	handle_t *handle =3D NULL;
> +	struct dx_frame dx_frame;
> +
> +	memset(&dx_frame, 0, sizeof(dx_frame));
>=20
> 	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
> 		return -EIO;
> @@ -3000,7 +3099,7 @@ static int ext4_unlink(struct inode *dir, struct =
dentry *dentry)
> 		return retval;
>=20
> 	retval =3D -ENOENT;
> -	bh =3D ext4_find_entry(dir, &dentry->d_name, &de, NULL);
> +	bh =3D ext4_find_entry(dir, &dentry->d_name, &de, NULL, =
&dx_frame);
> 	if (IS_ERR(bh))
> 		return PTR_ERR(bh);
> 	if (!bh)
> @@ -3028,9 +3127,10 @@ static int ext4_unlink(struct inode *dir, =
struct dentry *dentry)
> 				   dentry->d_name.len, =
dentry->d_name.name);
> 		set_nlink(inode, 1);
> 	}
> -	retval =3D ext4_delete_entry(handle, dir, de, bh);
> +	retval =3D ext4_delete_entry(handle, dir, de, bh, &dx_frame);
> 	if (retval)
> 		goto end_unlink;
> +
> 	dir->i_ctime =3D dir->i_mtime =3D current_time(dir);
> 	ext4_update_dx_flag(dir);
> 	ext4_mark_inode_dirty(handle, dir);
> @@ -3042,6 +3142,8 @@ static int ext4_unlink(struct inode *dir, struct =
dentry *dentry)
>=20
> end_unlink:
> 	brelse(bh);
> +	if (dx_frame.bh)
> +		brelse(dx_frame.bh);
> 	if (handle)
> 		ext4_journal_stop(handle);
> 	trace_ext4_unlink_exit(dentry, retval);
> @@ -3362,11 +3464,11 @@ static int ext4_find_delete_entry(handle_t =
*handle, struct inode *dir,
> 	struct buffer_head *bh;
> 	struct ext4_dir_entry_2 *de;
>=20
> -	bh =3D ext4_find_entry(dir, d_name, &de, NULL);
> +	bh =3D ext4_find_entry(dir, d_name, &de, NULL, NULL);
> 	if (IS_ERR(bh))
> 		return PTR_ERR(bh);
> 	if (bh) {
> -		retval =3D ext4_delete_entry(handle, dir, de, bh);
> +		retval =3D ext4_delete_entry(handle, dir, de, bh, NULL);
> 		brelse(bh);
> 	}
> 	return retval;
> @@ -3390,7 +3492,8 @@ static void ext4_rename_delete(handle_t *handle, =
struct ext4_renament *ent,
> 		retval =3D ext4_find_delete_entry(handle, ent->dir,
> 						&ent->dentry->d_name);
> 	} else {
> -		retval =3D ext4_delete_entry(handle, ent->dir, ent->de, =
ent->bh);
> +		retval =3D ext4_delete_entry(handle, ent->dir, ent->de, =
ent->bh,
> +					   NULL);
> 		if (retval =3D=3D -ENOENT) {
> 			retval =3D ext4_find_delete_entry(handle, =
ent->dir,
> 							=
&ent->dentry->d_name);
> @@ -3497,7 +3600,8 @@ static int ext4_rename(struct inode *old_dir, =
struct dentry *old_dentry,
> 			return retval;
> 	}
>=20
> -	old.bh =3D ext4_find_entry(old.dir, &old.dentry->d_name, =
&old.de, NULL);
> +	old.bh =3D ext4_find_entry(old.dir, &old.dentry->d_name, =
&old.de, NULL,
> +				 NULL);
> 	if (IS_ERR(old.bh))
> 		return PTR_ERR(old.bh);
> 	/*
> @@ -3511,7 +3615,7 @@ static int ext4_rename(struct inode *old_dir, =
struct dentry *old_dentry,
> 		goto end_rename;
>=20
> 	new.bh =3D ext4_find_entry(new.dir, &new.dentry->d_name,
> -				 &new.de, &new.inlined);
> +				 &new.de, &new.inlined, NULL);
> 	if (IS_ERR(new.bh)) {
> 		retval =3D PTR_ERR(new.bh);
> 		new.bh =3D NULL;
> @@ -3691,7 +3795,7 @@ static int ext4_cross_rename(struct inode =
*old_dir, struct dentry *old_dentry,
> 		return retval;
>=20
> 	old.bh =3D ext4_find_entry(old.dir, &old.dentry->d_name,
> -				 &old.de, &old.inlined);
> +				 &old.de, &old.inlined, NULL);
> 	if (IS_ERR(old.bh))
> 		return PTR_ERR(old.bh);
> 	/*
> @@ -3705,7 +3809,7 @@ static int ext4_cross_rename(struct inode =
*old_dir, struct dentry *old_dentry,
> 		goto end_rename;
>=20
> 	new.bh =3D ext4_find_entry(new.dir, &new.dentry->d_name,
> -				 &new.de, &new.inlined);
> +				 &new.de, &new.inlined, NULL);
> 	if (IS_ERR(new.bh)) {
> 		retval =3D PTR_ERR(new.bh);
> 		new.bh =3D NULL;
> --=20
> 2.20.1.97.g81188d93c3-goog
>=20
