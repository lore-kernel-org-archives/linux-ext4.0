Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484226;
	b=tyVOmL93E0dVepqj542W3MKTS5Rm5q7exhXUeOgADpaHy2v8oPaOCqN6kzYks71WPBAT
	 gy/3Vg+Qzx99exW8lhRrsdQ+p4gd+n5a+UfNASZ+dFsdflKKxrGiW/GXVFpxmDBPFH9gS
	 y/r25uKu06Pr2IkaelJ+rlFGjNCItfIbM3XgdP4+E6Z46lI53MpP0iWgUDfxXLKNonA88
	 x3VwkbDZBEVNMEGJGSFd4fIN5J1Dhl2OPex2NNeiNqfID6h54lWuivspnyL0pdPZN9LF1
	 cLYVXiP7gu8X58/b0S7EUsktaqwyH40/3m1fKICLjFJ80R6OGowo7noA+gWRPxTxA+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484226;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BOKbRY6lgtlG4S6r+FacwyuqYvppZMpU1Da4bpCtQ+s=;
	b=pY4JF5yWIl35AFOvE0jl3DEmHY99dLXWaoGpOG0hXS/I+koIgvOpXgZbz6wBLsGCNc+3
	 4gejfZKbx6HrCCkGhr1dXKEvOEtA4h+LtiVlNZ7/g/0Y4e9vyfXH49uXctvLP2UqCR8C9
	 0oNU9DRoWc81/qI/wsS67Ueo8BStAWKq26+JDP+M/foZWMUXrr6IY6SEWhI2z6szrrn8J
	 S1CjKPR0z6Nn3zJgl8MVnDq/+syR9QXiBsI3zjO0wliVyZdM3fdu5w+5KvWxoju7vq9pZ
	 AOM09I+9zJ0fBOy/3Wlcq5hvUs1/8lqU7hPpxpx2+GUg/CfiRoADYW1PV0A+iVQmNnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ViSemWoU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3329606A31C
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2026 08:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ViSemWoU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BA01F000C4;
	Tue, 20 Oct 2026 08:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484225;
	bh=BOKbRY6lgtlG4S6r+FacwyuqYvppZMpU1Da4bpCtQ+s=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ViSemWoUKIrR5Ew1gc0IWhq9/YYXEKPR2S6igVMjThb5Zxcm6e18XEMaWE1+W+Ped
	 WGsd/krNHeBoiyjy1sxRv1G/CfKcgsdX0+vzaVLtzy5ElXvol+0OorCTy6+n3Cgppc
	 TS6vyzLzq3MnpDfHCC1GuGhUW7hMpl56EjsgdevTBTPp5uo18dKAGy2x3Kywyp5nso
	 X9lSZE8oLVbAglkEQFVJgYYk27Bqmr0jSVgoH39gBuLQfboOQq7Os/rcnTEue4Gq7e
	 q2yLZc4Avq+cPUtkAeCa+AmRQTuqlHsEwG3jwbdyySzj9YZ7Wslo4S6cANtUfN17y5
	 e3ZAY0vWOwosw==
Message-ID: <sashiko-outbox-178509@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -RFC] ext4: add KUinit tests for
 fs/ext4/extents_status.c
Reply-To: sashiko-reviews@lists.linux.dev
To: "Theodore Tso" <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <atbPbe-i8DV3kLr8@mit.edu>
References: <atbPbe-i8DV3kLr8@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 08:17:05 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] ext4: use-after-free in es_cleanup_inode() due to KUnit teardown o=
rder
- [Medium] ext4: lock leak and sleep-in-atomic in assert_es_tree() under i_=
es_lock
- [Medium] ext4: extents_status-test: unlock sb->s_umount before kunit_acti=
vate_static_stub()
--

commit 68a97fa816f24b4b23fae3c4dae5fc1c10033a0d
Author: Theodore Tso <tytso@mit.edu>

ext4: add KUinit tests for fs/ext4/extents_status.c

This commit adds KUnit tests for the ext4 extents status tree and bigalloc
pending reservations, along with static stub redirects and symbol exports
needed by the test module.

> diff --git a/fs/ext4/extents_status-test.c b/fs/ext4/extents_status-test.c
> new file mode 100644
> index 0000000000000..65376666a362f
> --- /dev/null
> +++ b/fs/ext4/extents_status-test.c
> @@ -0,0 +1,1509 @@

