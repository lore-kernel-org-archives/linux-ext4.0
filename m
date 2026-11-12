Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456972;
	b=W1oycmTBrTZEhyMxmD10GVQGlKwNYJ2LwiTrZ6Ffcp6S61cX+bKiv8BVLEeQf7D5e4Hw
	 XVMmyc/rSgRLg+tRXzeoE56C8tvmdX5I7c4JUO18smg/OGPBxCfzroyVolNUG2xIIFSOR
	 bll9rMhtZp78PPFaEsiUjh5wVWnhGF+a3aneqCLwkfl7MnWicJvOA7Ig2nmzASl93+DZV
	 A7fs1FvTTssU6VYvNUwc5zokHaNJKXG01m9FE7rJHSHlWQB1OtnHwXHlbvCQF4Kd23gkX
	 jdv3tZD9vbqtfU4Z0pAUkf2+pTQI88X45rx+Zva2A2Vfyppgi258WkBtwko1M8WUADA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456972;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+3+rvaN7a4NHNs+ZbvtmfkaefErhVWa0YAR6D2WAiXY=;
	b=DwI6HxbA7tS5nv7AYOA9Mm5WWi+uQRGYR6VSqaK98RNIBvKkknJdhpY/I+JB8X7nk8Tq
	 uHRhxVZ+gGfq8Y+y5elTb2zvT4gGrEIiqckczBi1jawP6dKggiZrhzCfsZCKhZIIsIpK5
	 fUkqO+6XJD/0DyXpl/FbdTVgomE6Gr83mE6WxXvBOoCeFsxy4Hf9mHM+mmC7df3RbekQ4
	 hGiEeAF+qmVkG+G0jPK71JoWqWl8Y/a+5PxKi4n4hCe5gkrupmdPfWrjfLgSZW+8zUU3p
	 oqqKGHypu7rweGKOPlD7zX2QE5KuuwHuoIyN4JY+WG/Ryt5Wco7mMTI3nMOoxeeoQbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHF6AwI4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50657606A321
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHF6AwI4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B31E1F00A05;
	Thu, 12 Nov 2026 04:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794456972;
	bh=+3+rvaN7a4NHNs+ZbvtmfkaefErhVWa0YAR6D2WAiXY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=RHF6AwI4TEBkBOM2mAACP1seZ8CD6KdZ1E3BFAooeBgOgocqJf5iitVd7Dr/PzLH2
	 QJb2cCz0E5Xo9QuCFAAOPQq14Gllhjx4bOXehh7KiiSgWSw5Ez5CvoWgh2IhH7o+uU
	 tL/mQBT4Sp9NhfMo1bL/IvmEmZsfgv7E5cQ2EAi4uXxmlxPC04VVU+nNWEHTEIErMd
	 XXSHhJiIXIKaizDfEspmkbtjCoRXRqulSZbE84VtnHrpI1kd/IBe+lCiGyz6Qk8icZ
	 oVK7CZOpHO47Hxoj7rUFkCuKX3JkxUzf1TlBSQvIiIl4QILYLF026HgPCW7F6F7P7n
	 3ZwqMypndZNCw==
Message-ID: <sashiko-outbox-210316@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/27] ext4: add KUnit tests for fs/ext4/balloc.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-13-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-13-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:16:11 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add the ext4_balloc_test KUnit test suite in fs/ext4/balloc-test.c (29
> test cases, 43 subtests total) to comprehensively exercise block bitmap
> management, group descriptor and overhead calculations, cluster pool
> reservation, allocation retry policy, metadata block allocation, and
> goal block selection in fs/ext4/balloc.c using an in-memory VFS
> superblock, mock block device, and deterministic block pool without
> requiring a mounted block device:
>=20
> - Block-to-group and cluster-offset mapping (ext4_get_group_number and
>   ext4_get_group_no_and_offset) across 1K and 4K block sizes, standard
>   shift-based vs. non-standard do_div group geometries, bigalloc
>   multi-block clusters, s_first_data_block offsets, >32-bit physical
>   block numbers, and optional NULL output pointers.
> - Backup superblock placement (ext4_bg_has_super) across dense
>   filesystems, sparse_super powers of 3, 5, and 7, and sparse_super2
> [ ... ]
> through ext4_sb_getblk() so KUnit tests can intercept buffer-cache
> lookups via its existing static stub hook, and export the remaining
> non-static balloc.c entry points with EXPORT_SYMBOL_FOR_EXT4_TEST.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D12

