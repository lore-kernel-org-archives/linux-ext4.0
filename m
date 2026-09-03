Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8ED4AF68B
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442627; cv=none; b=D0gS+IG+8NiQrJ7KeE7af2nnJdCmtB5vbMCEOdRzWrWLqA1NvwbZocqo3CcNf5pj8stIfjGIDMl8FbKi7WPiajy/wfH+Eu/0LSSPzQzSgUB0+tAdihvVi9Ca5jRjBZ/AUxkigS5gPjKjrEjVhSb2k+kdoTUJsTphebg4FJZCR9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442627; c=relaxed/simple;
	bh=6FEmLcPE9o63Dov5JM3VYl0j/eIJcnwS/stsCGyXXb0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HS5f/wm129PO7+3rCEesQod4PVYCxR43I1U6rI2DrhmzKIwg62PPPZENWxq3P/2UbDXfSol67SXPyXglyZIfci/278Ab+bsM/IutszgdI51QsbiyanmOhiUEAAzw4XS85dd2pOTiRnyNylCDFpO9IXF8+iVrfEEvSIJWjMOShbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLyys9lF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLyys9lF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC101F00A3D;
	Thu,  3 Sep 2026 13:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442611;
	bh=lvLolcdrhpqb1aU1cxsi92MWg5pQAl7K6v23tCKAbaE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LLyys9lFj/8p/hvwuz91T7IyYK//Znu+y9/R04siklABZQCuBz2s+qve0tE7BhMXj
	 JAqofQReuVj99tZfjAAe0br94zoUcL1hegWXn/6FuKu5Lhf340KG12uWut9EQ6yiYi
	 ay2YYy5XZZgULoUSGWyO301xyTI2WHrC6IWfga18ho5PPfOexySdDyJMQz56jJE+x5
	 fMARfHsOnPgrGw7E7ZjgL5JI3fK010fhy0++4gJ5THpott9Ssg2We+aBt/c/2mnbOg
	 VgEKsb0w9RYaBqLOa92tmDilt2oq6pOvUG+BTY+bDnrKNyqkv+TSNq5M9yUDxiPGRA
	 2dLWwTT2MjLSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 15/31] ext4: implement writeback path using iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-16-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-16-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:36:50 +0000
Message-Id: <20260903133650.EDC101F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Journal Credits Exhaustion / Panic in `ext4_iomap_finish_ioend=
()` due to arbitrarily large merged ioends.
- [High] Infinite loop in `ext4_iomap_map_writeback_range` due to open-code=
d ENOSPC retry logic without limits.
--

commit e7cc5164579a940550c93afb2dfec1f186e079ed
Author: Zhang Yi <yi.zhang@huawei.com>
ext4: implement writeback path using iomap

This commit adds the iomap writeback path for ext4 buffered I/O, introducing
new writeback operations and end I/O handlers. It maps and allocates blocks
as unwritten extents during writeback to prevent stale data exposure.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1f18854b9cdd3..f7d7610197a1c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c

[ ... ]

> +static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wp=
c,
> +					  loff_t offset, unsigned int dirty_len)
> +{

[ ... ]

> +retry:
> +	map.m_lblk =3D index;
> +	map.m_len =3D min_t(unsigned int, MAX_WRITEPAGES_EXTENT_LEN, blk_len);
> +	ret =3D ext4_map_blocks(NULL, inode, &map,
> +			      EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT |
> +			      EXT4_GET_BLOCKS_METADATA_NOFAIL |
> +			      EXT4_GET_BLOCKS_IO_SUBMIT |
> +			      EXT4_EX_NOCACHE);
> +	if (ret < 0) {
> +		if (ext4_emergency_state(sb))
> +			return ret;
> +
> +		/*
> +		 * Retry transient ENOSPC errors, if
> +		 * ext4_count_free_blocks() is non-zero, a commit
> +		 * should free up blocks.
> +		 */
> +		if (ret =3D=3D -ENOSPC && journal && ext4_count_free_clusters(sb)) {
> +			jbd2_journal_force_commit_nested(journal);
> +			goto retry;
> +		}

[Severity: High]
Could this open-coded retry loop result in an infinite hang under certain
conditions?

If a non-root user fills the disk up to the threshold of root-reserved
blocks, ext4_map_blocks() will return -ENOSPC because the block allocator
denies access to reserved blocks for non-root users.

However, ext4_count_free_clusters() returns the total free space including
those root-reserved blocks. Because the count evaluates as non-zero, the co=
de
will force a journal commit and goto retry indefinitely, without any loop
limits.

Should this retry logic use a limit like ext4_should_retry_alloc(), or
specifically account for root-reserved blocks to prevent a soft lockup in
the writeback worker thread?

> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 0236b6b9785a2..9b0e12b5463cf 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c

[ ... ]

> +static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
> +{

[ ... ]

> +	/*
> +	 * We may need to convert one extent, update the i_disksize and
> +	 * dirty the inode.
> +	 */
> +	credits =3D ext4_chunk_trans_blocks(inode,
> +			EXT4_MAX_BLOCKS(size, pos, inode->i_blkbits));
> +	handle =3D ext4_journal_start(inode, EXT4_HT_EXT_CONVERT, credits);
> +	if (IS_ERR(handle)) {
> +		ret =3D PTR_ERR(handle);
> +		goto out_err;
> +	}

[ ... ]

> +void ext4_iomap_end_io(struct work_struct *work)
> +{
> +	struct ext4_inode_info *ei =3D container_of(work, struct ext4_inode_inf=
o,
> +						  i_rsv_conversion_work);
> +	struct iomap_ioend *ioend;
> +	struct list_head ioend_list;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> +	list_replace_init(&ei->i_rsv_conversion_list, &ioend_list);
> +	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> +
> +	iomap_sort_ioends(&ioend_list);
> +	while (!list_empty(&ioend_list)) {
> +		ioend =3D list_entry(ioend_list.next, struct iomap_ioend, io_list);
> +		list_del_init(&ioend->io_list);
> +		iomap_ioend_try_merge(ioend, &ioend_list);
> +		ext4_iomap_finish_ioend(ioend);
> +	}
> +}

[Severity: Critical]
Is there a risk of exhausting journal credits and panicking JBD2 when ioends
are merged?

In ext4_iomap_end_io(), iomap_ioend_try_merge() merges contiguous completio=
ns
into an arbitrarily large ioend. When this merged ioend is later passed to
ext4_iomap_finish_ioend(), it requests credits using ext4_chunk_trans_block=
s().

However, ext4_chunk_trans_blocks() internally hardcodes the extent count to=
 1,
allocating credits sufficient for modifying only a single extent on disk.

If a user writes a very large contiguous file (e.g., larger than 128MB), the
merged ioend will exceed the maximum size of a single unwritten extent in e=
xt4
(which is 32,768 blocks). This will cause ext4_convert_unwritten_extents() =
to
loop over multiple extents using the same transaction handle.

Could this exhaust the single-extent credits provided by the transaction
handle, resulting in a JBD2 panic during writeback?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D15
