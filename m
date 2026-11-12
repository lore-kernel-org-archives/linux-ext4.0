Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457559;
	b=MrSIqw1uaLH31h2TIUXjXe4BolNNc06ZKVKrgn+Knk5TdSSsATZxTlzNC6lfoRUgqpnJ
	 33R1TB6d/JWvrE4LEvWyhmUskyuYGBMOTMKnMm/gKitsTrkANRP0fVg/TE1Ab9H90QxPT
	 lGeTWC6a5xWZ/cd0qgS1381WhplBwo5zVK7YAwlvofpYTor97A0+1XJqQjeO/iNbmJDfa
	 lKtpAwNH7+g6wxI6bUN96l+4WS2gsbF5xUyYu/1ht5RMeWAVO6BXtNAMX8h8xzzCfrzAw
	 jaFO1jH7QzyNBJz46m2lNWbn/Op8uVFIYrQjE9u9mftT5znsJzejzQFmkaDTPWra4+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457559;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HD4PClTYgoXG6nZfpwKHjlRgk3coQ8AjjjMkx57zYwo=;
	b=IaOuZhRKNYx4KFqW9gMsUJTT9MA8ToLHPsd74bexUrkRaUw7H1cnpBy4EsZwEE1Vd5ww
	 3E1WNEyrxqnAlHZ91LpFuUq8+XCW9il8t84rSwfIBlEGeKkzrlzTk0Txj5XWjuUcNtYYs
	 4mI0noO4psVYzYNajNJWshzTtiBsYxS7eamP5BItKb4cLtNgH8Mioftkrb4JX3ftahjAN
	 xe99EqhhX6T6lep8MV5EyhL1/1JZj+WHrxl4CTGVG9CRQqQKfJF1jfl56kcledL+9d7s0
	 I8m6PMOL8Xu6Hzzajh5064NTdXFeDn79QgFP5OGAZ9JUVfQ0H0I0JnQNo/2lat1sNDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iiLSy5az;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC17E606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iiLSy5az
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C4D1F00A05;
	Thu, 12 Nov 2026 04:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457559;
	bh=HD4PClTYgoXG6nZfpwKHjlRgk3coQ8AjjjMkx57zYwo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=iiLSy5azFFthahQIlUgYJ9b8egN4HRxYDpx1TUseHCfOLG5wadnvwoPLdoJ+ICYUv
	 K5sWv/ZDWxYpX0GCw6yC/vGGCpXbAZYxub/R+Azo7erKQdHfqr3gA/2FVtmHvugWod
	 NuS3wPdTMeE4K8UgUZiCZC/4053a/6+RCxBQPEjcP0OY2DTECoKg5YlnbEVhqNJMqU
	 R8obxl797wLDez8ECeNM0+QCN6jA2EbbYWVx7ELM18vJQqhZ0MOr41hIEnTqwR3WPk
	 ZFrwr8wVKHhvTTrdF0RIYUU2z+SIYIIOdTZ+DjAJ06lOK5XWlCMrZsI9N8yiLLXHG+
	 r+f7ENN0hLR8w==
Message-ID: <sashiko-outbox-210333@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/27] ext4: add KUnit tests for fs/ext4/ialloc.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-12-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-12-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:25:58 +0000
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
- [Medium] ext4: UAF on super_block in ialloc_test_cleanup() from
  undrained fserror work
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] ext4: missing error handling for blkdev_issue_flush() in
  ext4_fc_commit() [1]
--

commit 52f553b981802c3fefc912614c6427cda362ae6f
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/ialloc.c

This commit adds a KUnit test suite for fs/ext4/ialloc.c along with static
stub hooks and helper exports to test inode allocation, freeing, bitmap
validation, and lazy inode table initialization.

> diff --git a/fs/ext4/ialloc-test.c b/fs/ext4/ialloc-test.c
> new file mode 100644
> index 0000000000000..a3066b788ce6a
> --- /dev/null
> +++ b/fs/ext4/ialloc-test.c

[ ... ]

