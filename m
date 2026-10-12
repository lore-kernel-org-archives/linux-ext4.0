Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04F54C4F5D
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 18:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791829200; cv=none; b=XqLmv15m+mm5n3FYzWReFVotzQCE0ZoSJN8fY7uAPPA0PU3qvBvRVEtZkXkdmG52qc+0U4PloupCPHNIUtd1wjV5YT5biEr9Ez0ArEZMCCQFbg2Tsj+dMEsHKLyDvCWtY11sPHWcFnd+SFEHU9ytcUMRW7b4U/0Q4Chf/84VM+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791829200; c=relaxed/simple;
	bh=QyHBaWM+WVjO1x0sC+DTHamkQzln1mLhqNDbKFfkhkg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=GL+51j4Vny+nVE382NPXNNpPypxHLVsktXmJdgjNbPNfXodsGvpVcwV2C/WEpfHb0TzQuGxll1OJrZUNXRB0+ezWLLXlHNdVH9vqGwl9OpEFbd/x/rfGPECjUakSO4oSTGHT1pQcq9XTlZcfg4HLaX0u9+46+j/MXUNJsmGQSKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IipXYbCr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IipXYbCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273F11F0089B;
	Mon, 12 Oct 2026 18:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791829199;
	bh=dc7AFFYJQmFZTD0x90eElcCZYl4eZp5zWYz3vuWAnfw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IipXYbCrorOARv+US+bHBMAZMMRNFDvIHVoj6RQZuMSJOC0VSfWIAl0YY86MgQOTR
	 wOzdOocQkQ5NOKZw3wHLBXsyvii492ckSwTg6WpjWnZvEZpo4bS4eBHmm8tof6207o
	 Z7UX1aHTbqM/evhaMJoBne4KGQ9R4l7p7RMPlCtWILJUm+WqtX9ERIAHo3Ugruc27Y
	 4su9RrCNdyi3skHT2oPnBlJyuEVLO2Hk99fEU+MKhsxJgvB/2G2idtU8eQ6bG0TL9x
	 mA/onxAaFE0n0hKNlvwfeDPISvmuIqLJp51gsS2R4eMPi6/iBDonKG2h9Hhl6VtZMl
	 lyq41FSUod+RQ==
Message-ID: <sashiko-outbox-168530@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: complete dropbehind writeback in task context
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
References: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 18:19:58 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: data race on io_end->flag corrupts UNWRITTEN and FAILED state
--

commit 578221fefbc4e5e8f3b366b7ce8ee33f43bb2e34
Author: Tal Zussman <tz2294@columbia.edu>

ext4: complete dropbehind writeback in task context

This commit introduces task-context bio completion for bios carrying
dropbehind folios. It sets BIO_COMPLETE_IN_TASK on these bios during
io_submit_add_bh() to ensure their invalidation runs from a worker rather
than interrupt context.

> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 734d856a6d478..e556598ce9e14 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c

[ ... ]

> @@ -458,6 +458,16 @@ static void io_submit_add_bh(struct ext4_io_submit *=
io,
>  		io_submit_init_bio(io, inode, folio, bh);
>  	if (!bio_add_folio(io->io_bio, folio, bh->b_size, bh_offset(bh)))
>  		goto submit_and_retry;
> +
> +	/*
> +	 * Dropbehind folios can only be invalidated in task context. An
> +	 * io_end with unwritten extents is completed from ext4's workqueue
> +	 * anyway, so only ask the block layer to defer the others.
> +	 */
> +	if (folio_test_dropbehind(folio) &&
> +	    !(io->io_end->flag & EXT4_IO_END_UNWRITTEN))
> +		bio_set_flag(io->io_bio, BIO_COMPLETE_IN_TASK);
> +

[Severity: High]
Does this lockless read of io_end->flag introduce a data race that could le=
ad
to data loss?

During submission, the ext4_writepages thread can map multiple extents that
share a single ext4_io_end. If an early bio completes with an error while t=
he
submission thread is still mapping a subsequent unwritten extent,
ext4_end_bio() can set EXT4_IO_END_FAILED concurrently:

fs/ext4/page-io.c:ext4_end_bio() {
    ...
    io_end->flag |=3D EXT4_IO_END_FAILED;
    ...
}

Meanwhile, the submission thread might be setting EXT4_IO_END_UNWRITTEN:

fs/ext4/ext4.h:ext4_set_io_unwritten_flag() {
    ...
    io_end->flag |=3D EXT4_IO_END_UNWRITTEN;
    ...
}

Since both paths use non-atomic bitwise OR without a shared lock, reading
the flag here in io_submit_add_bh() appears to rely on a racy state.

If the UNWRITTEN flag is lost due to a read-modify-write race,
ext4_io_end_defer_completion() will return false and Ext4 could drop the
io_end without converting the unwritten extents on disk. Can this lead to
silent data loss where written data reads as zeroes?

Could this lockless check be made safe against concurrent bio completions, =
or
perhaps atomic bitops should be used for io_end->flag?

>  	wbc_account_cgroup_owner(io->io_wbc, folio, bh->b_size);
>  	io->io_next_block++;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-ext4-dontc=
ache-complete-in-task-v1-1-6ac801557041@columbia.edu?part=3D1
