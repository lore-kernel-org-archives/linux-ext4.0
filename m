Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F152BE630
	for <linux-ext4@vger.kernel.org>; Wed,  7 Oct 2026 00:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334147; cv=none; b=YvIR0Hxsz3TUnzhMXBYiri0TpdpMOrIIT805q4jrl1GXazpzFB3TYzaJAH8Ek99GNwP+BKvZnKP2+eoPcKVYsx6Wb45Zvs5CmwjAAEGcrMynPx0GzvZN2VUclwNHSYwOhA4jFEB/D70Dh8qqaIIzCLgqOoWSm94dN/kq+InyzGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334147; c=relaxed/simple;
	bh=iRWvPV2UkCuwnrrFAP7VAiuRmQ6i+WN8d6kBmiD09ZU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=c1BcS6iHuw3vomTa7VXMGwpRdUVFmKjIchSdH9YhxLcUT7KX8njIljd7Mvrvg6e/OrfaqH33ONwjsn3ONsSCmXcuV5mKM0xll6ZRDcZIeIpk8qtoNhfH03zzISnh2Ub4IU+mphm0H4nZB6rYE8R31EJou0Vwv4j4iuYU4A3TtGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g9q9qyzg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g9q9qyzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006401F0089C;
	Wed,  7 Oct 2026 00:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791334146;
	bh=iRWvPV2UkCuwnrrFAP7VAiuRmQ6i+WN8d6kBmiD09ZU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g9q9qyzgNFK/1aptGlEmlGRUnfJ4l/sh6NO8VcFQvIRAcB6lq71RDGi4qSvsw4EyD
	 Mpf0bd7UiveSd2Go1JVzBLpNliBwGefHZI1Uynap5a52mdRbTnggJwcaFhc1CIYFZ0
	 uu97yizNkypIOFi8HpWmgQKkVa78zbMfHaoo8vd1mQNL++hfD2d+9AztbcgHiS0SXh
	 RUt98XrwIeRdFwHQxszHPyhfg1SrGwkBcQLZTDl2wf58BROahwttMb+p/Xt4J8O6Oe
	 PMWn88uESYSJglOq7KJkfj9WhvIURUjO0RR8RJzorFlSRk+dfyZJzW6DJbE2N4D0HG
	 xhClSQKnznyXg==
Message-ID: <sashiko-outbox-162552@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: skip holes when shrinking the extent tree in fast
 commit replay
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261007-ext4-fc-replay-shrink-v1-1-0e45fc03030d@samsung.com>
References: <20261007-ext4-fc-replay-shrink-v1-1-0e45fc03030d@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 00:49:05 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Daejun Park <daejun7.park@samsung.com>
>=20
> ext4_ext_replay_shrink_inode() walks the extents of an inode from block
> 0 up to the given end and tries to merge each one with its neighbours.
> When the walk is in a hole that follows an extent, ext4_find_extent()
> returns that extent, and the walk moves on by a single block. Replay
> calls it up to i_size after every ADD_RANGE and DEL_RANGE tag, so the
> time recovery takes is proportional to the number of tags times the
> number of hole blocks below i_size.
>=20
> After a crash, mount can be busy for minutes. Replaying a single
> ADD_RANGE tag, for one block written and fsynced in a sparse file with
> a 1 TiB i_size, kept mount busy for 157 seconds. Replaying four fast
> commits of a sparse file with 512 written regions (2048 ADD_RANGE tags,
> and 2044 DEL_RANGE tags for the gaps between them) took 44 seconds when
> the file was 64 MiB and 177 seconds when it was 256 MiB. With this
> change the 1 TiB case takes less than 0.1 seconds, and the other two 3
> seconds each.
>=20
> When the walk is in such a hole, continue at the next extent, as
> returned by ext4_ext_next_allocated_block(), or stop if there is none.
> For each block skipped this way, the old walk found the same extent
> again and retried the same merges, so the resulting tree is the same.
>=20
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-ext4-fc-re=
play-shrink-v1-1-0e45fc03030d@samsung.com?part=3D1

