Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457269;
	b=HCF9P/UmZQ5/MU8BZVpgV7vPljEq6iGNYCqTz8qC/wXuOMlqvHCS4MgW1KH0DdsN4ZUB
	 piLExB3eWWErunKtJ6eMoGxRR6FBWTpZSf9UCY75Uyc7UBp8B+OjsTOkC8Gj+uAEhAlS5
	 /On5Pp08DCyTaR09xKSJh5q2Tbu8knQ88EUnHwShn4jKVnq5QDTZmOu4eleNbgwyAUPvV
	 FEuq34BblaSLelzlkJFfSAMeHBjGJ4CYKuVUeac7O7u8XXerkwuBr9Z3unTGmwZj1f3A8
	 jpTSVd9IDyVxdXBbEkWHhTOHWKf9nxPP8C4EBiYzug1/Lba4qFiPYgLBfa24Cb7u5oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457269;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fvG/lM364Yi/rpB+U/CKq6qoH1XXYlt+NvaPpuwQXa8=;
	b=wwwC5A4uKRWuSTsGZjyUrVlO22Ftb7V8YHScML9vLiR37KFhqiE+yLFDEQEfYT6yVq4o
	 bLFtxH/HAfWWr+Gvy/UVki/rV2TXppnjFJ8kCk/P4tnGVywQoTAc1OXDcnU1ErAD6iwH9
	 SVH4XZV/cjvqWztyBHDiO1tJUsgDrt5kWFC2BYNZUl+XAXsjvfg0eFUjLJhxMZRP97Nea
	 iB767bita/SzdKL4OfJIpz3u6VtV49miCUPCTLWqDL28FkjTT9NwN9cSsrYJPTfvvzlP5
	 YQdfhsiGO/tTr4xYNi4d2LcYtaMBUdKCjeDD81DyPd1FoQlRPL9w6S4uTHGE+vOxvgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CUsn09mc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7718606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CUsn09mc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E7B1F00A05;
	Thu, 12 Nov 2026 04:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457269;
	bh=fvG/lM364Yi/rpB+U/CKq6qoH1XXYlt+NvaPpuwQXa8=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=CUsn09mcM3Wmx7+ECNPXmM3E+IGsvos5lmfWJBzv7g9c4Icj39wZ7JMo0lCCwCfan
	 1Ee4pkLabMd97ICR7MWBh7sD7ijQow2JikDWkffiJ+qvmSfCIZPHGa/YFBSet2TzfZ
	 BlxgEIAlQCIq76eCFsw5n/wTzi6i59BOI3tbwI9fTBibTXaindOYyNkScOBw8rK6Ai
	 +2O9nCVNVJ4LL6apmI9X/4G8CiOQGgJrrcxk2zFs6qNa1jTq0zeK0FRQrU3gTygsTn
	 l+odkuFATkWRcpklIGijS0IbWABVY/JE1IzBFZsa7ukpn/6lzxGpyPpf8RK84rF8Eb
	 8x5WX5INAhQXA==
Message-ID: <sashiko-outbox-210329@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/27] ext4: add KUnit tests for
 fs/ext4/block_validity.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-15-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-15-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:21:08 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D14

