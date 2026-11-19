Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104400;
	b=wPYoJwap3j9RZHiNfNiCyPUXlRL2HbuqQaMQest6nyYNaG0sB8ohCft9fvuo6gEZRQT1
	 TfbeZ8rGdMwEzCsnvtLaDwvtfu7JiyQpBy42r5FX3pnJlrvH3xgNWxxYsZ5B1YagBHNd/
	 2WQTnZE1WJJwqIP6yuULFZimNV6scWyjJ1Nn5aowbkdZwbmAtlJK+loNaI2HayM0mDfDA
	 2bnsNNPFX3TSLn+2y9w19LYXjTguaQxmVn1knyWMSwczk33ljr4ymUWVw7n/76x5W5IPn
	 vfk82xUxdN3Bs1cZFqQCSX/NxLaBQMC0WQXVE1F1b/yDQwsPUavA0eKRXFgaJmYFqSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104400;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gxtJc3rCv5K7+uD69IWOfBaIEAqw2uoOBW2bBVedUAY=;
	b=GwOF6LE0J++vESb9wGAUapvJO0YWNBpidql3RoNzJwTI8c7m1Cfoq5Rhorhvf7ii5Z5p
	 TdcMzh6HvEwjC2t1CaQYWILXj0n6x+y/WLShCeCLteACoLWygdbjO5uvYqEmeIWFLjZYt
	 nTTISqR2XQq1BTVZfxpSi3jUlBdpkGiKwAoMxmcVDB/Jk7ZGvr6tyx4MflelZgXnqsC/Z
	 46L0kI1VPZg8Xhr97qfyUcI5LNnDgO/SibQZItd9WETmA67iQvTD9WdvXqK0Q2JMPw51B
	 sWxvA011Wy4+f+uMhsBkPkodBQYqargc+Olw16ek29IEkCB6CbwgXSDJwmbal9NXe3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NfZN4dE8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DCEB606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NfZN4dE8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30641F000C9;
	Thu, 19 Nov 2026 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104399;
	bh=gxtJc3rCv5K7+uD69IWOfBaIEAqw2uoOBW2bBVedUAY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=NfZN4dE8/eBuVN6Yfe0QtkMis4qSrFUKh3Fc3xHUvoa2SrOget8qCe/PCUxm68Pji
	 Y4uV8vg0SmTjDvQf+A7Mt8x2onuM4iklEnixXdGONIuKzihUHJAQ6rWyxeHqkotyD7
	 JkCbMN5fIA6ADJrQwKWjCKbcUWMzDPbS9f7sr55WbR2eJjLSGlmedYyHe5P6V45NZe
	 s17B4JIbK/O44X4nxrm7xYmE6zOBKpN8VJvIsIxEU00575S+CBW/Wg0QSDi48GB+mh
	 HFGpF5HRrzdpezbOXkl973hnfCTb5iCzlPnuu5/cdaLOFFLqC4b0VSuGmRowHO+kxI
	 A7nGZ6DzDLiCw==
Message-ID: <sashiko-outbox-223468@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 10/26] ext4: add KUnit tests for fs/ext4/balloc.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-11-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-11-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:06:39 +0000
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
- [Low] ext4: kunit: leak of ctx in balloc_test_init() if
  kunit_kzalloc() fails
--

commit 12a7df5573859469528c2402fafb82063d22f755
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/balloc.c

This commit adds a KUnit test suite in fs/ext4/balloc-test.c to exercise
block bitmap management, group descriptor and overhead calculations,
cluster pool reservation, and metadata block allocation helpers in
fs/ext4/balloc.c.

> diff --git a/fs/ext4/balloc-test.c b/fs/ext4/balloc-test.c
> new file mode 100644
> index 0000000000000..b15d50907324f
> --- /dev/null
> +++ b/fs/ext4/balloc-test.c
> @@ -0,0 +1,2400 @@

[ ... ]

> +static int balloc_test_init(struct kunit *test)
> +{
> +	struct balloc_test_ctx *ctx;
> +	struct fs_context *fc;
> +	struct super_block *sb;
> +	struct ext4_sb_info *sbi;
> +	struct inode *root_inode;
> +	ext4_group_t g;
> +	s64 total_free_clusters =3D 0;
> +	s64 total_free_inodes =3D 0;
> +	int err;
> +
> +	ctx =3D kzalloc_obj(*ctx);
> +	KUNIT_ASSERT_NOT_NULL(test, ctx);
> +	test->priv =3D ctx;
> +
> +	for (g =3D 0; g < BALLOC_TEST_MAX_GROUPS; g++) {
> +		ctx->grp_infos[g] =3D kunit_kzalloc(test,
> +						  sizeof(*ctx->grp_infos[g]),
> +						  GFP_KERNEL);
> +		KUNIT_ASSERT_NOT_NULL(test, ctx->grp_infos[g]);
> +	}
> +
> +	INIT_WORK(&ctx->sbi.s_discard_work, balloc_test_discard_work_fn);
> +	rwlock_init(&ctx->journal.j_state_lock);\n+\n+\terr =3D kunit_add_actio=
n_or_reset(test, balloc_test_cleanup_action, ctx);

[Severity: Low]
Does this leak ctx if kunit_kzalloc() fails?  KUNIT_ASSERT_NOT_NULL()
aborts the test before kunit_add_action_or_reset() registers
balloc_test_cleanup_action to free ctx.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D10
