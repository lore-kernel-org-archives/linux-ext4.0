Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C4945C709
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703168; cv=none; b=m/u3+qagRhgv1i21t0R/+0RH9iQ/xYyJx48l9ytum9XJzjVjQlER+AeaBfHXjamiayI2N03Cv/qi/u0iwJYtfUtuD7wcpuXQQH37hshgT9O0GPdy6GJfsvfLnZOOvur8LAE8QL4+IHQVMpnBsVCbUwHXgNWN8wYFetHfoAFVAQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703168; c=relaxed/simple;
	bh=dUiEaqqNqLhnJR/jJJWfZ8K0gS4MzDlLoqHdex0WgJ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E2T8NYWR0ADPK3Fz2zLcDHyt+SzmZXKKPeIt+rsnMK5ZJGD6/w5bRtWyB5xL2UrlHMjYQug+9KMsmaoHl4jyXd1jrvrKxH8Qro2HvXo2y8pFn5+Fyf334DtPdA0wdp8C00Hkai8+0bPlAPlv80cYrGd8efuuEKIA1GVHKmw3iMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Djj7xl09; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Djj7xl09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB31B1F000E9;
	Fri, 14 Aug 2026 10:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786703156;
	bh=4i5hJtqz0IcZzK1gVIkVWFc5wNSWWDLGagk6YqYNgNo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Djj7xl09eesox8GJlB1qi2qi9ZsvYmRhRwBUt96J8YMFHZJWXuj3a+ZHqfZcIzWwh
	 cW6rHSk4pnt5l2dqoZCCPuWeKncCjatKpxxICCzOpo5YMatSkVQVwpRYHdf99BIEKG
	 LWUuzYtLbZDVExn+Qqn52uaPIDasF2ftA9d/fPjb7nXioS3SZGi0GPOvYn1IQrot/z
	 ZCoXZgMUmfqg5g/ND+6hRipYjHF4VmuBKrkeSu6XH00f2cgxiE1PBFA1gTr+pkkwx2
	 4E8jKJdcGBDoFyFMHJ7IjuWNeXz9jVYd+h59b34lnZ6sb7+07P+7ZibTo3h3EJe5rp
	 6PPwa24gCcyww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 23/32] ext4: submit and wait for pending
 disksize-grow I/O on writeback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-24-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-24-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:25:56 +0000
Message-Id: <20260814102556.AB31B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] Unconditional clearing of the disksize-grow-pending state on I=
/O error exposes stale data.
- [Critical] The iomap writeback path queues `struct iomap_ioend` to `ei->i=
_rsv_conversion_list`, but the work item executes `ext4_end_io_rsv_work` ex=
pecting `ext4_io_end_t`, causing memory corruption.
- [High] Proactive submission of the EOF block issues a WB_SYNC_ALL writeba=
ck pass, violating WB_SYNC_NONE non-blocking guarantees.
- [High] The EXT4_STATE_DISKSIZE_GROW_PENDING bit is never cleared when a f=
ile is truncated down or punched, leading to a permanent deadlock in ext4_i=
omap_wb_disksize_pending_wait on subsequent writes.
- [Medium] The EXT4_STATE_DISKSIZE_GROW_PENDING flag is never set anywhere =
in the codebase.
--

--- Patch [23]: [PATCH -next v5 23/32] ext4: submit and wait for pending di=
sksize-grow I/O on writeback ---
commit 8550774845865922b3c12e81e62fba6b64136065
Author: Zhang Yi <yi.zhang@huawei.com>
Subject: ext4: submit and wait for pending disksize-grow I/O on writeback

This patch introduces logic to submit and wait for pending zeroed EOF blocks
that straddle i_disksize during writeback to prevent exposing stale data.
It tags ioends with EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO and proactively submi=
ts
the pending ranges.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e4a4396eaf879..a0707310b464c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4379,6 +4382,21 @@ static int ext4_iomap_writeback_submit(struct ioma=
p_writepage_ctx *wpc,
>  	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
>  		ioend->io_bio.bi_end_io =3D ext4_iomap_end_bio;
> =20
> +	/*
> +	 * Mark the I/O as DISKSIZE_GROW_IO by setting io_private to
> +	 * EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO if it covers the pending range.
> +	 * Such I/O will allow or trigger i_disksize advancement in the
> +	 * ioend worker.
> +	 */
> +	plen =3D ext4_iomap_get_disksize_pending_range(inode, &pstart);

[Severity: Medium]
Does this actually get triggered? A codebase search shows that the flag
EXT4_STATE_DISKSIZE_GROW_PENDING is never actually set anywhere (for exampl=
e,
when zeroing the tail of the EOF block). Because the flag is never set,
ext4_iomap_get_disksize_pending_range() will always return 0, which seems to
completely bypass the newly added logic.

> +	if (plen &&
> +	    round_down(ioend->io_offset, blocksize) <=3D pstart &&
> +	    round_up(ioend->io_offset + ioend->io_size, blocksize) >=3D
> +			pstart + plen) {
> +		ioend->io_bio.bi_end_io =3D ext4_iomap_end_bio;
> +		ioend->io_private =3D (void *)EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO;
> +	}
> +

[ ... ]

> @@ -4398,6 +4416,29 @@ static const struct iomap_writeback_ops ext4_write=
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
> +	if (!plen || range_start < pstart + plen)
> +		return;
> +
> +	filemap_fdatawrite_range(mapping, pstart, pstart + plen - 1);

[Severity: High]
Does this violate the WB_SYNC_NONE guarantees when called by the background
flusher?=20

filemap_fdatawrite_range() initiates a WB_SYNC_ALL writeback pass. If
ext4_iomap_writepages() is invoked with wbc->sync_mode =3D=3D WB_SYNC_NONE,
this nested WB_SYNC_ALL call will synchronously block waiting on page locks
and in-flight I/O. This could stall the background flusher and potentially
cause deadlocks if the thread holding the lock is blocked in memory reclaim
waiting for the flusher to free pages.

> +}
> +

