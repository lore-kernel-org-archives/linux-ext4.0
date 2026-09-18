Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5757543B6E2
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731539; cv=none; b=bMXO/5So/0u27q6Mw8cxiBwShhpLnpOJ6CI8NGyVD0SBE3fS2rO/QWUgcQ5MObBCya7sy2yyhUybqu6CwBuqkauQNdMVPcghsb4PbqS1GdqiaC/qm1WDy7s71H7TwOssEWsIZZoEjPnyR3QSvQG6R8Xxh3VH7wRjihG9oL30D1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731539; c=relaxed/simple;
	bh=9YaOk9A8hQLYHnFW47V4mbMTiLrPhgO5p+bYt35SkkE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EODYmAjJIgurXqAAXhYcz+K5TEdcEo+RkLAvnD7whUzNuswLqU/9quwq+Glme/DI6d74/uXwX86eVMdzVIsmDUYQErazKk1fPJOUlgavlldE8NhLmxhO4H0H+Qfh1GQUe4B8VooMgWPkEyTJaJ6iJZuKPt56IrONRmKK4JzT2X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdS04cKj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdS04cKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6411F000FF;
	Fri, 18 Sep 2026 11:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731538;
	bh=0oXjT3egk3kaJKj3ZNjItm+jC2AAFFQI5IzOj1Erc84=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XdS04cKj0hlZt1iiAVvChkREeqj+dVT4TZh33MNGfY6rRfQxQxxwfa9lOXLXtZIZ3
	 A8qZEDGcPjwdw9XCmC4397mGKoTJCr6/ov2fl2e2SwPKnsbAnYVFHGUDR1z8MMMcmC
	 1dj+XwEHIP2zYgb9mgst40Q+Z90gBALu8yxpK0idzc0rrqr0N0MHV/PnYY542LStVO
	 28Lmstb7lExs4V8T+3RGZtq3gk9mYI2vTV8h9yzT50lczsL9dKO6vL4FUocM2KPlzA
	 cogX0kTU/eD6FnGVGDsEzkv5E1Ajy8s6K4TnHAc5cGvR+8T5GsHeE9bt0aUtvNc6Om
	 7OPPpwrDraPTw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 11/21] xfs: handle fsverity I/O in write/read path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: tytso@mit.edu, dsterba@suse.cz, linux-ext4@vger.kernel.org
In-Reply-To: <20260918111539.1003439-12-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-12-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:38:57 +0000
Message-Id: <20260918113857.BD6411F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] xfs: global IOMAP_F_FSVERITY in writeback triggers WARN_ON_ONCE an=
d skips zeroing
- [High] xfs: missing IOMAP_F_FSVERITY in srcmap causes Merkle tree data co=
rruption during COW
- [High] xfs: extent merging in writeback drops IOMAP_F_FSVERITY, permanent=
ly leaking dirty folios
--

commit 921462565b838ec412711bced36094baa0229a3e
Author: Andrey Albershteyn <aalbersh@kernel.org>
Date:   Fri Sep 18 11:15:23 2026 +0000

    xfs: handle fsverity I/O in write/read path

    For write/writeback set IOMAP_F_FSVERITY flag telling iomap to not
    update inode size and to not skip folios beyond EOF. Initiate fsverity
    writeback with IOMAP_F_FSVERITY set to tell iomap should not skip folio
    that is dirty beyond EOF.

> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ae91f63455c5d..ba6a9611f6f9d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
[ ... ]
> @@ -4401,6 +4403,10 @@ xfs_bmapi_convert_one_delalloc(
>  	 * the extent.  Just return the real extent at this offset.
>  	 */
>  	if (!isnullstartblock(bma.got.br_startblock)) {
> +		if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION) &&
> +		    XFS_FSB_TO_B(mp, bma.got.br_startoff) >=3D
> +			    xfs_fsverity_metadata_offset(ip))
> +			flags |=3D IOMAP_F_FSVERITY;

[Severity: High]
Does checking the potentially merged extent's start offset instead of the
requested offset cause the flag to be wrongly omitted?

If the file size is exactly aligned to the filesystem block size, the
Merkle tree begins immediately after the file data without a padding hole.
When xfs_bmapi_allocate() converts the Merkle tree delalloc extent to a real
extent, the block allocator might place it contiguously with the existing
data extent and automatically merge them. This shifts bma.got.br_startoff
back to 0.

This would cause the check to evaluate to false and IOMAP_F_FSVERITY to not
be set. Without the verity flag, iomap_writeback_handle_eof() processes the
Merkle tree folios as invalid past-EOF folios and returns false, completely
aborting writeback without clearing the dirty state. The Merkle tree folios
are permanently leaked as dirty memory, preventing filesystem unmount and
causing data loss of the Merkle tree.=20

