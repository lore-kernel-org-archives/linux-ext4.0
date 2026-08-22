Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370E53515EF
	for <linux-ext4@vger.kernel.org>; Sat, 22 Aug 2026 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787417030; cv=none; b=BBSrAl6mLCBePGhqnTEYmJJbEgjTRWaYZaOdStiz5vrIXACGvKz+DTh9BCzRWdAnkOKdjeE3xHfz25QVXWAh3tz9/QR7K8lvINw/4RNAC4tUy9prT59yA9bccafZLvPkH1cicpnm7LOMWFejcvfYOYPmK96jLBjVl/ibD8DmYiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787417030; c=relaxed/simple;
	bh=ZiGItsPX/MvOVHU/h7aKNwKVS/FxQ0ZC6uYgbEPeLt8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WM5U84EgQBUknkcr6UOFqkc+MXUzhpa5GOBXbD0s5e7Ctw7Gg7z3mABW0Tqg8CRB4in620HIbVvAqs17jfPHCPuwrHr/fQ4yV7XoO/N5FzWoQT+Czpoyp/BVWCwFFHejSyHBgloHiSjKQCzBfn+fWGB88icgCXRekQu8pWJ0GSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otGYWyif; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otGYWyif"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90811F000E9;
	Sat, 22 Aug 2026 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787417027;
	bh=+L6QXZI/sh8yIJKLeV4VpSsVn2G2S0gHCKGIoOv1nrg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=otGYWyifHjlrHoehLU76J6YZBiJmLasemGfZQ7ERoh6pVzDiogV2UXsWaFbmQBVIs
	 fmJmwl1SRGiRwHQSE0/o+AoMJBXwrrYejoY0cYOw+EZA1HZu7QpxxN+s5FhI8inzw7
	 tRY28qNdeVxc2uaEenSUGkPcCCp6hVyRjsK8+HzkkJDW1GPZfqyAeDD9AqhnWIruKh
	 vro5f7H1IScjx7uxf6I9KBeUIzL0fyeU3uwm50KzbrDzL4wUo1Z3hD1V9Izth8FZwv
	 49vbYpwrcWWTX3nciESkqqcsfGB8OcXj/cpChHd+UEppA2YXxfn6rO3SQLHQTtpPJe
	 yhBRmtQ5KtvxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
Reply-To: sashiko-reviews@lists.linux.dev
To: "shuo chen" <1289151713@qq.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <tencent_7FDF0CFD84843032AE9A95DCBD443746860A@qq.com>
References: <aoJ4bJZNgNAt4pLD@mit.edu>
 <tencent_7FDF0CFD84843032AE9A95DCBD443746860A@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 22 Aug 2026 16:43:46 +0000
Message-Id: <20260822164346.B90811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] Data blocks are permanently leaked in the block bitmap when `ext4_=
ext_insert_extent` fails with an error other than EDQUOT or ENOSPC.
- [High] The extent insertion hardcodes a length of 1, breaking bigalloc su=
pport and leaking blocks if the cluster size is greater than the block size.
- [High] Error recovery path triggers a BUG_ON(count > 1) in ext4_free_bloc=
ks for regular files or bigalloc clusters.
- [High] Raw inode memory is reverted on error without marking the buffer d=
irty, leading to an inconsistent journal state.
- [High] The on-disk inode's size is not updated when converting an inline =
directory, leaving the directory with a truncated size on disk.
- [Medium] The patch implementation completely contradicts the commit messa=
ge.
--

--- Patch [1]: [PATCH] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir=
 ---
commit 60b81af153ab511900118d63a628e53fb1229564
Author: pipishuo <1289151713@qq.com>
Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir

This commit refactors inline data conversion and adds error recovery for
extent insertion during block allocation.

> Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir

[Severity: Medium]
The commit message claims to add a check in ext4_readdir, but the diff
completely ignores ext4_readdir and instead refactors inline data
conversion in ext4_set_inline_data_block. Can the commit message be
updated to reflect the actual changes?

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482b..259a6af13b0f6 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
[ ... ]
> @@ -1079,21 +1080,115 @@ static int ext4_update_inline_dir(handle_t *hand=
le, struct inode *dir,
[ ... ]
> +		struct ext4_extent newex;
> +
> +		newex.ee_block =3D cpu_to_le32(0);
> +		newex.ee_len =3D cpu_to_le16(1);

[Severity: High]
Does hardcoding the extent length to 1 break bigalloc support? If the
cluster size is greater than the block size, or if multiple blocks are
allocated, the len parameter is ignored. Will the additional allocated
blocks marked in the bitmap be permanently leaked since they aren't
added to the extent tree?

> +		ext4_ext_store_pblock(&newex, block);
> +		path =3D ext4_ext_insert_extent(handle, inode, path, &newex, 0);
> +		if (IS_ERR(path)) {
> +			error =3D PTR_ERR(path);
> +			if (error =3D=3D -EDQUOT || error =3D=3D -ENOSPC) {
> +				goto recovery;
> +			} else {
> +				ext4_forget(handle, 0, inode, bh, block);
> +				goto nofree;

[Severity: High]
If ext4_ext_insert_extent() fails with an error other than EDQUOT or
ENOSPC, the code jumps to nofree. Does this permanently leak the
allocated data blocks in the block bitmap, since the ext4_free_blocks()
call in the recovery block is bypassed?

> +			}
> +		} else {
> +			ext4_free_ext_path(path);
> +		}
[ ... ]
> +recovery:
> +	if (error) {
> +		ext4_discard_preallocations(inode);
> +		ext4_free_blocks(handle, inode, bh, block, len, EXT4_FREE_BLOCKS_FORGE=
T);
> +nofree:
> +		memcpy((void *)raw_inode, inode_buf, inode_size);
> +		memcpy(ei->i_data, raw_inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
> +		ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);

[Severity: High]
This reverts the raw_inode memory on error, but is the buffer ever
marked dirty again? Because ext4_ext_tree_init() previously marked the
buffer dirty in the active transaction, doesn't overwriting the memory
here without calling ext4_mark_iloc_dirty() lead to an inconsistent
journal state?

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

[Severity: High]
Because ext4_mark_iloc_dirty() is called before the S_ISDIR size
updates, does this cause the new size to be missed in the buffer update?
Will the on-disk inode retain the old truncated inline data size?

> +		brelse(bh);
> +	}
[ ... ]
> @@ -1103,8 +1198,11 @@ static int ext4_convert_inline_data_nolock(handle_=
t *handle,
[ ... ]
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

[Severity: High]
Does this trigger a BUG_ON in ext4_free_blocks() on error paths? If we
allocate multiple blocks (e.g., when bigalloc is enabled or
EXT4_MB_HINT_DATA is used), allocated_block can be > 1.

Calling ext4_free_blocks() with a non-NULL data_bh, a count > 1, and the
EXT4_FREE_BLOCKS_FORGET flag will hit the BUG_ON(count > 1) in
ext4_free_blocks().

> +		up_write(&ei->i_data_sem);
> +	} else {
> +		error =3D ext4_set_inline_data_block(handle, inode,
> +				newblock, allocated_block, data_bh);
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_7FDF0CFD848=
43032AE9A95DCBD443746860A@qq.com?part=3D1
