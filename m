Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458063;
	b=A3Hcal5Urfzs5n/9RD/HHcJlMyhNOvMvcJqLPgmza5BE2GM9Cu0gUdHxwqDOLpHM2ap9
	 SMY5zvifWHzOcs35YKJG4XnkmPk/6VNPNSmfu5Ea+4ZBDdyK3yWhj2m3i4ajVhiF2QuOU
	 jx5OoHEXvcN17tPTExGu8aqZ/qARrlPgKo+Iyt33lZvvxFnJJiz+4fdat/55peTSO9bc2
	 y1SYgU5tOrd9BBSVbiR70xbk0BgJHcuePA8jtZ2++T/mNpZij5olQXHxjurlsHvHL9C2S
	 R8j7CS1N931qxKke8yRgLD1ZNuNSgpb5mipcgMYsg7IzQlBEXbZWyAu/Gy3iLMnmtew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458063;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0UiYBc/qPttz0257gIY5wEk+txs8nDD7lJYqywUJpbE=;
	b=dHgnrKJdB2z1xXAXlWz8Iiwp+T9PUvq80h5tOKRbko1eDSAIh/R/L9qDm1yBopyFNVPX
	 BfVsqVK2o7jmNPZCC9ZdKDX8qnvKiSP1oGnjrXsDPNwZPTvnKjcsjjEjlfjILelxAikZ3
	 NgRWax1d0QEC5jCaDYDpRnEefQK0+mvbU1zFgF+l7dEKQAhUnpfxmWRwJMXb5ebHH9Pur
	 YWIfbU+tg+DsdbCxSluS4zs1bn5j6Azryz0RpfpghtoiIOMZNpiJgt1s+W98fVl/DxnOh
	 5wpfv4TjDrlXaxisnqPWBQivYKCAFFcXPRDmqQz1LEsbcEjpmR8dUTtENjeoGVRcN5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=God+XqcG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3709606A32A
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=God+XqcG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9DF1F00A05;
	Thu, 12 Nov 2026 04:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794458062;
	bh=0UiYBc/qPttz0257gIY5wEk+txs8nDD7lJYqywUJpbE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=God+XqcGicFxlacX6LR1NnUzfYf15wyA2aK4jfipMMt2o4RcQNPXXmnSydiZhp/Ms
	 OhcNIgeebHkCcZhMajqtF1x7/IVsOzYGKwa0mjFv9zQhdIVOX9DyZVRx8b69MYCghY
	 WDfQSZgkwT1la06klXtBClX4I15PvPTJ9R2BWe3kSOXo+BrgUe5SH3BIs9iFIb3woT
	 ttJFhH0GmPWDNZgEDYt7JN0ztQl1dHSTGPEgNv8dQIzjljRaTtY9+TwJOzHCcJmRy8
	 rQWaB55lXuxIAp8E6W1yegNus1ps0Njtg4bwJH69FaqO7vrN+OSnqjkDZIrNPpiUWy
	 n4qQJIJJMKK+w==
Message-ID: <sashiko-outbox-210364@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 23/27] ext4: expand KUnit tests in
 fs/ext4/extents-test.c for file range operations
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-24-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-24-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:34:21 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] ext4: uninitialized invalidate_lock in ext_init_mock_inode()
- [Low] ext4: use-after-free of sb->s_bdev after deactivate_super() in
  extents_kunit_exit()
- [Low] ext4: i_data_sem and path leak on assertion abort in
  ext_expect_extent_at()
--

commit 0bbdba01f4f2a820793844a83a44fb01144fcc50
Author: Theodore Ts'o <tytso@mit.edu>

ext4: expand KUnit tests in fs/ext4/extents-test.c for file range operations

This commit expands the ext4 extents KUnit test suite to cover
ext4_fallocate(), ext4_zero_range(), ext4_collapse_range(),
ext4_insert_range(), unwritten extent conversion helpers, ext4_fiemap(),
and ext4_get_es_cache().

> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 7565a8aa4e106..4f1746be323ff 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c

[ ... ]

