Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458069;
	b=otraKkUOKTWEGR6NJ8bmFwvRcWT++A/rnEpSDnlBTe9eAjwrtJp8IVmh7/ngg8jMpOkq
	 t9pFojj9CFvGAB9yHOB1w1xRno+tytjtXIBmJ72GHLQGSJV7sC0GUiwVyUK8+hHmhuIVX
	 HVad4mLHyqCk/wWPDggM7KtjorM0Uox9gXsLC8U6HQ49ZKHpp8wjYQu6S6nWyUwVh4TlQ
	 mNz8DDDZ+SDFHPZzuBc8hTiIRZTwWE+VH3GWvLGTFgUm65w6GhfmGC5vpG3oCvlXofaaU
	 osonCIAqKdIEX1M9ZEC7ReoLlB1MSzr3Uo/IguRFt1m575ydfq78M4Z8RD94m0HgToA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458069;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7wu5UDPifu5V8DSRn2JlSFs2RZXg/0XeVBgoifblrLM=;
	b=jxa+nd2ccNAdxE9xqVoeStfj1J04NU1DI+nB3W5ebWgfUxQm9nNGWGFFXTd0R/ENEDI7
	 xL3XB449D+lOh7iOW5DpQ+mbYXISF6QFF6tnYyTG2Qo1z44cI0hk6cxHa8MskB25OO919
	 a8bjVTmnJj6c61oSjKm+n+VhDv5DUEV8B6+HbN0dQOZKu1P9G083+iLpWc/52anYC+Z2e
	 DbCYSPeAZ3oqLUX4oNaMH4btpYuO8mm3jf+BxekEhcuNPximuiGeFFDIoy5VljybbddlN
	 xBsmOFCdhp5i4jYrAupTMfxoT8zB4MJR+UYLEpWCy9M2qPaV8DkaA1silWVku/QH3Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gGhCKzqE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26BB606A32D
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gGhCKzqE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB7B1F00A07;
	Thu, 12 Nov 2026 04:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794458069;
	bh=7wu5UDPifu5V8DSRn2JlSFs2RZXg/0XeVBgoifblrLM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=gGhCKzqE+bKb4juvUyNF0nZstSrgHb3pzZxXLkSOfGwJNBTz9/Ptb/etVBfaS7d5c
	 scnXU1l3fjO9bxctp3FC7hqS3i/62u2C0hibu1UBhfCzS2c+7jyP6sj9vD+rJu5bKv
	 PGueqivULEuDzqtYzMyEHXdvgBJT9DCfMa5z2nxB/dYj4hOzInaIbwInpfFVw9QfVn
	 gqaUQ8/AT2qMFzncGWWI9Nudr1gwTcE9vHuOSoZdqVZ9Lln5GNTBO6J2+WkstGwjXp
	 wOoIm5sTgi80p77JabN+cRw965aUg66PdkFvDLnne7YVJ2AKWbEOCZxHMF8N5dRGir
	 gQCItsTIv7wzg==
Message-ID: <sashiko-outbox-210365@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 20/27] ext4: add KUnit tests for fs/ext4/resize.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-21-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-21-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:34:29 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] ext4: RCU callback context and barrier order in
  resize_test_cleanup()
- [Low] ext4: uninitialized work/timer cancel in resize_test_init()
  unwind
- [Low] ext4: leak of group_desc on assertion abort in
  resize_configure_fs()
- [Low] ext4: partial percpu_counter_init() leak in
  resize_configure_fs()
--

commit 2234a2c272479e93ed67d158ad4b60b46b408f78
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/resize.c

This commit adds a KUnit test suite for online filesystem resizing in
fs/ext4/resize.c and routes resize metadata buffer lookups and zeroout
calls through KUnit stubbed helpers.

> diff --git a/fs/ext4/resize-test.c b/fs/ext4/resize-test.c
> new file mode 100644
> index 0000000000000..081a5d6c6fd90
> --- /dev/null
> +++ b/fs/ext4/resize-test.c

[ ... ]

> +static void resize_test_free_inode(struct inode *inode)
> +{
> +	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> +	kfree(EXT4_I(inode));
> +}
> +
> +static void resize_test_evict_inode(struct inode *inode)
> +{
> +	truncate_inode_pages_final(&inode->i_data);
> +	clear_inode(inode);
> +}

[ ... ]

