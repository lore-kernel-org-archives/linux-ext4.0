Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794442415;
	b=xuUFVor858tQOdNH0G2BANuNjwuMG2XHNXjs0ERHBRuCPanODoFwD0q69+xqkCrKSAf9
	 gaIczVGo+aOvT195le/zuJGYloA9OCJ+az4j8hZ5R4BFmmq/PNguju3g65/yeIKPSkO6L
	 MYy150WEryqi0thwuUAy7SwWhADcJ4q4EtRAN7YPk/Uhb4XlLfhjfdWvH5xG2Tb/UiJMk
	 ucRtt1+/KOaw+1RxxQcwEKOP90r02dTQ7Y60G1QSdmaspS/I/taaRXUJd+4u9icvcgb0O
	 SeFeF9E3VKGeSupVqHF5bpVuw6SS3Qh/8fkZ/klryFZ+l7tcn7VO5OgQKwEcea4hz7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794442415;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6iticuenxNN2OmSXwO0WqBPTqyFVKsu3Nr3iYVVzqn4=;
	b=UN0MX1D+3R5j6PTQJafQtZeuSNgeuCxS7+B4EtJtn/IbmsdvlEFNKZgZEAQhrCS0CtdF
	 0SjO/XV24ZvNSg6xu5pi151Tq+4Pnbpkv0wDFaH8E/1Alv+YVsAI4FEurtT2v7RLGYUcd
	 qv/DhSyzW3dbXbWvqeRp6ab0b2JYVcPsYelMtVvEtu82DdPoX4SGzA8NVmYm9/eYSGXxk
	 2nrj1FeQ/a33nXA0qqkQukSkc9Z3i28xfS9pg0+IBy2iG8yf1XIyOkTBstjHT6rai6pcq
	 BBTYmN8xlg6MXmo9DHxLOBMeF+VBe2TyXp69GI84B1wDKtA8JD+u4ClKIk2hOB2TaOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="f/5IryBd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0418606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 00:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f/5IryBd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7451F00A06;
	Thu, 12 Nov 2026 00:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794442414;
	bh=6iticuenxNN2OmSXwO0WqBPTqyFVKsu3Nr3iYVVzqn4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f/5IryBd1L/GEo4ivk3wBGOWzeGsRwvOuWzvzbBPtJAQSSSEaamEKSraaycuiRGw8
	 5teyiU9WU36xUFUJ3hj1n/yMbf0KE/j/RXYNUy/pQCIPVP3TioaTzg+UqJpb8KBQrE
	 4L3UqYW3g/IRhx7wpP8VlmxekC/LlJyZZxhcWHFOv0qSPOFAuFWDnXwgqGb/1EquDU
	 oT6hu4o6YksoFJNTROCG3pUSR3MhtA8RVcYTFB2WiH483H83sgaoiB4hN9JcRejfVU
	 iUHPY5fmJ92fYBOj9GAvjTVQg8wMNeu2vfi9Xmpq0hKN0sj9dZ7BNNSdGG3qbzmzFN
	 pwv0AR1ktyGuw==
Message-ID: <sashiko-outbox-209888@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] ext4: fix directory count after fast commit replay
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mani Tofigh" <mt4022@columbia.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261111-ext4-fc-replay-mkdir-v1-1-4b20be29aed8@columbia.edu>
References: <20261111-ext4-fc-replay-mkdir-v1-0-4b20be29aed8@columbia.edu>
 <20261111-ext4-fc-replay-mkdir-v1-1-4b20be29aed8@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:13:33 +0000
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
- [Medium] ext4: unaligned memory access on raw_fc_inode in
  ext4_fc_replay_inode()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] ext4: unpropagated parent lookup error in
  ext4_fc_replay_link_internal() [1]
--

commit da3b7bd74825f337c491fafdca323cce067546e9
Author: Mani Tofigh <mt4022@columbia.edu>

ext4: fix directory count after fast commit replay

This commit passes the inode mode to ext4_mark_inode_used() so that fast
commit replay increments bg_used_dirs_count when marking a directory inode
in use, and moves the ext4_iget() lookup in ext4_fc_replay_create() ahead
of ext4_mark_inode_used().

> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0cac890cf3702..0eac7be3f58c2 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -1984,7 +1984,7 @@ static int ext4_fc_replay_inode(struct super_block =
*sb,
>  	ret =3D sync_dirty_buffer(iloc.bh);
>  	if (ret)
>  		goto out_brelse;
> -	ret =3D ext4_mark_inode_used(sb, ino);
> +	ret =3D ext4_mark_inode_used(sb, ino, le16_to_cpu(raw_fc_inode->i_mode)=
);
>  	if (ret)
>  		goto out_brelse;
> =20

[Severity: Medium]
Can dereferencing raw_fc_inode->i_mode trigger an unaligned memory access
fault on strict-alignment architectures?

Fast commit TLVs are packed contiguously without alignment padding, so an
earlier dentry tag with an odd-length filename places subsequent
EXT4_FC_TAG_INODE payloads and raw_fc_inode at an odd byte offset.
ext4_fc_replay_inode() already copies raw_fc_inode into the aligned
raw_inode buffer earlier in the function, so reading raw_inode->i_mode
instead avoids the unaligned load.

> @@ -2041,11 +2041,6 @@ static int ext4_fc_replay_create(struct super_bloc=
k *sb,
>  	trace_ext4_fc_replay(sb, EXT4_FC_TAG_CREAT, darg.ino,
>  			darg.parent_ino, darg.dname_len);
> =20
> -	/* This takes care of update group descriptor and other metadata */
> -	ret =3D ext4_mark_inode_used(sb, darg.ino);
> -	if (ret)
> -		goto out;
> -
>  	inode =3D ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
>  	if (IS_ERR(inode)) {
>  		ext4_debug("inode %d not found.", darg.ino);
> @@ -2054,6 +2049,11 @@ static int ext4_fc_replay_create(struct super_bloc=
k *sb,
>  		goto out;
>  	}
> =20
> +	/* This takes care of update group descriptor and other metadata */
> +	ret =3D ext4_mark_inode_used(sb, darg.ino, inode->i_mode);
> +	if (ret)
> +		goto out;
> +
>  	if (S_ISDIR(inode->i_mode)) {
>  		/*
>  		 * If we are creating a directory, we need to make sure that the

[Severity: Critical]
This problem wasn't introduced by this patch, but does
ext4_fc_replay_link_internal() [1] silently return 0 when looking up
the parent directory fails?

fs/ext4/fast_commit.c:ext4_fc_replay_link_internal() {
	...
	int ret =3D 0;

	dir =3D ext4_iget(sb, darg->parent_ino, EXT4_IGET_NORMAL);
	if (IS_ERR(dir)) {
		ext4_debug("Dir with inode %d not found.", darg->parent_ino);
		dir =3D NULL;
		goto out;
	}
	...
out:
	if (dir)
		iput(dir);

	return ret;
}

When ext4_fc_replay_create() calls ext4_fc_replay_link_internal() and the
parent lookup fails, it receives 0 and proceeds to set i_nlink to 1 and
mark the inode dirty, leaving an unlinked inode and inconsistent metadata
instead of aborting recovery.

[1] https://sashiko.dev/#/bug/linux-f99925c6-c893-41e7-947b-8df2ac40e92c

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-ext4-fc-re=
play-mkdir-v1-0-4b20be29aed8@columbia.edu?part=3D1
