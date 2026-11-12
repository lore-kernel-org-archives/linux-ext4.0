Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458241;
	b=pb4hdJxmcanFMW7JMNgK4fcOBK+kuv+LMCy2Om5z04HZyDU3/w6+odMSnSILOd8bkAhS
	 9eM7BQpnupm6QHy3Mz2jmd7C1yIZCbArkYGMo0gfRiQtTG3N1Ds4pFkZ6ygFdiKZhpvCK
	 aj1uiJgV5Jo7buN7EnxZIepUu+XmA+Hgk3fjo9rqWTI9Z28YiNVVAS2onR6Rf21WD7BKh
	 fCybnTQwwUyVfp3ooJ0Jlyq92BuIyH6zZsMXIuePs5fGqvMLF478Occ2lrRFc0agy1T59
	 Nvyh+1AtTkw82P2vClrrkqQCGMu4JfoKbwsz5RQEO5ImD8r72VBPztLZEcn1cgJiGzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458241;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=y0rz+LQTFDCykowLy5udqzrtTokeIh6bn9ZDO7MSZjI=;
	b=IAApBgHd4gE6NwBJGaQu7ZSFA4fE6FPc6RX0l/AUetkXR5++TOr4i1+7YbEBItdfB6CC
	 +PfX7taRhhMwAOeGsuGn8piE/WHWv3eK/udiT6+7b5GTpfucBHv7MxQXeCaiTDrYvO++1
	 oRG5JpMhL3OzoJi248J/TIuKcyAABp98uI6b6bh7/MRaRs5z8ypufIbIDq5rctgsBmQhu
	 lx5ultY2E/ItLnL0ZskJaqwZ3eHqCqfQRYhoInkp9BPEUJlf3C6iZztNs4U1xKh7jIoHL
	 DZcDvqOk7fuTRoQiYia94FB70/Ab0KjgJCF2+CbPdaqW9BAqjbnQ0NBrz1LVU+x5HRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dUsBezgP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C45606A8B3
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dUsBezgP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43D01F00A05;
	Thu, 12 Nov 2026 04:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794458241;
	bh=y0rz+LQTFDCykowLy5udqzrtTokeIh6bn9ZDO7MSZjI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=dUsBezgPP8sBFvj10/lsHV6i++jbRE0Nxu8cplTnU5k6anfdk9YxVG1wbJzN5Pe/T
	 C6d3X2Mtn11KFLDCskHODARbmkrPKDwbMMTjYJujWzEb4jhSrHi0YVSWvu2Fi/DXBJ
	 1qy3juvQ6UgFiwp3NkagyuBuTrtjIcGwORbR6QjdRDGY3D4/DnyjApO5MUTVVQmHIM
	 DqVb8p+35rE/G0fEzVoW1lsenLGs7BcZRUgZaKZzV0iMyUrDl1tdXeY0Ar48WqzUWd
	 V2zDyPtRd6hnR4d87EJmfDpJrZ/llO3SEfua05jI26HcdA7Yila7ZNZk6SJaL54Jla
	 9Y09kGOAEeHlg==
Message-ID: <sashiko-outbox-210369@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 21/27] ext4: add KUnit tests for fs/ext4/migrate.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-22-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-22-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:37:13 +0000
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
- [High] ext4: UAF and invalid RCU context in migrate_test_free_inode()
  and cleanup
- [Low] ext4: uninitialized work/timer teardown and counter leak in
  migrate_test_init()
- [Low] ext4: skipped extent block checksum check in migrate-test due to
  BH_Verified
- [Low] ext4: leaked ext4_ext_path and busy inodes on mid-test
  KUNIT_ASSERT failure
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] ext4: error clobbering and data loss in ext4_ext_migrate()
  [1]
--

commit 5ed76678c1803e6d79647899ecaa6195b5ca46ef
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/migrate.c

This commit adds the ext4_migrate_test KUnit suite in fs/ext4/migrate-test.c
to test online inode format migration between indirect block maps and extent
trees, and exports the tested helpers via EXPORT_SYMBOL_FOR_EXT4_TEST.

> diff --git a/fs/ext4/migrate-test.c b/fs/ext4/migrate-test.c
> new file mode 100644
> index 0000000000000..e83d208a5117e
> --- /dev/null
> +++ b/fs/ext4/migrate-test.c

