Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793149443;
	b=vjS59suwhMEHlxB8aHfDpBzjCGK63JXQNI4cxOLpTDMk6StNdPAtFZcfFvsVXs1olwh0
	 93Lih9HQE1cgBzMFe6v7c11F4JJFBIUSLWgX655IgKo8wNQjR8ddOT5DWEH9E/0b26zWF
	 vm0UyFgt2tcnb8UL4JjGcHv2MtQUYJQG9R3E6qhuB9p0cQEa7qF501h7hdkhm1WpAuvog
	 s5TbMHfgJeuc6df6S0ThgMkmB+dFi+22ggZjr4IBHuHd2Dj97ESMVPm5OYq6YOgsHV1T0
	 vIP6HT/+ZH2frjH5hMmYouAQ/jhE+owN+5HMSmWkm8jWH17aIsC+dgL7kp537W+kO8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793149443;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1wuJUbaE8Q8KuNfPYtpaLmAGPmRujybpR42vhfO3kqI=;
	b=kbAV4U0jMfE8/TGY5C7KlJc9Evl29urooBdYiAoGvb8C+nCGZsvA8cDxUJwg5HrZQjkU
	 Qcv+We4fie5XOBT1xnXrVd5ZFS08WLuBqro60tWxoo0A0WVGrJsVsUrnXuVXImPv26+3q
	 +70/e7dAabAX+HisyHDJDgkUF8UClwhHOSI/JF0jr0bSmXLtJ+RJLE6yv+VJMZJEzBkPp
	 Rx1QM/cFcFoCA5/SvdA8Wj6JK+5OGwrnVNHj9JtVBQhAnbMyGIL+wqU7qcmcIKFH0mZWE
	 RKmudiXKdk+CIk80HJZtHLYdAKQ/fSXRK14Zua9sGalytH1KsszFFsomqczOAn7Cnfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gvICqNRt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A01606A31A
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 01:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gvICqNRt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA8E1F01825;
	Wed, 28 Oct 2026 01:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793149442;
	bh=1wuJUbaE8Q8KuNfPYtpaLmAGPmRujybpR42vhfO3kqI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gvICqNRtNDiWwdPLwSH+nHygH4dLnf0uq4eh1gggRhj1BYIzkzXoQVl9t6HkpJ53e
	 fy24yJl5lvtzhQnjkmVInr2bbmCAJRd3loRt5ZaWOmRJB21DitGg7IFACSAR3NgmF8
	 167j+s80RIxGGQdQegGvsdmNYzCMZ+Q6EN8c9FZUsKMAE7m2/hYaUgpmj0nXBdTX34
	 VXYSZRr1vxy3FX1Zl5qpcO3UFi73N5mL+bTYvxtHyXumGu263vwuqcgtgAXDwbWDNZ
	 NgWgpKHs7U5vLPJSkDWor3GZffdrBJbB7ihPcau5BcUh/ep0uP4VYYvP2sO4PY3b1F
	 8nl8cobg8raFQ==
Message-ID: <sashiko-outbox-187300@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6] ext4: validate readdir offset before accessing
 dirent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261028004209.58412-1-ebiggers@kernel.org>
References: <20261028004209.58412-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 01:04:01 +0000
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
- [Medium] ext4: unchecked rec_len upper bound in ext4_readdir() rescan loop
--

commit d2979e729161116125f8d03cf9aa1731cdfdef1e
Author: Yao Kai <yaokai34@huawei.com>

ext4: validate readdir offset before accessing dirent

This commit bounds the directory entry rescan loop in ext4_readdir() and
validates the block offset before accessing directory entries. When an offs=
et
falls in a truncated block tail where a complete entry cannot fit, it repor=
ts
an error and skips to the next block.

Link: https://patch.msgid.link/20260706041313.708346-1-yaokai34@huawei.com

> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 6682b8ab11f1c..bc53ea82161d3 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c

[ ... ]

> @@ -233,7 +234,10 @@ static int ext4_readdir(struct file *file, struct di=
r_context *ctx)
>  		 * dirent right now.  Scan from the start of the block
>  		 * to make sure. */
>  		if (!inode_eq_iversion(inode, file->f_version)) {
> -			for (i =3D 0; i < sb->s_blocksize && i < offset; ) {
> +			for (i =3D 0;
> +			     i <=3D sb->s_blocksize -
> +				  ext4_dir_rec_len(1, has_csum ? NULL : inode) &&
> +			     i < offset;) {
>  				de =3D (struct ext4_dir_entry_2 *)
>  					(bh->b_data + i);
>  				/* It's too expensive to do a full
> @@ -255,6 +259,17 @@ static int ext4_readdir(struct file *file, struct di=
r_context *ctx)
>  			file->f_version =3D inode_query_iversion(inode);
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
What happens in ext4_readdir() if a corrupted directory entry in the rescan
loop has a de->rec_len that pushes i past sb->s_blocksize?

During the rescan loop when !inode_eq_iversion(inode, file->f_version):

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
file->f_version =3D inode_query_iversion(inode);

Only the lower bound of de->rec_len is checked before advancing i. If
de->rec_len is corrupted such that i + rlen > sb->s_blocksize (for example,
rec_len =3D 4100 in a 4096-byte block), the loop terminates with
offset > sb->s_blocksize, corrupts ctx->pos via the bitwise OR, and updates
file->f_version.

Because the new validation check requires offset < sb->s_blocksize, an
offset > sb->s_blocksize bypasses both this check and the subsequent
while (ctx->pos < inode->i_size && offset < sb->s_blocksize) loop without
reporting the corrupted block or rounding ctx->pos to a block boundary.

On the next iteration of the outer loop, file->f_version now matches the
inode version, so the rescan is skipped and offset =3D ctx->pos &
(sb->s_blocksize - 1) can land at an unvalidated mid-entry offset or in the
tail of an uncorrupted subsequent block, triggering EXT4_ERROR_FILE() on the
wrong block and skipping its entries.

Should the condition check offset !=3D sb->s_blocksize && offset >
sb->s_blocksize - ext4_dir_rec_len(1, has_csum ? NULL : inode) (or cap the
rescan step so i cannot exceed sb->s_blocksize)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028004209.5841=
2-1-ebiggers@kernel.org?part=3D1
