Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793278684;
	b=tolVHo2eZA/ORGLYU7d+wRyQyLerlq2+cGzFGANWKkaT2FMj8eEcW+rIT7Z7t5s/IcBa
	 QsBNfseh/TYeN5FUjk/JkQGY3dZhlojMcLLJErRShuJHCx86ZKO6WpSLThpJfVxTMcEMo
	 ZU2dZwB9JvBd/9SOGU57k96/6ixM1fzH50dKcL8jpBoXXKN6/6wodf6waVSewdgZcjsM2
	 mR7DzjfbJeit04/CFePe8RC2eD0phLucX5DVeJFSpQ6Ur+Ptgs2nr3X2i0Zpe3RLuShcb
	 8qopMb7HXLGyIHZySwY+CD5PXkVEc71S/m+iG/JltTj5Q6Vu8vPrDvRk7sJYjNfM8Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793278684;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sf6Q8Fo7Yxb+sGNJLWu0p9GOQg7QuSGqsNqufx60JVE=;
	b=sOBiiEU78qS8zdK+9X1YiWP9GMvUWt2lpCv7JLQxlxWiUTNSG+QFrEKOqIQey1ZpZWAZ
	 7KVpzPwqYWwhrFCJCtNKfJ2+GwmGj3vJcWB5mqqgapsMzAdEArzOmzbeiTNik/abfll4l
	 R5MIaqWWxMn/vxhJzW4+mmXA1FaYdWntLG4lskVs996qOji2qqUL5SfBBZHYgKfzsLaFe
	 Sbj/FV1deyhE/cVaVsvlw7YQB6RG9dajt1Hn30DJnWgKwdUgf8IGucT9BiG0vGWARKuug
	 ShKKHYZiSZTQomGmdGDWaNmHt/s4vJXMei13J+wMoMC+OEOpU3hO25vBDcZgGTrvPpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dpLwNEYq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FF4606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dpLwNEYq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73371F01825;
	Thu, 29 Oct 2026 12:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793278683;
	bh=sf6Q8Fo7Yxb+sGNJLWu0p9GOQg7QuSGqsNqufx60JVE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dpLwNEYq5St6gK/iX9k9gIOLVqPWY/pqn3lEiDsUDuA2arm9xKWMW+ucbO5xY6jg9
	 02Y1B+6zxiZ/0Rl2iEcLxKrOt/fPitnKHgzicoq+Q2WC2XOZIHLah3Xw2jcRY9PfqY
	 NpWULTIrh91640L9hwpXRKMazm2sd/RUWt0EZpYf3Fw/csr+VO7j6OClFNkn2g6+Tu
	 ExjR6CCSM3RZMjfSEs5oCcZFG8iIQ7EispkrExBiKFkxH7a8Gqy2GdtrkK4emd5xVF
	 FuicH6fhT88JachA4Wb86Ho0yh9REW+t4hZRAiFsJBhPXRghbKfH9BkIHw9I8pLNDZ
	 jZnZyf6/rR6BQ==
Message-ID: <sashiko-outbox-189337@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 11/11] ext4: Add EXT4_IOC_SET_LUFID ioctl for
 setting LUFID on directory entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261029122413.230409-12-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
 <20261029122413.230409-12-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:58:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 9 potential issue(=
s) to consider:
- [Critical] ext4: buffer overflow in ext4_insert_dentry_data() with large =
LUFID entries
- [High] ext4: missing dquot_initialize() in ext4_dirdata_set_lufid()
- [High] ext4: silent LUFID loss and inode orphan risk in ext4_dirdata_set_=
lufid()
- [High] ext4: ext4_dirdata_set_lufid() deletes dirent before strict UTF-8 =
check
- [High] ext4: directory entry corruption in ext4_rename() whiteout rollback
- [Medium] ext4: ext4_dirdata_set_lufid() changes filename case on encrypte=
d casefold dirs
- [Medium] ext4: inconsistent dirent length and offset calculation in dx_ge=
t_dx_info()
- [Medium] ext4: missing IS_DIRSYNC() check in ext4_dirdata_set_lufid()
- [Medium] ext4: potential i_rwsem deadlock on subdir in ext4_dirdata_set_l=
ufid()
--

commit cdb77af430b2349668752f74c28aae8c30a2dce5
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries

