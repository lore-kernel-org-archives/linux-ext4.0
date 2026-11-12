Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457953;
	b=C6kSASxEvp4D+2UK7iD04PuQk12idRzbeN4kJ3J/uhr12pecTyLiqSx8x9PFHndGPkK2
	 1sIw6l+dOi71xFQv3uzCUifV9/XxJwTo2dKaertSjsVEoOE3wObRQBfWBogv5/klJZDtL
	 HepnqoTZMV1kDYz4Ps/N/NxK1UGi8CJV7dT8OTTxvk3goEbENagLtjflCYBZpuBC6Skr8
	 mRbE5bRC+jMsGL08eKCZelCocT76KGovKdzWSWH6ElxlNK5/L8lWZNk3y6Vu8KzLWdjKo
	 Ym0wL8qXzLrTD2xJnZSl7zrqm62e25jJIMa2Tl3cWAnr3g3a+6o39yUpTKeAHEzA8IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457953;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HeTom+IkSnuBO3FvCm6tmyzlPigDjMHcEzYzOgt0dOI=;
	b=S1pTtBa/q9PMebSpfKNOq/jLaH7N4bC5mYAYtgPBd0AEa1dT8/jsKLfHhET7x/VKeqSb
	 hywhVTws46UCt74EZ/rq2TxbXVLWZBgqIUv5Y+RFMDMYFSvPHMbd2Hnyil3lHT0JZkzGD
	 ieweXPS/OdlxNasJDiTH4xDtViy52Lnow3Y4AlMfL4uu7P47VIM6L0UDhWpLjeHjYh2VJ
	 iQ8YeqI9xi08hZoNRxOVCDrpcJ6V7FqlvbKspK5VIQjVUOK7Nixpxyp/Ub7lAX2gWEvxX
	 hzJOJGMFUwVVk39rmBIMrM3V413yckOVerRHIx0/EyoxX4kwnk2BFH3+7SxrVSbEAbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eWq5sZn3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53400606A32E
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eWq5sZn3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0416A1F00A08;
	Thu, 12 Nov 2026 04:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457953;
	bh=HeTom+IkSnuBO3FvCm6tmyzlPigDjMHcEzYzOgt0dOI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=eWq5sZn3zQ4PvisFsUrUPR27dZ5fjQ3IjEYUzw5EanwZvaPMw+gLri3I5JkN2wyOu
	 chhG1htnZKkVQRdEq4WEAp8lGsEyCj+qPjSnXKNdAm7JI1rT+OEDwGKi1i7hbeZ2t2
	 fEIR+PqOWv6uNR83y8rd/dHuxAmLDf+FU2nPnvKMjPQo8L9/81GJRF91G9GSpZ5cPI
	 dyFNZS+/8OxAweZ9CBw8lywomGHI+Fm+F1Wb5+TjbA/8R8TbinVByJfeVe5zgC5voM
	 bmIDeojIb3rZED6FoPX1jQ+CnybKclYSCRl07vWRSTvZLgtzyHUzP8E9EGp/AaPoqR
	 M62sBOTV6P/xA==
Message-ID: <sashiko-outbox-210360@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 18/27] ext4: add KUnit tests for fs/ext4/sysfs.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-19-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-19-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:32:32 +0000
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
- [Medium] ext4: UAF of ctx->sb in fserror_worker() due to NULL
  sb->s_root in sysfs-test.c
- [Low] ext4: preemptible part_stat_add() call in
  test_computed_ro_and_error_time_attrs()
- [Low] ext4: s_last_error_func check fails under !CONFIG_PRINTK in
  sysfs-test.c
- [Low] ext4: sysfs_test_cleanup() frees ctx->sb before canceling work
  and timer
--

commit f2e9ba8068c01ef9b7c5be16e187d6640c8a57c0
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/sysfs.c

This commit adds a KUnit test suite covering ext4 sysfs attribute show and
store handlers, feature capability attributes, and sysfs/procfs registratio=
n.

> diff --git a/fs/ext4/sysfs-test.c b/fs/ext4/sysfs-test.c
> new file mode 100644
> index 0000000000000..c13785420aa11
> --- /dev/null
> +++ b/fs/ext4/sysfs-test.c
> @@ -0,0 +1,653 @@

[ ... ]

