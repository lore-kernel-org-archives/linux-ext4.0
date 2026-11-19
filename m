Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104908;
	b=3zoWkuJOvqwY7LM9ZQ0qW2U9wsSECCo9NOvqmWTBcQrznvn8BZnE59Pd+VL7WVAZVGbx
	 Cgeh2sU/U68CFOxVDbAgbwjP1vahvcETrFFFEXBVyWMALtDkMCTfD7Aqo228LjdwSsg5c
	 UHlfNQ4mYUQXcVt4klCRQz3w6ILblFPSqE496s++4DqF4296cbGixhAAQjblEanLsiBcD
	 KKXr6m7AfQOqWIT/naLzOrc8BQ56dz8IGyE9FRCIG+xRccAw+hyu+veC8vSA57c0PehBD
	 M3quiw/+0O7ZtalhOYrqDGVRagsPZEzE45QoDbPhtqwEqvzwD3Ji76A5gbq/4hqoYqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104908;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=mOyG7ETSNqbuyd/29s0IWAZ9kqpTMPfMQInWXEPB2IE=;
	b=QME4d+jFzBDfNMB5oxTsZj80F/02LmbEWrH/hkbaUfn9AVTHZzGWFDhy1S2m/qIGwc3A
	 hLQKt6zXQhXFt3oO/Xb73NdQizYn0MxWGKz/KboKDHx1lYYFM9E7/Fj5VnLNFfzKq3CXy
	 99kIgKz/wVdrhCoj+a5KZi713ZHMZMIjrCA7YZfoV+bHdziWBWnCYR0xTVe28G0MNG9Qo
	 Xy4r3GNGLgZ4yISvMr1qNY1HFGlZM0lAQw68w+C+HiMg1px+kswjsIl/mzGaXfQ7hXWSs
	 V72CGM3ErzJVJ6iAQSl6/VLezHa+JPBn/eHUHwraOH2UssvI890QbQlY997+4rrtI7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lp/veWik";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B11606A32C
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lp/veWik
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BF91F000C7;
	Thu, 19 Nov 2026 16:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104908;
	bh=mOyG7ETSNqbuyd/29s0IWAZ9kqpTMPfMQInWXEPB2IE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=lp/veWikye/+e5zaQcyOR53jVVay6y0kMWb/SZ1so0UfCe4QUBaLBT9kO1PsYoZaM
	 O94ZQWfQ4dLcYWcIGRwGzmbssDOIQSuGH6p6vHWiBC21fIFRLCuKGxisfSjD+5L5eO
	 NPac8gf9dYaOkCYgPrOsBLC7n2JHl7+sGr5AE7b1kPSswRf26LCOXctxJX2672xu2N
	 WwmA3CWLjz+nKvDdtUo6oie3cfKgygc+mIxwKzu3LEBmVhrLls7gaqfqdeVNMKQWrs
	 d8Qbx7hLGjyMic8WeCiO3cxwkixxkjTjNJlWn5/PwWkEQpEgadv30Sa1syaunUwraR
	 C//rfYEA6VaYQ==
Message-ID: <sashiko-outbox-223500@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 26/26] ext4: add KUnit regression tests for inode
 migration fixes
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-27-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-27-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:15:07 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add KUnit regression tests in fs/ext4/migrate-test.c covering the
> ext4_ext_migrate() bug fixes in the tree:
>=20
> - test_ext_migrate_caps_long_run_at_init_max_len(): verify that a
>   contiguous run longer than EXT_INIT_MAX_LEN is split into multiple
>   initialized extents, covering commit b0a3f2c102e8 ("ext4: cap
>   migration extent length at EXT_INIT_MAX_LEN").
> - test_ext_migrate_survives_handle_restart(): verify that a handle
>   restart during extent insertion does not abort migration, covering
>   commit 3b6aee59883c ("ext4: clear journal restart indication after
>   inserting extent").
> - test_ext_migrate_reports_concurrent_allocation() and an -EIO check in
>   test_ext_migrate_error_rollback_frees_tmp_extent_blocks(): verify that
>   migration errors are returned to the caller instead of being
>   overwritten, covering commit 82e2a5743b6a ("ext4: don't clobber the
> [ ... ]
> __ext4_journal_ensure_credits() in fs/ext4/ext4_jbd2.c so the KUnit
> tests can emulate transaction restarts, concurrent block allocations,
> and post-swap credit failures without a journal.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D26