[ ... ]

> +static void es_cleanup_inode(struct inode *inode)
> +{
> +	struct ext4_inode_info *ei =3D EXT4_I(inode);
> +	struct ext4_sb_info *sbi =3D EXT4_SB(inode->i_sb);
> +	struct rb_node *node;
> +
> +	sbi->s_mount_state &=3D ~EXT4_FC_REPLAY;
> +	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> +
> +	while ((node =3D rb_first(&ei->i_pending_tree.root)) !=3D NULL) {
> +		struct pending_reservation *pr;
> +
> +		pr =3D rb_entry(node, struct pending_reservation, rb_node);
> +		ext4_remove_pending(inode, EXT4_C2B(sbi, pr->lclu));
> +	}
> +}
> +
> +KUNIT_DEFINE_ACTION_WRAPPER(es_cleanup_inode_action, es_cleanup_inode,
> +			    struct inode *);
> +
> +static struct inode *es_alloc_test_inode(struct kunit *test,
> +					 struct super_block *sb,
> +					 unsigned long ino)
> +{
> +	struct ext4_inode_info *ei;
> +	int ret;
> +
> +	ei =3D kunit_kzalloc(test, sizeof(*ei), GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, ei);
> +	es_init_mock_inode(ei, sb, ino);
> +
> +	ret =3D kunit_add_action_or_reset(test, es_cleanup_inode_action,
> +					&ei->vfs_inode);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +
> +	return &ei->vfs_inode;
> +}

[ ... ]

> +static int es_kunit_init(struct kunit *test)
> +{

[ ... ]

> +	es_init_mock_inode(ctx->ei, sb, 12);
> +	ctx->sb =3D sb;
> +	ctx->sbi =3D sbi;
> +	ctx->shrinker_registered =3D true;
> +	test->priv =3D ctx;
> +
> +	kunit_activate_static_stub(test, ext4_da_update_reserve_space,
> +				   ext4_da_update_reserve_space_stub);
> +	kunit_activate_static_stub(test, ext4_da_release_space,
> +				   ext4_da_release_space_stub);
> +
> +	up_write(&sb->s_umount);
> +	return 0;
> +}

[Severity: Medium]
Should up_write(&sb->s_umount) happen before kunit_activate_static_stub()?

sget_fc() returns with sb->s_umount held write-locked, and test->priv =3D c=
tx is
assigned before calling kunit_activate_static_stub(). Inside
__kunit_activate_static_stub(), an allocation failure triggers
KUNIT_ASSERT_NOT_ERR_OR_NULL(), which aborts the init kthread via
kunit_try_catch_throw() before up_write(&sb->s_umount) is reached.

When KUnit then runs es_kunit_exit() in the cleanup kthread,
deactivate_super(ctx->sb) -> __super_lock_excl() will attempt to acquire
sb->s_umount and deadlock.

> +
> +static void es_kunit_exit(struct kunit *test)
> +{
> +	struct es_test_ctx *ctx =3D test->priv;
> +
> +	if (!ctx)
> +		return;
> +
> +	if (ctx->ei && ctx->sb)
> +		es_cleanup_inode(&ctx->ei->vfs_inode);
> +	if (ctx->shrinker_registered)
> +		ext4_es_unregister_shrinker(ctx->sbi);
> +	if (ctx->sb)
> +		deactivate_super(ctx->sb);
> +}

[Severity: High]
Can registering es_cleanup_inode_action() via kunit_add_action_or_reset() in
es_alloc_test_inode() cause a use-after-free when KUnit tears down the test?

In lib/kunit/test.c, kunit_run_case_cleanup() runs suite->exit(test) before
unwinding test resources via kunit_case_internal_cleanup():

kunit_run_case_cleanup()
  suite->exit(test) -> es_kunit_exit()
    ext4_es_unregister_shrinker(ctx->sbi)
    deactivate_super(ctx->sb)
  kunit_case_internal_cleanup(test)
    kunit_cleanup(test)
      es_cleanup_inode_action(inode2)
        es_cleanup_inode(inode2)

When test_es_shrinker_skips_precached_inode_until_last_resort() allocates
inode2 with es_alloc_test_inode(), es_kunit_exit() destroys the s_es_stats
per-CPU counters via ext4_es_unregister_shrinker() and drops the superblock
reference via deactivate_super(ctx->sb) before es_cleanup_inode(inode2) run=
s.

