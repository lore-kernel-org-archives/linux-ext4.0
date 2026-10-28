Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793149346;
	b=apKk6UlNT6gKI4LkfMdTEeB4ws5jTfJjtxNsWvOFsnt6vkmO8KwPy5AGoDBPRFwQhlaa
	 IAyRuUFOXGemHs47Owbi3czrMnGNSC0Z3LsqzI1V3qWaCNn6NwhEaGvzDLazwLY54Fi1t
	 PkrlwemCFyUAqKpIgCu/UJdGCpyRVGKlIZRYTu1uhRGtjfv3B9sXE+veOjpX6X/6/fLla
	 PxRmiim4U/LJdna6XztH576o82LDAERtr3zj1cTlHmJgw7GYs+4LpBdHJjYy4LykbAMGK
	 z33CDnSc2z9IbcMzSw05AKsAV0YSB1dvmUozT0Y4jij4h7ZysLAcw98Zmhvt15sh61Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793149346;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+6smSR9BwmqBGNfpDwi+BfvbmEchUfuCnfAhCoRbgic=;
	b=HDzNJj7bgiWtjYW/j+AIXP2lOioLSAViiR2SC1sDe0ImsrKIgDnL4xSzkDg/TRV3D+P8
	 KYJApskI6+htdOJ7dtHIuwp+U6ElclrVwXOrCViU+a7m9o4A3R+sXHL6hGlHSeUm6BEKJ
	 g4htEjgOpdQoCXkMAvQoe8WOVUNyCiFhz7Rv6c15AfViokCPvqQzW7z7bsO8bb4D/jVcv
	 mKOSYFQN9vjGQdl0aDvixb4ru9ltgO/bC4ID7Zu/xM2A0P8GpQksWGykYQ5uJ1DBOZ1j9
	 oJpIrTM9zYUshkgb5XaS6zfVRCjN1iSFTL9v7sASCHIEbSuNWuzUfH+dArEj7eko/Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aELs0Gum;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F52606A31A
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 01:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aELs0Gum
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF311F01825;
	Wed, 28 Oct 2026 01:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793149346;
	bh=+6smSR9BwmqBGNfpDwi+BfvbmEchUfuCnfAhCoRbgic=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aELs0Gum6TcTLQIMkpw6y8K3v33IyVAvy3cjAUEepNLxMmkOkyycb7D9EYSCUH2Bk
	 6qk/r/SA3p2qU4/Zq7pkntWZA0BmMZ30DRucUnPt/K/cz6KUl4XMm6ojzrlvAC4J4p
	 4lhFaaEvlrZso2QWIKyhZLxmpjfExC3plnJo4d3QZvvB3Jovr3fifdc7PearZzOHam
	 MripkOAMlY+xcgqX0jx1oMDMk5TDmQMtltdxjUviTl3ZrYYFXrxAvwdXZMOLvFq3db
	 R/f8fFE5ZBbbFnH85/MTp4eXBqOi3vYB/R7apHwun8j8aop7P644rHymf4Zi373bqA
	 J6TDD8yIKyA1g==
Message-ID: <sashiko-outbox-187298@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.12] ext4: validate readdir offset before accessing
 dirent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261028003746.31943-1-ebiggers@kernel.org>
References: <20261028003746.31943-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 01:02:25 +0000
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
- [Medium] ext4: unvalidated rescan rec_len in ext4_readdir() bypasses tail=
 check
--

commit f6671320411a20d7f17d0b2fabcaf53f7a52ec83
Author: Yao Kai <yaokai34@huawei.com>

ext4: validate readdir offset before accessing dirent

This commit bounds the directory entry rescan loop in ext4_readdir() using =
the
minimum directory entry record length and validates that offset does not la=
nd
in a truncated block tail before entering the main entry-processing loop. If
offset falls into the trailing bytes at the end of the block, it logs a
directory error and advances ctx->pos to the next block.

