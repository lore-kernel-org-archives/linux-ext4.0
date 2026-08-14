Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84423D9029
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702807; cv=none; b=ujfbjEl+u6/gTaFrL19j7KSn0SY7giFmfVAcQywMlpXrAdGSmi5Y6tcix8NRBKmr9St7yEMsdiifoRqjeVyzatBjJ6Zq1CMiTshY4v85ahMpPTIc5mlsa5dzRpYAW4zz6nnEgzVcGek9W8qMY3t2n/oo0kCGEHAJiHfLgGJHO40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702807; c=relaxed/simple;
	bh=2uG/7pcBn+eh/gELJI9ZMCS8GRwniXZs+HuO47sdW6w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HfS4bz0vUS8zvg1dtkLo29zk+XZOWfC6bE7frNCJCLKeBGFULjR72+6hojImXgwa0cGL7v26JcPB0ZkYwAUjxhhYC8hySH7YAq6RClEwtEMbcr5DK+3E5fOlkAWJYHfshxxrCTlhKy8Q66lneESn1a8HEciSWf8RqqjTy/2nxT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sjfd8eZH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sjfd8eZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE051F000E9;
	Fri, 14 Aug 2026 10:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702788;
	bh=/yXLv2WYYnz7bu8O+IxGIhCZjtzg2QLsS8URxf4UGBM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sjfd8eZHOLy1xcW5tycwVvbJBnALpnlle268FDct+3E7yAPFJVBCrgnDRyfX9j2D6
	 BzHsmA6dkMzSUeLNGO8GbbWGJjuaxWBtzB0//0mDr0kJdfKg7IWtJ30UL//h7LvDSz
	 Jq3cy4RF5MKFGCGS5gCADGqB2rqKI+nFciEuP1W/pmmCM8deDRTAVzsDnUtoeylrK5
	 1UTqi5RPtg6t698zB5PlQKH+sewDBF+MPn4iwSdS2PEPPhRFcvN+5JrjPzeeR/QBuP
	 BIVnA1VZt4AC3jtBGw0nhLhY8MTEOyiHSCuV0VOIyT+3b/vVGKOq4XwCWqKgp1eQAK
	 RWFm8j/DdkjEw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 16/32] ext4: implement writeback path using
 iomap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-17-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-17-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:19:48 +0000
Message-Id: <20260814101948.9AE051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] The iomap writeback path queues `iomap_ioend` structures to th=
e `i_rsv_conversion_list`, but the worker function is uninitialized and def=
aults to `ext4_end_io_rsv_work`, leading to type confusion and memory corru=
ption.
- [Critical] Failure to update `ext4_page_mkwrite()` to use the iomap frame=
work for iomap-enabled inodes causes AB-BA deadlocks and type confusion on =
`folio->private`.
- [High] The iomap writeback range mapping logic unconditionally expands th=
e allocation length up to the end of the writeback range, incorrectly alloc=
ating up to 8MB of unwritten extents into sparse file holes.
- [Medium] Missing WRITE_ONCE() for 64-bit ei->i_disksize allows torn reads=
 on 32-bit systems.
- [Medium] Improper use of min_t() truncates the 64-bit wbc->range_end befo=
re comparison, defeating the maximum block cap.
--

--- Patch [16]: [PATCH -next v5 16/32] ext4: implement writeback path using=
 iomap ---
commit 5c1a016c9a25acdff3a66fb714afe96821e567b6
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: implement writeback path using iomap

