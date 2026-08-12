Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B8F347505
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2026 05:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786511136; cv=none; b=sMbMgI9ZRliO3Av8TII4Rr+lwn0Pgc3ZPl/aD38aIgHsx6gMG0vSoz6hteIC9GBQxWDLrcfBPW7GhPXSX6v3NrhKPOici1B3pWPBQyle7IVEcYM0lyf4o+5WSZtLTHaAInzXkysMViw61mdjybx2X3y2N8npDmrexP6FUC0IfNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786511136; c=relaxed/simple;
	bh=fKGsnRc3hjLdiHeyQF5Bd5AH3UbMY12NiIuwUbipG4A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lVHZMd/I9dYxHoa9LnC9ErF2+7QwzHtJXMYCyDMio0666Jt0ukBVNL2eHIeIA46TzFnjjn+hCQMt0aCkE1VBCJOVm0HnWrZ4NIFBAyawc4BifNBZ2CR0IJw+XcrTD15p0MG5sGnyOPjde9nixu7VZbC/CGouSydMqx08JucV1Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lG50PTZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lG50PTZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7091F000E9;
	Wed, 12 Aug 2026 05:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786511134;
	bh=PSdeouH7NGMw/19UuYQfU8/Onb6HcYVP6sNo5ai+mN0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lG50PTZZSaT+hSQBpcRiYqn0R6mYKd4RTBW8acj459JorMUxx19dAR4mP6YLx9J64
	 xIW2+LI2nsHwpdKpvPFYqlb4qgsrpZDw4IrC49Kq8OxeiXWn4DIfoesOEUiUuUvO64
	 x5gemehOj79uK7EiPwt6TIO5LBHk1GadFXDa52Nq3GXx0G6fHr9/FeEzbvGt+CyD1H
	 GllGX7se48wbnwJCoHJAofS28Cz+FrJhbKyVHimMG9I5Gp90HSEQoAkebVLbRfrou2
	 km8DgXscMBjiWnZMZUxgkurGeC1h6BgxGzaetybaZzRYo0fX6XhCK1C5aCYkS/3cuF
	 i1GGXr8qOnZ9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/1] ext4: drop extra ea_inode ref in cached-block reuse
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Matthias Goergens" <matthias.goergens@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260812044556.2209787-1-matthias.goergens@gmail.com>
References: <20260812044556.2209787-1-matthias.goergens@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 05:05:33 +0000
Message-Id: <20260812050534.4E7091F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] On-disk reference counts for ea_inodes and physical blocks are lea=
ked if block creation fails after calling ext4_xattr_inode_inc_ref_all().
--

--- Patch [1]: [PATCH 1/1] ext4: drop extra ea_inode ref in cached-block re=
use path ---
commit 57ed7d8076824778cc2e749011823fc10096cd99
Author: Matthias Goergens <matthias.goergens@gmail.com>

ext4: drop extra ea_inode ref in cached-block reuse path

ext4_xattr_block_set() acquires a reference to the ea_inode via
ext4_xattr_inode_lookup_create() before constructing the new xattr
block.  In the new-block allocation path this extra reference is dropped
after ext4_xattr_inode_inc_ref_all() accounts for every entry in the
block.  But when mbcache supplies an identical existing block and that
block is reused, the cached block already carries the correct refcount
for its entries, and the extra reference is never dropped.

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 6127e94ea4f5d..cec71c993286d 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2032,6 +2032,26 @@ ext4_xattr_block_set(handle_t *handle, struct inod=
e *inode,
>  			mb_cache_entry_touch(ea_block_cache, ce);
>  			mb_cache_entry_put(ea_block_cache, ce);
>  			ce =3D NULL;
> +			if (!(bs->bh && s->base =3D=3D bs->bh->b_data) &&
> +			    ea_inode) {
[ ... ]
> +				error =3D ext4_xattr_inode_dec_ref(handle,
> +								 ea_inode);
> +				if (error)
> +					ext4_warning_inode(ea_inode,
> +							   "dec ref error=3D%d",
> +							   error);
> +				iput(ea_inode);
> +				ea_inode =3D NULL;
> +			}
>  		} else if (bs->bh && s->base =3D=3D bs->bh->b_data) {

[Severity: High]
This is a pre-existing issue, but does this error path leak on-disk EA inode
reference counts, block quota, and physical blocks?

Further down in the new block allocation path of ext4_xattr_block_set(), the
code calls ext4_xattr_inode_inc_ref_all() to increment the on-disk reference
counts for all entries in the block:

			error =3D ext4_xattr_inode_inc_ref_all(handle, inode,
						      ENTRY(header(s->base)+1));
			if (error)
				goto getblk_failed;

If a subsequent operation like ext4_handle_dirty_metadata() fails, such as
returning -EIO due to a synchronous write failure in nojournal mode:

			error =3D ext4_handle_dirty_metadata(handle, inode,
							   new_bh);
			if (error)
				goto cleanup;

The code jumps directly to the cleanup label.

Will jumping to cleanup bypass block deallocation (getblk_failed) and
fail to revert the previously incremented EA inode references?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812044556.2209=
787-1-matthias.goergens@gmail.com?part=3D1
