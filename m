Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458135;
	b=p2+Mtf59enO7CXuuwwyAg7/YBAKheL1gLB950csXd2s27cwSRQQ+eCJwsmNkSJaxSkdB
	 wV68XxBUh5jLbN8apm7G2s9MSHCM89k7Cr8eV4zScBEwLyCSU3TyeoaCGHAGDxFpDQ7u/
	 Dvv9jWNcDgpPaA53hetUqPwlE5f5x/Hn9cx+FO6oNt0HsxqUUTokunJGB42m1+QGkUcTp
	 IFJ4dvy4yuFJUIgkKUzcjlg74VexFf8CYUb8rlBaHNaoKaOte2iQBOZjBNqDWfyLuHAja
	 GbfS19QxMRkjYgiBSsYJVd28UYSQSIoWUTlwqkChwQOIMnmzagcUrfrbwvoUWCM/t2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458135;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IeiYsseVy9KQRIuGpCsy2RyL//7KD8MpXqyMehSoKAo=;
	b=HIzQxR1n+KsqYITMSoUQ6Al0MldmPfYOn5Q1IV66vP0Rl11/pJnWIi4RU/zlhK+dRprq
	 8jZxUqJgF/axhCaKXwVHPD8qkn4gSRTwFaA4oMgt5s9R2dTgImRKR+ASk7KQb65koN4a4
	 a0xJxxqq7n7hZobl3TyREGMuilHHs5yriiUfg6E9rlA0W0TMki/yOaDXMoQMOR0N+IwjQ
	 01Ip8pJJX9w/d6/rzSpe404ARHjD0wFI2vzPbPTn2oyCwFH4iP+J5rpJE7a4uEiPIxsBG
	 uqqmjGxLhEWMbvwwHdryBgiWeGRsiLbTkZ1kb0q3Ci/QePi1vZBGWXpOD+cpPN/Tecg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJv2BxHp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63F6606A880
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJv2BxHp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A34B1F00A08;
	Thu, 12 Nov 2026 04:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794458135;
	bh=IeiYsseVy9KQRIuGpCsy2RyL//7KD8MpXqyMehSoKAo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=FJv2BxHpu/0F6otEbCQGzDN+lbF3PUlMP5GpYBrJp/V13MWR5cLi8YMS6CD+3gPtu
	 PBJ47IVyYZx9LIJcyOjA91KT9mmLcHBgQaDL5EFX+SS2Qv7FEbRVga/Xh4uC6rMLgF
	 OkO8dTXJ7V+iqiGMecC4xV8kxTJnJB1BHAlkrsCUEpMo8I024QJNdR+zgDGFrtpNg1
	 lH/wlrkNbwiaKSJRtCoBdJZJQFozzJcwg1y0mfDT+OTAFNOkw9/BxRmIUCmND8jiGB
	 xHCEcJn8juS5fFiXUylI1iwVmqYE+QOot7o10ru5v0S8DX78rGyo56sPporAqErgRk
	 e/Cb0eYxz2wVw==
Message-ID: <sashiko-outbox-210366@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 19/27] ext4: add KUnit tests for fs/ext4/ioctl.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-20-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-20-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:35:34 +0000
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
- [Medium] ext4: uninitialized s_es_stats counters dereferenced in
  ioctl_test_init()
- [Low] ext4: uninitialized work and timer cleanup in ioctl_test_init()
  error paths
- [Low] ext4: NULL bh->b_bdev in ioctl_init_mock_bh() dereferenced by
  tracepoint
- [Low] ext4: leaked inodes and dentries on KUNIT_ASSERT_NOT_NULL()
  abort in ioctl-test
It also noticed 2 related pre-existing issues this patch does not
introduce:
- [High] ext4: missing s_encoding initialization in
  ext4_ioctl_set_tune_sb() [1]
- [High] ext4: torn read of i_version in swap_inode_data() [2]
--

commit e7c759c842d0abec3f3d75ab9a035c69eb297d76
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/ioctl.c

This commit adds a KUnit test suite for superblock online tuning, backup
superblock updates, inode data swapping, fileattr handling, forced shutdown,
and ioctl dispatch in fs/ext4/ioctl.c, exporting helper wrappers for testin=
g.

> diff --git a/fs/ext4/ioctl-test.c b/fs/ext4/ioctl-test.c
> new file mode 100644
> index 0000000000000..fa31a9cc5d920
> --- /dev/null
> +++ b/fs/ext4/ioctl-test.c
[ ... ]
> +static void ioctl_init_mock_bh(struct buffer_head *bh, struct folio *fol=
io,
> +			       u8 *data, size_t size, sector_t blocknr)
> +{
> +	memset(bh, 0, sizeof(*bh));
> +	bh->b_folio =3D folio;
> +	bh->b_data =3D (char *)data;
> +	bh->b_size =3D size;
> +	bh->b_blocknr =3D blocknr;
> +	atomic_set(&bh->b_count, 2);
> +	set_buffer_uptodate(bh);
> +}

