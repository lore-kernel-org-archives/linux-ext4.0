Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793785004;
	b=tJlOVnFWW2cVfkzYRunJnPdt5MY1I11qSfZe9NVyft0ZO8S4znmZ+w8O1nRCsNUM3n0c
	 YdFjq4YB90MFPdCuuanq7KMC24noz9fKA2QO1bVoeIUxKfRqPWisVyL8OHWQYgUNP4OB6
	 lc7vWq9JFi5t7z8MGoJv3QG1p+R57BKu146Bplxi+fcJGmmRvg9Ffe7ap2/EIHS2jZmCy
	 gOGRwkuhbRH4d/FKyUPjif1dLsPlakJYkdZ1s9ZIyVhQkiBGfxPgeeGnKvqlPPZAwUwYE
	 A6JnymMq2Ea9BKIdR5WVzM0wffq9w3Aw0Rrt0DN/0wC4MfRRILemD8N3k1nDi5D2ajQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785004;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=01p5GeNw3P/L87SFuQYP5P5H5Jf9lRoPfbVdIzsdj/o=;
	b=yfNzaNRXmWA21NDHO12SIdS7mjxwwfdkVDbGSXQH4RIG3XHeq796BLd5J2BpUJX09knE
	 8cvZInRjxq/lGLhTd68aeciOYafwR1+zJG/dx4ve+2DlO8UR1SdpqBzyLJIQArcfvwUhZ
	 QLNrLzzj/Dv3OfwPVwjrIEG8mVuTWYuOqcmV6/GNhKkOzQNzf8f/zMU7tH0ZuR+Og8QJ/
	 rwMFnDbleYCGeSFMIFChAKTTD1avlj6Ce9OuVckxzDMzeyFup/2/2VK28UcdfqGqzag5C
	 7YYTE8b8H56koxZgliVwllCVt1pYiEou9lQmlRG/lBXM01HekalHFbz+IQLNEe2247w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NObZ8L5a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E8B606A31B
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 09:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NObZ8L5a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15F11F00919;
	Wed,  4 Nov 2026 09:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793785003;
	bh=01p5GeNw3P/L87SFuQYP5P5H5Jf9lRoPfbVdIzsdj/o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NObZ8L5as1+G+8Je0uZTot3aMqaLG4cgL6mu1ia3d4+m7OSgZuse15wagp9UxRMBa
	 WXWQtpSBvP7loSz3ur0B+mR/iZs7f5PMRzD7BcXaOu0LJtclj2SsNdNblUXVJpvRLs
	 3j2kdLVUBhYLkovo4bmrYuAk7hYPmocPi7xnN1ngLvn+wU5J+nKHZ/tisOM2xgGqKY
	 27iZOKw6LgGmFKbah9u+t8UHYPBvY+3TMxG2XPMIe+vWoiaaCTlUozpUTLkwvbJl2M
	 DxiBQw24ORJa0iADzBmAoRipTxe+/y2ioSI1iSBJW4fwGr8dby2BKFA9B4BEOZ7mcM
	 px+J7bvgt6iDA==
Message-ID: <sashiko-outbox-196970@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: fix slab-use-after-free in do_split()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <tencent_8E52FEA6C91DD754CC6282C41D4DFA95E505@qq.com>
References: <sashiko-outbox-196913@kernel.org>
 <tencent_8E52FEA6C91DD754CC6282C41D4DFA95E505@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 09:36:43 +0000
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
- [High] ext4: do_split() index aliasing check misses ancestor htree frames
--

commit e40bb57a242c155ab31395a6ce2f3af162258422
Author: Shuai Liu <847807867@qq.com>

ext4: fix slab-use-after-free in do_split()

