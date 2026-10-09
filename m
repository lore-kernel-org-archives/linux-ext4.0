Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEAE4A261C
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544890; cv=none; b=KkB2bdlypY+OYXd1usRgA3DDeE4ha59MaPnDt4hdFD8GEa7pex+WMQ6JODSMz/azG8WNG+GnFpXW0kRhpRfw0RMjhPt7HLJRjk7xKCIRK/xPelIGN0DPWjhrYLrGvDDkFNC5DlYyc0uVrDgUCa7kFJ8OjkXXym8lryFYbKdhVTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544890; c=relaxed/simple;
	bh=xH2Mav+OfPyr4WG5h3VMKSSRJgQW07d3HiEc5QBrOzU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oFKzkZEJr0wOCaaujPdhljVp62SYpp4ipKDn+GIRX6z+kZlFkEuRtnCx+nVnXd9hONypmrRL4cGK7iPa8UjMluTNu7A2HMw+RErRJyHgVoIpMDBNX6GLFx39Ujsu9SoredaRn5aRsWLYQcvDBWLrLpM9hbhqy46zYeb69Kcvls0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/mO/sqD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/mO/sqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C591F00893;
	Fri,  9 Oct 2026 11:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544880;
	bh=oNWYso0UypPinHpzGCS6RblWUN/apkFRqVWhMGbsY7E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a/mO/sqDhcSKc68SN+c7WH5doa9liATJWtt99ADkEVDgsCbA5jHyids5ymFlRLRw6
	 vUGlJvHabSO9GwAcZ7wVI9zsdwCulk966ATCmzl7qOsMz64OqUuT57TdXJvJU0K+1I
	 vgumZNpNND63B9VBENS8qEb5oOp0k5QMX3chfRaEhUchqEmvkj82/cZ1o/pVU1DQEg
	 aTa0bzNY2RyRvqgRSHBL9NMDkVysdgxHn1h3XSlwZtzRVqRx2dz5wHjJ82hqloPzQv
	 V8ZpdJYRZ5UyR4vsN93vcH97QxZBnqMMCUBBT8YxCD/fcTDBoYTIOT5r8GEIrlHOye
	 HKBfPtEThuP8g==
Message-ID: <sashiko-outbox-165360@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing
 unaligned EOF block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-28-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-28-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:21:19 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ext4: torn lockless read of i_disksize causes missing DISKSIZE_G=
ROW_PENDING
--

commit 4a76a3a815e11b477d4aaf7fd5a0eb69623ddb31
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: set DISKSIZE_GROW_PENDING after zeroing unaligned EOF block

This commit adds the ext4_iomap_mark_disksize_pending() function to set
EXT4_STATE_DISKSIZE_GROW_PENDING after zeroing an unaligned EOF block.
It ensures that the zeroed block is written before any subsequent data
updates i_disksize, preventing the exposure of stale data.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9b6916609000c..3bdb5f3b119ab 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4847,6 +4847,89 @@ static int ext4_block_zero_range(struct inode *ino=
de,

[ ... ]

> +	/*
> +	 * If the zeroed range does not overlap the existing on-disk tail
> +	 * block, the zeroed data lies beyond the currently on-disk data
> +	 * and will be written back before i_disksize is advanced past it,
> +	 * so no stale data can be exposed.
> +	 *
> +	 * Checking i_disksize here (after folio_wait_writeback()) is
> +	 * necessary and safe. If a delalloc writeback of this folio was
> +	 * in-flight, it could be raced by a concurrent mmap write which
> +	 * corrupts the tail block beyond i_size but the i_disksize is not
> +	 * advanced. folio_wait_writeback() has waited for its completion
> +	 * and the ioend has advanced i_disksize accordingly. If writeback
> +	 * had not started, we don't need to mark any pending state because
> +	 * any future writeback will carry the pagecache content that now
> +	 * includes the zeroed data, so no stale data can appear on disk
> +	 * even without the pending tracking.
> +	 */
> +	if (from >=3D round_up(READ_ONCE(EXT4_I(inode)->i_disksize),
> +			     i_blocksize(inode)))
> +		goto out;

[Severity: Medium]
Could this lockless read of a 64-bit integer suffer from a torn read on
32-bit architectures?

On a 32-bit system, READ_ONCE() on a 64-bit variable like i_disksize compil=
es
to two 32-bit loads. If a concurrent thread updates i_disksize via
WRITE_ONCE() (for example, during I/O completion while holding i_data_sem)
and the value crosses a 32-bit boundary, this read can tear.=20

For instance, if i_disksize changes from 0x00000000_FFFFFFFF to
0x00000001_00000000, the torn read could yield 0x00000000_00000000.

This would cause the condition to evaluate to true, skipping the pending
tracking and failing to set EXT4_STATE_DISKSIZE_GROW_PENDING.

If the system crashes, this could allow i_disksize to be advanced past the
unwritten zeroed block, exposing stale, uninitialized disk data to the
file tail and defeating the data-ordering mechanism.

While i_size is protected by i_size_seqcount on 32-bit platforms, i_disksize
does not seem to have seqcount protection here.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D27
