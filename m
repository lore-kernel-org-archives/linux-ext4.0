Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773CB242D84
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2026 00:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334526; cv=none; b=KGPa9GY5NoIls2ep+XZd947+j3SXEbAYhlFKKVsgG2nnFQbuzsbFVgiAaglZUVH5PYt2kSJAA6HWf8Bxv6Ojci0jgFjmqn2bJ/pjCq6dqZOm2WljD4RbNLWvdVL3tiDycpyBkCBrKEqQkBshiJ7YIJhs6sG5S5azrTxMcvGGLGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334526; c=relaxed/simple;
	bh=45yaZEYM7x0ccI7BWR1Bgv9Bo4rBsMN404VEKD5zRl8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VfBK3jdknewA7/DLa3S4DhlLrq0R5+ldxYaJLe/stN24wbAPvfii2Hq+wmwaN9P/vJSm/c0syhxNMUH1yqGun9TAs6Xw7JE6PGNNuYgEnsZbniao2y5Yuqk2GJoVFweS9sOx73bZsdqNBno83UWnw4DLeH5XqGtKN8YMNbCgOMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BzkaT2IY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BzkaT2IY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F431F0089B;
	Wed,  7 Oct 2026 00:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791334525;
	bh=LEaUgC/C+G6VaGDh4UCNrXjW6e1mLKUU2LyhMw4zHY0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BzkaT2IYixr6qqYcrO5EvH4gztonrhPPO3uO+aeSYCjRrZWfQWYCSPnlEgOilfRKl
	 OmWQUrcJr41oLzqZXAzpT5iBa3K1ca+Wq0DRT2QLkDUotYtXrQ65B3PA+iyvMdDnt+
	 1u4+obCVMe05qz/rQW8MAegYX7rkWNCJz0omPLe21kXxo+Q1i4oc7jSusfm5meMff1
	 dPb7NlWYrGRYXRnnrRoSjdTVZUawKzbpDdFBG+7Ark0BTO48wCSOXqx8l4/4iVrRi8
	 Kcj4eXNFI5jR9ACE21IEa/GnvBMcG6X/Sym5jiq792QPFlgPg4dzhAXhBUa2fbbzM3
	 FUmCFKKXLmQgw==
Message-ID: <sashiko-outbox-162556@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] ext4: track zeroed out blocks of unwritten extents
 for fast commit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261007-ext4-fc-zeroout-v1-2-b86de6439431@samsung.com>
References: <20261007-ext4-fc-zeroout-v1-0-b86de6439431@samsung.com>
 <20261007-ext4-fc-zeroout-v1-2-b86de6439431@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 00:55:24 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: missing ES tree update in ext4_split_extent_zeroout() causes=
 stale fast commit logs
--

commit 9e702f427b4057cfc7aebd5f1480625ae8d66b78
Author: Daejun Park <daejun7.park@samsung.com>

ext4: track zeroed out blocks of unwritten extents for fast commit

When ext4_ext_convert_to_initialized() converts part of an unwritten
extent, it may zero out the blocks before and after that range and convert
them to written together with it. This patch tracks these zeroed out blocks
for fast commit in ext4_zeroout_es() and ext4_split_extent_zeroout().

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index d65e30f3c1a74..3b45b55931c2b 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3149,7 +3149,8 @@ void ext4_ext_release(struct super_block *sb)
>  #endif
>  }
> =20
> -static void ext4_zeroout_es(struct inode *inode, struct ext4_extent *ex)
> +static void ext4_zeroout_es(handle_t *handle, struct inode *inode,
> +			    struct ext4_extent *ex)
>  {
>  	ext4_lblk_t  ee_block;
>  	ext4_fsblk_t ee_pblock;
> @@ -3164,6 +3165,12 @@ static void ext4_zeroout_es(struct inode *inode, s=
truct ext4_extent *ex)
> =20
>  	ext4_es_insert_extent(inode, ee_block, ee_len, ee_pblock,
>  			      EXTENT_STATUS_WRITTEN, false);
> +	/*
> +	 * The zeroed out blocks became written together with the mapped
> +	 * range, but ext4_map_blocks() reports only the mapped range to fast
> +	 * commit.
> +	 */
> +	ext4_fc_track_range(handle, inode, ee_block, ee_block + ee_len - 1);
>  }
> =20
>  /* FIXME!! we need to try to merge to left or right after zero-out  */

[ ... ]

> @@ -3400,6 +3407,14 @@ static int ext4_split_extent_zeroout(handle_t *han=
dle, struct inode *inode,
>  	if (err)
>  		return err;
> =20
> +	/*
> +	 * The whole extent is written now, not only the range in @map that
> +	 * ext4_map_blocks() reports to fast commit.
> +	 */
> +	if (flags & EXT4_GET_BLOCKS_CONVERT)
> +		ext4_fc_track_range(handle, inode, ee_block,
> +				    ee_block + ee_len - 1);
> +
>  	return 0;
>  }

[Severity: High]
Does this code need to update the in-memory ES tree by calling
ext4_es_insert_extent() before tracking the range for fast commit?

Unlike ext4_zeroout_es(), ext4_split_extent_zeroout() does not update the ES
tree, so the outer zeroed blocks remain EXTENT_STATUS_UNWRITTEN in the cach=
e.

When the fast commit thread runs ext4_fc_snapshot_inode_data(), it traverses
the tracked bounding box and queries the ES tree. Because the ES tree is st=
ale,
it sees the outer blocks as unwritten and incorrectly logs them as
EXT4_FC_TAG_ADD_RANGE with unwritten =3D 1.

After a crash and replay, could this cause the extent to be incorrectly res=
tored
as unwritten instead of initialized?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-ext4-fc-ze=
roout-v1-0-b86de6439431@samsung.com?part=3D2
