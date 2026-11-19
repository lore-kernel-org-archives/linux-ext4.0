Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105145;
	b=O03XiQF6v8ggBTksp6pJtYjQDhCxp8KegAhNv4d+9lESaqqi5j7/NaRoX5dGWiLza/Oq
	 8fq7gohPOxuYyaDK4wZfz2N3TovJbbLf/A1yor8ACPFM/zAq66Gfuy2ljOcWQUOGPdvOU
	 mPaqPqNuYqCbDiVtkMCYDm9rFqyWxg4XRf6yw20q0NTqK+mG5xBy2k3ArOk0ifH3Ad+Eb
	 2u3IkGZ+z9BfK4BeWZQXSAIpJr+F2qbgCjp3nZ4laWg3Z9BtsDIvyIrPlSHvLXWGklulE
	 5JOWHPiIIWdirZqemABC8dlJ7vLzxYP95Ab8ISs5f+ely9MVzh9nvsSvqC9dKXeq0OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105145;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3v4Mpnk3qfdDDq8V1qF1sofWsP0cu286bA1kQu5PbOE=;
	b=nAR2GxoqgDFkBXso/rIVvzntiyas912OF3PXZbgaLLL3N24UkS3YMmQHkEiMg2+cKQBG
	 Ke05TKzDOSzF76HdBFxKCgE8vS8b6UMpAcZgONZt0bCILX6D58BV8JuaJRozSwGEineLh
	 mp4B7U7rsAiUxBDuR5zCrPmsCshqpa91od7zDCni0DtJq+cHcol0XTeXaaeuW2pVO/J+f
	 j50w7FnndaadBVbTQ9eevsg+X/uhPzEJqry/JryQ4W84ctWnuIYQRw3/Js1/+LEc8487U
	 UP6QaGi2ULH/crpP/rxu6hc7LsvZzPdHqJFVapDWyfr+ftndnvHxZ5Qe07lthBf+iBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cuJD+BFa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C198606A33D
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cuJD+BFa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7DB1F000C5;
	Thu, 19 Nov 2026 16:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795105145;
	bh=3v4Mpnk3qfdDDq8V1qF1sofWsP0cu286bA1kQu5PbOE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=cuJD+BFaYruvuI1w31IBlm3zFoI5t1F+ubpMk0UenY2FjvMUN6xCUjoSTF3b7H7pE
	 yreoaFSQGEVQkSkTqbsnhkIeNLgAxtyOGgVCFECKSqq2zREnWt9HpKLuDbx7J03kpl
	 QRkSuKeAt0yeWyFhkmJRiFUFTcv8ow5PyPsrhquwr0uzyAQRqLmgb3K7jzXGK6J3ds
	 StiFTzt7dnSzjoIqgNnyhtaPcaPUW08M6m4h8BdBxuySLf/L+HwajBzAMhNmFXRlzZ
	 QIb/wkw4Ti1pwH0jpJ0dQb4qz81eTqJFL/UpccbgWjKOfxrroJzNjaODIMysS8LJB0
	 WyuR/6SXjVrJQ==
Message-ID: <sashiko-outbox-223509@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 02/26] ext4: add KUnit tests for fs/ext4/extents.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-3-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-3-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:19:04 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] ext4: extent loss in ext4_ext_split() after dropping
  __GFP_NOFAIL
--

commit ebd19bc1cdea3cf4f65a39e530d43e87d087d855
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/extents.c

This commit expands the ext4_extents_test KUnit test suite to cover extent
tree operations in fs/ext4/extents.c and adds KUnit static stub redirects
and symbol exports for testing.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index aa65aca4a1ead..0a442844b954e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
[ ... ]
> @@ -1212,7 +1219,7 @@ static int ext4_ext_split(handle_t *handle, struct =
inode *inode,
>  	while (k--) {
>  		oldblock =3D newblock;
>  		newblock =3D ablocks[--a];
> -		bh =3D sb_getblk(inode->i_sb, newblock);
> +		bh =3D ext4_ext_getblk(inode, newblock, __GFP_MOVABLE | GFP_NOFS);
>  		if (unlikely(!bh)) {
>  			err =3D -ENOMEM;
>  			goto cleanup;

[Severity: Medium]
Can replacing sb_getblk() (which passes __GFP_NOFAIL) with
ext4_ext_getblk(..., __GFP_MOVABLE | GFP_NOFS) lose the m split extents if
this allocation fails?

By the time ext4_ext_split() enters the intermediate index loop, the m
extents have been moved to the new leaf block in ablocks[] and the old
leaf has already had its eh_entries decremented in place and dirtied:

fs/ext4/extents.c:ext4_ext_split() {
	...
	/* correct old leaf */
	if (m) {
		err =3D ext4_ext_get_access(handle, inode, path + depth);
		if (err)
			goto cleanup;
		le16_add_cpu(&path[depth].p_hdr->eh_entries, -m);
		err =3D ext4_ext_dirty(handle, inode, path + depth);
		if (err)
			goto cleanup;

	}
	...
}

Jumping to cleanup on -ENOMEM frees all blocks in ablocks[] (including the
new leaf block holding those m extents) without restoring
path[depth].p_hdr->eh_entries, leaving the old leaf truncated in the
running transaction.  Passing __GFP_NOFAIL here as sb_getblk() did would
avoid failing after the old leaf has been modified.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D2