Could this use the requested offset instead of the potentially merged
extent's start offset?

>  		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
>  				xfs_iomap_inode_sequence(ip, flags));
>  		if (seq)
[ ... ]
> @@ -4448,6 +4454,11 @@ xfs_bmapi_convert_one_delalloc(
>  	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
>  	XFS_STATS_INC(mp, xs_xstrat_quick);
> =20
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION) &&
> +	    XFS_FSB_TO_B(mp, bma.got.br_startoff) >=3D
> +		    xfs_fsverity_metadata_offset(ip))
> +		flags |=3D IOMAP_F_FSVERITY;
> +

[Severity: High]
Does this check have the same issue with merged extents causing the flag
to be dropped as mentioned above?

>  	ASSERT(!isnullstartblock(bma.got.br_startblock));
>  	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
>  				xfs_iomap_inode_sequence(ip, flags));
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c30e688cfc9f6..19640e4e3ed12 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
[ ... ]
> @@ -172,12 +173,16 @@ xfs_map_blocks(
>  	int			retries =3D 0;
>  	int			error =3D 0;
>  	unsigned int		*seq;
> +	unsigned int		iomap_flags =3D 0;
> =20
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
> =20
>  	XFS_ERRORTAG_DELAY(mp, XFS_ERRTAG_WB_DELAY_MS);
> =20
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		iomap_flags |=3D IOMAP_F_FSVERITY;
> +

[Severity: High]
Does unconditionally setting IOMAP_F_FSVERITY here, without checking if the
mapped offset is actually within the metadata region, contaminate writeback
for data folios?

If a large folio is allocated that spans across both the file size and the
verity metadata offset, the folio covers both data and metadata. During
writeback of this dirtied folio, iomap_writeback_handle_eof() sees the
IOMAP_F_FSVERITY flag set unconditionally. Because folio_pos(folio) < isize,
it triggers a WARN_ON_ONCE and returns early, entirely skipping the
folio_zero_segment() call required to zero the padding hole between the
file size and the Merkle tree. This leaks uninitialized pagecache memory to
disk and causes a kernel DoS via the splat.

>  	/*
>  	 * COW fork blocks can overlap data fork blocks even if the blocks
>  	 * aren't shared.  COW I/O always takes precedent, so we must always
[ ... ]
> @@ -507,6 +517,22 @@ static const struct iomap_writeback_ops xfs_zoned_wr=
iteback_ops =3D {
>  	.writeback_submit	=3D xfs_zoned_writeback_submit,
>  };
> =20
> +static int
> +xfs_iomap_writepages(
> +	struct xfs_inode		*ip,
> +	struct iomap_writepage_ctx	*ctx)
> +{
> +	/*
> +	 * Writeback does not work for folios past EOF, let it know that
> +	 * I/O happens for fsverity metadata and this restriction need
> +	 * to be skipped
> +	 */
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		ctx->iomap.flags |=3D IOMAP_F_FSVERITY;

[Severity: High]
Can this unconditional assignment also trigger the same kernel splat and
skip tail-zeroing for large folios spanning EOF?

> +
> +	return iomap_writepages(ctx);
> +}
> +
>  STATIC int
>  xfs_vm_writepages(
[ ... ]
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 7c6238fed61e4..fa11d830dfc09 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
[ ... ]
> @@ -1809,9 +1817,12 @@ xfs_buffered_write_iomap_begin(
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
> =20
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		iomap_flags |=3D IOMAP_F_FSVERITY;
> +

[Severity: High]
Does this code omit passing the IOMAP_F_FSVERITY flag to the srcmap when
a COW extent is mapped for a write?

Later in this function (and similarly in xfs_direct_write_iomap_begin()),
xfs_bmbt_to_iomap() is called to populate the srcmap:

	if (imap.br_startblock !=3D HOLESTARTBLOCK) {
		seq =3D xfs_iomap_inode_sequence(ip, 0);
		error =3D xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0, seq);
		if (error)
			goto out_unlock;
	}

Since 0 is passed instead of iomap_flags, IOMAP_F_FSVERITY is missing
from the srcmap. If always_cow is enabled on the mount, writes to the Merkle
tree will allocate in the COW fork. A subsequent partial block write to the
same block requires a read-modify-write cycle. Because srcmap->flags lacks
IOMAP_F_FSVERITY, iomap_block_needs_zeroing() incorrectly zeroes the block
(thinking it's past EOF) instead of reading the existing Merkle tree data
from disk. This permanently corrupts the fs-verity metadata.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D11
