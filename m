Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172DB4B0495
	for <linux-ext4@vger.kernel.org>; Sun, 16 Aug 2026 15:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786893382; cv=none; b=j+LnrxK8V9q4GidM0c18mBPZSvUQh8lq4IYH0I8djZVMYkde4VMvf4QKbYcX3xZBTvEUfUMvO+OZv1tpsbndfTVB/PtLVnPbNoHOB6k6DGX56z7fCeAwW4/tmXApMej9jsMRbuuVFQYZGvyvuwCEa0CXyVhFvK4P0v/Tco7JC5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786893382; c=relaxed/simple;
	bh=rvMFuMvjOACRSXu4CPLUsL+YNs2AF79mppIGT+HOOg0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LBnulrEbD8OoVZOpcy1U99GZ0fH5TjWEV4628BoDzU/xQJIKIvxifSFKMiy8UGmabGO+ROcqR3BaCID5yeBDGoIGy5Vu7WS/09UFo/oLZfVeim3CsgZN15/kPSUE8RsLrGF/jYiU3bvjOiHm+V1+boUZKPooaWNjDVoxlgGyH1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BFz82Ek7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFz82Ek7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849EC1F000E9;
	Sun, 16 Aug 2026 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786893380;
	bh=rGOXQaTYff+UiqoaEJLpDnzpkyMpMIXJgkrf6jSqKZQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BFz82Ek78sm1rBh+GsQ6R/3EVluZaRoyltZ6JOLZSyTAD/UIRHL9DuVV2iu3cmtgb
	 B4C5RCSWa8uj3+XtzCiSCdmla8z5rqrVygvLrnSAVuMIaoWPI3utn2JHi3XSfdE0vi
	 4soRscHc1wF6jvEmTvW5n36WJtqkmPilqZqmILu3/FxPA5cdeO86EAt5SpMuhGByD8
	 cB+TFYTmBK11AS2vryq5rsjsLxj3u2IvRaFAbRlpk+cjmqK8185IB8FKylF4jKhW+k
	 ALdkXW9NkF84LqsaAJi0MZCOXVc/b5Eb/njbUWwbu9jGQhBLPBChd8GoYSzLnP29fp
	 lw+eMVPlzWRmg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
Reply-To: sashiko-reviews@lists.linux.dev
To: "shuo chen" <1289151713@qq.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <tencent_BDF7C28D876E422418FB57474B765F0C1A09@qq.com>
References: <an5_shcksPF6uIaW@mit.edu>
 <tencent_BDF7C28D876E422418FB57474B765F0C1A09@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 16 Aug 2026 15:16:20 +0000
Message-Id: <20260816151620.849EC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] Dangling extent tree reference causes double-allocation risk i=
n the error path of block conversion.
- [High] The return value of ext4_find_extent() is passed to ext4_ext_inser=
t_extent() without checking for ERR_PTR, leading to a kernel panic on failu=
re.
- [High] The dynamically allocated ext4_ext_path array is leaked, and the r=
eturn value of ext4_ext_insert_extent() is ignored, suppressing insertion f=
ailures.
- [High] If deleting the inline data xattr returns -ENODATA, the function p=
rematurely returns success, skipping extent insertion and leaking the newly=
 allocated file block.
- [High] Destructive modifications to inline data before validating extent =
tree insertion can lead to unrecoverable data loss.
- [Medium] The commit message claims to modify ext4_readdir, but no such ch=
anges are present in the patch.
--

--- Patch [1]: [PATCH v2] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_read=
dir ---
commit e51d3b5fd4decc28517230e5645f25ee40f9b2fb
Author: shuo chen <1289151713@qq.com>
Subject: Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir

The commit rewrites ext4_convert_inline_data_nolock() to allocate blocks
before destroying inline data, aiming for a safer conversion.

Link: https://lore.kernel.org/linux-ext4/tencent_7A0B62235E38C5907A080BE3D5=
6A59C9FD06@qq.com/T/#t=EF=BC=9A

> Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir

