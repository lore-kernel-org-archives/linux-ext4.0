Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794458761;
	b=5PXVRTZ+Cs9sWG7kQ22Jmb4tLfPXb/BapW/lI3EtmCXQQGu268HruVKxwWuXl+HZ1/cg
	 Ozqzl/9ob5Q/fMWEJGfpYpRvAcm5IJhPmdn6vb1nkBdDMkTquPauiXo7/wkVSFwdPkOpq
	 Hp5fHVhXHu9HZu+EYkJg1odgbMnO8AngjM4CF5lbwL+eL1EQ9xZbMPUSk93D8n4SVnjVd
	 SVEopjBIebHQYBgueCn724vKBf0/njlXUVI2axdIWtC8KsS8Km+La3j7Y8hU5MQpWLwUS
	 RHWBgoVufC5B09q7peY+nwjVS8xtDGKYQGHn1PjE8tyhxUkgRIc9+wAAAnPNCM2QtnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794458761;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=k+P/WfjUMhGRObjnaicvKOikEGDduWe9NJ2yb9xHwTo=;
	b=BIS54wrfkJJfqYCyT8FZ9M5rSc6le/+vMGusOIGiaZtC+eyw/DYC5gNfeKglw4CRgNwl
	 VU6RuNuRQS0P/zNdrMT6jbA365oHkmwORUR67ZyaQwqCAj8oHj97IZeML+uTn/OJ78UoG
	 K5/2L/9C3+mqpnx+dt+ppfYoxTUUIdDjlmuSNCtLJJFPhhV7Tq2+OGJgW0pg/gnEpZYdO
	 7J+/qmTCsKNmqMli6k5+d9KcDOtknztHC0/LcRBnzhSsZpWtxsgwfWpWNl9skof2GNnd6
	 9Ria2Px6IMYNX4GLH/btx50M5F7EwaqbCvFE83+i/Ti6GhQCmcUC0x6dn9oIUb9QUHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mv0xLbuw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8B7606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mv0xLbuw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D661F00A05;
	Thu, 12 Nov 2026 04:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794458761;
	bh=k+P/WfjUMhGRObjnaicvKOikEGDduWe9NJ2yb9xHwTo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=mv0xLbuw5IdU629FuCsQ8MjFJVqC2MLd3PKIXHXseMoC140EMvRinj8e1A4BdU9tu
	 0B5vbugwjXwdmWxRoE0PR4cadvWhtrlriGDpK+ED33yGZ3oXcIJDJYZw6g13kxg55j
	 ZB9+2cxQgUOmC+xwDKGtpg24/P6xv7+vjet6xkusCf5jTcC7S4IugnwLnr79yZY9G8
	 VY/1XLIaDeQ0ItxPtzxxUqVCxSzPWl+iBbg0Gk19lDQTBIwAPzGhphFw1bGicpelki
	 yERT5uqS8TiiuhE2iPLjg27omuAjLCsdp65Et1KDVAHYMe6474HQFGmSERYf5hG5Ts
	 sGi9bXz0IgrVw==
Message-ID: <sashiko-outbox-210391@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 22/27] ext4: add KUnit tests for fs/ext4/indirect.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-23-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-23-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:46:00 +0000
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
- [Medium] ext4: indirect-test: UAF in ind_test_free_inode() after RCU
  grace period
- [Low] ext4: uncleaned percpu_counter and uninited work/timer in
  ind_test_init()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] ext4: incomplete error check in ext4_ind_map_blocks() [1]
--

commit ebeb5ffec6cf1b1539b939ab7329a1923d9ae24c
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/indirect.c

This commit adds the ext4_indirect_test KUnit test suite for indirect block
mapping, truncation, and hole punching, and routes indirect block buffer
lookups through ext4_sb_getblk().

> diff --git a/fs/ext4/indirect-test.c b/fs/ext4/indirect-test.c
> new file mode 100644
> index 0000000000000..add5662adc3ba
> --- /dev/null
> +++ b/fs/ext4/indirect-test.c

[ ... ]

> +static void ind_test_free_inode(struct inode *inode)
> +{
> +	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> +	kfree(EXT4_I(inode));
> +}
> +
> +static void ind_test_evict_inode(struct inode *inode)
> +{
> +	truncate_inode_pages_final(&inode->i_data);
> +	clear_inode(inode);
> +}

[Severity: Medium]
Can ind_test_free_inode() trigger a use-after-free on ctx->sbi after the
test finishes?

At the end of each test, iput() runs ind_test_evict_inode() synchronously
and queues i_callback() -> ind_test_free_inode() via call_rcu().  KUnit
then runs ind_test_cleanup() without an rcu_barrier() and frees ctx, so
when the RCU callback later runs ext4_es_remove_extent(), it dereferences
EXT4_SB(inode->i_sb) inside the freed ctx.

Moving ext4_es_remove_extent() into ind_test_evict_inode() and calling
rcu_barrier() in ind_test_cleanup() before deactivating sb would avoid
this.

[ ... ]

> +static void ind_test_cleanup(struct ind_test_ctx *ctx)
> +{
> +	struct super_block *sb =3D ctx->sb;
> +	struct ext4_sb_info *sbi =3D &ctx->sbi;
> +	struct ind_mock_blk *blk, *tmp;
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

[ ... ]

> +	ctx->sb =3D sb;
> +	up_write(&sb->s_umount);
> +
> +	ret =3D kunit_add_action_or_reset(test, ind_test_cleanup_action, ctx);
> +	KUNIT_ASSERT_EQ(test, ret, 0);

[ ... ]

> +	INIT_WORK(&sbi->s_sb_upd_work, ind_test_sb_upd_work);
> +	timer_setup(&sbi->s_err_report, ind_test_err_timer, 0);

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
If the second or third percpu_counter_init() fails, does KUNIT_ASSERT_EQ()
abort while ctx->counters_inited is still false?  ind_test_cleanup() then
skips percpu_counter_destroy(), leaking the earlier counter and leaving it
linked in the global percpu_counters list when ctx is freed.

Also, ctx->sb is set before kunit_add_action_or_reset(), whereas
s_sb_upd_work and s_err_report are initialized later, so if
kunit_add_action_or_reset() fails, ind_test_cleanup() calls
cancel_work_sync() and timer_delete_sync() on uninitialized structures.

[ ... ]

> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 5aec759eed705..5b2b2be73a90a 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -163,7 +163,7 @@ static Indirect *ext4_get_branch(struct inode *inode,=
 int depth,
>  			ret =3D -EFSCORRUPTED;
>  			goto failure;
>  		}
> -		bh =3D sb_getblk(sb, key);
> +		bh =3D ext4_sb_getblk(sb, key);
>  		if (unlikely(!bh)) {
>  			ret =3D -ENOMEM;
>  			goto failure;

[Severity: Critical]
This problem wasn't introduced by this patch, but when ext4_get_branch()
fails with -EFSCORRUPTED or -ENOMEM [1], doesn't
ext4_ind_map_blocks() miss the error when EXT4_GET_BLOCKS_CREATE is set?

fs/ext4/indirect.c:ext4_ind_map_blocks() {
	...
	/* Failed read of indirect block */
	if (err =3D=3D -EIO)
		goto cleanup;
	...
}

Because ext4_ind_map_blocks() only checks for err =3D=3D -EIO, it treats the
partial chain returned on -ENOMEM or -EFSCORRUPTED as a hole, allocates new
blocks, and splices them over the existing indirect block pointer,
orphaning the original subtree and corrupting the file.

[1] https://sashiko.dev/#/bug/linux-2bfbc9ba-6121-45d3-a664-11e7452ad5d6

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D22