This commit adds the EXT4_IOC_SET_LUFID ioctl and ext4_dirdata_set_lufid() =
to
set LUFID dirdata on an existing directory entry by looking up the target
entry, deleting it, and re-creating it with the LUFID payload attached.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 5a118320eef9b..4ab1f14442b09 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -543,11 +543,13 @@ static struct dx_root_info *dx_get_dx_info(struct i=
node *dir, void *de_buf)
>  {
>  	unsigned int blocksize =3D dir->i_sb->s_blocksize;
>  	void *base =3D de_buf;
> +	unsigned int rlen;
> =20
>  	/* '.' and '..' never carry the casefold+fscrypt hash, so pass NULL
>  	 * for dir regardless of the directory's flags */
> -	if (ext4_rec_len_from_disk(((struct ext4_dir_entry_2 *)de_buf)->rec_len,
> -				   blocksize) < EXT4_BASE_DIR_LEN)
> +	rlen =3D ext4_rec_len_from_disk(((struct ext4_dir_entry_2 *)de_buf)->re=
c_len,
> +				      blocksize);
> +	if (rlen < EXT4_BASE_DIR_LEN || rlen > blocksize)
>  		return ERR_PTR(-EFSCORRUPTED);
>  	de_buf +=3D ext4_dir_entry_len(de_buf, blocksize, NULL);
> =20
> @@ -555,6 +557,11 @@ static struct dx_root_info *dx_get_dx_info(struct in=
ode *dir, void *de_buf)
>  	if (de_buf < base || (char *)de_buf - (char *)base +
>  	    EXT4_BASE_DIR_LEN > blocksize)
>  		return ERR_PTR(-EFSCORRUPTED);
> +	rlen =3D ext4_rec_len_from_disk(((struct ext4_dir_entry_2 *)de_buf)->re=
c_len,
> +				      blocksize);
> +	if (rlen < EXT4_BASE_DIR_LEN ||
> +	    (char *)de_buf - (char *)base + rlen > blocksize)
> +		return ERR_PTR(-EFSCORRUPTED);
>  	de_buf +=3D ext4_dir_entry_len(de_buf, blocksize, NULL);

[Severity: Medium]
In dx_get_dx_info(), rlen (from de->rec_len) is validated for both "." and
"..", but de_buf is still advanced by ext4_dir_entry_len(de_buf, blocksize,
NULL) without checking that ext4_dir_entry_len() <=3D rlen.

Meanwhile, get_dx_countlimit() and make_indexed_dir() locate ".." by steppi=
ng
over "." using dot_de->rec_len (rlen), and both ext4_check_dir_entry() and
ext4_check_dx_root() permit dot_de->rec_len > ext4_dir_entry_len(dot_de).

If "." has slack space (or a corrupted name_len where ext4_dir_entry_len() >
rlen), in make_indexed_dir() after bh2 is allocated, EXT4_INODE_INDEX is set
on dir, and entries after ".." are cleared from block 0, dx_get_dx_info() w=
ill
step into the slack space of "." instead of dotdot_de at offset rlen. Could
this either return -EFSCORRUPTED (leaving EXT4_INODE_INDEX set on a wiped r=
oot
block) or return a dx_root_info pointer that overlaps dotdot_de and corrupts
the root block?

Also, while this commit guards ext4_dirent_get_data_len() with
ext4_has_feature_dirdata() in ext4_htree_store_dirent(), ext4_dir_entry_len=
()
in fs/ext4/ext4.h still calls ext4_dirent_get_data_len() unconditionally (a=
nd
receives dir =3D=3D NULL here and in get_dx_countlimit()). Should
ext4_dir_entry_len() check ext4_has_feature_dirdata() as well, and should
dx_get_dx_info() verify ext4_dir_entry_len() <=3D rlen (and advance past ".=
" by
rlen)?

[ ... ]

> @@ -2374,9 +2392,9 @@ int ext4_find_dest_de(struct inode *dir, struct buf=
fer_head *bh,
>  	return 0;
>  }
> =20
> -void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
> -			     struct ext4_dir_entry_2 *de, int buf_size,
> -			     struct ext4_filename *fname, void *data)
> +int ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
> +			    struct ext4_dir_entry_2 *de, int buf_size,
> +			    struct ext4_filename *fname, void *data)
>  {
>  	int nlen, rlen;
> =20
> @@ -2394,7 +2412,7 @@ void ext4_insert_dentry_data(struct inode *dir, str=
uct inode *inode,
>  	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
>  	de->name_len =3D fname_len(fname);
>  	memcpy(de->name, fname_name(fname), fname_len(fname));
> -	ext4_dirdata_set(de, dir, data, fname);
> +	return ext4_dirdata_set(de, dir, data, fname);
>  }
> =20
>  /*
> @@ -2446,7 +2464,11 @@ static int add_dirent_to_buf(handle_t *handle, str=
uct ext4_filename *fname,
>  	}
> =20
>  	/* By now the buffer is marked for journaling */
> -	ext4_insert_dentry_data(dir, inode, de, blocksize, fname, dfid);
> +	err =3D ext4_insert_dentry_data(dir, inode, de, blocksize, fname, dfid);
> +	if (err) {
> +		ext4_std_error(dir->i_sb, err);
> +		return err;
> +	}

[Severity: Critical]
Can this overflow bh->b_data or corrupt the directory block in
ext4_insert_dentry_data() when splitting a 1024-byte directory block contai=
ning
large LUFID entries?

In fs/ext4/ioctl.c:ext4_ioctl_set_lufid(), esl_name_len can be up to 255 by=
tes
and esl_data_len can be up to 254 bytes (ddh_length =3D 255):

	if (lufid_args.esl_name_len =3D=3D 0 || lufid_args.esl_name_len > EXT4_NAM=
E_LEN)
		return -EINVAL;

	if (lufid_args.esl_data_len =3D=3D 0 ||
	    lufid_args.esl_data_len > 255 - sizeof(edp.df_header))
		return -EINVAL;

Including EXT4_BASE_DIR_LEN (8), the 1-byte NUL separator, and an optional
9-byte CFHASH (when casefold and encryption are enabled), a single directory
entry can now require up to 520 bytes (or 528 bytes with CFHASH).

When adding an entry overflows a leaf block, make_indexed_dir() and
ext4_dx_add_entry() call do_split() and pass its returned tail entry de
(non-NULL) to add_dirent_to_buf(handle, fname, dir, inode, de, bh). Because=
 de
is non-NULL, add_dirent_to_buf() skips ext4_find_dest_de() and calls
ext4_insert_dentry_data() directly without verifying that rlen - nlen in de=
 can
hold the new entry:

	/* Ensure that neither split block is over half full */
	size =3D 0;
	move =3D 0;
	for (i =3D count-1; i >=3D 0; i--) {
		/* is more than half of this entry in 2nd half of the block? */
		if (size + map[i].size/2 > blocksize/2)
			break;
		size +=3D map[i].size;
		move++;
	}

On a 1024-byte blocksize filesystem (blocksize / 2 =3D 512, usable space =
=3D 1012
bytes with metadata_csum), do_split() relies on the assumption that a direc=
tory
entry is at most 264 bytes. With entries up to 520-528 bytes:

1. If a leaf block holds a single entry >=3D 496 bytes (count =3D=3D 1) and=
 a second
~520-byte entry is added, map[0].size / 2 <=3D 512 gives move =3D 1 and spl=
it =3D
count - move =3D 0 (with fallback split =3D count / 2 =3D 0), triggering
WARN_ON_ONCE(split =3D=3D 0), ext4_error_inode_block(), and -EFSCORRUPTED.

2. If a leaf block contains 3 entries of sizes 240, 520 (with LUFID), and 2=
52
bytes (total 1012), do_split() moves both the 252-byte and 520-byte entries
into data2 (since 252 + 520/2 =3D 512 <=3D 512), occupying 772 bytes in dat=
a2 and
leaving only rlen - nlen =3D 240 bytes free at offset 772 (only 252 bytes b=
efore
the end of the 1024-byte bh2->b_data buffer). When the new entry hashes to
data2 with fname_len(fname) =3D=3D 255, ext4_insert_dentry_data() places de=
1 at
offset 772 and calls memcpy(de->name, fname_name(fname), 255) at offset 780
without checking rlen - nlen, overwriting ext4_dir_entry_tail and writing 11
bytes past the end of bh2->b_data.

3. Even when rlen - nlen >=3D 8 + fname_len(fname) so memcpy(de->name, ...)=
 stays
within bh->b_data, if rlen - nlen is smaller than the full entry size with
LUFID/CFHASH (for example, 496 bytes free vs 520 bytes needed),
ext4_insert_dentry_data() has already mutated the journaled buffer in-place
(shrinking de->rec_len and writing de1->inode, de1->file_type, de1->name_le=
n,
and de1->name) before ext4_dirdata_set() returns -EIO and add_dirent_to_buf=
()
calls ext4_std_error(dir->i_sb, err). That leaves a half-written active dir=
ent
in the block and causes the rollback ext4_add_entry() in
ext4_dirdata_set_lufid() to fail with -EEXIST.

[ ... ]

> @@ -4581,6 +4609,21 @@ static int ext4_rename(struct mnt_idmap *idmap, st=
ruct inode *old_dir,
>  	ext4_lufid_snap_release(&old_snap);
>  	if (whiteout) {
>  		if (retval) {
> +			/* Known limitation: if the old entry carried both LUFID
> +			 * and CFHASH, ext4_setent_compact_exts() slid CFHASH
> +			 * into the LUFID slot above, and old_snap was released
> +			 * before this point, so resetent can only restore the
> +			 * LUFID flag =E2=80=94 not the original byte layout.  This
> +			 * leaves the entry with CFHASH data at the LUFID offset
> +			 * and garbage at the CFHASH offset until the next
> +			 * SET_LUFID ioctl re-writes it.  The scenario requires
> +			 * RENAME_WHITEOUT on a casefolded+encrypted dirdata
> +			 * directory whose entry has a LUFID, followed by a
> +			 * journal IO error in the single ext4_mark_inode_dirty()
> +			 * call that follows =E2=80=94 an extremely unlikely combination
> +			 * in practice.  (OOM during the LUFID wrapper allocation
> +			 * cannot trigger this path because that allocation is
> +			 * hoisted before ext4_setent() modifies the entry.) */
>  			ext4_resetent(handle, &old,
>  				      old.inode->i_ino, old_file_type);
>  			drop_nlink(whiteout);

[Severity: High]
Does this whiteout rollback path in ext4_rename() permanently corrupt old.de
even without a journal IO error, and can SET_LUFID actually recover it?

After the whiteout block in ext4_rename() calls ext4_setent() (which calls
ext4_setent_compact_exts() and slides the 9-byte CFHASH into the LUFID slot=
 at
loff) and ext4_mark_inode_dirty(handle, whiteout), execution continues to:

	if (!new.bh) {
		new.dentry->d_fsdata =3D edp;
		retval =3D ext4_add_entry(handle, new.dentry, old.inode);
		new.dentry->d_fsdata =3D NULL;
		if (retval)
			goto end_rename;

If ext4_add_entry() fails under normal conditions such as -ENOSPC or -EDQUOT
when allocating a block for the destination directory, it jumps to end_rena=
me.
At end_rename, ext4_lufid_snap_release(&old_snap) frees old_snap before the
if (whiteout) block runs, and ext4_resetent() calls ext4_setent() with dfid=
 =3D=3D
NULL, which restores the EXT4_DIRENT_LUFID flag in old.de->file_type while =
the
9-byte CFHASH (with dh_header.ddh_length =3D=3D 9) is still sitting at the =
LUFID
offset loff.

Once that happens, any subsequent lookup (including ext4_find_entry() in
ext4_dirdata_set_lufid()) calls ext4_match() -> ext4_dirdata_get(), which s=
kips
9 bytes for LUFID and reads stale bytes at loff + 9 as the CFHASH. Doesn't =
the
hash check in ext4_match() then fail on every lookup, making the entry
permanently unreachable to lookup, unlink, or EXT4_IOC_SET_LUFID while leav=
ing
the directory non-empty? Why not pass old_snap.fid to ext4_resetent() and
release old_snap afterwards?

> @@ -4793,6 +4836,266 @@ static int ext4_rename2(struct mnt_idmap *idmap,
>  	return ext4_rename(idmap, old_dir, old_dentry, new_dir, new_dentry, fla=
gs);
>  }
> =20
> +/*
> + * ext4_dirdata_set_lufid() - Set LUFID data on an existing directory en=
try
> + * @dir:        parent directory inode
> + * @filename:   name of the file in the directory
> + * @namelen:    length of filename
> + * @edp:        pointer to initialized dentry param with LUFID data
> + *
> + * This function finds an existing directory entry, deletes it, and re-c=
reates it
> + * with LUFID data attached. Used by the EXT4_IOC_SET_LUFID ioctl.
> + *
> + * Returns 0 on success, negative error code on failure.
> + */
> +int ext4_dirdata_set_lufid(struct mnt_idmap *idmap, struct inode *dir,
> +			    const char *filename, int namelen,
> +			    struct ext4_dentry_param *edp)
> +{

[ ... ]

> +	d_name.name =3D filename;
> +	d_name.len =3D namelen;
> +
> +	err =3D ext4_fname_setup_filename(dir, &d_name, 0, &fname);
> +	if (err)
> +		goto out_free;
> +
> +	/* Lock dir with the VFS parent-mutation subclass.  The lookup and any
> +	 * mutation must be inside this lock to prevent TOCTOU races. */
> +	inode_lock_nested(dir, I_MUTEX_PARENT);

[Severity: High]
Should ext4_dirdata_set_lufid() call dquot_initialize(dir) before starting =
the
journal transaction?

Opening a directory via ext4_dir_open() and looking up an inode via ext4_ig=
et()
do not initialize quotas on dir, leaving dir->i_dquot[] entries NULL if no
prior VFS mutation has initialized them. Every other directory-mutating
operation in fs/ext4/namei.c calls dquot_initialize(dir) before
ext4_journal_start().

When ext4_dirdata_set_lufid() deletes the entry and re-adds it with LUFID d=
ata
via ext4_add_entry(), the larger entry may not fit in existing inline data =
or
directory blocks, causing ext4_add_entry() to allocate new directory blocks
(via ext4_convert_inline_data_nolock(), make_indexed_dir(), do_split(), or
ext4_append()). Without dquot_initialize(dir), dquot_alloc_block(dir, ...)
skips quota enforcement and does not charge the allocated blocks while
dir->i_blocks is incremented, which allows bypassing quota limits and causes
quota counter underflow (and warnings in dquot_free_space_nodirty() or
ext4_expand_extra_isize_ea()) when quotas on dir are later initialized and =
the
blocks are freed.

[ ... ]

> +	/* Lock the target inode BEFORE starting the journal (dir-then-child,
> +	 * VFS-locks-before-journal ordering).  Use I_MUTEX_CHILD for directory
> +	 * inodes (consistent with VFS rename/rmdir) and I_MUTEX_NONDIR2 for
> +	 * all others; mixing subclasses on the same inode triggers lockdep
> +	 * cycles with concurrent rename. */
> +	if (inode !=3D dir) {
> +		if (S_ISDIR(inode->i_mode))
> +			inode_lock_nested(inode, I_MUTEX_CHILD);
> +		else
> +			inode_lock_nested(inode, I_MUTEX_NONDIR2);
> +		child_locked =3D true;
> +	}

[Severity: Medium]
Can locking a directory inode with inode_lock_nested(inode, I_MUTEX_CHILD) =
here
cause an AB-BA deadlock on i_rwsem if a corrupted on-disk directory entry in
dir references an ancestor directory?

In normal VFS path walks, ext4_lookup() -> d_splice_alias() checks
d_ancestor() under rename_lock and rejects directory loops with -ELOOP befo=
re
callers like vfs_rmdir() or vfs_rename() lock the child directory inode. He=
re,
ext4_dirdata_set_lufid() reads ino directly from the on-disk de->inode via
ext4_find_entry() and ext4_iget() while holding dir->i_rwsem, bypassing dca=
che
ancestor checks and sb->s_vfs_rename_mutex. If de->inode points to an ances=
tor
directory, locking inode->i_rwsem while holding dir->i_rwsem inverts the
ancestor-before-descendant locking order against concurrent path walks, rmd=
ir,
or rename.

Since deleting and re-adding the entry within the same parent directory only
mutates dir's blocks and does not modify a child directory inode, its i_nli=
nk,
or its ".." entry (similar to same-directory rename in vfs_rename() where
lock_old_subdir is false when new_dir =3D=3D old_dir), is locking a subdire=
ctory
inode needed here at all?

> +
> +	handle =3D ext4_journal_start(dir, EXT4_HT_DIR,
> +				    3 * EXT4_DATA_TRANS_BLOCKS(sb) +
> +				    2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS);
> +	if (IS_ERR(handle)) {
> +		err =3D PTR_ERR(handle);
> +		handle =3D NULL;
> +		goto out_unlock;
> +	}

[Severity: Medium]
Should ext4_dirdata_set_lufid() check IS_DIRSYNC(dir) and call
ext4_handle_sync(handle) after starting the transaction, as the other
directory-mutating operations in fs/ext4/namei.c do? Without it, neither
ext4_delete_entry() nor ext4_add_entry() marks the handle synchronous, so
ext4_journal_stop() will return without committing the transaction on a
synchronous directory.

[ ... ]

> +	/* Choose the name to use for re-adding the entry after deletion.
> +	 *
> +	 * For non-encrypted casefolded directories ext4_find_entry() matches
> +	 * case-insensitively, so de->name may differ in case from the
> +	 * caller-supplied filename.  Re-adding with the caller's case would
> +	 * silently rename the entry, so preserve the on-disk bytes.
> +	 *
> +	 * For encrypted directories (with or without casefold) de->name holds
> +	 * the raw ciphertext.  ext4_fname_setup_filename() deterministically
> +	 * re-encrypts d_name (the plaintext) to the identical ciphertext, so
> +	 * using d_name for the re-add is correct.  Passing the raw ciphertext
> +	 * bytes would cause double-encryption and make the entry unreachable. =
*/
> +	if (IS_CASEFOLDED(dir) && !IS_ENCRYPTED(dir)) {
> +		memcpy(ondisk_name, de->name, de->name_len);
> +		real_name.name =3D ondisk_name;
> +		real_name.len =3D de->name_len;
> +		add_name =3D &real_name;
> +	} else {
> +		add_name =3D &d_name;
> +	}

[Severity: Medium]
When both IS_CASEFOLDED(dir) and IS_ENCRYPTED(dir) are true, doesn't using
add_name =3D &d_name overwrite the on-disk filename's case with the caller's
case?

In ext4_fname_setup_filename(), fscrypt_setup_filename() encrypts the exact
un-casefolded plaintext name (for example, "FooBar" -> Enc("FooBar")), while
ext4_fname_setup_ci_filename() computes the hash of the casefolded name
("foobar") for CFHASH. When ext4_find_entry() is called with d_name =3D "fo=
obar",
ext4_match() matches the CFHASH and generic_ci_match() decrypts de->name to
"FooBar" and matches it case-insensitively.

Because fscrypt encryption is deterministic on the exact plaintext bytes ra=
ther
than the casefolded bytes, re-adding the entry with add_name =3D &d_name wi=
ll
encrypt "foobar" into Enc("foobar") !=3D Enc("FooBar"), silently changing t=
he
on-disk filename's casing (and potentially its byte length for multi-byte U=
TF-8
casefold mappings) and leaving any cached positive dentry in the VFS dcache=
 out
of sync with the on-disk entry.

> +
> +	/* Snapshot the old LUFID before deleting so we can restore it if the
> +	 * re-add fails.  Without this the rollback path re-adds the entry
> +	 * without any LUFID, silently orphaning the old FID-to-path mapping. */
> +	err =3D ext4_lufid_snapshot(de, sb->s_blocksize, &old_snap);
> +	if (err)
> +		goto out_brelse;
> +
> +	err =3D ext4_delete_entry(handle, dir, de, bh);
> +	if (err)
> +		goto out_brelse;
> +
> +	brelse(bh);
> +	bh =3D NULL;
> +
> +	/* Re-add with LUFID via dentry->d_fsdata.  ext4_add_entry() resolves
> +	 * dfid from d_fsdata into fname.dfid and passes it through to
> +	 * add_dirent_to_buf() without touching the shared i_dirdata field,
> +	 * eliminating the race with concurrent link() calls. */
> +	{
> +		struct dentry parent_dentry =3D { .d_inode =3D dir };
> +		struct dentry new_dentry =3D {
> +			.d_name =3D *add_name,
> +			.d_parent =3D &parent_dentry,
> +			.d_inode =3D inode,
> +			.d_fsdata =3D edp,
> +		};
> +		err =3D ext4_add_entry(handle, &new_dentry, inode);
> +	}

[Severity: High]
What happens on a casefolded directory with strict encoding enabled
(SB_ENC_STRICT_MODE_FL) if an existing entry has invalid UTF-8 bytes in its
name (for instance, created before strict encoding was enabled)?

In ext4_dirdata_set_lufid(), ext4_fname_setup_filename() ->
ext4_fname_setup_ci_filename() ignores utf8_casefold() failure by setting
cf_name->name =3D NULL and returning 0, and ext4_find_entry() ->
generic_ci_match() matches the existing entry via its exact byte-for-byte
memcmp() fast path without checking sb_has_strict_encoding().

However, after ext4_delete_entry() deletes the entry from the directory,
ext4_add_entry() -> __ext4_add_entry() checks:

	if (!generic_ci_validate_strict_name(dir, d_name))
		return -EINVAL;

Both the primary ext4_add_entry(handle, &new_dentry, inode) and the rollback
ext4_add_entry(handle, &orig_dentry, inode) will then deterministically fail
with -EINVAL, triggering EXT4_ERROR_INODE() and leaving the directory entry
deleted and the target inode orphaned. Should generic_ci_validate_strict_na=
me()
be checked before calling ext4_delete_entry()?

> +
> +	if (err) {
> +		/* Delete succeeded but re-add failed; try to restore so the
> +		 * inode is not left without a directory entry.  Restore the
> +		 * original LUFID too: without it the entry is re-added clean
> +		 * and the old FID-to-path mapping is silently lost. */
> +		struct dentry parent_dentry =3D { .d_inode =3D dir };
> +		struct dentry orig_dentry =3D {
> +			.d_name =3D *add_name,
> +			.d_parent =3D &parent_dentry,
> +			.d_inode =3D inode,
> +		};
> +		int rollback_err;
> +
> +		if (old_snap.fid) {
> +			unsigned int fid_size =3D old_snap.fid->df_header.ddh_length;
> +			struct ext4_dentry_param *old_edp =3D
> +				kmalloc(sizeof(*old_edp) + fid_size, GFP_NOFS);
> +
> +			if (old_edp) {
> +				old_edp->edp_magic =3D EXT4_LUFID_MAGIC;
> +				memcpy(old_edp->edp_dfid, old_snap.fid, fid_size);
> +				orig_dentry.d_fsdata =3D old_edp;
> +			}
> +		}
> +
> +		rollback_err =3D ext4_add_entry(handle, &orig_dentry, inode);
> +		kfree(orig_dentry.d_fsdata);
> +
> +		if (rollback_err)
> +			EXT4_ERROR_INODE(dir,
> +				"Failed to set LUFID on '%.*s' (err=3D%d) and failed to restore the =
original directory entry (err=3D%d); inode %llu may be orphaned",
> +				namelen, filename, err, rollback_err,
> +				(unsigned long long)inode->i_ino);
> +		goto out_journal;
> +	}

[Severity: High]
Why is old_edp allocated with kmalloc(..., GFP_NOFS) after ext4_delete_entr=
y()
has already removed the entry, rather than being pre-allocated before the
deletion like edp in ext4_rename()?

If the primary ext4_add_entry() fails (for example with -ENOSPC, -EDQUOT, or
-ENOMEM) and the GFP_NOFS allocation of old_edp returns NULL,
orig_dentry.d_fsdata remains NULL and the rollback ext4_add_entry() silently
re-adds the entry without its original LUFID.

Also, ext4_dirdata_set_lufid() calls ext4_fname_setup_filename(dir, &d_name=
, 0,
&fname) at the start of the function, but fname is never used. Instead,
ext4_add_entry() -> __ext4_add_entry() calls ext4_fname_setup_filename() ag=
ain
under GFP_NOFS during both the re-add and the rollback after the entry has
already been deleted. If the rollback ext4_add_entry() fails (for instance =
due
to -ENOMEM in ext4_fname_setup_filename()), ext4_journal_stop() still commi=
ts
the transaction with the directory entry deleted and without updating
inode->i_nlink or adding inode to the orphan list. Could old_edp and the
filename buffers be prepared before ext4_delete_entry() so rollback does not
depend on post-deletion allocations?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029122413.2304=
09-1-ablagodarenko@thelustrecollective.com?part=3D11
