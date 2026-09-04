Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7220C13AF2
	for <linux-ext4@vger.kernel.org>; Fri,  4 Sep 2026 01:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788486399; cv=none; b=tzKfUoRp5dCg1KqV7x52rqPjMoD9BdAYfJ2p+9zj40Kewg97hWzI/lVLT9tIGOseuKtWeBn7C1DNYToO6Znp4wvsBfwKYM7X2YJDKqijXHdZmL5PM3APGihlP2XX8FliBrHmE7vhe8XFrQ81XNa99TyxAqx0iGY0tGsm1f4QDkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788486399; c=relaxed/simple;
	bh=FjB4AQAZhRMTnL/TROJMnWswmFd3hvnCG+BgQLwbwvg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZoqRsyPL21tBua9L9yCX2CYbw5CktX/19fjlOsx/8rDrYLXIZhHhuCdVHHvl+0gw6pSAis/gj4BV1/96fRdzLJeAr1hlc4iTvfLqp3yPrxMhaz0nbIfmjOpJ1rJvJo0caX7jT1PigeAw8ngavbGTt2ncWeK7bCTGSdzY93tYmaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSNr7Oim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSNr7Oim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEE01F000E9;
	Fri,  4 Sep 2026 01:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788486398;
	bh=z3dFDO7y5I+75wPSvtd+Aru6+NvjSOhz37j0ryzU7wE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TSNr7Oim9ctJmsv9t/nkwsYAK3i60YUP4eD0WMaWHJazAThFKuwUr6q6Fiq+5dN13
	 l4jX27xrH8nE4kfdeNFIauT+eUlrIz2Di6pu55+B38R2M/kb4MbxYuXsDi0DXyhO1Y
	 LqSYjfYpRdr7WVUhKyCJi+k1uAFFOBV/mFxdl0SAS4RH2AxVJOubouzQ1cLe64WqzF
	 NfZtqwV+jnfezgI8efiAg4XPsnoxMSnNSel1UaheO4z4qR9WcIlJHfesajLItIZsT3
	 Og3NokEqZSaiYeOD6WanEF1VYasTzb9haZa4wNpdHG73luQFt596MMPXbjZXKNq2BD
	 oKZWZSoo4JUGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6] ext4: rewrite ext4_convert_inline_data_nolock to
 make it safer
Reply-To: sashiko-reviews@lists.linux.dev
To: "shuo chen" <1289151713@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_3656CB4AA45EA01A8DC2B9865242BA18A709@qq.com>
References: <tencent_93CC3232AC6A9418BCE4372286770F91850A@qq.com>
 <tencent_3656CB4AA45EA01A8DC2B9865242BA18A709@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 01:46:37 +0000
Message-Id: <20260904014637.BBEE01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Silent data block leak when ext4_ext_insert_extent fails with non-=
space errors.
- [High] Block leak of over-allocated blocks from ext4_mb_new_blocks() due =
to hardcoded extent length.
--

commit 4f5429b131a64abd614d1b0e2bd7535d3f83a7c0
Author: shuo chen <1289151713@qq.com>

ext4: rewrite ext4_convert_inline_data_nolock to make it safer

This commit refactors the inline data conversion logic to address issues wi=
th
uninitialized xattr space and data loss on extent insertion failures. It ai=
ms
to revert the inode back to inline data if extent insertion fails for reaso=
ns
other than quota or space limitations.

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482b..5a3763d3b51a5 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
[ ... ]
> @@ -1079,21 +1080,123 @@ static int ext4_update_inline_dir(handle_t *hand=
le, struct inode *dir,
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
> +		ext4_ext_store_pblock(&newex, block);

[Severity: High]
Does this hardcode the extent length to 1 block, potentially leaking blocks=
 if=20
ext4_mb_new_blocks() allocates a larger contiguous extent?

In ext4_convert_inline_data_nolock(), the actual allocation size is captured
as allocated_block =3D EXT4_C2B(sbi, ar.len). If the allocation request ret=
urns
multiple blocks (for example, on a bigalloc filesystem), only the first blo=
ck
is added to the extent tree here. The remaining blocks appear to be neither
mapped nor freed, which would leave them orphaned in the block bitmap.

> +		path =3D ext4_ext_insert_extent(handle, inode, path, &newex, 0);
> +		if (IS_ERR(path)) {
> +			error =3D PTR_ERR(path);
> +			if (error =3D=3D -EDQUOT || error =3D=3D -ENOSPC)
> +				goto recovery;
> +			else
> +				goto no_free;
> +		} else {
> +			ext4_free_ext_path(path);
> +		}
[ ... ]
> +recovery:
> +	if (error) {
> +		ext4_discard_preallocations(inode);
> +		ext4_free_blocks(handle, inode, NULL, block, len, 0);
> +		memcpy(header, xattr_buf, xattr_size);
> +no_free:
> +		ext4_forget(handle, 0, inode, bh, block);

[Severity: High]
Can this error path result in a permanent data block leak?

If ext4_ext_insert_extent() fails with an error like -ENOMEM or -EIO, the
code jumps directly to the no_free label. This deliberately bypasses the
ext4_free_blocks() call just above it. Because the calling function relies
on ext4_set_inline_data_block() to free the newly allocated block on error,
bypassing the free operation here appears to leave the blocks permanently
marked as used in the filesystem.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_3656CB4AA45=
EA01A8DC2B9865242BA18A709@qq.com?part=3D1