> @@ -200,20 +210,29 @@ static void ext_init_mock_inode(struct ext4_inode_i=
nfo *ei,
>  	inode->i_sb =3D sb;
>  	inode->i_ino =3D ino;
>  	inode->i_mode =3D S_IFREG | 0644;
> +	set_nlink(inode, 1);
>  	inode->i_blkbits =3D sb->s_blocksize_bits;
> -	inode->i_flags |=3D S_NOQUOTA;
> +	inode->i_flags |=3D S_NOQUOTA | S_NOSEC;
>  	inode->i_mapping =3D &inode->i_data;
> +	inode_set_iversion(inode, 1);
> =20
>  	spin_lock_init(&inode->i_lock);
>  	init_rwsem(&inode->i_rwsem);
> -	init_rwsem(&inode->i_data.invalidate_lock);
> +	address_space_init_once(&inode->i_data);
> +	inode->i_data.host =3D inode;
>  	inode_state_set_raw(inode, I_DIRTY_SYNC | I_DIRTY_DATASYNC);

[Severity: Medium]
Does replacing init_rwsem(&inode->i_data.invalidate_lock) with
address_space_init_once(&inode->i_data) leave invalidate_lock
uninitialized?

address_space_init_once() zeroes inode->i_data and initializes only
i_pages, i_mmap_rwsem, i_private_lock, and i_mmap; in the VFS,
invalidate_lock is initialized separately in inode_init_always_gfp().
When the new fallocate tests call ext4_fallocate() with punch hole, zero
range, collapse range, or insert range, filemap_invalidate_lock() acquires
this zeroed rw_semaphore, which triggers lockdep or CONFIG_DEBUG_RWSEMS
warnings and deadlocks on CONFIG_PREEMPT_RT kernels.  Keeping
init_rwsem(&inode->i_data.invalidate_lock) after address_space_init_once()
avoids this.

[ ... ]

> @@ -267,6 +286,7 @@ static void extents_kunit_exit(struct kunit *test)
> =20
>  	kfree(k_ctx.meta_blocks);
>  	kfree(sbi->s_es);
> +	kfree(sb->s_bdev->bd_queue);
>  	kfree(sb->s_bdev->bd_mapping);
>  	kfree(sb->s_bdev);
>  	kfree(sbi);

[Severity: Low]
Can dereferencing sb->s_bdev here use sb after it has been freed?

deactivate_super(sb) is called just above this hunk, which drops the final
reference on sb and schedules its destruction via RCU and
destroy_super_work(), unlike the error path in extents_kunit_init() which
frees sb->s_bdev->bd_queue, sb->s_bdev->bd_mapping, and sb->s_bdev before
deactivating the superblock.

[ ... ]

> +static void ext_expect_extent_at(struct kunit *test, struct inode *inode,
> +				 ext4_lblk_t lblk, unsigned short exp_len,
> +				 ext4_fsblk_t exp_pblk, bool exp_unwritten)
> +{
> +	struct ext4_ext_path *path;
> +	struct ext4_extent *ex;
> +
> +	down_read(&EXT4_I(inode)->i_data_sem);
> +	path =3D ext4_find_extent(inode, lblk, NULL, EXT4_EX_NOCACHE);
> +	KUNIT_ASSERT_FALSE(test, IS_ERR(path));
> +	ex =3D path[path->p_depth].p_ext;
> +	KUNIT_ASSERT_NOT_NULL(test, ex);
> +
> +	KUNIT_EXPECT_EQ(test, le32_to_cpu(ex->ee_block), lblk);
> +	KUNIT_EXPECT_EQ(test, ext4_ext_get_actual_len(ex), exp_len);
> +	KUNIT_EXPECT_EQ(test, ext4_ext_pblock(ex), exp_pblk);
> +	KUNIT_EXPECT_EQ(test, !!ext4_ext_is_unwritten(ex), exp_unwritten);
> +
> +	ext4_free_ext_path(path);
> +	up_read(&EXT4_I(inode)->i_data_sem);
> +}

[Severity: Low]
If KUNIT_ASSERT_FALSE() or KUNIT_ASSERT_NOT_NULL() fails in
ext_expect_extent_at(), does the test abort with EXT4_I(inode)->i_data_sem
still held for read and path leaked?

Because KUNIT_ASSERT_* immediately terminates the test kthread,
extents_kunit_exit() -> ext_cleanup_inode() will then deadlock on
down_write(&ei->i_data_sem).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D23