Link: https://patch.msgid.link/20260706041313.708346-1-yaokai34@huawei.com

> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index b278b5703c197..265e544cc3482 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c

[ ... ]

> @@ -234,7 +235,10 @@ static int ext4_readdir(struct file *file, struct di=
r_context *ctx)
>  		 * dirent right now.  Scan from the start of the block
>  		 * to make sure. */
>  		if (!inode_eq_iversion(inode, info->cookie)) {
> -			for (i =3D 0; i < sb->s_blocksize && i < offset; ) {
> +			for (i =3D 0;
> +			     i <=3D sb->s_blocksize -
> +				  ext4_dir_rec_len(1, has_csum ? NULL : inode) &&
> +			     i < offset;) {
>  				de =3D (struct ext4_dir_entry_2 *)
>  					(bh->b_data + i);
>  				/* It's too expensive to do a full
> @@ -256,6 +260,17 @@ static int ext4_readdir(struct file *file, struct di=
r_context *ctx)
>  			info->cookie =3D inode_query_iversion(inode);
>  		}
> =20
> +		if (unlikely(offset < sb->s_blocksize &&
> +			     offset > sb->s_blocksize -
> +			     ext4_dir_rec_len(1, has_csum ? NULL : inode))) {
> +			EXT4_ERROR_FILE(file, bh->b_blocknr,
> +					"bad entry in directory: %s - offset=3D%u, size=3D%lu",
> +					"directory entry too close to block end",
> +					offset, sb->s_blocksize);
> +			ctx->pos =3D round_up(ctx->pos, sb->s_blocksize);
> +			goto next_block;
> +		}

[Severity: Medium]
What happens in ext4_readdir() if a corrupted de->rec_len in the rescan loop
advances i past sb->s_blocksize?

In fs/ext4/dir.c:ext4_readdir(), when !inode_eq_iversion(inode, info->cooki=
e)
triggers a rescan (for instance after ext4_dir_llseek()), the loop only che=
cks
the lower bound of de->rec_len before adding it to i and updating ctx->pos:

		if (!inode_eq_iversion(inode, info->cookie)) {
			for (i =3D 0;
			     i <=3D sb->s_blocksize -
				  ext4_dir_rec_len(1, has_csum ? NULL : inode) &&
			     i < offset;) {
				...
				if (ext4_rec_len_from_disk(de->rec_len,
					sb->s_blocksize) < ext4_dir_rec_len(1,
									inode))
					break;
				i +=3D ext4_rec_len_from_disk(de->rec_len,
							    sb->s_blocksize);
			}
			offset =3D i;
			ctx->pos =3D (ctx->pos & ~(sb->s_blocksize - 1))
				| offset;
			info->cookie =3D inode_query_iversion(inode);
		}

Because de->rec_len is a 16-bit on-disk value, a corrupted entry can set
offset > sb->s_blocksize. That value is bitwise-ORed into ctx->pos, which
corrupts the upper block-number bits of ctx->pos, and info->cookie is updat=
ed
to match inode->i_version.

Then, because the new tail check requires offset < sb->s_blocksize:

		if (unlikely(offset < sb->s_blocksize &&
			     offset > sb->s_blocksize -
			     ext4_dir_rec_len(1, has_csum ? NULL : inode))) {

and the subsequent main loop also checks offset < sb->s_blocksize, an
oversized offset bypasses both EXT4_ERROR_FILE() and ext4_check_dir_entry()=
 on
the corrupted block. On the next iteration of the outer loop, ext4_readdir()
will read the block corresponding to the corrupted ctx->pos at an arbitrary
mid-block offset =3D ctx->pos & (sb->s_blocksize - 1) without rescanning, s=
ince
info->cookie now matches inode->i_version.

Should the tail check (or the rescan loop) also catch offset > sb->s_blocks=
ize
before bitwise-ORing offset into ctx->pos and validating info->cookie?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028003746.3194=
3-1-ebiggers@kernel.org?part=3D1
