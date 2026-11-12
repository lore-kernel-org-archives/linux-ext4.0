Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457825;
	b=NSEl9O2ZFQ9yF5DvPm19fH5iSHjCCuTfrPZQBMNh4r88CENyBzR4EKACDLEgwljzuY07
	 V1bxZawyU2d1N/2CxFshOYyBSok/3FTfHofDlUdQzRHL3Kq+4cO72IVjv/Ks5GNWEuLcn
	 15kihOCYxfWSxhj2X11jfoLY4fIujDBTv54W3w7ocR1nzJPtPdXOYKoI/1TAQvGmMfmOe
	 jwC1I2dksf5RbNaLSp/eSpQLL1cKVk22ofI33VlDdefeBpSJv3CkTsTfnq+Fec0o+yQqJ
	 3raHwrNUsfFYqzRXxlHNga5xtS2iKQmqvfjOXULtpMDTsApYRleuN/sE9xFP0nXjaFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457825;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JnVP/4XkIY8aJnFul3t7rajCq3JYQK8tKWNUInSPQvc=;
	b=PWmDSkpenZY9Pyp5EC32P9dcc1IveZc0P0O73/33bUEYrDdWZ0NuVpqK9nmNihk5sXJN
	 K/TYlXdNVly+DmP2lLU6BWB8GXSBTteQ4x5DwDLtWNeS/3bS0R3HU9wCXY+IAh5cItmPE
	 iekkap2HA0IerWxqN3B5YXUR0L7KHUGAWfwc6qJVFyQL4KVl4bQ1U46lX7/XDkyIQ8yTb
	 RsSiFDFJn/q69eU4lkchV4AA6JAYAJ4BMiOSItvR9+b+oGZJIDi4dQ8JShTmsmUNJgo5t
	 lwNg0U4oNF+12kTakcYJLnuSTRvNzRotc2YPYnd3qj87NHP5okz8WTTk1d+S2c8HYcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jk99ERMf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5255606A327
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jk99ERMf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439EE1F00A08;
	Thu, 12 Nov 2026 04:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457825;
	bh=JnVP/4XkIY8aJnFul3t7rajCq3JYQK8tKWNUInSPQvc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Jk99ERMfLwu345JfMp4y/iCxc6/9gTtP2lt308INxjnhw/0IETnvhdf9wtuoZYGt+
	 GFwjR6ychCJYRPDzbNRICAwp5otxYKaZlRbbIisqMO7OJLa0BWOkVRQS2TbjEG7btH
	 7de2cpiMmuqck3RKIITp9KKV6jhsv6cIbyLR1/h298DzdfTLuyxE0yE3IDC3CJ3+1v
	 U4JETMHmqPDfkz/5uF+s1rrjQ7SMLcIAI6cem0kRT2fYlwc6u2wP33IpFmmY7notKY
	 5ZS1OGbC9cQrhPGU9860FXT5C90S7KRgkOahUHlNvyChOQzE51XzWmv/sfREkpmnce
	 sGiug5+UD1owQ==
Message-ID: <sashiko-outbox-210342@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 24/27] ext4: add KUnit tests for fs/ext4/fsmap.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-25-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-25-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:30:24 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] ext4: per-CPU disk_stats leak on assert abort in
  fsmap_create_ctx()
- [Low] ext4: unused fail_err field in fsmap_rec_sink and
  fsmap_collect_cb()
--

commit 26245fe40968f50951fa0187b785c405d62e3f12
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/fsmap.c

This commit adds a KUnit test suite covering FS_IOC_GETFSMAP reverse-mapping
queries in fs/ext4/fsmap.c.

> diff --git a/fs/ext4/fsmap-test.c b/fs/ext4/fsmap-test.c
> new file mode 100644
> index 0000000000000..63a1061b413a7
> --- /dev/null
> +++ b/fs/ext4/fsmap-test.c
> @@ -0,0 +1,787 @@

[ ... ]

> +struct fsmap_rec_sink {
> +	struct ext4_fsmap recs[FSMAP_TEST_MAX_RECS];
> +	unsigned int count;
> +	unsigned int abort_after;
> +	int fail_err;
> +};

[ ... ]

