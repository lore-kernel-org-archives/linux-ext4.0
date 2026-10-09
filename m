Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7803D3BFAC0
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 11:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791544720; cv=none; b=hHcWbSJEY0fq/H0EeWofNi1X88daiBqiMZjgtQ/4r0XDTDoXffgcuWACVAceN9O/AoBTzCPArgR9ht0rI8BhqE2tK97cEyBT4nQDxKPpK0YMzgLypumcjRtWQH5MrZ+LRrogHajvL//o5LbnAD6rQCNogUg2+aIH2UwxoCt4Sn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791544720; c=relaxed/simple;
	bh=45IXsw8ulBqMeDjPuEpG2hSLbSD5zCqV2cRxqITgTY0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=cOFsR4o6IJQGkKG7VBJhAB8p9TdFiqbAujfFD01h2yzKpQC1tMjcGyaQRd370rLvITAN/if/WUx5S3ktMn+ijiv6UBWP+vsSj36d7n2wsAvZ9i/HqeetBT5lxeYBXuRo4+FPNaJhiAm2JV3cnNJRMt4CARlkSTj8xVJxieIO7ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3ImM1N2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3ImM1N2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B3F1F00893;
	Fri,  9 Oct 2026 11:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791544709;
	bh=Lwnn9j4/7+FQ/ozDOzb2vc4co84iV2Oj0/6r32OWy0U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S3ImM1N2+0JN37pIDFH2/nIM+pooDUMKtArz+U3xnPM3WXkari78TrUv/amJqn/5t
	 m6cE/WHx3LycvKpp6ytaQTWMeXiyW318ZrscS1GHyi/7Po8XrqJyMAigWC7dt5Zro7
	 TrkUhQrDGKDpgXO7g0PtM+RDobNE1DDNYDTWa3oJMrQ7eh0F0TnZ2U66csbZ0PEbyN
	 zcgD40BtDi4KdOdfn595qWdor/wz3RuBiPow9myKL1o11wYeQS4r1LTTI0ncQ72CiU
	 1zHxbvCdJUFIETu/r66FdiikOe6h+YGxpi6VV9TYednspjmts/i5r3+4xftD1soXb2
	 M+65vjBTaeRlA==
Message-ID: <sashiko-outbox-165347@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 22/31] ext4: submit and wait for pending
 disksize-grow I/O on writeback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009103033.2920530-23-yi.zhang@huaweicloud.com>
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-23-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 11:18:29 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: multi-second stall in rsv_conversion_wq due to skipped locke=
d folio
--

commit effefa308fc467b9330490d20efb3b9b03f85c73
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: submit and wait for pending disksize-grow I/O on writeback

This commit introduces the ioend mechanism for the pending disksize-grow
I/O range. It attempts to proactively submit the pending range in
ext4_iomap_writepages() so it completes in parallel, and waits for its
completion in the ioend finish path to avoid exposing stale data when
advancing i_disksize.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9c45a0c01d1c1..76e070eaa6f89 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
[ ... ]
> @@ -4404,6 +4422,36 @@ static const struct iomap_writeback_ops ext4_write=
back_ops =3D {
>  	.writeback_submit =3D ext4_iomap_writeback_submit,
>  };
> =20
> +/*
> + * If the current writeback range begins after the pending zeroed EOF
> + * block range which straddles i_disksize, issue a separate writeback to
> + * flush it first, so as to avoid prolonged waiting.
> + */
> +static void ext4_iomap_wb_submit_zeroed_eof(struct inode *inode,
> +					    struct writeback_control *wbc)
> +{
> +	struct address_space *mapping =3D inode->i_mapping;
> +	loff_t pstart, plen, range_start;
> +
> +	if (wbc->range_cyclic)
> +		range_start =3D (loff_t)mapping->writeback_index << PAGE_SHIFT;
> +	else
> +		range_start =3D wbc->range_start;
> +
> +	plen =3D ext4_iomap_get_disksize_pending_range(inode, &pstart);
> +	if (!plen)
> +		return;
> +	if (round_down(range_start, mapping_min_folio_nrbytes(mapping)) <
> +	    pstart + plen)
> +		return;
> +
> +	/* Keep the caller's sync mode to avoid stalling the background flusher=
. */
> +	if (wbc->sync_mode =3D=3D WB_SYNC_ALL)
> +		filemap_fdatawrite_range(mapping, pstart, pstart + plen - 1);
> +	else
> +		filemap_flush_range(mapping, pstart, pstart + plen - 1);

[Severity: High]
Does this code risk skipping locked folios and causing a stall later?

If wbc->sync_mode is WB_SYNC_NONE, filemap_flush_range() is used, which
skips folios that are locked by other threads without returning an error.
If the pending zeroed EOF folio is transiently locked (for example, by a
concurrent buffered read or write), it will be skipped and remain dirty,
and its pending bit will not be cleared.

However, the main writeback pass will continue and submit I/O for subsequent
folios in the file.

> +}
> +
>  static int ext4_iomap_writepages(struct address_space *mapping,
[ ... ]
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
> +

[Severity: High]
Can this wait block the rsv_conversion_wq indefinitely?

When the subsequent IOs complete, ext4_iomap_finish_ioend() runs in the
single-threaded rsv_conversion_wq. It calls
ext4_iomap_wb_disksize_pending_wait(), which waits for the pending bit
to be cleared.

If the pending block was silently skipped earlier by filemap_flush_range(),
the bit will not be cleared until the skipped folio is written by a future
writeback pass. During this time, the entire filesystem's I/O conversions
are stalled, potentially causing massive latency spikes or deadlocking memo=
ry
reclaim.

>  	/*
>  	 * We may need to convert one extent, update the i_disksize and
>  	 * dirty the inode.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009103033.2920=
530-1-yi.zhang@huaweicloud.com?part=3D22
