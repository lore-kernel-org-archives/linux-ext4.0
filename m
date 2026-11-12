Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457713;
	b=c0UENy9ZCXpAQY3Ha+eLNDF6lcX+p/qIe/Ev0iF5DF7ScM9uJoc4OIb50f/QBDarfFWM
	 ZyyfH3CLbhT6FCfZ7B0SZDXuBlZKwJGfmbhMAI9756BBO9vWvXuwFgoLzZ/j6qVSdTKXU
	 6bA70OEfsjb4lDCSYBXibOIwQROm20iTqA8TeqMPAQ8WVOq7D5d6gE4XMPg5dRaN92YVU
	 lDxbZW5pRpTYYk4bAELN8hUiz9xMLVnlaw8Z1zssCB5KCLUmcKQa4RHW9GJJGMZk53IgE
	 S5SYqj7HrdvG+Mcw7DO6WSQkQ9/uSehTw1pTrS5JxSzn74LwoQ8iM8A1s795CaLdTKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457713;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=la5/TLkbDv7ZYovdVEDkygyrvKUVdFyDv5IIaahTXjQ=;
	b=luGqLBUcfAOp30snbUHDc30aTnF0j1LZYBoBemgcsTZ3YqtoLNVD9jqiYmgvrx9BE+ps
	 OFwbKfSu9RdCsDgiYm1ypZilZ2uL0TJwahrZoDBFb2X3vMj53NmAtMlKzmBFTCX1n6X5p
	 F+yZKCn9PdyZi0569AX+avELM6h9GFBhiRU/Iik6UoH4jIGMpBPA++DxMbeUA00iv7a0C
	 58CpV8oXrxIPegT6owA8sYjKjbGwgNTGSDL2K55ye7bb+n7v7Rm+DNXRQ0qL/lrJPBwRi
	 6WQYQ5WDNTbXMDcAfVyHw8dDu694e4KH6YiOyv12HfZZe53HYgEjE06XRu5TrbYK5PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lj5h9Nq+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB9A606A321
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lj5h9Nq+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB0E1F00A05;
	Thu, 12 Nov 2026 04:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457713;
	bh=la5/TLkbDv7ZYovdVEDkygyrvKUVdFyDv5IIaahTXjQ=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=lj5h9Nq+hXlYMxy6qZDbtnTBTugFW88cPaJal+BuOCDWScFphYqXwXbEgHHFRNDNt
	 Qg2KBTBLwr61Fd38g9rg3Kxj6WsIk3tnkoG0jCLPqhX57eQkPe/W74YwlPyDCxmZVa
	 BSq+Ft6O80UC++0YCGs2ceIIyj8Nxx+YKJMwYuKka+cjsWNhTSCVGLaD91OVd3giHW
	 iXb4XKfAQw+iIKYqXb7As5fK2uArxxNQeXjUDkz+JZeHPs0AAQEQ+/X/NZEowx3SMG
	 ySCA2iUYnrENZNeVPEoc3GudI9pFCy/lZdWx3jwtu4uYzwERSNPMhrTvK6twrgSE3p
	 iMzzO4qunYTXw==
Message-ID: <sashiko-outbox-210338@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/27] ext4: add KUnit tests for fs/ext4/fast_commit.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-10-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-10-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:28:32 +0000
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
- [Medium] ext4: uninitialized j_trans_commit_map in
  fast_commit_test_init()
- [Medium] ext4: excessive stack frame size in fast_commit-test.c test
  cases
- [Low] ext4: resource leak and UAF on abort in fast_commit_test_init()
  and cleanup
--

commit 0a44fff123afc676ec0d455ddc174806f24be58f
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/fast_commit.c

This commit adds the ext4_fast_commit_test KUnit test suite in
fs/ext4/fast_commit-test.c and exports fast commit helpers and static stub
hooks in fs/ext4/fast_commit.c and related files.