This commit adds the iomap writeback path for ext4 buffered I/O, introducin=
g=20
ext4_iomap_writepages() and the corresponding iomap_writeback_ops. It also=
=20
adds an end I/O work handler to convert unwritten extents and update file=20
size upon I/O completion.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d831d1911a6ff..0b3e54e12b78f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
[ ... ]
> @@ -4134,10 +4135,154 @@ static void ext4_iomap_readahead(struct readahea=
d_control *rac)
> +static int ext4_iomap_map_writeback_range(struct iomap_writepage_ctx *wp=
c,
> +					  loff_t offset, unsigned int dirty_len)
> +{
[ ... ]
> +	blk_len =3D dirty_len >> blkbits;
> +	blk_end =3D min_t(unsigned int, (wpc->wbc->range_end >> blkbits),
> +				      (UINT_MAX - 1));

[Severity: Medium]
Does this code truncate the 64-bit range_end before the comparison?

If wpc->wbc->range_end >> blkbits is evaluated as a 64-bit value but then
cast to unsigned int by min_t(unsigned int, ...), could this truncate the
value to 0 when the shifted value is a multiple of 2^32?

This might disable the writeback batching optimization for specific offsets
in very large files (e.g., syncing around 16TB boundaries).

> +	if (blk_end > index + blk_len)
> +		blk_len =3D blk_end - index + 1;

[Severity: High]
Will this logic unconditionally expand the block allocation length to the
end of the writeback range?

It looks like blk_len is expanded up to blk_end (which typically represents
the end of the VFS writeback range) without querying the delalloc
reservation length.

If a dirty folio is followed by a hole, could this allocate up to 8MB of
unwritten extents into sparse file holes? This seems like it could
improperly consume disk space and quotas.

> +retry:
> +	map.m_lblk =3D index;
> +	map.m_len =3D min_t(unsigned int, MAX_WRITEPAGES_EXTENT_LEN, blk_len);
[ ... ]
> +static const struct iomap_writeback_ops ext4_writeback_ops =3D {
> +	.writeback_range =3D ext4_iomap_writeback_range,
> +	.writeback_submit =3D ext4_iomap_writeback_submit,
> +};
> +
>  static int ext4_iomap_writepages(struct address_space *mapping,
>  				 struct writeback_control *wbc)
>  {

[Severity: Critical]
Since this patch introduces the iomap writeback path, do we also need to
update the mmap fault handler?

The ext4_file_vm_ops.page_mkwrite handler remains hardcoded to
ext4_page_mkwrite(), which uses the legacy ext4_block_page_mkwrite()
logic.

That legacy path attaches a buffer_head to folio->private and starts a
transaction before taking the folio lock.

When ext4_iomap_writepages() later flushes the folio,
iomap_writeback_init() will cast folio->private to struct
iomap_folio_state.

Calling atomic_set() on this state could overwrite the b_this_page list
pointer in the buffer_head, potentially leading to memory corruption and
AB-BA deadlocks between page faulting and writeback.

> -	return 0;
> +	struct inode *inode =3D mapping->host;
[ ... ]
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 0236b6b9785a2..2888e00575615 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
[ ... ]
> @@ -547,3 +548,124 @@ void ext4_bio_write_folio(struct ext4_io_submit *io=
, struct folio *folio,
> +static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode =
*inode,
> +					 loff_t end)
> +{
[ ... ]
> +	down_write(&ei->i_data_sem);
> +	new_disksize =3D min(new_disksize, i_size_read(inode));
> +	if (new_disksize > ei->i_disksize)
> +		ei->i_disksize =3D new_disksize;

[Severity: Medium]
Does this 64-bit assignment need a WRITE_ONCE() wrapper?

On 32-bit platforms, a plain 64-bit store to ei->i_disksize can be split
into two 32-bit stores.

A concurrent lockless reader calling READ_ONCE(ei->i_disksize) might
observe a torn value, resulting in wildly incorrect disk size values
during concurrent writeback and truncation.

> +	up_write(&ei->i_data_sem);
> +	ret =3D ext4_mark_inode_dirty(handle, inode);
[ ... ]
> +void ext4_iomap_end_bio(struct bio *bio)
> +{
> +	struct iomap_ioend *ioend =3D iomap_ioend_from_bio(bio);
> +	struct ext4_inode_info *ei =3D EXT4_I(ioend->io_inode);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> +	if (list_empty(&ei->i_rsv_conversion_list))
> +		queue_work(EXT4_SB(ioend->io_inode->i_sb)->rsv_conversion_wq,
> +			   &ei->i_rsv_conversion_work);

[Severity: Critical]
Is the worker function for ei->i_rsv_conversion_work properly initialized
for iomap inodes?

It looks like ei->i_rsv_conversion_work is statically initialized to the
legacy ext4_end_io_rsv_work() function in ext4_alloc_inode().

This new iomap writeback path queues iomap_ioend structs to the list, but
it doesn't appear to call INIT_WORK() to reassign the worker function to
the newly introduced ext4_iomap_end_io().

When the work queue executes, wouldn't the legacy ext4_end_io_rsv_work()
iterate over this list and blindly cast iomap_ioend structs to
incompatible ext4_io_end_t structs, resulting in type confusion?

> +	list_add_tail(&ioend->io_list, &ei->i_rsv_conversion_list);
> +	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D16