[Severity: Medium]
The commit title mentions adding a check in ext4_readdir(), but the patch
only modifies ext4_convert_inline_data_nolock() in fs/ext4/inline.c. Are
there missing changes, or should the commit message be updated to reflect
the actual modifications?

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482b..1fad2a4454ecc 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
[ ... ]
> +static int ext4_set_inline_data_block(handle_t *handle, struct inode *in=
ode,
> +				      ext4_fsblk_t block, unsigned int len)
> +{
[ ... ]
> +	error =3D ext4_journal_get_write_access(handle, inode->i_sb, is.iloc.bh=
, EXT4_JTR_NONE);
> +	if (error)
> +		goto out;
> +	error =3D ext4_xattr_ibody_set(handle, inode, &i, &is);
> +	if (error)
> +		goto out;

[Severity: High]
If the file's inline data fits entirely in i_block, the system data xattr
will not exist, and ext4_xattr_ibody_set() will return -ENODATA. This jumps
to the out label where the error is cleared to 0. Does this cause the extent
insertion to be completely skipped?

If ext4_convert_inline_data_nolock() receives a success code without the
extent being inserted, could it fail to free the newly allocated block and
leak it permanently?

> +	memset((void *)ext4_raw_inode(&is.iloc)->i_block,
> +		0, EXT4_MIN_INLINE_DATA_SIZE);
> +	memset(ei->i_data, 0, EXT4_MIN_INLINE_DATA_SIZE);

[Severity: High]
This irreversibly destroys the existing inline data before we attempt to
insert the new extent into the tree. If ext4_ext_insert_extent() fails, we
return an error and the caller frees the newly allocated block. Doesn't this
mean both the old inline data and the new block are lost, causing
unrecoverable data loss?

> +
> +	if (ext4_has_feature_extents(inode->i_sb) &&
> +		(S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode) || S_ISLNK(inode->i_=
mode))) {
> +		ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
> +		ext4_ext_tree_init(handle, inode);
> +		struct ext4_ext_path *path =3D ext4_find_extent(inode, 0, NULL, 0);

[Severity: High]
Can ext4_find_extent() return an error pointer like ERR_PTR(-ENOMEM)?

Since the returned path is not checked with IS_ERR(), passing it directly to
ext4_ext_insert_extent() could result in a fatal NULL or ERR pointer
dereference.

> +		struct ext4_extent newex;
> +
> +		newex.ee_block =3D cpu_to_le32(0);
> +		newex.ee_len =3D cpu_to_le16(len);
> +		ext4_ext_store_pblock(&newex, block);
> +		ext4_ext_insert_extent(handle, inode, path, &newex, 0);

[Severity: High]
It looks like ext4_find_extent() dynamically allocates the path array, but =
it
is never freed here with ext4_free_ext_path(). Does this leak memory on eve=
ry
execution?

Additionally, ext4_ext_insert_extent() can fail and return an ERR_PTR or
reallocate the path. By ignoring its return value, we might suppress errors
like -ENOSPC and fail to capture the updated path pointer, leaving the inode
corrupted without its data mapping.

[ ... ]
> @@ -1180,12 +1225,14 @@ static int ext4_convert_inline_data_nolock(handle=
_t *handle,
>  			error =3D ext4_mark_inode_dirty(handle, inode);
>  	}
> =20
> -out_restore:
>  	if (error)
> -		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
> -
> -out:
> +		goto out_bh;
> +	error =3D ext4_set_inline_data_block(handle, inode, newblock, ar.len);
> +out_bh:
> +	if (error)
> +		ext4_free_blocks(handle, inode, data_bh, newblock, ar.len, EXT4_FREE_B=
LOCKS_FORGET);

[Severity: Critical]
If ext4_set_inline_data_block() successfully inserts the block into the
extent tree but fails later (for example, in ext4_mark_iloc_dirty()), it
returns an error.

The caller will then execute this path and call ext4_free_blocks() on the
newly allocated block.

Since the insertion into the extent tree is not rolled back, the block
remains mapped in the inode's extent tree but is marked as free in the
filesystem's block bitmap. Could this lead to a double-allocation
vulnerability?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_BDF7C28D876=
E422418FB57474B765F0C1A09@qq.com?part=3D1