> diff --git a/fs/ext4/fast_commit-test.c b/fs/ext4/fast_commit-test.c
> new file mode 100644
> index 0000000000000..57745e51bea67
> --- /dev/null
> +++ b/fs/ext4/fast_commit-test.c
[ ... ]
> +/* --- Suite Setup & Teardown --- */
> +
> +static void fc_cleanup_all(void *priv)
> +{
> +	struct fc_test_ctx *ctx =3D priv;
> +	int i;
> +
> +	ctx->sbi->s_mount_state &=3D ~EXT4_FC_REPLAY;
> +	ext4_fc_cleanup_test(&ctx->journal, 1, 999999);
> +	ext4_fc_replay_cleanup(ctx->sb);
> +
> +	for (i =3D 0; i < TEST_MAX_INODES; i++) {
> +		if (!ctx->inodes[i].allocated)
> +			continue;
> +		down_write(&ctx->inodes[i].ei.i_data_sem);
> +		ext4_es_remove_extent(&ctx->inodes[i].ei.vfs_inode, 0,
> +				      EXT_MAX_BLOCKS);
> +		up_write(&ctx->inodes[i].ei.i_data_sem);
> +		ext4_fc_free_inode_snap_test(&ctx->inodes[i].ei.vfs_inode);
> +	}
> +
> +	ext4_es_unregister_shrinker(ctx->sbi);
> +	deactivate_super(ctx->sb);
> +}
> +
> +static int fast_commit_test_init(struct kunit *test)
> +{
> +	struct fc_test_ctx *ctx;
> +	struct ext4_sb_info *sbi;
> +	struct super_block *sb;
> +	struct fs_context *fc;
> +	int i, err;
> +
> +	ctx =3D kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
> +
> +	sbi =3D kunit_kzalloc(test, sizeof(*sbi), GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sbi);
> +
> +	fc =3D fs_context_for_mount(&fc_fs_type, 0);
> +	KUNIT_ASSERT_FALSE(test, IS_ERR(fc));
> +	sb =3D sget_fc(fc, NULL, fc_set_anon);
> +	put_fs_context(fc);
> +	KUNIT_ASSERT_FALSE(test, IS_ERR(sb));
[ ... ]
> +	up_write(&sb->s_umount);
> +
> +	err =3D ext4_es_register_shrinker(sbi);
> +	KUNIT_ASSERT_EQ(test, err, 0);
> +	ctx->shrinker_count =3D sbi->s_es_shrinker->count_objects;
> +	ctx->shrinker_scan =3D sbi->s_es_shrinker->scan_objects;
> +	WRITE_ONCE(sbi->s_es_shrinker->count_objects, fc_dummy_shrinker_count);
> +	WRITE_ONCE(sbi->s_es_shrinker->scan_objects, fc_dummy_shrinker_scan);
> +
> +	/* Mock journal, running transaction, and handle setup */
> +	rwlock_init(&ctx->journal.j_state_lock);
> +	spin_lock_init(&ctx->journal.j_list_lock);
> +	mutex_init(&ctx->journal.j_barrier);

[Severity: Medium]
Does fast_commit_test_init() leave ctx->journal.j_trans_commit_map
uninitialized?

ctx is heap-allocated with kunit_kzalloc().  When test_fc_commit_paths()
calls ext4_fc_commit() -> ext4_fc_perform_commit() ->
jbd2_journal_lock_updates(), jbd2_might_wait_for_commit() passes
&ctx->journal.j_trans_commit_map to rwsem_acquire() and rwsem_release().
With CONFIG_LOCKDEP enabled, its NULL key in non-static memory triggers
"INFO: trying to register non-static key" and turns off lockdep via
debug_locks_off().

[ ... ]

> +	kunit_activate_static_stub(test, ext4_fc_submit_bh,
> +				   stub_fc_submit_bh);
> +	kunit_activate_static_stub(test, ext4_fc_issue_flush,
> +				   stub_fc_issue_flush);
> +
> +	init_mock_inode_slot(ctx, &ctx->inodes[0], TEST_ROOT_INO,
> +			     S_IFDIR | 0755);
> +	init_mock_inode_slot(ctx, &ctx->inodes[1], TEST_DIR_INO,
> +			     S_IFDIR | 0755);
> +	init_mock_inode_slot(ctx, &ctx->inodes[2], TEST_FILE1_INO,
> +			     S_IFREG | 0644);
> +	init_mock_inode_slot(ctx, &ctx->inodes[3], TEST_FILE2_INO,
> +			     S_IFREG | 0644);
> +	init_mock_inode_slot(ctx, &ctx->inodes[4], TEST_SUBDIR_INO,
> +			     S_IFDIR | 0755);
> +
> +	err =3D kunit_add_action_or_reset(test, fc_cleanup_all, ctx);
> +	KUNIT_ASSERT_EQ(test, err, 0);
> +
> +	return 0;
> +}

[Severity: Low]
Can an assertion failure in fast_commit_test_init() leak sb and leave
sbi->s_es_shrinker and sbi->s_es_stats percpu_counters registered after
KUnit frees sbi?

fc_cleanup_all() is only registered after ext4_es_register_shrinker() and
all the kunit_activate_static_stub() calls, which themselves assert on
allocation failure.  Aborting in that window skips deactivate_super(sb) and
ext4_es_unregister_shrinker(sbi), causing a use-after-free once the
kunit_kzalloc()-allocated sbi is freed.

Also, in fc_cleanup_all(), calling ext4_fc_cleanup_test() only once drains
FC_Q_MAIN before splicing FC_Q_STAGING into FC_Q_MAIN, so any
ext4_fc_dentry_update entries on s_fc_dentry_q[FC_Q_STAGING] when a test
aborts are leaked.

> +
> +/* =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + * 1. Initialization, Eligibility, and Snapshot Stat Helpers
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + */
> +
> +static void test_fc_init_and_eligibility(struct kunit *test)
> +{
> +	struct fc_test_ctx *ctx =3D test->priv;
> +	struct super_block *sb =3D ctx->sb;
> +	struct inode *inode =3D get_mock_inode(ctx, TEST_FILE1_INO);
> +	struct ext4_inode_info *ei =3D EXT4_I(inode);
> +	journal_t tmp_journal =3D {};

[Severity: Medium]
Does allocating tmp_journal on the stack here (and five struct dentry
objects on the stack in test_fc_replay_inode_and_dentries()) exceed
CONFIG_FRAME_WARN?

journal_t is over 1.3 KB (and over 2.2 KB with CONFIG_LOCKDEP enabled), and
the five dentries in test_fc_replay_inode_and_dentries() take ~1.6 KB with
CONFIG_LOCKDEP, triggering -Wframe-larger-than warnings or build failures
under CONFIG_WERROR.  Could tmp_journal and the mock dentries be allocated
with kunit_kzalloc() or moved into struct fc_test_ctx?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D9
