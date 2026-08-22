Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E2A3AFCE4
	for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2026 16:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787417146; cv=none; b=P0DrQ2AKjtSVy6pV/ycv0TwJDGM2cmK3WEnIO0r6ZPXM8jvHnvf7Mhl8/2d1+px2oLdJjOHxnonUK6td6tYkL5D/Dyex0kIR/lVZPU2emp+5/OFyEG32g/8zDK9YGvhFaFgMJDI2TGLrAo/3sGFmgfDSLC6R4rkEmcM+J5WVGwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787417146; c=relaxed/simple;
	bh=evwk1fBqmgu86xl+oV9uTGsXjcj14Kk1EsVallX4l+A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RZRIat6K9uleqXttY35a6b+Ww8dlYA38JsVcoTrDMLv4QMOoRl8UTodsZ2729Xljd3W5PQJFr/W0YlUKijfIPt63+x21/1U0nZIKPKKhQ2TBaXJccZuXApwRBUeQjldLPhHVA3+8XLdeHJ49hjKGxyGaeecC/sLhXpkx8y0pHNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M22UWd4G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M22UWd4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A9F1F00A3A;
	Sat, 22 Aug 2026 16:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787417143;
	bh=quyCEU7BufbnKP6mZaAVrjjWav6stLklzytUj534sU0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M22UWd4Gdd3gRA0KJwY2sJDjvhiui47nCiPKWOFArMTrBW+VwP3LjWnyQfZcyiqD1
	 40TvO3my/ujoWyxcvbMw0DDUsmZ6LS5H1nM7wgh9BrO9xfWZ33YS+vCgROQzB+0OLT
	 4NI2kX5GRkScXheDZRxak+frSp0o6+p28o4RgqboSfekqLU0i44ABuHp5AY3uRAmmU
	 sfc+5RDVki5CVKGCA30ouOkvhbn1+7Z97EejZ7jWHKAJHvsZiUOpw3vRneI264nZ3a
	 28aVPgEhzxnf76+jGY7+T5fi4534AsMMJdf9WQHHgfoehoQ85GKy4hW05zfy3aylbq
	 2DO6JGViorDTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V3] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
Reply-To: sashiko-reviews@lists.linux.dev
To: "shuo chen" <1289151713@qq.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <tencent_5FCFA1D9100C4691D5AA92A597B846A8F007@qq.com>
References: <aoJ4bJZNgNAt4pLD@mit.edu>
 <tencent_5FCFA1D9100C4691D5AA92A597B846A8F007@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 22 Aug 2026 16:45:43 +0000
Message-Id: <20260822164543.96A9F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Critical] Misordered metadata update causes corrupt directory `i_size` o=
n disk.
- [Critical] Unconditional BUG_ON() crash in `ext4_free_blocks()` on error =
paths for allocations > 1 block.
- [High] Permanent block leak when `ext4_ext_insert_extent` fails with an e=
rror other than EDQUOT or ENOSPC.
- [High] Concurrent inode metadata changes are overwritten during error rec=
overy.
- [High] Permanent space leak due to hardcoded extent length of 1 block.
- [High] Missing `i_blocks` accounting for newly allocated physical blocks.
- [Medium] The commit message describes a completely different change.
--

--- Patch [1]: [PATCH V3] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_read=
dir ---
commit 1cb52ec17c1b86718dd26a2d224b02e260c85e40
Author: pipishuo <1289151713@qq.com>
Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir

The commit message describes adding a state check in ext4_readdir, but the
patch refactors ext4_convert_inline_data_nolock and introduces a new block
allocation mechanism for inline data conversion.

>     Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
>    =20
>     Resend as v3 because I forgot to add the version number

[Severity: Medium]
Is the commit message mismatched with the actual code changes? The subject
and message describe adding a state check in ext4_readdir, but the patch
entirely refactors ext4_convert_inline_data_nolock and introduces a new
block allocation mechanism for inline data conversion without mentioning it.

> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
[ ... ]
> @@ -1079,21 +1080,115 @@ static int ext4_update_inline_dir(handle_t *hand=
le, struct inode *dir,
>  	return 0;
>  }
> =20
> -static void ext4_restore_inline_data(handle_t *handle, struct inode *ino=
de,
> -				     struct ext4_iloc *iloc,
> -				     void *buf, int inline_size)
> +static int ext4_set_inline_data_block(handle_t *handle, struct inode *in=
ode, ext4_fsblk_t block,
> +					unsigned int len, struct buffer_head *bh)
>  {
[ ... ]
> +		struct ext4_extent newex;
> +
> +		newex.ee_block =3D cpu_to_le32(0);
> +		newex.ee_len =3D cpu_to_le16(1);

[Severity: High]
Does this permanently leak physical blocks if the allocator returns more
than 1 block? When ext4_mb_new_blocks() returns a larger allocation
(e.g., due to cluster normalization on bigalloc filesystems), hardcoding
the extent length to 1 abandons the extra blocks. Should this use the
allocated length (len parameter) instead?

> +		ext4_ext_store_pblock(&newex, block);
> +		path =3D ext4_ext_insert_extent(handle, inode, path, &newex, 0);

[Severity: High]
Does this miss accounting for the newly allocated physical blocks?
Manually inserting the extent bypasses the normal ext4_map_blocks()
pipeline, meaning ext4_inode_add_physical_space() is never called to
increment inode->i_blocks. Could this lead to stat() inconsistencies and
fsck failures?

> +		if (IS_ERR(path)) {
> +			error =3D PTR_ERR(path);
> +			if (error =3D=3D -EDQUOT || error =3D=3D -ENOSPC) {
> +				goto recovery;
> +			} else {
> +				ext4_forget(handle, 0, inode, bh, block);
> +				goto nofree;
> +			}
> +		} else {
> +			ext4_free_ext_path(path);
> +		}
> +	} else {
> +		EXT4_I(inode)->i_data[0] =3D cpu_to_le32(block);
> +	}
> +	error =3D ext4_xattr_ibody_find(inode, &i, &is);
> +	if (error)
> +		goto recovery;
> +	if (!is.s.not_found)
> +		error =3D ext4_xattr_ibody_set(handle, inode, &i, &is);
> +recovery:
> +	if (error) {
> +		ext4_discard_preallocations(inode);
> +		ext4_free_blocks(handle, inode, bh, block, len, EXT4_FREE_BLOCKS_FORGE=
T);

[Severity: Critical]
Can this trigger a BUG_ON() crash in ext4_free_blocks() on bigalloc
filesystems? If the length (len) is greater than 1, calling
ext4_free_blocks() with both a valid buffer_head (bh) and the
EXT4_FREE_BLOCKS_FORGET flag will unconditionally hit the
BUG_ON(count > 1) check inside ext4_free_blocks().

> +nofree:

[Severity: High]
Does the jump to the nofree label earlier permanently leak the allocated
blocks if the extent insertion fails with an error other than -EDQUOT or
-ENOSPC? Jumping here bypasses the ext4_free_blocks() call during error
recovery. Because ext4_forget() only removes the buffer from the journal
without freeing the physical blocks in the buddy bitmap, the blocks appear
to be permanently leaked.

> +		memcpy((void *)raw_inode, inode_buf, inode_size);

[Severity: High]
Could this non-atomic memcpy() overwrite concurrent metadata updates?
The i_data_sem protects the block mapping, but background flushers or
other operations might have updated the inode's timestamps or extended
attributes in the raw_inode while we were allocating blocks. Blindly
copying back the old inode_buf could silently discard those changes.

> +		memcpy(ei->i_data, raw_inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
> +		ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);
> +	} else {
> +		ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
> +		get_bh(is.iloc.bh);
> +		error =3D ext4_mark_iloc_dirty(handle, inode, &is.iloc);
> +		EXT4_I(inode)->i_inline_off =3D 0;
> +		EXT4_I(inode)->i_inline_size =3D 0;
> +		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> +		if (S_ISDIR(inode->i_mode)) {
> +			i_size_write(inode, inode->i_sb->s_blocksize);
> +			EXT4_I(inode)->i_disksize =3D inode->i_sb->s_blocksize;
> +		}

[Severity: Critical]
Does this permanently save a stale directory size to disk?
The raw metadata buffer is marked dirty via ext4_mark_iloc_dirty()
before the VFS inode size and i_disksize are updated. Since this patch
removed the later ext4_mark_inode_dirty() call, is there a risk the
updated size fields never make it to the on-disk raw_inode?

> +		brelse(bh);
> +	}
[ ... ]
> @@ -1168,24 +1263,28 @@ static int ext4_convert_inline_data_nolock(handle=
_t *handle,
>  						   inode, data_bh);
>  	} else {
>  		unlock_buffer(data_bh);
> -		inode->i_size =3D inode->i_sb->s_blocksize;
> -		i_size_write(inode, inode->i_sb->s_blocksize);
> -		EXT4_I(inode)->i_disksize =3D inode->i_sb->s_blocksize;
> -
>  		error =3D ext4_init_dirblock(handle, inode, data_bh,
>  			  le32_to_cpu(((struct ext4_dir_entry_2 *)buf)->inode),
>  			  buf + EXT4_INLINE_DOTDOT_SIZE,
>  			  inline_size - EXT4_INLINE_DOTDOT_SIZE);
> -		if (!error)
> -			error =3D ext4_mark_inode_dirty(handle, inode);
>  	}
> +out_bh:
> +	if (error) {
> +		int flags =3D 0;
> =20
> -out_restore:
> -	if (error)
> -		ext4_restore_inline_data(handle, inode, iloc, buf, inline_size);
> +		if (data_bh)
> +			flags |=3D EXT4_FREE_BLOCKS_FORGET;
> +		struct ext4_inode_info *ei =3D EXT4_I(inode);
> =20
> +		down_write(&ei->i_data_sem);
> +		ext4_discard_preallocations(inode);
> +		ext4_free_blocks(handle, inode, data_bh, newblock, allocated_block, fl=
ags);

[Severity: Critical]
Similarly, could this also trigger the BUG_ON(count > 1) in
ext4_free_blocks() on failure? If allocated_block is greater than 1
(e.g., bigalloc) and data_bh is valid, flags will include
EXT4_FREE_BLOCKS_FORGET, which crashes when freeing multiple blocks
with a provided buffer_head.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_5FCFA1D9100=
C4691D5AA92A597B846A8F007@qq.com?part=3D1
