Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716159;
	b=ER1r0yzLl12JJe/HV/4iihO+BPeDoDQWluoqaDQDoxJ4l+01/uBeRsTcRnDswccC+dWE
	 hVTMwmP9DdvJLr93dMywz7y1KA5LwU/vYk/bZMYmcOjvIi101EhGgfrSw6XO+CstqpE+I
	 WMrRn3Be9h0PbKSa7+WcBAlI00GK3pfwCwnVMxU+/wvSUpGJUWy7yKdHbRyys7DjknINr
	 pnsAjVg6lovL2JVoyARfbVkUm2DNkGnRV4vQW3tW+OzbIhSJGRzBLTZsyIWJnEVxPL0H7
	 qCf5D0hFd5xyNHQHA/UzLk1bS5Usp46beRN2U9aQ5QVgBeZJ6fB9Q62cbNVoBPV/dpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716159;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+yotjTI5QtFSsjQAOhX2FVuMDXwLDvOHD62TG6chYkM=;
	b=UjUxXF4dQcKN4z19LkrJVLtZzg55Kunz6Hw51a1+sbOKuw8IRB0pe2fja/3L3nWAeUrr
	 cWcYu/Wt/iUvPrCXzuEmAlmS1jwBguLaUnj4M2QqTbUpb0/CTyzkNBM/7wQlHSro6rcNP
	 6510RMWcfhV7+Gp5iXQBhue1bzXuT4JI5UkrcyXwo71W0KD2jqaae0/P4edyKMGEH7KL9
	 Joazst9GuGxQkhqE6dMlxImMbrsTZ/4pUFVmM4eX4LSlcKrHTi1tgJdFEe91rvdO7Zgs+
	 hWL+ayc4uY5eAuXVshkkSxkBOOXX+77H3hHFp6ivPZ7isBP0THzNvrELPDXRSWiDioQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aK6hATII;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E1A606A324
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 14:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aK6hATII
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86961F00919;
	Tue,  3 Nov 2026 14:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793716158;
	bh=+yotjTI5QtFSsjQAOhX2FVuMDXwLDvOHD62TG6chYkM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aK6hATIIqBKKtDH4Y1WoUWYucGLuXaDFprIyz2shsMcUGiMiKscqPgE7lweL2sAUj
	 tTQqTaDFEDC63KahZeztn2OJ4w5MZ+YbnZK/N/Z5AohlZCShRgPWd6JNnVvE653OOG
	 o/7Vvi77ZfXD4s6YwSjVtqQqzJEAIwqQV3pG16wht9ZMqHl3I3oQewL0UbSZ4pY3ds
	 NGt0N/lB8CgiLT6M5ukQ8ygU0O7mgzd5WUflPEGcMDI5KL0ViA8ZyUAhbh30u/Q3a1
	 8fFPS7s511pAJeh8JbQCn0QBl1n+AyfhHTSxtHlqHeISAw2NRORQMCihpj+cX3hbUD
	 Nu4XOs1eQXBdA==
Message-ID: <sashiko-outbox-195448@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 12/12] ext4: Add EXT4_IOC_SET_LUFID ioctl for
 setting LUFID on directory entries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-13-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-13-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:29:17 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] ext4: rollback in ext4_dirdata_set_lufid() can fail and lose d=
irectory entry
- [High] ext4: premature fscrypt_has_encryption_key() check in ext4_dirdata=
_set_lufid()
- [Medium] ext4: missing validation of looked-up inode in ext4_dirdata_set_=
lufid()
- [Medium] ext4: check_sticky() positive return value leaked in ext4_dirdat=
a_set_lufid()
--

commit 8661288e629af06ada9624f600ed1251cebe9539
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries

This commit introduces the EXT4_IOC_SET_LUFID ioctl and
ext4_dirdata_set_lufid() to attach LUFID dirdata to existing directory
entries by looking up the entry, deleting it, and re-creating it with the
LUFID payload.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 8f1a6c000373e..68c5caff4707e 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c

[ ... ]