es_cleanup_inode(inode2) and ext4_es_remove_extent() then dereference
inode->i_sb after deactivate_super(ctx->sb). If inode2 still has any extents
in i_es_tree (for example if an earlier assertion fails before inode2 is
shrunk), ext4_es_remove_extent() -> ext4_es_free_extent() will also call
percpu_counter_dec() on the already-destroyed s_es_stats counters where
fbc->counters is NULL.

> +
> +static void assert_es_tree(struct kunit *test, struct inode *inode,
> +			   const struct expected_es *exp, unsigned int nr_exp)
> +{
> +	struct ext4_inode_info *ei =3D EXT4_I(inode);
> +	struct rb_node *node;
> +	unsigned int i =3D 0;
> +	ext4_lblk_t prev_end =3D 0;
> +
> +	read_lock(&ei->i_es_lock);
> +	for (node =3D rb_first(&ei->i_es_tree.root); node; node =3D rb_next(nod=
e)) {
> +		struct extent_status *es =3D
> +			rb_entry(node, struct extent_status, rb_node);
> +
> +		KUNIT_ASSERT_LT_MSG(test, i, nr_exp,
> +				    "unexpected extra extent [%u/%u) type 0x%x",
> +				    es->es_lblk, es->es_len, ext4_es_type(es));
> +
> +		if (i > 0)
> +			KUNIT_EXPECT_GT_MSG(test, es->es_lblk, prev_end,
> +					    "extent %u not strictly ordered",
> +					    i);
> +
> +		KUNIT_EXPECT_EQ_MSG(test, es->es_lblk, exp[i].lblk,
> +				    "extent %u lblk mismatch", i);
> +		KUNIT_EXPECT_EQ_MSG(test, es->es_len, exp[i].len,
> +				    "extent %u len mismatch", i);
> +		KUNIT_EXPECT_EQ_MSG(test, ext4_es_type(es), exp[i].type,
> +				    "extent %u type mismatch", i);
> +
> +		if (exp[i].type & (EXTENT_STATUS_WRITTEN |
> +				   EXTENT_STATUS_UNWRITTEN))
> +			KUNIT_EXPECT_EQ_MSG(test, ext4_es_pblock(es),
> +					    exp[i].pblk,
> +					    "extent %u pblk mismatch", i);
> +
> +		prev_end =3D es->es_lblk + es->es_len - 1;
> +		i++;
> +	}
> +	read_unlock(&ei->i_es_lock);
> +
> +	KUNIT_EXPECT_EQ(test, i, nr_exp);
> +	KUNIT_EXPECT_EQ(test, ei->i_es_all_nr, nr_exp);
> +}

[Severity: Medium]
Is it safe to invoke KUNIT_ASSERT_LT_MSG() and KUNIT_EXPECT_*_MSG() while
holding read_lock(&ei->i_es_lock)?

When a KUnit expectation or assertion fails, __kunit_do_failed_assertion() =
->
kunit_fail() calls kunit_alloc_string_stream(test, GFP_KERNEL), which perfo=
rms
a sleeping allocation under the ei->i_es_lock rwlock.

In addition, if KUNIT_ASSERT_LT_MSG() fails, __kunit_abort() exits the test
kthread immediately without calling read_unlock(&ei->i_es_lock). During
teardown, es_kunit_exit() -> es_cleanup_inode() -> ext4_es_remove_extent()
will then call write_lock(&EXT4_I(inode)->i_es_lock) and deadlock on the
leaked read lock.

[ ... ]

> +static void
> +test_es_shrinker_skips_precached_inode_until_last_resort(struct kunit *t=
est)
> +{
> +	struct es_test_ctx *ctx =3D test->priv;
> +	struct inode *inode1 =3D &ctx->ei->vfs_inode;
> +	struct inode *inode2;
> +	struct shrinker *shrink =3D ctx->sbi->s_es_shrinker;
> +	struct shrink_control sc;
> +	unsigned long shrunk;
> +
> +	inode2 =3D es_alloc_test_inode(test, ctx->sb, 13);

[ ... ]

> +}

[ ... ]

> --=20
> 2.51.2
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/atbPbe-i8DV3kLr8@mi=
t.edu?part=3D1
