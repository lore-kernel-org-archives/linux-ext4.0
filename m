Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456956;
	b=t0kvT0qBL/GRaF0WnT8zIaLZPuxfsBY+6K4sYZGDGDI7GlNuaxbzY7hvaDkRvXFiTKIR
	 OCD9rIABiXgGdoUAtjhtLi60N46DJe9NqP3Rr0T7uCPLHRDN221QbYghApEqVqdALJEyN
	 hRlcRYhEa/kzfKJlWwFnZE4iIlVQlJKeLQEr70CmuktCnTCEa6LYmc5e/Djjl680E+sZd
	 bHyZUSFhhXz2312KUIBY5Je0D//QpfWtWJntQiqJ0FNg27ofWpkajSsuTIfIeI10QTMty
	 oVK8U3/GGG0S1hhUzxOm9tWI3mWMYr+MMpHRT13g5fJZIWb/IiKQw//TEkcgbFELTBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456956;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IREpR8iwdPOhcuSHdrKXsm2EWaJe3ngYCslmwpd4r2Q=;
	b=hJvccYy6F54EsxwGTtDiGu2chGOcUW+A0Yb2BkgxAdwlz5ZRdblIgeEb+d4IpsOmBO0f
	 /nN2mA/cklgYMo4ZqlnWepDin2nTvTCpJAXsdD8/arnT57W21b3W9G7FidJpIYYR5dQH3
	 sR6F6acieSP88feMAPkBFX1XdUKsvIRXsWHAB9RxOdjcSsLUfKMeDc4T6nVBXUd8Zid2h
	 M3KrgVET/SN3KCF6fl3ZHyrtamic/VsPevKN1uFg9EhDTLql5esU+aOQ6eRgge2QpSKfA
	 G66CvaGa5kXpwI5l209kfK05hm+0XYmvy+PwOpEgJl/++oMa4e5MkijQF9Iis+asH5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ouAcQa3B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6EA606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ouAcQa3B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B311F00A05;
	Thu, 12 Nov 2026 04:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794456956;
	bh=IREpR8iwdPOhcuSHdrKXsm2EWaJe3ngYCslmwpd4r2Q=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ouAcQa3B6kSUf8YG8qLQ8NPI4ZsiduFm4cCo7Ea4klsLMMVv/FonFhuT5ZRcP1Z52
	 g5TDfNo8qGuRvwL7aNkCak8WZbWsLNbTRX34k1Hs0OtLLynrGIpx41bWwsCKKzabuf
	 Bp6BTzMEG+oFVkFIRssMC40HaoOVqi8kgMvnpghDDuI8PtbaRN0b+/Dxeu5udN6NmR
	 5PHxvCRPWwB/4Ze9/63fCUtePwvW3gIWW0OPFSVGsHaZtR2T0ve4HS9GJsSOs6ZkPQ
	 ejWA19bhgMfTNMXeC1bP1GN10/eJ3sIgBbnkFm2I2HoPO7PKnjzy3SNvWiIc8PL/Fd
	 qlSeG1CSVDYSw==
Message-ID: <sashiko-outbox-210315@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/27] ext4: add KUnit tests for ext4_ext_split() leaf
 and index splitting
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-4-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-4-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:15:55 +0000
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
- [Low] ext4: unexplained test_swap_extents() changes and stale Fixes
  SHA
--

commit 55141b7904f9009059aca2d2a02dc5c501ed9bde
Author: Theodore Ts'o <tytso@mit.edu>

> ext4: add KUnit tests for ext4_ext_split() leaf and index splitting
>
> Commit 7831b3664109 ("ext4: add KUnit tests for fs/ext4/extents.c")
> updated both block-allocation paths in ext4_ext_split() to call
> ext4_ext_getblk() and noted node splitting in the commit message, but
> none of the test cases in fs/ext4/extents-test.c actually reached
> ext4_ext_split(). In test_insert_extent_grow_and_merge_up(), inserting a
> 5th extent into a full depth-0 root triggers ext4_ext_grow_indepth(),
> moving the 4 extents into an external leaf block with eh_max =3D=3D 340 a=
nd
> returning from ext4_ext_create_new_leaf() without splitting.
>
> Add two KUnit test cases to exercise ext4_ext_split() across leaf and
> intermediate index levels:
>
> - test_insert_extent_leaf_split(): fills a depth-1 external leaf block
>   to capacity (340 extents), inserts in the middle to trigger a leaf
>   split that moves tail extents into a new leaf block, and then fills
>   the second leaf and appends past its end to exercise the m =3D=3D 0
>   leaf-addition path.
> - test_insert_extent_index_split(): exercises depth 1 -> 2 tree growth
>   followed by leaf splitting via the repeat loop in
>   ext4_ext_create_new_leaf(), and then clamps the depth-1 index block's
>   eh_max to exercise simultaneous leaf and intermediate index block
>   splitting (k =3D=3D 1) in ext4_ext_split().
>
> Fixes: 7831b3664109 ("ext4: add KUnit tests for fs/ext4/extents.c")
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 7056481862188..47ddeb94e2bf4 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c

[ ... ]

> @@ -2073,17 +2265,13 @@ static void test_swap_extents(struct kunit *test)
>  	KUNIT_ASSERT_EQ(test, ext_insert_one(inode1, 10, 10, 100, false, 0), 0);
>  	KUNIT_ASSERT_EQ(test, ext_insert_one(inode2, 10, 10, 200, false, 0), 0);
> =20
> -	inode_lock(inode1);
> -	inode_lock(inode2);
> -	down_write(&EXT4_I(inode1)->i_data_sem);
> -	down_write(&EXT4_I(inode2)->i_data_sem);
> +	lock_two_nondirectories(inode1, inode2);
> +	ext4_double_down_write_data_sem(inode1, inode2);
> =20
>  	replaced =3D ext4_swap_extents(NULL, inode1, inode2, 12, 12, 5, 1, &err=
);
> =20
> -	up_write(&EXT4_I(inode2)->i_data_sem);
> -	up_write(&EXT4_I(inode1)->i_data_sem);
> -	inode_unlock(inode2);
> -	inode_unlock(inode1);
> +	ext4_double_up_write_data_sem(inode1, inode2);
> +	unlock_two_nondirectories(inode1, inode2);
> =20
>  	KUNIT_EXPECT_EQ(test, err, 0);
>  	KUNIT_EXPECT_EQ(test, replaced, 5);

[ ... ]

> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index 3329b7ad5dbd8..d1405e7639128 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -656,3 +656,8 @@ int ext4_move_extents(struct file *o_filp, struct fil=
e *d_filp, __u64 orig_blk,
>  	unlock_two_nondirectories(orig_inode, donor_inode);
>  	return ret;
>  }
> +
> +#if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_double_down_write_data_sem);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_double_up_write_data_sem);
> +#endif

[Severity: Low]
This isn't a bug, but the commit message does not mention updating
test_swap_extents() to use lock_two_nondirectories() and
ext4_double_down_write_data_sem() (and exporting those helpers from
fs/ext4/move_extent.c) to avoid lockdep warnings on i_rwsem and
i_data_sem.

Also, the commit message and Fixes: trailer cite a stale pre-rebase sha
for commit "ext4: add KUnit tests for fs/ext4/extents.c" rather than the
parent commit in this branch.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D3
