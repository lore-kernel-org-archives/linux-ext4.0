Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793841549;
	b=A9SCdXHupu0Dzc52hmrMJt0i235ST/uWiCkJmZX3xkzuuzUjSYNkq0AdjRLRukQRd0EX
	 l5OSfl9tjlWCHndN5xEA8SrMv+A6s0XFhGR5g7WH4rUNYoLerzpP7K999xwb333uWrXNP
	 OABncVVYxDfuz9KXP1a8kYDpfkaRtcGpRCcWMsMHVAdYTi8p6f9wGIPLi0NHSbivz6woL
	 f3CygUXUO3GlmvCo3LMoBTwYsJOZIER8EzGA03EbyHrleHHmsovp4/vYs/62bfLI+Blv1
	 IqbJ8t62km9pNDPfI7e30KepvT94BbRN3BfDRG6Xwv2MaIM1In/roMr0vSFv7ZEwWCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793841549;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LzH3zCIUlf8Sl2PSyGGiKnxh9LAdELRLrm/Qx1meGuA=;
	b=Wx2kXtt5xCepcsvKbyycm2iVxNgcXLok91h2vKUD4hM/fvFPgFCwiu+zd0fd6HWu1Tsz
	 s4gd9Qv/zbj9bxIMBF0vLITq0UvgEcG4Dg7q2qqUkSxSS23J7H8kOy3MPCEPnwCOO3Ex1
	 YyyT+P8u8fq0q0HQAkfbBdiLX7agvBUs1oShi6PpzazcfmY6ap4vnP1x86pXJP/vrUoE4
	 X7TSvQTrH9ezd0Wc35JnhIJCYYxNoymrrViZ94musvy2U/irEY54bQm9d5Q/vRCjhk5ot
	 QcsLQe2SKHuZyplH4kxHXHX9a+80yaqaXupMXVZyVImFsII65zO7nje+OLr/BTnPQ9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V9KdCUbQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708EE606D818
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V9KdCUbQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81341F00A02;
	Thu,  5 Nov 2026 01:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793841549;
	bh=LzH3zCIUlf8Sl2PSyGGiKnxh9LAdELRLrm/Qx1meGuA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V9KdCUbQoY11UNt/rdnP+rdkqurPuy3H7ZqvN9Ef4OVPThxtBCgQlThVmVPGlgDQr
	 jWV9zVZkFKHTbrydAAV91p7yd/3nFZi73C4t/gI2f6rdmHFAGn2NwtOi869W2dtTlM
	 JzrPfuMxSVJ0CQXfRQAR6Hwh4z5lFxed8qf/WIaoriK866mYXPgz4XsVfxtTCUyWaX
	 OCjMZ1625aPLHJ8m500eSlLTafx1He/+zN1LrcNUzgQWdv+cJS7apAYLLjM2zKehrl
	 IMREYGNQypc1QD48Vd4C5HdMZPonn9srfBbV0l/0gm4++mLFc/tKjkva9qea0tn9fQ
	 hCmyxgfLBypzg==
Message-ID: <sashiko-outbox-198398@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7] ext4: fix slab-use-after-free in do_split()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <tencent_7C8B9CBC52133FEE9798F6C494FB91B43106@qq.com>
References: <sashiko-outbox-198371@kernel.org>
 <tencent_7C8B9CBC52133FEE9798F6C494FB91B43106@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 01:19:08 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: missing index-to-index alias check in dx_probe() and ext4_dx=
_add_entry()
--

commit 5e5de45a3996807d23fd6ebf3ff43ca17d889c45
Author: Shuai Liu <847807867@qq.com>

ext4: fix slab-use-after-free in do_split()

This commit adds buffer_head alias checks in do_split(), make_indexed_dir(),
and ext4_dx_add_entry() to prevent directory leaf blocks and newly allocated
blocks from aliasing each other or active htree index frames on corrupted
filesystems.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 231a274b814ec..fadc2de1beb1c 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c

[ ... ]

