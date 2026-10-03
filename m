Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DAD3769E9
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991262; cv=none; b=lJHhVhwK25XQteA3ft6pNHV+zevE6dpAmO+34pG+xsl7L15NQW2V5Rmxyd+3Wi4AAXfVK0NFlBYN5q6+J5t/EGDmuLuDBe0w9qkTOIjBZLyrGZXhevDkq6S+WdVLNgB0Zj7je9Ar39hXy33+9Z19wMH9yBS5mCi1NF/oPXl5eOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991262; c=relaxed/simple;
	bh=/zP/aP3Qaz+UVrDL1sYAWrEZ/6F9f8FWDkEZz5fATC4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QHl/zQRKApKstqwisU+/2AZeR745EXaLR8vGkU30HT/1Y3IM5CYBysrU7q+uq8M5I0LOL7bXhzsQxkPgYHE5m4niYl40AonjPvd4dToG2YAV7RzjP7lzPlEuo3Ef+e1C6fG5jAyC1+71kPxixRy5IT6LRnLp14aZVq5IWGAJ12A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OovaZvHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OovaZvHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED4D1F000FF;
	Sat,  3 Oct 2026 01:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991261;
	bh=SySqUGBtZUkxe/IcZwklkIQ9/BMIZLRIdk8geHpfU08=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OovaZvHYApS21HzUT1ObshpQBYaY5A8CUrmekMEXuidw5zyfu/PRj44303DTwfxcx
	 aAaHGQ49G+G/c3X451kuW6DfIYtsFVGQiqByh8c9Gc7tMZ9S4uRbbQx4WdnlI2gwPq
	 p/PSlIbLfnw+GYC5umsaLg/cMtan8EvDeeLNXj+SgGA2MAzSWbnfBqg0hrDq7AJIXo
	 m4lQ9ulXWrlH6KWJDzugKSuzy7RwTEppL3kJ/FlKnPY6RCmihcKuTileUwOQIyLK3k
	 P1UDgVtkFEwypjv+DE1CWDVxsMUMGNRVVOfEiRL9zaWLTLXVOCfqAdj7eTpquXXOIy
	 VisLY3UcDiEbQ==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 11/21] xfs: handle fsverity I/O in
 write/read path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20261002223705.2175542-12-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-12-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:20 +0000
Message-Id: <20261003013420.DED4D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] xfs: unconditional IOMAP_F_FSVERITY in xfs_map_blocks triggers WAR=
N_ON_ONCE
- [Medium] xfs: IOMAP_F_SHARED state leak in xfs_zoned_buffered_write_iomap=
_begin
--

commit 2fc682567a88b5a6a260af60da335367a346353b
Author: Andrey Albershteyn via Linux-f2fs-devel <linux-f2fs-devel@lists.sou=
rceforge.net>

xfs: handle fsverity I/O in write/read path

This commit adds fsverity handling to the XFS read and write paths. It
introduces a new inode flag for Merkle tree construction and passes the
IOMAP_F_FSVERITY flag to iomap so it processes fsverity metadata properly
beyond EOF.

> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c30e688cfc9f6..19640e4e3ed12 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
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

[Severity: High]
Does this unconditionally set IOMAP_F_FSVERITY for any writeback when the
construction flag is set?

If a user mmaps a file with PROT_WRITE, calls FS_IOC_ENABLE_VERITY, and
dirties a folio below isize during Merkle tree construction, the writeback
will hit this path and apply IOMAP_F_FSVERITY. This appears to lack the
offset >=3D xfs_fsverity_metadata_offset(ip) restriction used elsewhere
(such as in xfs_bmapi_convert_one_delalloc()), which could trigger a
WARN_ON_ONCE(folio_pos(folio) < isize) in iomap_writepage_handle_eof()
for folios before EOF.

[ ... ]

> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 7c6238fed61e4..ccc8b8fabab3f 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
[ ... ]
> @@ -1668,7 +1674,8 @@ xfs_zoned_buffered_write_iomap_begin(
>  				smap.br_startoff + smap.br_blockcount);
>  			xfs_trim_extent(&smap, offset_fsb,
>  					end_fsb - offset_fsb);
> -			error =3D xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
> +			error =3D xfs_bmbt_to_iomap(ip, srcmap, &smap, flags,
> +					iomap_flags,
>  					xfs_iomap_inode_sequence(ip, 0));
>  			if (error)
>  				goto out_unlock;
> @@ -1678,6 +1685,8 @@ xfs_zoned_buffered_write_iomap_begin(
>  	if (!ip->i_cowfp)
>  		xfs_ifork_init_cow(ip);
> =20
> +	iomap_flags |=3D IOMAP_F_SHARED;
> +

[Severity: Medium]
Can this IOMAP_F_SHARED state leak across iterations?

By modifying the local iomap_flags variable here, it seems IOMAP_F_SHARED
is retained if the code later takes the goto restart path.

xfs_zoned_buffered_write_iomap_begin() {
restart:
    ...
    error =3D xfs_bmbt_to_iomap(..., iomap_flags, ...);
    ...
    iomap_flags |=3D IOMAP_F_SHARED;
    ...
    if ((flags & IOMAP_ZERO) && srcmap->type =3D=3D IOMAP_HOLE) {
        if (filemap_range_needs_writeback(...)) {
            ...
            goto restart;
        }
    }
}

This would pollute the source map state with COW-specific flags on the
subsequent iteration.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D11