[ ... ]

> +static void migrate_test_free_inode(struct inode *inode)
> +{
> +	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> +	kfree(EXT4_I(inode));
> +}
> +
> +static void migrate_test_evict_inode(struct inode *inode)
> +{
> +	truncate_inode_pages_final(&inode->i_data);
> +	clear_inode(inode);
> +}

[ ... ]

> +static void migrate_test_cleanup(struct migrate_test_ctx *ctx)
> +{
> +	struct super_block *sb =3D ctx->sb;
> +	struct ext4_sb_info *sbi =3D &ctx->sbi;
> +	struct migrate_mock_blk *blk, *tmp;
> +
> +	if (sb) {
> +		cancel_work_sync(&sbi->s_sb_upd_work);
> +		timer_delete_sync(&sbi->s_err_report);
> +	}
> +
> +	if (ctx->es_shrinker_inited) {
> +		ext4_es_unregister_shrinker(sbi);
> +		ctx->es_shrinker_inited =3D false;
> +	}
> +
> +	if (ctx->counters_inited) {
> +		percpu_counter_destroy(&sbi->s_freeclusters_counter);
> +		percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
> +		percpu_counter_destroy(&sbi->s_freeinodes_counter);
> +		ctx->counters_inited =3D false;
> +	}
> +
> +	if (ctx->rwsem_inited) {
> +		percpu_free_rwsem(&sbi->s_writepages_rwsem);
> +		ctx->rwsem_inited =3D false;
> +	}
> +
> +	if (sb) {
> +		deactivate_super(sb);
> +		ctx->sb =3D NULL;
> +	}

[Severity: High]
Does calling ext4_es_remove_extent() from migrate_test_free_inode() run in
RCU softirq context and race with migrate_test_cleanup()?

During ext4_ext_migrate(), finish_range() -> ext4_find_extent() caches
extents in EXT4_I(tmp_inode)->i_es_tree and links the inode onto
ctx->sbi.s_es_list.  Because destroy_inode() invokes .free_inode via
call_rcu(), migrate_test_free_inode() runs in RCU softirq context, where
ext4_es_remove_extent() takes non-softirq-safe locks (i_es_lock and
s_es_lock) and can allocate with GFP_KERNEL.

In addition, migrate_test_cleanup() destroys the extent status shrinker's
percpu counters before deactivate_super(sb) and returns without
rcu_barrier() before KUnit frees ctx:

CPU0                              CPU1 (<softirq>)
migrate_test_cleanup()
  ext4_es_unregister_shrinker(sbi)
    percpu_counter_destroy(...)
  deactivate_super(sb)
  /* KUnit frees ctx */
                                  i_callback()
                                    migrate_test_free_inode()
                                      ext4_es_remove_extent()
                                        /* dereferences freed ctx->sbi
                                         * and NULL counter->counters
                                         */  <-- use-after-free

Calling ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS) in
migrate_test_evict_inode() before clear_inode(), moving deactivate_super(sb)
ahead of the sbi teardown in migrate_test_cleanup(), and calling
rcu_barrier() before returning would avoid this.

[ ... ]

