Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276FD3F4DCC
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 10:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786961248; cv=none; b=sRJ8a9An5AO5LW6xS5EafCBvo8SyYmHGAlGBzS9NXfaBqr0P/M3Jhn+jPUh5yhRYTAVwyhJnQuv04tnhYflMILdv+nzkix5HSUd5owOrrBhLrND4tosbgqNj+o48qqJAMlS54t2J61H3svrAPEvb4QjuL1ynSFR7wKy7b80pYm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786961248; c=relaxed/simple;
	bh=pfUQNLJa+8jR1IKsVS+htlquzfzAbHItGdVQGryoEBE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qX0HuhZNKEwliOUW0KBjDYNAbQI4sQiRUXi5ilJY1T3YRjA8DL8DfTJulTHZA3OaTWVf0BJKrnvXEEiWxkmg4LfYo365G8+1bf/KWEozUyQXBwGucq6ou8LnNrr6jwqBN/El1vX/6pT6qpxVBBRd5bA3N1fKkEPGLzRaG9gIJ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GEXs56/U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GEXs56/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923291F000E9;
	Mon, 17 Aug 2026 10:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786961244;
	bh=eFpQpXeunbapA4X1sIsTi7SKHnqTZ9nev5TaH5aaTvY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GEXs56/UezQ//SwUuXovcdCeNnzk427DPx1oXsSdm58PcfzuBoq8s89YJ+kliW6ea
	 Oz0IUZ8SDQm+0ixrCbGl0aJTHR2LEW1PZ7g9FfMvSiFX1SBHpGA0c8B7fTgNi/UeYw
	 ZZF80bCA9JZwXdcXpwsoFkp4zHSedulToHzHF8eXLRVXX0T2ReY0ck06yYdb0Q4yOO
	 IiVzW8ti9xs0gpfCwoE9PkL5vWcrOfbWkUiVww62ASlVAHd/sNduq9Zy1xahXnvA5Z
	 2zm1SEzBrtbo32RpgDa4gDIwjxgmXuLBm5pAD0vixZtwD5ngMwCag/72uqweC/xgvY
	 VyWT/U4oWIxhA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: compensate ea_inode refs and free block on new
 xattr block write error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Matthias Goergens" <matthias.goergens@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260817095421.1171145-1-matthias.goergens@gmail.com>
References: <20260814070432.595B91F00A3A@smtp.kernel.org>
 <20260817095421.1171145-1-matthias.goergens@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 10:07:24 +0000
Message-Id: <20260817100724.923291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The patch introduces calls to `mb_cache_entry_delete_or_get()` and =
`mb_cache_entry_wait_unused()`, which are not defined anywhere in the Linux=
 kernel codebase. This will cause compilation and linking failures due to i=
mplicit function declarations and undefined symbols.
--

--- Patch [1]: [PATCH] ext4: compensate ea_inode refs and free block on new=
 xattr block write error ---
commit 867eb1668b3595297e1515877804d2ee15fc4038
Author: Matthias Goergens <matthias.goergens@gmail.com>

ext4: compensate ea_inode refs and free block on new xattr block write error

This commit adds error handling in ext4_xattr_block_set() to properly revert
the on-disk reference counts and free the newly allocated xattr block if
metadata dirtying fails. It introduces ext4_xattr_new_block_fail() to handle
mbcache cleanup, block freeing, and quota release.

Link: https://lore.kernel.org/linux-ext4/20260814070432.595B91F00A3A@smtp.k=
ernel.org/

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 6127e94ea4f5d..f49d1e74e3214 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c

[ ... ]

> @@ -1299,6 +1299,63 @@ ext4_xattr_release_block(handle_t *handle, struct =
inode *inode,
>  	return;
>  }
> =20
> +/*
> + * Undo the setup of a new xattr block that failed to be written out: dr=
op
> + * the ext4_xattr_inode_inc_ref_all() references, free the block, and
> + * release the quota this operation charged for the new value (quota_len,
> + * zero when the value is not in an EA inode).
> + */
> +static void ext4_xattr_new_block_fail(handle_t *handle, struct inode *in=
ode,
> +				      struct buffer_head *new_bh,
> +				      size_t quota_len, int error)
> +{

[ ... ]

> +	lock_buffer(new_bh);
> +retry_owner:
> +	if (le32_to_cpu(BHDR(new_bh)->h_refcount) !=3D 1) {
> +		unlock_buffer(new_bh);
> +		return;
> +	}
> +	if (ea_block_cache) {
> +		oe =3D mb_cache_entry_delete_or_get(ea_block_cache,
> +						  le32_to_cpu(BHDR(new_bh)->h_hash),
> +						  new_bh->b_blocknr);
> +		if (oe) {
> +			unlock_buffer(new_bh);
> +			mb_cache_entry_wait_unused(oe);

[Severity: Low]
Are mb_cache_entry_delete_or_get() and mb_cache_entry_wait_unused() defined
anywhere in the kernel codebase?

Building the kernel with EXT4 support enabled will likely fail to compile
or link because these required mbcache functions appear to be missing.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817095421.1171=
145-1-matthias.goergens@gmail.com?part=3D1
