Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104689;
	b=YTuHZi0sGqjJSH6FBo6c99Dhj7MDBTCDurUwGxUV0+JaVS7gADXnUB/wZLd5RD5QfsE7
	 MaWUVZaF/aZox8E4Lyqq32SE8LWdYV/AZJDC9uaXZjKPD/+zrZI73xALHKylRpCkuela4
	 yZ4hbLjFS73A9FYnv8exb7emEbyUd9PJLoxN8caifadW3Z8AytmhsEHbvjNmBlOtdOLEi
	 CZzsFXL3wLeRP5yZPtLVIGUv4NjFz1EzuPRb3kQkMHdFY7B40YsthKexi0xWckJpFVHL0
	 Asdp2njqDeOZ9ZfM8kBd/rpix6nAwYGEaJseCsPqQqRjWIsKXGtdJk7zDRXrY362I5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104689;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0BhucgBIxq8sB+ZuV4+D8atjCQIIbo4bwuyVHP/n3X4=;
	b=4A6CQ6dpiHxSSUh02+0cJQpoBwvxBgyaZosxDmQ5yR2fJUHpoEri2JKpk8AZE7BuKlut
	 owD99Nudj4P26qxczZHeN4rvKLyBJyLk1P0ZVOGSze7tlq2JcGmgWguMsblnRgRveY9fV
	 7hj/ABnvS3CsOXBXfYwFlfATcZcDsJLLPPZnL2xqyDpeEeeOo2Zz2MX2MNnwpTC39kvnk
	 w4C/ZOz984rVwtPrKrTkaMu35pgQ94O6FXx0TpcYXVXqTocVtgnNiuMQjlnJvdzzba5g6
	 CKUKyKNvZHvzOIAuaYhvT/HIyT4Idxh6NdtW7LHKHlWyf37sMg6UvNMUbyEY1/dAqcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N2rvZNNX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093FB606A32A
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N2rvZNNX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6CB1F000C4;
	Thu, 19 Nov 2026 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104688;
	bh=0BhucgBIxq8sB+ZuV4+D8atjCQIIbo4bwuyVHP/n3X4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=N2rvZNNXIYKdJDcAR2Z1zltwUM1YSPKIKkLgMRX9by5fupgtOyIKEOZF3iklnsnw2
	 Bfk7j95+EcD1ibbQfc9sDPkJqQz692TKudLi9SJzfz4ovE42gOd7OcSCn7xD/fYraF
	 gIPFjsvNq8joBSDFOVzpMeJlxDXXE5pDnwSx8oZJasqwkeWZHhFM6v+zs3+qCgZDtt
	 A4H8IzG6ID7O68454xBVwb5ObEKuZ/a7CZXiDWbqsaPDfI2gmh/Z5Jl67GuacBMuP4
	 XJd2TM1x+zE+vaE1//JSWb3GFHkOYFSe8W3dPOGJZk3AT1joIyFncVHRibMCmyrprW
	 P28VDTGU0y5kw==
Message-ID: <sashiko-outbox-223483@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 04/26] ext4: add KUnit tests for fs/ext4/namei.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-5-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-5-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:11:28 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add the ext4_namei_test KUnit test suite in fs/ext4/namei-test.c and
> shared internal HTree definitions in fs/ext4/namei.h to exercise
> directory lookup, HTree indexing, and namespace operations in
> fs/ext4/namei.c without requiring a mounted block device:
>=20
> - Directory leaf tail initialization (ext4_initialize_dirent_tail),
>   metadata CRC32C checksum calculation and verification
>   (ext4_dirblock_csum_verify, ext4_handle_dirty_dirblock), and
>   corrupted tail/checksum detection.
> - HTree root and interior node limit calculations (dx_root_limit,
>   dx_node_limit), entry accessors (dx_get_block, dx_set_block,
>   dx_get_hash, dx_set_hash, dx_get_count, dx_get_limit, dx_set_count,
>   dx_set_limit), and index block checksum verification
>   (ext4_dx_csum_set, ext4_dx_csum_verify).
> - Directory block reading (__ext4_read_dirblock) across 10
> [ ... ]
> Export the tested functions with EXPORT_SYMBOL_FOR_EXT4_TEST and add
> KUNIT_STATIC_STUB_REDIRECT hooks for ext4_orphan_add and
> ext4_orphan_del.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D4

