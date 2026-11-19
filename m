Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104431;
	b=nVrTBpng7DIPj6HsRPwaMb+f931N8uzSlvxLsmWqbNqnLCwxyVK0x7ZVbpAoqtkZ4ZAE
	 44MYEieq4EgNJg80nqyLZ+OywpUAULrNQccAuNKXECUdWY4WLpoEAaopE3nFDBoIBj2G8
	 8FsIJh86ZaBaCN9HQp7CyFueQJRvTIlLMc4P0Wht2OHR6Iv5nL1Y2oKuYOnN5GJ+PFHtz
	 r1bzMFs80b1UdXhHxrEGzr3jVxkjna7m28iYIfpDSmyJ1i45nmuq4W+fIx/wJ18m7Ef7Z
	 5S8y4jk6gbRca2yMeQRvd9qIuWvlK4gKZqdPX7m26mS3Nm793OuhhrRFMiMSlpmxx/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104431;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4Nwg/1sIGp5eUeqKpPSlCDVQeT3GZennHA6ebjqtrd4=;
	b=Z5XhtGsnun9SHFClUGYJfHSZqGy8IbHFZW6bkPll1+OweXidnpreQQ49JtVbWOn5XNwY
	 0W7lFyEQ7kHkiy7Ru+bFIfyztMo3cEwTTxlq+xecVOkXKtj4mRa7zJNl600adKUqDAkrs
	 3hYT9pBRhhx8nsEd4BwEQxUycImGrkcVfEevFZJpnc97ZNXTp4Yr4cExASThqtWn25oSj
	 O1XHBk/AZz1YJQrHn5PLVOl1XO1WADfiG7QSrnXBdOTGmufj2YvTZfDE0/mi5/xwtvTVY
	 NEr9U/dbDRoa+OcEyeuvZ37ymLAPailly5mzYkSalgjNxduaj7XR4jec1MLQYlv5e8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQC+DA+i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A1D606A324
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DQC+DA+i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530191F000C7;
	Thu, 19 Nov 2026 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104430;
	bh=4Nwg/1sIGp5eUeqKpPSlCDVQeT3GZennHA6ebjqtrd4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=DQC+DA+iRFa83LcddSffe/v/IONRwslPhS1v+lnwCIQa1r8neBtF4KS1xld4G0vkv
	 WQgf2d0Vdq83ZDgQ/NVWJn2uaU3YPUZeXWOQpJwzZ7s/Rai+653lz5/Eh99FAqEn14
	 /DRRiF9M3mnmrPQBdSd4fju1C6pGaXGFUAoEDRCDRv5KKPY6ilca+B65P3KCWxXpko
	 +kx4hBZHpnUmWUYq/9z58A1KTgQY8wblLIfpiDdxQb4NL28iqrme7y5wUZub/8zVnp
	 ocDc59YuB89lvDk2e5n63o2LiELwx3vqA4c9oE6N1j01qug11e3KYsadVWvxbzVW5m
	 P5Y/NxkOBLIJA==
Message-ID: <sashiko-outbox-223469@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 07/26] ext4: add KUnit tests for
 fs/ext4/fast_commit.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-8-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-8-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:07:09 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add the ext4_fast_commit_test KUnit test suite in
> fs/ext4/fast_commit-test.c to comprehensively exercise fast commit
> tracking, snapshotting, TLV serialization, commit execution, and journal
> replay in fs/ext4/fast_commit.c without requiring a mounted block
> device:
>=20
> - Fast commit initialization and eligibility helpers (ext4_fc_init,
>   ext4_fc_init_inode, ext4_fc_disabled, ext4_fc_eligible,
>   ext4_fc_set_snap_err, and ext4_fc_snap_stats_update_max).
> - Ineligibility tracking (ext4_fc_mark_ineligible) with active handles,
>   NULL handles with or without a running transaction, monotonic
>   s_fc_ineligible_tid updates, and per-reason statistics counters.
> - Inode and logical range tracking (ext4_fc_track_inode and
>   ext4_fc_track_range), covering directory skips, data-journalling and
>   inline-data ineligibility, special inodes (< EXT4_FIRST_INO), same-TID
> [ ... ]
> ext4_fc_get_buf, ext4_fc_submit_bh, ext4_fc_issue_flush,
> ext4_get_inode_loc_noio, ext4_get_fc_inode_loc, ext4_mark_inode_used,
> ext4_mb_mark_bb, and ext4_es_lookup_extent.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D7