> @@ -2496,6 +2535,15 @@ static int ext4_dx_add_entry(handle_t *handle, str=
uct ext4_filename *fname,
>  		bh =3D NULL;
>  		goto cleanup;
>  	}
> +	for (f =3D frames; f <=3D frame; f++) {
> +		if (bh =3D=3D f->bh) {
> +			ext4_error_inode_block(dir, bh->b_blocknr,
> +					       EFSCORRUPTED,
> +					       "leaf block aliased with index block");
> +			err =3D -EFSCORRUPTED;
> +			goto cleanup;
> +		}
> +	}
> =20
>  	BUFFER_TRACE(bh, "get_write_access");
>  	err =3D ext4_journal_get_write_access(handle, sb, bh, EXT4_JTR_NONE);
> @@ -2549,6 +2597,18 @@ static int ext4_dx_add_entry(handle_t *handle, str=
uct ext4_filename *fname,
>  			err =3D PTR_ERR(bh2);
>  			goto cleanup;
>  		}
> +		for (f =3D frames; f < frames + levels; f++) {
> +			if (bh2 =3D=3D f->bh)
> +				break;
> +		}
> +		if (f < frames + levels || bh2 =3D=3D bh) {
> +			ext4_error_inode_block(dir, bh2->b_blocknr,
> +					       EFSCORRUPTED,
> +					       "cannot split aliased index block");
> +			brelse(bh2);
> +			err =3D -EFSCORRUPTED;
> +			goto cleanup;
> +		}

[Severity: High]
What happens if two active htree index frames in frames[] already alias the
same physical block when dx_probe() returns?

In dx_probe(), the cycle check only compares logical block numbers in
blocks[]:

	block =3D dx_get_block(at);
	for (i =3D 0; i <=3D level; i++) {
		if (blocks[i] =3D=3D block) {
			ext4_warning_inode(dir,
				"dx entry: tree cycle block %u points back to block %u",
				blocks[level], block);
			goto fail;
		}
	}
	if (++level > indirect)
		return frame;
	blocks[level] =3D block;
	frame++;
	frame->bh =3D ext4_read_dirblock(dir, block, INDEX);

On a corrupted filesystem where two distinct logical index blocks (such as
logical block 0 for frames[0] and logical block 1 for frames[1]) map to the
same physical disk block, dx_probe() can populate frames[] with identical
buffer_head pointers (frames[0].bh =3D=3D frames[1].bh) becauseframes[0].en=
tries
is read at offset 32 (after dx_root_info) while the child dx_node entries
array is read at offset 8, allowing a single physical block to pass the
limit, count, and checksum checks for both levels.

The new checks in ext4_dx_add_entry() and do_split() verify that the leaf
block bh and newly appended block bh2 do not alias f->bh, but nothing checks
whether the active index frames in frames[0..frame] alias each other.

When do_split() or the interior index split in ext4_dx_add_entry() calls
dx_insert_block() on a child frame whose bh aliases frames[0].bh, shifting =
or
writing dx_node entries starting at offset 8 overwrites frames[0]'s
dx_root_info (including info.indirect_levels) and root dx_countlimit in
place. When dx_release() subsequently runs:

	info =3D &((struct dx_root *)frames[0].bh->b_data)->info;
	/* save local copy, "info" may be freed after brelse() */
	indirect_levels =3D info->indirect_levels;
	for (i =3D 0; i <=3D indirect_levels; i++) {
		if (frames[i].bh =3D=3D NULL)
			break;
		brelse(frames[i].bh);
		frames[i].bh =3D NULL;
	}

Can this corrupt info->indirect_levels and cause dx_release() to either leak
lower-level frame buffer_heads or read past the end of frames[EXT4_HTREE_LE=
VEL]
when all frames are active? Would checking that frame->bh does not alias any
ancestor frames[0..level-1].bh in dx_probe() prevent index-to-index aliasing
as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_7C8B9CBC521=
33FEE9798F6C494FB91B43106@qq.com?part=3D1
