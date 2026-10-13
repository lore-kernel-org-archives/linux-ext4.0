Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7023DA7E0
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 06:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791873577; cv=none; b=j7iG1+FwGILLV6XAh4xfJ68fjoA3CG4U1+2c8zkRj/kB8jjSC/KIYWkwKZiC6dBTdabCK9saXyxBXjt/ATczqLXtrCJo1CQjy6nXaT0hYEX9iB8LU/RcCeN8XRaJ9ZJjiFATq38m62eKaI2Tqr/x1Iy9KVLMR+ir6l6vVQcdMtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791873577; c=relaxed/simple;
	bh=o/11whAoAmbREQNpC6B6VdrSDIa2QCDi9Ma6RkgLRnA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=NC5ftnuX0nkmmIgQ0aM0MoXg7Uz8KpkijsERvqGEIxl05/BFKS9wxRcqxFmYQJx8i5wfsV9GtcKLnibLP7BwvQBWe01uTe1jO8suZwFwDPxjrmIBIUOi3TK1A7Vl7z2+7ORo5lZJDRM/44CGgl0q396m1Yb75ziSJcUv0RkRcaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2rApsCN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2rApsCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4061F000FF;
	Tue, 13 Oct 2026 06:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791873575;
	bh=K99yxLmQ3265LEVEPM3bHk72MvODI1umvsD1P8YMM/k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a2rApsCN/cLi5SFKqWxdAZUPPKizmrwrTZXUmdjszMbAN8Fm/UoE4Dl6DT7f4rg0z
	 akv9Z5JDuCoua2ALNoC5c1B8o5uO1jJbWzLd07GV4Y+/gGrFk3pttxJ6GaK+Hy2ZkN
	 /3/1M0uRUHit1FDFlcm9raPcL3xYEwmWqgiafZPExYbmqLNr2gneAywUnZqZw0g03K
	 Jm3da/1oDmhM1yI2Qwjn20LHMxbnE/RTWFgvWJvPllCpJLb5nWaCahNv9zPLtmq6qv
	 jv7LXaI7tcufh9PQwtgxv7Q2WoBX7XZITNVC5bg4YWs1tz6e6Wu6NMuE4aROcdX1fL
	 PWmio8lMRX2oA==
Message-ID: <sashiko-outbox-169116@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] ext4: check return value of blkdev_issue_flush()
 when initializing inode tables
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
References: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 06:39:35 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ext4: lazyinit thread ignores nobarrier mount option and aborts =
on flush error
--

commit 06e54e3a165a1e8b6269f6dbdf6487defdbf7915
Author: guolingxing <guolingxing@tju.edu.cn>

ext4: check return value of blkdev_issue_flush() when initializing inode ta=
bles

This commit checks the return value of blkdev_issue_flush() when lazily
zeroing inode tables to prevent exposing stale data if the flush fails.
By leaving the EXT4_BG_INODE_ZEROED flag unset on failure, it ensures
the zeroing is retried on the next mount.

> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index f97a2f4904ebb..843a78fc6e51a 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c

[ ... ]

> @@ -1611,8 +1611,11 @@ int ext4_init_inode_table(struct super_block *sb, =
ext4_group_t group,
>  	ret =3D sb_issue_zeroout(sb, blk, num, GFP_NOFS);
>  	if (ret < 0)
>  		goto err_out;
> -	if (barrier)
> -		blkdev_issue_flush(sb->s_bdev);
> +	if (barrier) {
> +		ret =3D blkdev_issue_flush(sb->s_bdev);
> +		if (ret)
> +			goto err_out;
> +	}

[Severity: Medium]
Does this change break filesystem initialization for users who mount with
the nobarrier option on devices with broken write caches?

In ext4_run_li_request() in fs/ext4/super.c, the lazyinit thread calls
ext4_init_inode_table() with the barrier argument set unconditionally
to 1 for the first block group, ignoring the mount options:

    ret =3D ext4_init_inode_table(sb, group,
                                elr->lr_timeout ? 0 : 1);

If a user mounts with -o nobarrier because their block device returns errors
for flush requests, this timing measurement flush will fail. Before this
patch, the flush error was safely ignored.

Now that the return value is checked, will this cause the lazy inode table
initialization thread to permanently abort and leave the inode tables
un-zeroed across mounts?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013062618.1741=
670-1-guolingxing@tju.edu.cn?part=3D1