[ ... ]

> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 2888e00575615..955ff88045db6 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -549,6 +549,34 @@ void ext4_bio_write_folio(struct ext4_io_submit *io,=
 struct folio *folio,
>  	} while ((bh =3D bh->b_this_page) !=3D head);
>  }
> =20
> +/*
> + * If the current writeback range starts beyond the zeroed EOF pending
> + * range that straddles i_disksize, wait for the zeroed data from
> + * ext4_block_zero_eof() to be written out first. Otherwise, extending
> + * i_disksize may expose stale data in the old EOF block.
> + */
> +static void ext4_iomap_wb_disksize_pending_wait(struct inode *inode,
> +						loff_t pos, size_t size)
> +{
> +	loff_t disksize =3D READ_ONCE(EXT4_I(inode)->i_disksize);
> +	loff_t pstart, plen;
> +
> +	/*
> +	 * Overwrite I/Os and I/Os covering the EOF block do not need to
> +	 * wait: the former do not advance i_disksize past the pending
> +	 * boundary, and the latter are the pending I/O itself (cleared in
> +	 * the bio completion path).
> +	 */
> +	if (pos < round_up(disksize, i_blocksize(inode)))
> +		return;
> +
> +	plen =3D ext4_iomap_get_disksize_pending_range(inode, &pstart);
> +	if (!plen || pos < pstart + plen)
> +		return;
> +
> +	ext4_iomap_wait_disksize_pending(inode);

[Severity: High]
Could this wait indefinitely if the file is truncated down or punched?

If EXT4_STATE_DISKSIZE_GROW_PENDING is set, but no code clears it during
ext4_truncate() or ext4_punch_hole(), the zeroed EOF page will be removed
from the page cache while the bit remains set. If new data is subsequently
written past the stale pending range, the writeback completion might call
ext4_iomap_wb_disksize_pending_wait().=20

Since the original page was dropped, no I/O will ever complete to clear the
bit, causing the worker thread to hang forever in the wait_on_bit call and
permanently blocking the rsv_conversion_wq.

> +}
> +

[ ... ]

> @@ -660,8 +691,17 @@ void ext4_iomap_end_bio(struct bio *bio)
>  {
>  	struct iomap_ioend *ioend =3D iomap_ioend_from_bio(bio);
>  	struct ext4_inode_info *ei =3D EXT4_I(ioend->io_inode);
> +	unsigned long io_mode =3D (unsigned long)ioend->io_private;
>  	unsigned long flags;
> =20
> +	/*
> +	 * This is a disksize-pending I/O: clear the disksize-pending
> +	 * state set in ext4_block_zero_eof() and wake up all waiters
> +	 * that will update the inode i_disksize.
> +	 */
> +	if (io_mode =3D=3D EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO)
> +		ext4_iomap_clear_disksize_pending(ioend->io_inode);

[Severity: Critical]
Does clearing the pending state here expose stale data on I/O errors?

If the writeback fails, the pending state is unconditionally cleared here,
waking up waiters in ext4_iomap_wb_disksize_pending_wait(). Because those
waiters only check their own bio status, they could proceed to advance
i_disksize past the failed EOF block in ext4_iomap_finish_ioend(). Advancing
i_disksize over the failed zeroing operation exposes the stale data previou=
sly
present in the block's tail on disk.

> +
>  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>  	if (list_empty(&ei->i_rsv_conversion_list))
>  		queue_work(EXT4_SB(ioend->io_inode->i_sb)->rsv_conversion_wq,
>  			   &ei->i_rsv_conversion_work);
>  	list_add_tail(&ioend->io_list, &ei->i_rsv_conversion_list);

[Severity: Critical]
Can this queueing lead to memory corruption due to type confusion?

A struct iomap_ioend is added to ei->i_rsv_conversion_list here and
ei->i_rsv_conversion_work is scheduled. However, this work item is
permanently bound in ext4_alloc_inode() to execute ext4_end_io_rsv_work().

When the workqueue executes ext4_end_io_rsv_work(), it iterates over the
list and improperly casts the struct iomap_ioend entries to ext4_io_end_t.
Accessing fields from this miscast pointer will retrieve garbage data,
leading to a panic or use-after-free.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D23