> +static void sysfs_test_cleanup(struct sysfs_test_ctx *ctx)
> +{
> +	ctx->sbi.s_journal =3D NULL;
> +
> +	deactivate_super(ctx->sb);
> +	rcu_barrier();
> +
> +	cancel_work_sync(&ctx->sbi.s_sb_upd_work);
> +	timer_delete_sync(&ctx->sbi.s_err_report);

[Severity: Low]
Should cancel_work_sync() and timer_delete_sync() run before
deactivate_super(ctx->sb)?

Writing a non-zero value to err_report_sec in test_validated_rw_attrs()
replaces sbi->s_err_report's callback with print_daily_error_info() and arms
the timer, and print_daily_error_info() dereferences sbi->s_sb (ctx->sb).
Stopping the work item and timer before deactivating and RCU-freeing ctx->sb
ensures neither callback can access ctx->sb after it is freed.

[ ... ]

> +	sbi->s_sb =3D sb;
> +	sb->s_fs_info =3D sbi;
> +	sb->s_op =3D &sysfs_test_sops;
> +#ifdef CONFIG_FS_ENCRYPTION
> +	sb->s_cop =3D &ext4_cryptops;
> +#endif
> +	sb->s_flags |=3D SB_ACTIVE;
> +	sb->s_blocksize =3D SYSFS_TEST_BLK_SIZE;
> +	sb->s_blocksize_bits =3D SYSFS_TEST_BLK_BITS;
> +	strscpy(sb->s_id, "ext4_sysfs_kunit", sizeof(sb->s_id));

[Severity: Medium]
Can leaving sb->s_root NULL while setting SB_ACTIVE cause a use-after-free =
of
ctx->sb in fserror_worker()?

In test_feature_attrs_and_trigger_error(), writing to trigger_fs_error calls
trigger_test_error() -> ext4_error() -> __ext4_error() ->
fserror_report_metadata().  Because alloc_super() initialized
sb->s_pending_errors to 1 and SB_ACTIVE is set, fserror_report_metadata()
queues an asynchronous fserror_worker work item holding a raw pointer to
ctx->sb.  However, generic_shutdown_super() only clears SB_ACTIVE and calls
fserror_unmount(sb) to drain pending events when sb->s_root is non-NULL:

CPU0                                      kworker
test_feature_attrs_and_trigger_error()
  ...
    fserror_report_metadata(sb, ...)
      schedule_work(&event->work)
sysfs_test_cleanup()
  deactivate_super(ctx->sb)
    kill_anon_super()
      generic_shutdown_super()
        /* sb->s_root is NULL:
         * skips fserror_unmount(sb)
         */
      put_super(sb)
  rcu_barrier()
  /* destroy_super_work() frees sb */
                                          fserror_worker()
                                            sb =3D event->sb;
                                            if (!(sb->s_flags & SB_ACTIVE))
                                              <-- use-after-free

Initializing sb->s_root with d_make_root() (or calling fserror_unmount(ctx-=
>sb)
before deactivating the superblock) would ensure pending fserror events are
drained before ctx->sb is freed.

[ ... ]

> +static void test_computed_ro_and_error_time_attrs(struct kunit *test)
> +{
> +	struct sysfs_test_ctx *ctx =3D test->priv;
> +	struct ext4_sb_info *sbi =3D &ctx->sbi;
> +	struct ext4_super_block *es =3D &ctx->es;
> +	char expected_pid[32];
> +	char *buf;
> +
> +	buf =3D kunit_kzalloc(test, PAGE_SIZE, GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, buf);
> +
> +	/* 7 dirty clusters * 4 blocks/cluster =3D=3D 28 delayed allocation blk=
s */
> +	percpu_counter_set(&sbi->s_dirtyclusters_counter, 7);
> +	KUNIT_EXPECT_GT(test,
> +			ext4_sysfs_attr_show_test(sbi,
> +				"delayed_allocation_blocks", buf),
> +			(ssize_t)0);
> +	KUNIT_EXPECT_STREQ(test, buf, "28\n");
> +
> +	/* (50 - 10) sectors >> 1 =3D=3D 20 KB session, + 100 =3D=3D 120 KB lif=
etime */
> +	sbi->s_sectors_written_start =3D 10;
> +	sbi->s_kbytes_written =3D 100;
> +	part_stat_add(&ctx->bdev, sectors[STAT_WRITE], 50);

[Severity: Low]
Does calling part_stat_add() here without part_stat_lock() /
part_stat_unlock() trigger a CONFIG_DEBUG_PREEMPT warning?

part_stat_add() uses __this_cpu_add(), which requires preemption to be
disabled and logs a "BUG: using __this_cpu_add() in preemptible" warning wh=
en
called in a preemptible KUnit thread with CONFIG_DEBUG_PREEMPT enabled.

[ ... ]

> +	/* Non-empty message records error state via ext4_error() */
> +	KUNIT_EXPECT_EQ(test,
> +			ext4_sysfs_attr_store_test(sbi, "trigger_fs_error",
> +						   "kunit injected\n", 15),
> +			(ssize_t)15);
> +	KUNIT_EXPECT_NE(test, sbi->s_mount_state & EXT4_ERROR_FS, 0);
> +	KUNIT_EXPECT_STREQ(test, sbi->s_last_error_func, "trigger_test_error");
> +	sbi->s_journal =3D NULL;
> +}

[Severity: Low]
Will the sbi->s_last_error_func assertion fail when CONFIG_PRINTK is disabl=
ed?

In fs/ext4/ext4.h, the !CONFIG_PRINTK definition of ext4_error() passes ""
instead of __func__ to __ext4_error(), so sbi->s_last_error_func is set to =
""
rather than "trigger_test_error".

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D18