> @@ -4825,6 +4858,245 @@ static int ext4_rename2(struct mnt_idmap *idmap,
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
> +			   const char *filename, int namelen,
> +			   struct ext4_dentry_param *edp)
> +{
> +	struct super_block *sb =3D dir->i_sb;
> +	/* zero-init: safe to free on any path */
> +	struct ext4_filename new_fname =3D {}, old_fname =3D {};
> +	struct ext4_dir_entry_2 *de =3D NULL;
> +	struct buffer_head *bh =3D NULL;
> +	struct inode *inode =3D NULL;
> +	handle_t *handle =3D NULL;
> +	struct ext4_lufid_snap old_snap =3D {};
> +	struct qstr d_name =3D QSTR_INIT(filename, namelen);
> +	/* the name as stored on disk, for casefolded directories */
> +	struct fscrypt_str stored =3D FSTR_INIT(NULL, 0);
> +	struct qstr stored_name;
> +	const struct qstr *add_name =3D &d_name;
> +	__u32 ino;
> +	int err, err2;
> +
> +	if (!ext4_has_feature_dirdata(sb))
> +		return -EOPNOTSUPP;
> +
> +	if (namelen > EXT4_NAME_LEN)
> +		return -ENAMETOOLONG;
> +	if (namelen !=3D strnlen(filename, namelen + 1))
> +		return -EINVAL;
> +
> +	/* the entry is re-created from its plaintext name */
> +	if (IS_ENCRYPTED(dir) && !fscrypt_has_encryption_key(dir))
> +		return -ENOKEY;

[Severity: High]
Won't this fscrypt_has_encryption_key(dir) check fail with -ENOKEY on an
encrypted directory even when the key is present in the keyring?

fscrypt_has_encryption_key() only checks whether dir->i_crypt_info has
already been populated:

include/linux/fscrypt.h:fscrypt_has_encryption_key() {
	return fscrypt_get_inode_info(inode) !=3D NULL;
}

Opening a directory via ext4_dir_open() does not set up i_crypt_info, nor
does looking up a top-level encrypted directory in an unencrypted parent or
adding a key via FS_IOC_ADD_ENCRYPTION_KEY on an already-open directory fd.

Should ext4_dirdata_set_lufid() call fscrypt_prepare_readdir(dir) (or
fscrypt_get_encryption_info(dir)) before checking
fscrypt_has_encryption_key(dir)?

> +
> +	err =3D dquot_initialize(dir);
> +	if (err)
> +		return err;
> +
> +	/*
> +	 * The lookup and the change must both be under the directory lock.
> +	 * The entry is deleted and re-added in the same directory, so the
> +	 * target inode itself is not changed and is not locked.
> +	 */
> +	inode_lock_nested(dir, I_MUTEX_PARENT);
> +
> +	/*
> +	 * Look up the entry first to get the inode for the permission
> +	 * checks, without holding a journal handle.
> +	 */
> +	bh =3D ext4_find_entry(dir, &d_name, &de, NULL);
> +	if (IS_ERR(bh)) {
> +		err =3D PTR_ERR(bh);
> +		bh =3D NULL;
> +		goto out_unlock_dir;
> +	}
> +	if (!bh) {
> +		err =3D -ENOENT;
> +		goto out_unlock_dir;
> +	}
> +	ino =3D le32_to_cpu(de->inode);
> +	brelse(bh);
> +	bh =3D NULL;
> +	de =3D NULL;
> +
> +	inode =3D ext4_iget(sb, ino, EXT4_IGET_NORMAL);
> +	if (IS_ERR(inode)) {
> +		err =3D PTR_ERR(inode);
> +		inode =3D NULL;
> +		goto out_unlock_dir;
> +	}

[Severity: Medium]
Should this lookup validate ino and the returned inode the same way
ext4_lookup() does?

In ext4_lookup(), before and after calling ext4_iget(), it checks for
invalid inode numbers, entries pointing back to the parent directory itself,
and deleted inodes returning -ESTALE:

fs/ext4/namei.c:ext4_lookup() {
		if (!ext4_valid_inum(dir->i_sb, ino)) {
			EXT4_ERROR_INODE(dir, "bad inode number: %u", ino);
			return ERR_PTR(-EFSCORRUPTED);
		}
		if (unlikely(ino =3D=3D dir->i_ino)) {
			EXT4_ERROR_INODE(dir, "'%pd' linked to parent dir",
					 dentry);
			return ERR_PTR(-EFSCORRUPTED);
		}
		inode =3D ext4_iget(dir->i_sb, ino, EXT4_IGET_NORMAL);
		if (inode =3D=3D ERR_PTR(-ESTALE)) {
			EXT4_ERROR_INODE(dir,
					 "deleted inode referenced: %u",
					 ino);
			return ERR_PTR(-EFSCORRUPTED);
		}
}

Also, if a corrupted directory entry references an unlinked inode that is
still open in memory, ext4_iget() will return the cached inode with
inode->i_nlink =3D=3D 0. Should ext4_dirdata_set_lufid() check for these ca=
ses
and report -EFSCORRUPTED instead of deleting and re-creating a corrupted
entry?

> +
> +	/* Enforce sticky-bit restriction: on a sticky directory only the
> +	 * directory owner, the file owner, or a privileged process may
> +	 * modify entries.  inode_permission(MAY_WRITE) alone does not cover
> +	 * this, so check it explicitly here as may_delete() does. */
> +	err =3D check_sticky(idmap, dir, inode);
> +	if (err)
> +		goto out_iput;

[Severity: Medium]
Does this leak a positive return value (+1) to userspace when sticky-bit
permission is denied?

check_sticky() calls __check_sticky(), which returns 0 when allowed and 1
(not -EPERM) when denied:

fs/namei.c:__check_sticky() {
	if (vfsuid_eq_kuid(i_uid_into_vfsuid(idmap, inode), fsuid))
		return 0;
	if (vfsuid_eq_kuid(i_uid_into_vfsuid(idmap, dir), fsuid))
		return 0;
	return !capable_wrt_inode_uidgid(idmap, inode, CAP_FOWNER);
}

Assigning that return value to err and jumping to out_iput causes
ext4_ioctl_set_lufid() to return 1 to userspace instead of -EPERM. Should
this set err =3D -EPERM when check_sticky(idmap, dir, inode) is non-zero?

[ ... ]

> +	err =3D ext4_delete_entry(handle, dir, de, bh);
> +	if (err)
> +		goto out_brelse;
> +
> +	brelse(bh);
> +	bh =3D NULL;
> +
> +	err =3D ext4_add_fname(handle, dir, &new_fname, inode);
> +	if (err) {
> +		/*
> +		 * The old entry fits in the space it was deleted from, so
> +		 * this needs no new block.
> +		 */
> +		err2 =3D ext4_add_fname(handle, dir, &old_fname, inode);
> +		if (err2)
> +			EXT4_ERROR_INODE(dir,
> +				"Failed to set LUFID on '%.*s' (err=3D%d) and failed to restore the =
original directory entry (err=3D%d); inode %llu may be orphaned",
> +				namelen, filename, err, err2,
> +				(unsigned long long)inode->i_ino);
> +		goto out_journal;
> +	}

[Severity: Critical]
Can the rollback call to ext4_add_fname(handle, dir, &old_fname, inode) fail
in an HTree-indexed directory and permanently lose the directory entry?

When looking up the existing entry, ext4_find_entry() ->
ext4_dx_find_entry() walks continuation leaf blocks via
ext4_htree_next_block() when a hash collision chain spans multiple blocks
(and __ext4_find_entry() can also fall back to a linear scan across all
directory blocks on casefolded directories or on ERR_BAD_DX_DIR).

However, when re-adding the entry, ext4_add_fname() -> ext4_dx_add_entry()
only probes the single primary leaf block returned by dx_probe() and never
walks continuation blocks:

fs/ext4/namei.c:ext4_dx_add_entry() {
	frame =3D dx_probe(fname, dir, NULL, frames);
	if (IS_ERR(frame))
		return PTR_ERR(frame);
	entries =3D frame->entries;
	at =3D frame->at;
	bh =3D ext4_read_dirblock(dir, dx_get_block(frame->at), DIRENT_HTREE);
	...
	err =3D add_dirent_to_buf(handle, fname, dir, inode, NULL, bh);
	if (err !=3D -ENOSPC)
		goto cleanup;
	...
	de =3D do_split(handle, dir, &bh, frame, &fname->hinfo);
}

If the old entry resided in a continuation block (or was found via linear
fallback), ext4_delete_entry() frees space in that continuation block, while
the primary block returned by dx_probe() remains full. If splitting that
primary block in ext4_add_fname(&new_fname) then fails (for example due to
-ENOSPC, -EDQUOT, or reaching the maximum HTree level), the rollback call
ext4_add_fname(&old_fname) will probe the same full primary block, fail to
split it for the same reason, and commit the transaction with the entry
deleted and inode's link count leaked.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D12
