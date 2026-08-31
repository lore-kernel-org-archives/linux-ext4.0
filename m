Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D19838F95E
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2026 02:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788143698; cv=none; b=ihU1BhzxM4RzQ3tAKIhBurpYilMWC3Wzv1vOIwxS/70+u32INumsG4g4e63vKl1Eu0TrIBeKEH+aHeOfCmBUBtySg16r8+MgQrJjqE3VksHUUS4nqYy/NivkgURyjHTCgH8HoQl4/ANGYkTHYbqSQBsgheDJ8eGpbnkGYt/vfMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788143698; c=relaxed/simple;
	bh=Y5mwv/n5bgrEhNIhAkrTG0EBoyj8wpl3W5Qf+j0bhrg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P8hsaq9UAQo/UW6QoYTV2N3dnRCu3RF1wLHVzFpldA9Z85T1rhwOctZBPikkI8lFfEie36zNUTjdPhX95iu05J/IYCUf+uP1PXXVSFhaEu4mrD8dICS+je9k//5taYolyDEl4bYwKYMUn2a//rZNMDY7iaSPYtnp/FB9b1ajhgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KrFdVHpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KrFdVHpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F981F000E9;
	Mon, 31 Aug 2026 02:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788143695;
	bh=YK0Ik0gmxlErK0iuWnYXaCXW5q9iazr4sx1McyO2+d8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KrFdVHpQZ32LIba/tABj2ykl6boD+/PkJvZxTQLvyr+EHQF8ioxyKWBiD+chVonPh
	 MLgb90vhP2b8V3ZEkk4/75++coWnmt0tD3sgbSL/DaZ+xBCQyNXUkEpj9BSnRN8Jd/
	 jSmFdlOcEHTVkppYBy6k6NgyaVvks6nEtG5lmQKdQbg8cmvHZj36Oua95RQhvSySb1
	 wxReac/JpqEA8k5Eg1Ch8u81Kwjux1fZBvCPnDhPVTxY9tRKIKHaheNadPMlj9pRL/
	 H817KVAq14PvpAY38TtnU7e5Y7/qBmF/w3EFUIgCd+NPMRrKWi1JmjMCvwGwmnFpFP
	 TV0iLLy2B+DwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] ext4: rewrite ext4_convert_inline_data_nolock to
 make it safer
Reply-To: sashiko-reviews@lists.linux.dev
To: "shuo chen" <1289151713@qq.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <tencent_54332AAC969648BF78341E85930FE984D80A@qq.com>
References: <tencent_DBADB12BBC6D88300488F16E75A384FAE505@qq.com>
 <tencent_54332AAC969648BF78341E85930FE984D80A@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:34:54 +0000
Message-Id: <20260831023455.02F981F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Silent data loss, block leak, and file corruption when `ext4_e=
xt_insert_extent` fails with non-quota errors.
- [Critical] Incomplete error rollback leaves the on-disk inode corrupted w=
ith EXT4_INODE_EXTENTS flag set but inline data present in i_block.
- [High] Buffer head reference leak on the xattr_buf allocation error path.
- [High] Hardcoded extent length to 1 leaks extra allocated blocks when ext=
4_mb_new_blocks returns a larger extent.
--

commit ce8b20336077e6f612c3df128b34228b4e54e5b5
Author: shuo chen <1289151713@qq.com>
ext4: rewrite ext4_convert_inline_data_nolock to make it safer

