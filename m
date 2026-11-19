Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104773;
	b=sRGpym5PqaTtorwncZEUMm2yaU9ef69QSwiC5ZKQwdn3EB6r8/i6YNReWKqYgrXdlGhF
	 bATU//dMBH85Hm1BAltVVfHBhVyV/MFxbjPjOI+NTcoOuMKtZntu/6pseot6B/xfBOHdF
	 7E6KZ/RBVnQGGgaVQf1ORdPMcQZGgCs5xVcj2DcD+TzIAB9P7FekGHHQ5lJVPEwZXke52
	 hdLCAkPHBvGGOAXHF8RK0dkhdcNQHySBbZ0P16jXy047NhG+K5bTjTzWPdKv3FwBooMcH
	 hff/FxrtHgNFNM22VWdx6Z3WzSgrG3ZfTG7D+wegQfYFZ7u9vAl+v6Lekip+iAzzXoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104773;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=006xT27H4oaSyjdDOejJ0GZmY1E/bMVUAuHw84mhO/o=;
	b=4qbpss6uKBge1xvtM4M56lEZqOk4txztvaa+DclY+dM/r7dDd6QaH7BC2DH/AOHtGzjI
	 MDbcrkgjKlrkiHikvO6BV166bcNSlEVQLUmwTcm7+HPNtVbQ8aB6eHjdb5Pp/t0xtDfnB
	 qkCUhVG7m245ZUJ768bGiwomCRNXDB+QZoct6DXUs5dPoY0izsQyk6VjPo5x5fFPMgCg+
	 ENjVAEAypWWaMLcJ87Davvp0CZMtxGcfvysryaJw0bJy3Xrq7FGYbwAMEvQoWoy5z0eZg
	 JOvXyYa2hevivr6Si8XkNWArRMdVzgn+d7J5rXplfeZUXG4jkwoLArRqBx5HVJusL1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aK8hwutB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6008606A331
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aK8hwutB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A690B1F000C7;
	Thu, 19 Nov 2026 16:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104772;
	bh=006xT27H4oaSyjdDOejJ0GZmY1E/bMVUAuHw84mhO/o=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=aK8hwutBUFpQ9Hp91d3aF+rjPItXXXbhU+uQCmk5oINLwOSJihLb3iHYcmr8D97Sj
	 CtBOtQ0s93VkA2GQZr1iCK1BoQ3WTcEOthS3ESndHb/juTXqnS9U1yxqUbuGJowS79
	 OC7BkWzQ8nBIZUqQUPs72vo0cthhRPV8NnrxaU2TTWqbb90n7X+hDKRl3zUiEnI2dR
	 lyt/+bHlnVO+uyzUiBIF9tWhCuuYQTMdLaBPYXo2ZgYiin1lpAOzFFShPptHbK9h0u
	 7FqEBhCWFa5/vqvGPoABqFB2Q0rH8Bdw6SP1cw+pw3hnujDFekSLFIhfFb6N6fFfyh
	 OHg6+hf5866OQ==
Message-ID: <sashiko-outbox-223490@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 12/26] ext4: add KUnit tests for
 fs/ext4/block_validity.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-13-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-13-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:12:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add the ext4_block_validity_test KUnit test suite in
> fs/ext4/block_validity-test.c (16 test cases, 40 subtests total) to
> comprehensively exercise system-zone rbtree construction, RCU release,
> block range validation, reserved journal inode protection, and indirect
> block reference checking in fs/ext4/block_validity.c using an in-memory
> VFS superblock and mock block device without requiring a mounted disk:
>=20
> - Bounds and 64-bit overflow checks (ext4_sb_block_valid and
>   ext4_inode_block_valid) across 1KiB (s_first_data_block =3D 1) and 4KiB
>   (s_first_data_block =3D 0) geometries, exact end-of-filesystem single
>   and multi-block spans, 64-bit u64 addition wrap-around, >32-bit block
>   counts under EXT4_FEATURE_INCOMPAT_64BIT, and high-32-bit masking when
>   64bit is cleared.
> - System-zone lifecycle management (ext4_setup_system_zone and
>   ext4_release_system_zone), covering pre-setup NULL behavior, RCU
> [ ... ]
>=20
> Export the five runtime entry points in fs/ext4/block_validity.c with
> EXPORT_SYMBOL_FOR_EXT4_TEST for the ext4-test KUnit module.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D12

