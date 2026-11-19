Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104468;
	b=Fi/LvumEuSKhcvLBXZ7BvBXv2A3h8I7AkPqD3tZEFAc0UUhi2Nu5sncaTbR6BgKrqu+I
	 up6d7IkcuLPGIkqIfIpDJXhe+DmbO+4QEglIuEY8Bv7OsdqdQChLlowCGF0hk91GgIGps
	 KRjK1Hbv4u5R8evLDsCRV3ymzYYn1kINzdUtvhXTZf6oY5DRqxtCLLQeqEDkxCT2nJG21
	 vsBZJrDt1gFyf/LfDh3obOmutp0wW/oNPyhMOebm/44BmFsXExvrIJ/83kUbdJaZqCnyo
	 lOSljlOqocCbYKQSIMQLMcKX0fZv+8Uf8i/tqa/+K5vFdHVqDzwt0Gd0NVN4APDdegw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104468;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ex3SMmmeEtWDSrag0DUdYHez5Zt6239feZSMt+HvhZ4=;
	b=3ZSSgEjTmUucUJS/hsuTLgD73DmjgvJMcjnqaU5dUOzho4bPXmcXGy50KlaZkEZCZAhq
	 Q8yUG4an7QwbnWL+/stO0EMM8zsfqa/Qkg5lVncyg4thFOdrGV61UJzSsTPwGzRtdBXXG
	 mBAypvTOuzit1wPzifog8gq+IXcBs+JHenJVhhC36851TQWyhJ6MR9iEX0eWE73vcjQbM
	 GgDe9nPa1pq2dc0PaLeFVysMR5a3nrhLTzvvWefuYeUu9GixO3tv1awQa8+A/Tm4USpH0
	 2SOkF1bZSpa1KxjBPYGit1Z9DgAwLGuJM/DnUIzeSYlAumWto4N75w1C398A4raPaBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D9vp1umE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A30606A324
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D9vp1umE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B80F1F000C4;
	Thu, 19 Nov 2026 16:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104468;
	bh=Ex3SMmmeEtWDSrag0DUdYHez5Zt6239feZSMt+HvhZ4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=D9vp1umEbO9TszDbpyI3/0dIl7YyKFAaHbbqEZ53dLuh4hPpJLUr0TOPXAgGuepah
	 LJHcOyqKo/m0NFoneb9EILfDF6nLvhcSX1+v8uxZUnxhlU6QGiFdwvvCKX78ezll33
	 7N+DuHrQrbT7jm9qOYjxBsJl+Uv2aGrh59iqKujv7uxRx6qgxoc3w0iwfY1UM0Toos
	 IB/gSBH88XPe3DWjB9lzP5wEXN1Mu0U3IQPhuPlPN0gamDkybXMf16Vhv4NmbWB3E9
	 vrJoa3FEcgYrKeHFMUURbw9UcYNpPVqkgPpOoC1F0o13mTnymJdAvgHuhbPKTxFZMR
	 E+PbvAVLgq5MA==
Message-ID: <sashiko-outbox-223474@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 15/26] ext4: add KUnit tests for fs/ext4/super.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-16-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-16-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:07:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add a KUnit test suite (ext4_super_test) covering superblock validation,
> geometry checks, metadata checksums, mount options, overhead/statfs
> accounting, and persistent error recording in fs/ext4/super.c:
>=20
> - Feature flag compatibility in ext4_feature_set_ok() and
>   ext4_check_feature_compatibility() across RW/RO mounts, bigalloc
>   constraints, Hurd creator-OS restrictions, DAX, and encryption levels.
> - Inode, block-group, cluster-size, and directory hash initialization in
>   ext4_inode_info_init(), ext4_block_group_meta_init(),
>   ext4_handle_clustersize(), and ext4_hash_info_init().
> - Filesystem geometry validation in ext4_check_geometry(), descriptor
>   location arithmetic in descriptor_loc() (linear and meta_bg),
>   superblock and group descriptor CRC16/CRC32C verification, descriptor
>   overlap checks in ext4_check_descriptors(), and flex_bg counter
>   aggregation in ext4_fill_flex_info() / ext4_alloc_flex_bg_array().
> - Maximum file size helpers ext4_max_size() / ext4_max_bitmap_size(),
>   stripe selection in ext4_get_stripe_size(), reserved cluster defaults
>   in ext4_set_resv_clusters(), overhead calculation in count_overhead()
>   and ext4_calculate_overhead(), and space reporting in ext4_statfs().
> - Mount option defaults, parsing, consistency checks, remount guards,
>   on-disk s_mount_opts parsing, and _ext4_show_options() formatting.
> - Error translation, first/last error persistence in save_error_info(),
>   and superblock state flushing in ext4_update_super().
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D15