This commit adds checks in do_split() to verify that the directory leaf blo=
ck
being split (*bh) and the newly allocated block (bh2) do not alias each oth=
er
or the htree index block (frame->bh) before moving directory entries.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 231a274b814ec..0789c9dc31b80 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1922,12 +1922,36 @@ static struct ext4_dir_entry_2 *do_split(handle_t=
 *handle, struct inode *dir,
>  	if (ext4_has_feature_metadata_csum(dir->i_sb))
>  		csum_size =3D sizeof(struct ext4_dir_entry_tail);
> =20
> +	if (*bh =3D=3D frame->bh) {
> +		ext4_error_inode_block(dir, (*bh)->b_blocknr, EFSCORRUPTED,
> +				       "leaf block aliased with index block");
> +		brelse(*bh);
> +		*bh =3D NULL;
> +		return ERR_PTR(-EFSCORRUPTED);
> +	}
> +
>  	bh2 =3D ext4_append(handle, dir, &newblock);
>  	if (IS_ERR(bh2)) {
>  		brelse(*bh);
>  		*bh =3D NULL;
>  		return ERR_CAST(bh2);
>  	}
> +	if (bh2 =3D=3D *bh) {
> +		ext4_error_inode_block(dir, (*bh)->b_blocknr, EFSCORRUPTED,
> +				       "cannot split aliased directory block");
> +		brelse(bh2);
> +		brelse(*bh);
> +		*bh =3D NULL;
> +		return ERR_PTR(-EFSCORRUPTED);
> +	}
> +	if (bh2 =3D=3D frame->bh) {
> +		ext4_error_inode_block(dir, bh2->b_blocknr, EFSCORRUPTED,
> +				       "leaf block aliased with index block");
> +		brelse(bh2);
> +		brelse(*bh);
> +		*bh =3D NULL;
> +		return ERR_PTR(-EFSCORRUPTED);
> +	}

[Severity: High]
As reported by Sashiko on v2 [1], what happens in a multi-level htree
directory (indirect_levels >=3D 1) when *bh or bh2 aliases an ancestor index
block such as frames[0].bh?

In ext4_dx_add_entry(), dx_probe() populates frames[0..indirect] and returns
frame =3D &frames[indirect], which is then passed to do_split():

fs/ext4/namei.c:ext4_dx_add_entry() {
	frame =3D dx_probe(fname, dir, NULL, frames);
	...
	de =3D do_split(handle, dir, &bh, frame, &fname->hinfo);
}

When indirect >=3D 1, frame->bh is the lowest-level interior index node
(frames[1].bh or frames[2].bh), while frames[0].bh holds the root index blo=
ck
(struct dx_root, containing info.indirect_levels at byte offset 30). Because
do_split() only compares *bh and bh2 against frame->bh, an alias with
frames[0].bh (or frames[1].bh in a 3-level tree) is not caught.

Note that in a 1-level htree (indirect =3D=3D 0, the only case where
frame =3D=3D &frames[0]), frames[1].bh is NULL, so dx_release() breaks at i=
 =3D 1
and cannot read past the stack array frames[EXT4_HTREE_LEVEL]. The
out-of-bounds read in dx_release() can only happen when all three frames are
populated (indirect =3D=3D 2, where frame =3D=3D &frames[2]):

fs/ext4/namei.c:dx_release() {
	info =3D &((struct dx_root *)frames[0].bh->b_data)->info;
	/* save local copy, "info" may be freed after brelse() */
	indirect_levels =3D info->indirect_levels;
	for (i =3D 0; i <=3D indirect_levels; i++) {
		if (frames[i].bh =3D=3D NULL)
			break;
		brelse(frames[i].bh);
		frames[i].bh =3D NULL;
	}
}

If *bh or bh2 aliases frames[0].bh when indirect >=3D 1, dx_move_dirents() =
and
dx_pack_dirents() overwrite frames[0].bh->b_data, corrupting
info->indirect_levels. When ext4_dx_add_entry() then calls dx_release(frame=
s),
could a smaller overwritten indirect_levels value cause dx_release() to stop
early and leak frames[1..indirect].bh, and could an overwritten value >=3D =
3 in
a 3-level tree cause dx_release() to read past frames[] on the stack and pa=
ss
stack garbage to brelse()?

Also, should the commit message body be updated to mention the index block
aliasing checks added in v3?

[1] https://lore.kernel.org/r/tencent_7AA5D3581EE4D99A947097C4F02730DCCF09@=
qq.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_8E52FEA6C91=
DD754CC6282C41D4DFA95E505@qq.com?part=3D1
