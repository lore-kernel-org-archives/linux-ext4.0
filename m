Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104463;
	b=09NLyOw9KcbNmGfVR068nGbMJ+JwLVKoV7cx3QXrPRIUQmWRr+YzG+YqFEuzAxuMNnqQ
	 8Q2sr/sEaqAOdUzMYC/GUY4L5nqeqW3cJ0a8dBOkpdkksM4e+OGFfFvhFUdBGtrGz2DGI
	 fQLP/DKdAD3KgD46Fg4yDunLgBjaIxjImIJmnuKmdwxDLj8VUYmtbgjfgxgXpSEUrjQe6
	 uabfNNAVoJYKYCLCqVnqINebQbTv4tcyCAWwFCIJsXvsI6f24AWJakEafPo88xV6V3rl4
	 7xchIxy4Vc/K3ql/2vboIwPht5s/w0w7C4QFuwM6jEL3jZFqD/KlxwjH4rraKGEzoUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104463;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VRBc/nCi1pgNYE+BwetpSuuHYEEODOCwLpvXPeSd83Q=;
	b=R57U3R1wayuCJonY4RRbGsIO9zNNx7otlTpcwSdUni27MW5V1V7qjcWHcMrotgGffXO6
	 /XGNwSI7Msh99rS5klozilTKywQ9d0598+EuzBEYvsM+hjVe7eH3D5vLn9/r8ShSo2kEd
	 pszsoi9UYAcvkjvpOBGP2sjNN+0VHh5ZLJpdYa3LZp/dX0gKdnv5GAgYYaEiALWHMiNNF
	 /JYCgvi8VdR2MaMR/ZRI3G+mrXh6AgwN9tFws5LilglKpyTXROuJE+K3tDVfnTSEviANE
	 wsDjFE6P+MhU9YW0+HX+WOlh+4TgqqAuept12NIRLV/bT11OHDo4kCeK1V1z2s7hyog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D6GTScMh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD36606A333
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D6GTScMh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677361F000C5;
	Thu, 19 Nov 2026 16:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104462;
	bh=VRBc/nCi1pgNYE+BwetpSuuHYEEODOCwLpvXPeSd83Q=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=D6GTScMhUlDw7wpVqHypXAKiHVRix4Dr/hItXjp75PvA25l38KaowYqh+roTReb0i
	 d8WecLH29UUGCFowdL29pnSqhxEBnUQxCV0WlD/ymalXA9mgbdxkO5CDr1beQM/0JK
	 imVWZm6VoJxm5VsfJNF2dHyBptBDzE6BbdY40Nn1gZjwO5g1P5o6fQrgHm3J8eW8M7
	 gGVg75fCYm2Bz4AtxJIIlBO9mx9QJLOXducCx2rw/J5Sm9ofTEYsm1kopl2v6eiqMq
	 EzkesL6lnsytO8uiltH5ZdhHWca881lO6x61Uucto2fDQRgjM4onpm/idg357XtV+k
	 iLIFrUvMA2rEA==
Message-ID: <sashiko-outbox-223473@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 06/26] ext4: add KUnit tests for fs/ext4/inline.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-7-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-7-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:07:42 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add the ext4_inline_test KUnit test suite in fs/ext4/inline-test.c to
> comprehensively exercise inline data operations for regular files,
> symlinks, and directories in fs/ext4/inline.c without requiring a
> mounted block device:
>=20
> - Inline capacity and discovery (ext4_get_max_inline_size and
>   ext4_find_inline_data_nolock) across fresh inodes, inodes with zero
>   extra_isize or 128-byte inode size, inodes with coexisting user
>   xattrs in ibody, 0-byte and non-empty system.data xattrs, and
>   corrupted xattr entries (e_name_len overflow and non-zero
>   e_value_inum).
> - Inline file creation, expansion, overwrite, and destruction
>   (ext4_try_to_write_inline_data, ext4_write_inline_data_end, and
>   ext4_destroy_inline_data) spanning i_block (< 60 bytes) and the
>   ibody system.data xattr (>=3D 60 bytes), short writes with failed-write
> [ ... ]
> Export the tested functions with EXPORT_SYMBOL_FOR_EXT4_TEST and add
> KUNIT_STATIC_STUB_REDIRECT hooks for ext4_inline_getblk,
> ext4_da_get_block_prep, and ext4_inode_journal_mode.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D6