This patch rewrites ext4_convert_inline_data_nolock() by preallocating
blocks and handling errors more robustly. It also introduces
ext4_set_inline_data_block() to manage the conversion of inline data to blo=
cks.

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482b..d1cf3c702e79e 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
[ ... ]
> @@ -1079,21 +1080,125 @@ static int ext4_update_inline_dir(handle_t *hand=
le, struct inode *dir,
[ ... ]
> +	error =3D ext4_get_inode_loc(inode, &is.iloc);
> +	if (error)
> +		goto error;
> +	raw_inode =3D ext4_raw_inode(&is.iloc);
> +	header =3D IHDR(inode, raw_inode);
> +	tail =3D ITAIL(inode, raw_inode);
> +	xattr_size =3D tail - header;
> +	xattr_buf =3D kmalloc(xattr_size, GFP_NOFS);
> +	if (!xattr_buf) {
> +		error =3D -ENOMEM;
> +		goto error;
> +	}

[Severity: High]
Does this error path leak a reference to is.iloc.bh?

If kmalloc() for xattr_buf fails, the code jumps to the error label which d=
oes
not call brelse(is.iloc.bh). Since ext4_get_inode_loc() pins a reference
on is.iloc.bh, could this result in a permanent buffer head reference leak?

[ ... ]
> +	if (ext4_has_feature_extents(inode->i_sb) &&
> +		(S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode) || S_ISLNK(inode->i_=
mode))) {
> +		ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
> +		ext4_ext_tree_init(handle, inode);
> +		struct ext4_ext_path *path =3D ext4_find_extent(inode, 0, NULL, 0);
> +
> +		if (IS_ERR(path)) {
> +			error =3D PTR_ERR(path);
> +			goto recovery;
> +		}
> +		struct ext4_extent newex;
> +
> +		newex.ee_block =3D cpu_to_le32(0);
> +		newex.ee_len =3D cpu_to_le16(1);

[Severity: High]
Does hardcoding the extent length to 1 leak extra allocated blocks?

In ext4_convert_inline_data_nolock(), ext4_mb_new_blocks() may return a
larger extent due to bigalloc or normalization, passing the total allocated
blocks as len:

fs/ext4/inline.c:ext4_convert_inline_data_nolock() {
	...
	newblock =3D ext4_mb_new_blocks(handle, &ar, &error);
	if (error < 0)
		goto out;
	allocated_block =3D EXT4_C2B(sbi, ar.len);
	...
		error =3D ext4_set_inline_data_block(handle, inode,
				newblock, allocated_block, bh);
	...
}

If multiple blocks were allocated, the remaining blocks might be permanently
leaked since they are marked as used but not mapped to the file.

> +		ext4_ext_store_pblock(&newex, block);
> +		path =3D ext4_ext_insert_extent(handle, inode, path, &newex, 0);
> +		if (IS_ERR(path)) {
> +			error =3D PTR_ERR(path);
> +			if (error =3D=3D -EDQUOT || error =3D=3D -ENOSPC)
> +				goto recovery;
> +		} else {
> +			ext4_free_ext_path(path);
> +		}
> +	} else {
> +		EXT4_I(inode)->i_data[0] =3D cpu_to_le32(block);
> +	}
> +	error =3D ext4_xattr_ibody_find(inode, &i, &is);

[Severity: Critical]
Is it possible this overwrites the error code from ext4_ext_insert_extent()?

If ext4_ext_insert_extent() fails with an error other than -EDQUOT or
-ENOSPC, execution falls through to the ext4_xattr_ibody_find() call, which
could succeed (returning 0) and overwrite the failure. This would cause the
function to proceed to the success path, clearing EXT4_INODE_INLINE_DATA
without actually inserting the extent, potentially leading to data loss and
a block leak.

> +	if (error)
> +		goto recovery;
> +	if (!is.s.not_found)
> +		error =3D ext4_xattr_ibody_set(handle, inode, &i, &is);
> +recovery:
> +	if (error) {
> +		ext4_forget(handle, 0, inode, bh, block);
> +		ext4_discard_preallocations(inode);
> +		ext4_free_blocks(handle, inode, NULL, block, len, 0);
> +		memcpy((void *)raw_inode->i_block, i_block_buf, EXT4_MIN_INLINE_DATA_S=
IZE);
> +		memcpy(ei->i_data, raw_inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
> +		memcpy(header, xattr_buf, xattr_size);
> +		ext4_clear_inode_flag(inode, EXT4_INODE_EXTENTS);

[Severity: Critical]
Does this recovery path miss a call to ext4_mark_iloc_dirty()?

The code restores the inline data into raw_inode->i_block and clears the
EXT4_INODE_EXTENTS flag, but doesn't mark the inode dirty. Since
ext4_ext_tree_init() previously dirtied the inode, it might be written to
disk with an invalid checksum and the EXT4_EXTENTS_FL flag still set in
raw_inode->i_flags, which could cause metadata corruption.

> +	} else {
> +		ext4_clear_inode_flag(inode, EXT4_INODE_INLINE_DATA);
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_54332AAC969=
648BF78341E85930FE984D80A@qq.com?part=3D1
