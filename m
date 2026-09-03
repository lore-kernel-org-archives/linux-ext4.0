Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2144AEBF7
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442858; cv=none; b=ugWew8rObyhBxtX5WziasAXZsbC1SWwj6lFM0aq5J551DXXVH8C4YsdkWHqlAApWF7a5TXQdyTiFaU+b6YppFTkjh7NFewjQ3V41Y+uvyW5TC99yde+IgvelhjJOkFLEobIUqGZ0UBku5Z0DdI1QOaRBzPcKAJ/XXSsOPrVavIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442858; c=relaxed/simple;
	bh=WkslfH/Z8NVe+Sy0jE2fmsZagsthlRLyxi86XxjE+mM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m0G/PMvt+uuwA7zWedm3BRTpE6/WZgtQ+ikB4cEc/MlJzMn6bZ+F/V3yDmuuMwbvn8cxZEnO4W7NFa2K86IXQeWo6oBswdOOtOOJUc2H3ZVD7jLbQ8z1lObV/Y9CAvI89G/GvawGNcHY0cN/EHObY/zH2L01jvDqzu11gQgb5OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnLU6d4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnLU6d4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0251F00A3F;
	Thu,  3 Sep 2026 13:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442842;
	bh=3dB7cC1hv4ArJeIW39I1qKBD5P0bq5qv0G+S+vePcwc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bnLU6d4JBr4WFqOGgHP4smOQ5K1jnimc/vuEDRrjQAbXvh9AiMyeauT3R+P7JbpSx
	 PAQp72fEt/6GDAnuLUWuHOVGbyfUGas11XrrOdTx5C1xtHG1cydmWd3DXTD0cFuS9J
	 2VPgu2QoF0CRi8X10t+4yeE16u4AzpSBjXk1nxk7s2enQYbFRAyfQgxW7Stl1Cxsuv
	 /JibmGxbAiDLWG9ve2v1AU5cRu5gFH94qG2XFgVFIS70B+Q2GsbNEq1n6qEMQZgFMV
	 HRC2eofLPo8uyEkay7mOZx7qt2rioeiQmCEE7Y1OQHWIQi5SPGWSKZM/OKBymcYJac
	 aW/pHmttKhGFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 22/31] ext4: submit and wait for pending
 disksize-grow I/O on writeback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-23-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-23-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:40:41 +0000
Message-Id: <20260903134042.5E0251F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Single-threaded workqueue stall causing filesystem-wide deadlo=
ck on concurrent write and writeback due to WB_SYNC_NONE skipping locked fo=
lios.
--

commit 8015bea7c1654bcaea86ce738fcb50400fa35290
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: submit and wait for pending disksize-grow I/O on writeback

This commit introduces a mechanism to proactively submit and wait for pendi=
ng
disksize-grow zeroed EOF blocks during writeback. This prevents stale data
exposure when advancing i_disksize.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 383824e89d123..4c2b6cd15d1f9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
[ ... ]
> +static void ext4_iomap_wb_submit_zeroed_eof(struct inode *inode,
> +					    struct writeback_control *wbc)
> +{
> +	struct address_space *mapping =3D inode->i_mapping;
> +	loff_t pstart, plen, range_start;
[ ... ]
> +	/* Keep the caller's sync mode to avoid stalling the background flusher=
. */
> +	if (wbc->sync_mode =3D=3D WB_SYNC_ALL)
> +		filemap_fdatawrite_range(mapping, pstart, pstart + plen - 1);
> +	else
> +		filemap_flush_range(mapping, pstart, pstart + plen - 1);

[Severity: Critical]
Could this WB_SYNC_NONE flush silently skip a locked folio, leaving the pen=
ding
EOF block unsubmitted?

If a user-space thread is concurrently modifying a folio covering the pendi=
ng
zeroed EOF block (which has EXT4_STATE_DISKSIZE_GROW_PENDING set), the folio
will be temporarily locked.=20

When background writeback (kupdate) flushes a subsequent range, it will call
filemap_flush_range() here, which uses WB_SYNC_NONE and skips locked folios
without submitting their I/O.

> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 9b0e12b5463cf..697e12a54a49a 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
[ ... ]
> @@ -594,6 +622,9 @@ static void ext4_iomap_finish_ioend(struct iomap_ioen=
d *ioend)
>  	    end <=3D READ_ONCE(EXT4_I(inode)->i_disksize))
>  		goto out;
> =20
> +	/* Wait for disksize-pending zeroed data to be written out. */
> +	ext4_iomap_wb_disksize_pending_wait(inode, pos, size);

[Severity: Critical]
Does this wait cause a permanent filesystem-wide deadlock if the pending EOF
block was skipped during WB_SYNC_NONE?

If the locked EOF folio was skipped by ext4_iomap_wb_submit_zeroed_eof(), t=
he
I/O for the subsequent range will complete and queue its ioend on the
single-threaded sbi->rsv_conversion_wq. The worker thread will unconditiona=
lly
block here waiting for the unsubmitted EOF block's I/O to complete.

This stalls the entire workqueue. Later, the jbd2 commit thread runs and bl=
ocks
in filemap_fdatawait() waiting for the PG_writeback bit of the subsequent r=
ange
to clear, which only happens at the end of ext4_iomap_finish_ioend() via
iomap_finish_ioends().

Finally, kupdate attempts to write another file with delayed allocation,
blocking in ext4_journal_start() waiting for jbd2. Because kupdate is now
deadlocked, it will never loop back to write out the skipped EOF folio,
resulting in a permanent circular deadlock.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D22