> +static int fsmap_collect_cb(struct ext4_fsmap *fmr, void *priv)
> +{
> +	struct fsmap_rec_sink *sink =3D priv;
> +
> +	if (sink->fail_err)
> +		return sink->fail_err;

[Severity: Low]
Nothing in this file sets sink->fail_err, leaving the field and this check
in fsmap_collect_cb() unused.

[ ... ]

> +static struct fsmap_test_ctx *fsmap_create_ctx(struct kunit *test,
> +					       unsigned int blocksize_bits,
> +					       unsigned int cluster_bits,
> +					       ext4_group_t groups_count,
> +					       ext4_grpblk_t blocks_per_group)
> +{
> +	struct fsmap_test_ctx *ctx;
> +	struct fs_context *fc;
> +	struct super_block *sb;
> +	struct ext4_sb_info *sbi;
> +	unsigned int blocksize =3D 1U << blocksize_bits;
> +	ext4_fsblk_t bofs =3D (blocksize =3D=3D 1024) ? 1 : 0;
> +	int err;
> +
> +	ctx =3D kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
> +	KUNIT_ASSERT_NOT_NULL(test, ctx);
> +
> +	inode_init_once(&ctx->data_bdev.vfs_inode);
> +	address_space_init_once(&ctx->data_bdev.vfs_inode.i_data);
> +	ctx->data_bdev.vfs_inode.i_data.host =3D &ctx->data_bdev.vfs_inode;
> +	ctx->data_bdev.bdev.bd_dev =3D FSMAP_TEST_DATADEV;
> +	ctx->data_bdev.bdev.bd_mapping =3D &ctx->data_bdev.vfs_inode.i_data;
> +	ctx->data_bdev.bdev.bd_stats =3D alloc_percpu(struct disk_stats);
> +	KUNIT_ASSERT_NOT_NULL(test, ctx->data_bdev.bdev.bd_stats);
> +
> +	inode_init_once(&ctx->log_bdev.vfs_inode);
> +	address_space_init_once(&ctx->log_bdev.vfs_inode.i_data);
> +	ctx->log_bdev.vfs_inode.i_data.host =3D &ctx->log_bdev.vfs_inode;
> +	ctx->log_bdev.bdev.bd_dev =3D FSMAP_TEST_LOGDEV;
> +	ctx->log_bdev.bdev.bd_mapping =3D &ctx->log_bdev.vfs_inode.i_data;
> +	ctx->log_bdev.bdev.bd_stats =3D alloc_percpu(struct disk_stats);
> +	KUNIT_ASSERT_NOT_NULL(test, ctx->log_bdev.bdev.bd_stats);
> +	ctx->log_bdev_file.f_mapping =3D &ctx->log_bdev.vfs_inode.i_data;
> +
> +	sbi =3D &ctx->sbi;
> +	INIT_WORK(&sbi->s_sb_upd_work, fsmap_noop_work);
> +	timer_setup(&sbi->s_err_report, fsmap_noop_timer, 0);
> +	spin_lock_init(&sbi->s_error_lock);
> +	spin_lock_init(&sbi->s_bdev_wb_lock);
> +	ratelimit_state_init(&sbi->s_err_ratelimit_state,
> +			     DEFAULT_RATELIMIT_INTERVAL,
> +			     DEFAULT_RATELIMIT_BURST);
> +
> +	fc =3D fs_context_for_mount(&fsmap_test_fs_type, 0);
> +	KUNIT_ASSERT_FALSE(test, IS_ERR(fc));
> +	sb =3D sget_fc(fc, NULL, fsmap_test_set_super);
> +	put_fs_context(fc);
> +	KUNIT_ASSERT_FALSE(test, IS_ERR(sb));
> +	up_write(&sb->s_umount);
> +
> +	ctx->sb =3D sb;
> +	err =3D kunit_add_action_or_reset(test, fsmap_cleanup_ctx, ctx);
> +	KUNIT_ASSERT_EQ(test, err, 0);

[Severity: Low]
Does this leak the per-CPU bd_stats allocations if one of the assertions
before kunit_add_action_or_reset() aborts the test?  Registering
fsmap_cleanup_ctx() before calling alloc_percpu() would ensure they are
freed on early assertion failure.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D24
