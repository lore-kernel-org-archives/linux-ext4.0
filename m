Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C9C46D09D
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 06:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791873725; cv=none; b=I7MyFaF0gftiSWyZAqy6RqPtVWguZWczUdAbMRvLEKrG4fDojSqCQMjMQZ1ADe+3lZvtAMA6L9y2NRcjh3MdTJGL6accYQVeyEMLbIhdL9zysINiqAF3pR3C6KJnjSFCuCHNIy72B0TSivxar+lKQDNgjG6DxB32+HZaGBhgjcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791873725; c=relaxed/simple;
	bh=Trlt/ScbWyq2ICjQY6Y9I/gSKyxKgbEnpeYX7OYY6LQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LWMjJ6sw2T68xYj+QCx8U6VhNxTwYzbyFrE8MhwZtfQ1ZWOg1aJrVDhKkMgab4azKtLE1z+uPdmDZzcU6D6i721JHRmMGLJ9SwnnN+Si/SYc84krpbm1lJ3irw/cYNx2d0TO4oEDdxvAnaQfpwUXO1aUk5JqI4zR/SfRbr/B7QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+tEYMlS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+tEYMlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976991F000FF;
	Tue, 13 Oct 2026 06:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791873723;
	bh=jHXRSNuSNE+KQrWR0b/MqXjHbj44gg/I4f5aC6buT4E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j+tEYMlS4AppNgCJ4HjHYKQxc2XPk1n/7EzAzYRbsBfGdwIBa6i2XXEe7yBgVfFCv
	 MuHU9fKWJy7vGmClRLYSWQROWWciVJuyfFE3ZfOk1nltTDunSylUZX6Yr4Rd8r6VCy
	 q9f65gQi7GRoXGqgtecPTBNXIGuzmv2PtVk1pFQQDyKmihNoWfysAA7hqJwa/KESwl
	 YO9WVcjqk1we1Haq42hv5FTXBBZpzaY1Cg7CwJ21rcQcv6rCfmlSDDtRfbqa0cDDJU
	 VO6oZAVyrd4fJebAQd4XGtBzj1z6RIejW14V4XByhNH8UZrO+5rHRmSl3itvTv2Hh3
	 W+xRgXcC/gADA==
Message-ID: <sashiko-outbox-169121@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] ext4: check return value of blkdev_issue_flush()
 when starting a fast commit
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013062618.1741670-2-guolingxing@tju.edu.cn>
References: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
 <20261013062618.1741670-2-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 06:42:02 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] ext4: missing JBD2_BARRIER check for fast commit device flush
--

commit a1cae98067fdb2cd8eec738283b6d33c84b7ca8d
Author: guolingxing <guolingxing@tju.edu.cn>

ext4: check return value of blkdev_issue_flush() when starting a fast commit

When the file system device differs from the journal device, a cache flush
is issued before fast commit blocks are written. The return value of
blkdev_issue_flush() was previously ignored. This patch checks the return
value and aborts the fast commit if the flush fails, falling back to a full
journal commit.

> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0cac890cf3702..ead8b16f9be07 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -1425,8 +1425,11 @@ static int ext4_fc_perform_commit(journal_t *journ=
al, tid_t commit_tid)
>  	 * Step 5: If file system device is different from journal device,
>  	 * issue a cache flush before we start writing fast commit blocks.
>  	 */
> -	if (journal->j_fs_dev !=3D journal->j_dev)
> -		blkdev_issue_flush(journal->j_fs_dev);
> +	if (journal->j_fs_dev !=3D journal->j_dev) {
> +		ret =3D blkdev_issue_flush(journal->j_fs_dev);
> +		if (ret)
> +			return ret;
> +	}

[Severity: Medium]
This problem wasn't introduced by this patch, but does this flush need to
validate journal->j_flags & JBD2_BARRIER before proceeding?

In ext4_fc_perform_commit(), blkdev_issue_flush() is called unconditionally
when the filesystem device differs from the journal device. If the filesyst=
em
is mounted with the "nobarrier" option, this appears to ignore the mount
option and issue the cache flush anyway, unlike the JBD2 full commit path a=
nd
fast commit tail block writers.

Could this bypass the user's mount options and cause unnecessary I/O
overhead during fast commits?

> =20
>  	blk_start_plug(&plug);
>  	alloc_ctx =3D ext4_fc_lock(sb);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013062618.1741=
670-1-guolingxing@tju.edu.cn?part=3D2