> +static void ialloc_test_cleanup(void *data)
> +{
> +	struct ialloc_test_ctx *ctx =3D data;
> +	handle_t *handle;
> +	unsigned int i;
> +
> +	ctx->evict_skip_free =3D true;
> +	ctx->sbi.s_journal =3D NULL;
> +
> +	while ((handle =3D ext4_journal_current_handle()) !=3D NULL)
> +		ext4_journal_stop(handle);
> +
> +	for (i =3D 0; i < ctx->nr_tracked_inodes; i++) {
> +		struct inode *ti =3D ctx->tracked_inodes[i];
> +
> +		if (ti) {
> +			if (inode_state_read_once(ti) & I_NEW)
> +				unlock_new_inode(ti);
> +			spin_lock(&ti->i_lock);
> +			inode_state_clear(ti, I_DIRTY_TIME);
> +			spin_unlock(&ti->i_lock);
> +			set_nlink(ti, 1);
> +			iput(ti);
> +			ctx->tracked_inodes[i] =3D NULL;
> +		}
> +	}
> +	ctx->nr_tracked_inodes =3D 0;
> +
> +	ctx->sb->s_root =3D NULL;
> +	if (ctx->root_inode) {
> +		set_nlink(ctx->root_inode, 2);
> +		iput(ctx->root_inode);
> +		ctx->root_inode =3D NULL;
> +	}
> +
> +	deactivate_super(ctx->sb);

[Severity: Medium]
Can clearing ctx->sb->s_root before deactivate_super(ctx->sb) cause a
use-after-free on ctx->sb in fserror_worker()?

ialloc_test_init() sets SB_ACTIVE on ctx->sb, so tests that trigger
ext4_error() or ext4_std_error() queue fserror_worker() items referencing
ctx->sb via fserror_report_metadata().  In generic_shutdown_super(),
fserror_unmount(sb) is only called inside the if (sb->s_root) block, so
nulling s_root beforehand skips draining those pending work items before
ctx->sb is freed:

CPU0                              kworker
ialloc_test_validate_ibitmap_csum()
  ext4_error()
    fserror_report_metadata()
      queue_work(..., &event->work)
ialloc_test_cleanup()
  ctx->sb->s_root =3D NULL
  deactivate_super(ctx->sb)
    generic_shutdown_super()
      /* skips fserror_unmount() */
    put_super()
      ...
        kfree(sb)
                                  fserror_worker()
                                    sb =3D event->sb
                                    if (sb->s_flags & SB_ACTIVE)
                                      <-- use-after-free

Omitting SB_ACTIVE in ialloc_test_init() would avoid queueing fserror
events in the first place.

> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 02546b828836c..66215b6359320 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c

[ ... ]

> @@ -1521,6 +1527,23 @@ unsigned long ext4_count_dirs(struct super_block *=
 sb)
>  	}
>  	return count;
>  }
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_count_dirs);
> +
> +int ext4_itable_zeroout(struct super_block *sb, ext4_fsblk_t blk, int nu=
m,
> +			int barrier)
> +{
> +	int ret;
> +
> +	KUNIT_STATIC_STUB_REDIRECT(ext4_itable_zeroout, sb, blk, num, barrier);
> +
> +	ret =3D sb_issue_zeroout(sb, blk, num, GFP_NOFS);
> +	if (ret < 0)
> +		return ret;
> +	if (barrier)
> +		blkdev_issue_flush(sb->s_bdev);
> +	return ret;
> +}
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_itable_zeroout);

[Severity: Critical]
This problem wasn't introduced by this patch, but should
ext4_itable_zeroout() check and return the error from
blkdev_issue_flush() [1]?

When barrier is set and blkdev_issue_flush() fails, ext4_itable_zeroout()
still returns 0, so ext4_init_inode_table() proceeds to set
EXT4_BG_INODE_ZEROED in the group descriptor even though the zeroed inode
table blocks may not have been flushed to stable storage before a crash.
(The same unchecked blkdev_issue_flush() pattern also exists in
ext4_fc_perform_commit() and ext4_fc_replay_inode() in
fs/ext4/fast_commit.c.)

[1] https://sashiko.dev/#/bug/linux-d85ff7fd-2937-4bb0-8016-be8fb0499fbd

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D11