> +static void resize_test_cleanup(struct resize_test_ctx *ctx)
> +{
> +	struct super_block *sb =3D ctx->sb;
> +	struct ext4_sb_info *sbi =3D &ctx->sbi;
> +	struct flex_groups **flex_groups;
> +	struct resize_mock_blk *blk, *tmp;
> +	unsigned int i;
> +
> +	if (sb) {
> +		cancel_work_sync(&sbi->s_sb_upd_work);
> +		timer_delete_sync(&sbi->s_err_report);
> +	}
> +
> +	if (ctx->resize_inode) {
> +		iput(ctx->resize_inode);
> +		ctx->resize_inode =3D NULL;
> +	}
> +
> +	if (ctx->mb_inited && sb) {
> +		ext4_mb_release(sb);
> +		ctx->mb_inited =3D false;
> +	}
> +
> +	if (ctx->counters_inited) {
> +		percpu_counter_destroy(&sbi->s_freeclusters_counter);
> +		percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
> +		percpu_counter_destroy(&sbi->s_freeinodes_counter);
> +		ctx->counters_inited =3D false;
> +	}
> +
> +	flex_groups =3D rcu_access_pointer(sbi->s_flex_groups);
> +	if (flex_groups) {
> +		for (i =3D 0; i < sbi->s_flex_groups_allocated; i++)
> +			kvfree(flex_groups[i]);
> +		kvfree(flex_groups);
> +		rcu_assign_pointer(sbi->s_flex_groups, NULL);
> +		sbi->s_flex_groups_allocated =3D 0;
> +	}
> +
> +	rcu_barrier();
> +	kvfree(rcu_access_pointer(sbi->s_group_desc));
> +	rcu_assign_pointer(sbi->s_group_desc, NULL);
> +
> +	if (sb) {
> +		deactivate_super(sb);
> +		ctx->sb =3D NULL;
> +	}

[Severity: Medium]
Can resize_test_free_inode() and resize_test_cleanup() cause a
use-after-free on ctx->sbi and take i_es_lock in RCU softirq context?

The VFS invokes super_operations.free_inode from i_callback() in RCU
softirq context, but resize_test_free_inode() calls
ext4_es_remove_extent(), which takes write_lock(&EXT4_I(inode)->i_es_lock)
without disabling softirqs, reads EXT4_SB(inode->i_sb)->s_mount_state, and
can touch sbi->s_dirtyclusters_counter.  In addition, resize_test_cleanup()
destroys the percpu counters before rcu_barrier() and calls
deactivate_super(sb) after rcu_barrier(); if a test aborts while an inode
such as rinode in test_convert_meta_bg_validation_and_conversion() is still
live, deactivate_super() -> evict_inodes() queues i_callback() after
rcu_barrier() has already returned, so resize_test_free_inode() can run
after KUnit frees ctx.

Moving ext4_es_remove_extent() into resize_test_evict_inode() (matching
ext4_clear_inode()) and calling deactivate_super(sb) before rcu_barrier()
and percpu_counter_destroy() would avoid both issues.

[ ... ]

> +static void resize_configure_fs(struct kunit *test, ext4_group_t ngroups,
> +				u16 reserved_gdb, u8 log_flex,
> +				u32 last_grp_blks)
> +{

[ ... ]

> +	group_desc =3D kvmalloc_array(gdb_count, sizeof(*group_desc), GFP_KERNE=
L);
> +	KUNIT_ASSERT_NOT_NULL(test, group_desc);
> +	for (g =3D 0; g < gdb_count; g++) {
> +		struct buffer_head *bh;
> +
> +		bh =3D resize_get_or_create_bh(ctx,
> +					     RESIZE_TEST_FIRST_DATA_BLK + 1 + g);
> +		KUNIT_ASSERT_NOT_NULL(test, bh);
> +		brelse(bh);
> +		group_desc[g] =3D bh;
> +	}
> +	rcu_assign_pointer(sbi->s_group_desc, group_desc);

[Severity: Low]
Does this leak group_desc if KUNIT_ASSERT_NOT_NULL(test, bh) aborts the
test?  Because sbi->s_group_desc is only assigned after the loop,
resize_test_cleanup() will not see group_desc to free it.

[ ... ]

> +	ret =3D percpu_counter_init(&sbi->s_freeclusters_counter,
> +				  total_free_blks, GFP_KERNEL);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +	ret =3D percpu_counter_init(&sbi->s_dirtyclusters_counter, 0, GFP_KERNE=
L);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +	ret =3D percpu_counter_init(&sbi->s_freeinodes_counter,
> +				  total_inodes - 10, GFP_KERNEL);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +	ctx->counters_inited =3D true;

[Severity: Low]
What happens if the second or third percpu_counter_init() fails and
KUNIT_ASSERT_EQ() aborts before ctx->counters_inited is set?

resize_test_cleanup() skips percpu_counter_destroy() when
ctx->counters_inited is false, leaking the already-initialized counter(s)
and, under CONFIG_HOTPLUG_CPU, leaving their list_head entries inside
ctx->sbi linked on the global percpu_counters list after ctx is freed.
Since percpu_counter_destroy() is a no-op on zero-initialized counters,
resize_test_cleanup() can call percpu_counter_destroy() unconditionally.

[ ... ]

> +static int resize_test_init(struct kunit *test)
> +{

[ ... ]

> +	ctx->sb =3D sb;
> +	up_write(&sb->s_umount);
> +
> +	ret =3D kunit_add_action_or_reset(test, resize_test_cleanup_action, ctx=
);
> +	KUNIT_ASSERT_EQ(test, ret, 0);

[ ... ]

> +	INIT_WORK(&sbi->s_sb_upd_work, resize_test_sb_upd_work);
> +	timer_setup(&sbi->s_err_report, resize_test_err_timer, 0);

[Severity: Low]
If kunit_add_action_or_reset() fails to allocate the action, it immediately
invokes resize_test_cleanup() while ctx->sb is already set, before
sbi->s_sb_upd_work and sbi->s_err_report are initialized below.  Would
cancel_work_sync() and timer_delete_sync() in resize_test_cleanup() then
trigger warnings on the uninitialized work and timer structures?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D20