[Severity: Low]
Can leaving bh->b_bdev NULL here cause a NULL pointer dereference when the
block_dirty_buffer tracepoint is enabled?

test_update_superblocks_and_overhead() marks these mock buffer_heads dirty
via ext4_update_primary_sb() and ext4_update_backup_sb() ->
mark_buffer_dirty(), which calls trace_block_dirty_buffer(bh) and
dereferences bh->b_bdev->bd_dev.

[ ... ]
> +static void ioctl_test_cleanup(struct ioctl_test_ctx *ctx)
> +{
> +	active_ioctl_test =3D NULL;
> +
> +	if (ctx->sb) {
> +		deactivate_super(ctx->sb);
> +		rcu_barrier();
> +	}
> +
> +	cancel_work_sync(&ctx->sbi.s_sb_upd_work);
> +	timer_delete_sync(&ctx->sbi.s_err_report);
[ ... ]
> +static int ioctl_test_init(struct kunit *test)
> +{
[ ... ]
> +	ctx =3D kzalloc_obj(*ctx);
> +	KUNIT_ASSERT_NOT_NULL(test, ctx);
> +	test->priv =3D ctx;
> +	active_ioctl_test =3D test;
[ ... ]
> +	err =3D percpu_counter_init(&sbi->s_freeclusters_counter, 0, GFP_KERNEL=
);
> +	if (err) {
> +		up_write(&sb->s_umount);
> +		ioctl_test_cleanup(ctx);
> +		KUNIT_ASSERT_EQ(test, err, 0);
> +	}
> +	err =3D percpu_counter_init(&sbi->s_dirtyclusters_counter, 0, GFP_KERNE=
L);
> +	if (err) {
> +		percpu_counter_destroy(&sbi->s_freeclusters_counter);
> +		up_write(&sb->s_umount);
> +		ioctl_test_cleanup(ctx);
> +		KUNIT_ASSERT_EQ(test, err, 0);
> +	}
> +	err =3D percpu_counter_init(&sbi->s_freeinodes_counter, 0, GFP_KERNEL);
> +	if (err) {
> +		percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
> +		percpu_counter_destroy(&sbi->s_freeclusters_counter);
> +		up_write(&sb->s_umount);
> +		ioctl_test_cleanup(ctx);
> +		KUNIT_ASSERT_EQ(test, err, 0);
> +	}
> +	ctx->counters_inited =3D true;
> +
> +	INIT_WORK(&sbi->s_sb_upd_work, ioctl_test_sb_upd_work);
> +	timer_setup(&sbi->s_err_report, ioctl_test_err_timer, 0);

[Severity: Low]
If any of the percpu_counter_init() calls fail, does ioctl_test_cleanup() r=
un
cancel_work_sync() and timer_delete_sync() on uninitialized s_sb_upd_work a=
nd
s_err_report?

Because INIT_WORK() and timer_setup() happen after these error branches,
cancel_work_sync() hits WARN_ON(!work->func) in __flush_work() and
timer_delete_sync() passes an uninitialized lockdep_map to
lock_map_acquire().  Also, the earlier allocation failure paths before
sget_fc() abort without resetting active_ioctl_test to NULL.

> +	spin_lock_init(&sbi->s_error_lock);
> +	spin_lock_init(&sbi->s_md_lock);
> +	spin_lock_init(&sbi->s_bdev_wb_lock);
> +	spin_lock_init(&sbi->s_es_lock);
> +	INIT_LIST_HEAD(&sbi->s_es_list);

[Severity: Medium]
Does ioctl_test_init() leave the sbi->s_es_stats per-CPU counters
uninitialized?

test_swap_inode_data_and_seed() and test_force_shutdown_and_ioctl_dispatch()
insert and remove extents via ext4_es_insert_extent() and
ext4_es_remove_extent(), which call percpu_counter_inc() and
percpu_counter_dec() on sbi->s_es_stats.es_stats_shk_cnt and
sbi->s_es_stats.es_stats_all_cnt.  Because neither percpu_counter_init() nor
ext4_es_register_shrinker() is called for sbi, running these tests on
CONFIG_SMP dereferences a NULL per-CPU pointer and uses an uninitialized
spinlock in percpu_counter_add_batch().

[ ... ]
> +static void test_swap_inode_data_and_seed(struct kunit *test)
> +{
[ ... ]
> +	inode1 =3D new_inode(sb);
> +	inode2 =3D new_inode(sb);
> +	KUNIT_ASSERT_NOT_NULL(test, inode1);
> +	KUNIT_ASSERT_NOT_NULL(test, inode2);

[Severity: Low]
If the second new_inode(sb) call returns NULL, does KUNIT_ASSERT_NOT_NULL()
abort the test while leaking inode1?

When ioctl_test_cleanup() subsequently calls deactivate_super(ctx->sb), the
unreleased inode remains on sb->s_inodes and triggers the busy-inodes
CHECK_DATA_CORRUPTION() in generic_shutdown_super().  The same pattern
appears in test_immutable_dax_and_fileattr() when allocating reg_inode,
dir_inode, reg_dentry, and dir_dentry before d_instantiate(), and in
test_force_shutdown_and_ioctl_dispatch() if d_alloc_anon() fails after
new_inode().

> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index c8387e6a2c6e9..61e59c30e7611 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
[ ... ]
> @@ -1465,34 +1468,35 @@ static int ext4_ioctl_set_tune_sb(struct file *fi=
lp,
>  		 * Filter out the features that are already set from
>  		 * the set_mask.
>  		 */
> -		params.set_feature_compat_mask &=3D
> +		params->set_feature_compat_mask &=3D
>  			~le32_to_cpu(es->s_feature_compat);
> -		params.set_feature_incompat_mask &=3D
> +		params->set_feature_incompat_mask &=3D
>  			~le32_to_cpu(es->s_feature_incompat);
> -		params.set_feature_ro_compat_mask &=3D
> +		params->set_feature_ro_compat_mask &=3D
>  			~le32_to_cpu(es->s_feature_ro_compat);
> -		if ((params.set_feature_incompat_mask &
> -		     EXT4_FEATURE_INCOMPAT_CASEFOLD)) {
> +		if (params->set_feature_incompat_mask &
> +		    EXT4_FEATURE_INCOMPAT_CASEFOLD) {
>  			enabling_casefold =3D 1;
> -			if (!(params.set_flags & EXT4_TUNE_FL_ENCODING)) {
> -				params.encoding =3D EXT4_ENC_UTF8_12_1;
> -				params.set_flags |=3D EXT4_TUNE_FL_ENCODING;
> +			if (!(params->set_flags & EXT4_TUNE_FL_ENCODING)) {
> +				params->encoding =3D EXT4_ENC_UTF8_12_1;
> +				params->set_flags |=3D EXT4_TUNE_FL_ENCODING;
>  			}
> -			if (!(params.set_flags & EXT4_TUNE_FL_ENCODING_FLAGS)) {
> -				params.encoding_flags =3D 0;
> -				params.set_flags |=3D EXT4_TUNE_FL_ENCODING_FLAGS;
> +			if (!(params->set_flags &
> +			      EXT4_TUNE_FL_ENCODING_FLAGS)) {
> +				params->encoding_flags =3D 0;
> +				params->set_flags |=3D
> +					EXT4_TUNE_FL_ENCODING_FLAGS;
>  			}
>  		}

[Severity: High]
This problem wasn't introduced by this patch, but when
EXT4_FEATURE_INCOMPAT_CASEFOLD is enabled online via
EXT4_IOC_SET_TUNE_SB_PARAM [1], does anything initialize
sb->s_encoding in memory?

ext4_sb_setparams() sets EXT4_FEATURE_INCOMPAT_CASEFOLD in the superblock
without loading the unicode map into sb->s_encoding.  Subsequent
EXT4_IOC_SETFLAGS calls can then set EXT4_CASEFOLD_FL on a directory, and a
lookup in that directory calls ext4_fname_setup_ci_filename() ->
utf8_casefold(dir->i_sb->s_encoding, ...), dereferencing a NULL
sb->s_encoding pointer.

[ ... ]
> +void ext4_swap_inode_data_test(struct inode *inode1, struct inode *inode=
2)
> +{
> +	swap_inode_data(inode1, inode2);
> +}
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_swap_inode_data_test);

[Severity: High]
This problem wasn't introduced by this patch, but can swap_inode_data()
cause torn reads of i_version on 32-bit architectures [2]?

fs/ext4/ioctl.c:swap_inode_data() {
	...
	swap(inode1->i_version, inode2->i_version);
	...
}

Because i_version is an atomic64_t, exchanging it with swap() performs plain
struct assignment instead of using atomic64 accessors, allowing concurrent
lockless readers such as inode_peek_iversion_raw() to observe torn values on
32-bit SMP systems.

[1] https://sashiko.dev/#/bug/linux-4eae7256-2707-4887-b442-c774f5662e2b
[2] https://sashiko.dev/#/bug/linux-14d568d4-dbf5-4a52-9af4-757563dc37e3

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D19