> +static int migrate_test_init(struct kunit *test)
> +{

[ ... ]

> +	ctx->sb =3D sb;
> +	up_write(&sb->s_umount);
> +
> +	ret =3D kunit_add_action_or_reset(test, migrate_test_cleanup_action, ct=
x);
> +	KUNIT_ASSERT_EQ(test, ret, 0);

[ ... ]

> +	INIT_WORK(&sbi->s_sb_upd_work, migrate_test_sb_upd_work);
> +	timer_setup(&sbi->s_err_report, migrate_test_err_timer, 0);

[ ... ]

> +	ret =3D percpu_counter_init(&sbi->s_freeclusters_counter, 4096,
> +				  GFP_KERNEL);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +	ret =3D percpu_counter_init(&sbi->s_dirtyclusters_counter, 0, GFP_KERNE=
L);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +	ret =3D percpu_counter_init(&sbi->s_freeinodes_counter, 200, GFP_KERNEL=
);
> +	KUNIT_ASSERT_EQ(test, ret, 0);
> +	ctx->counters_inited =3D true;

[Severity: Low]
If kunit_add_action_or_reset() fails, can migrate_test_cleanup() call
cancel_work_sync() and timer_delete_sync() on s_sb_upd_work and s_err_report
before they are initialized?

Also, if the second or third percpu_counter_init() fails, KUNIT_ASSERT_EQ()
aborts before ctx->counters_inited is set, so migrate_test_cleanup() skips
percpu_counter_destroy() and leaks the already-initialized percpu counters.

[ ... ]

> +static void test_ext_migrate_dind_tind_and_multilevel_tree(struct kunit =
*test)
> +{

[ ... ]

> +	for (i =3D 0; i < ARRAY_SIZE(expected); i++) {
> +		path =3D ext4_find_extent(inode, expected[i].lblk, NULL, 0);
> +		KUNIT_ASSERT_FALSE_MSG(test, IS_ERR(path),
> +				       "find_extent failed at idx %u", i);
> +		KUNIT_ASSERT_NOT_NULL(test, path[path->p_depth].p_ext);
> +		KUNIT_EXPECT_EQ_MSG(test,
> +				    le32_to_cpu(path[path->p_depth].p_ext->ee_block),
> +				    expected[i].lblk, "lblk idx %u", i);
> +		KUNIT_EXPECT_EQ_MSG(test,
> +				    ext4_ext_pblock(path[path->p_depth].p_ext),
> +				    expected[i].pblk, "pblk idx %u", i);
> +		ext4_free_ext_path(path);
> +	}

[Severity: Low]
Does ext4_find_extent(inode, ..., 0) here skip verifying the extent block
checksum on the migrated inode?

While building the tree on tmp_inode, ext4_ext_grow_indepth() and
migrate_ext_dirty_stub() call set_buffer_verified() on the mock buffer_head.
When ext4_find_extent() is later called on inode with flags =3D=3D 0,
__read_extent_tree_block() sees buffer_verified(bh) and returns without
running __ext4_ext_check(), so i_csum_seed propagation is never checked.
Passing EXT4_EX_FORCE_CACHE (or clearing buffer_verified() on the block)
would force checksum verification.

[Severity: Low]
In the same loop, if KUNIT_ASSERT_NOT_NULL(test, path[path->p_depth].p_ext)
fails, does the early abort leak path and leave inode referenced during
deactivate_super(sb)?  Other KUNIT_ASSERT_* calls in these tests while
holding a test inode similarly skip iput(inode) on failure.

> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 5d60ef10fe110..8d76042f0caea 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -597,6 +597,7 @@ int ext4_ext_migrate(struct inode *inode)
>  	iput(tmp_inode);
>  	return retval;
>  }
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_ext_migrate);

[Severity: Critical]
This problem wasn't introduced by this patch [1], but in
ext4_ext_migrate(), does assigning the result of
ext4_journal_ensure_credits() to retval after err_out clobber the migration
error and risk freeing the original file's data blocks?

fs/ext4/migrate.c:ext4_ext_migrate() {
    ...
err_out:
	if (retval)
		free_ext_block(handle, tmp_inode);
	else {
		...
	}

	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
	retval =3D ext4_journal_ensure_credits(handle, 1, 0);
	if (retval < 0)
		goto out_stop;
	...
	tmp_inode->i_blocks =3D 0;
	EXT4_I(tmp_inode)->i_csum_seed =3D tmp_csum_seed;

	/* Reset the extent details */
	ext4_ext_tree_init(handle, tmp_inode);
out_stop:
	ext4_journal_stop(handle);
out_tmp_inode:
	unlock_new_inode(tmp_inode);
out_unlock:
	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
	iput(tmp_inode);
	return retval;
}

When extent building fails (such as in
test_ext_migrate_error_rollback_frees_tmp_extent_blocks()),
ext4_journal_ensure_credits() overwrites the negative retval with 0 so
ext4_ext_migrate() returns success.  Worse, if
ext4_journal_ensure_credits() fails, jumping to out_stop leaves tmp_inode
with i_nlink =3D=3D 0, non-zero i_blocks, and in-inode root extents still
pointing at the original file's physical data blocks, which
iput(tmp_inode) -> ext4_evict_inode() will then free.

[1] https://sashiko.dev/#/bug/linux-29ab25ff-78b3-4378-b750-b1aca01c3a2d

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D21
