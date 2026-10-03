Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA613806AB
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991257; cv=none; b=hwNk8yKPedWbruYwsmFXk/f9UELGmnvslR5r5gbI/sKYtcGk/42syHNrXXQAyQg/SbKnWJhYZ2ahNMU83lsPFSxzfLwCuXCQOMc776G63ZJJ8aPjh27wc21IW6zndQNBsnwgSE4Jf6W9qoF6tPg/+kybsBOkmE72yP6pnSc0WVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991257; c=relaxed/simple;
	bh=kJj4Iw+UVLiPYAwtqWcyWa8pxmFNuIJGjOAMqy0dWa4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NwSSzXJffNZskSQkmv/sxqIgMu+nGmDbyeziZG3ZVOWHmhlkZ+LVrtAYjatsafK9KBLHGFb1lvBWj0O+pSOq3LfEWSCMfoyTQiEulwiHmt+1rZ7hnSiNGSdpJlofFp1zkJzjfHLhSgq6gzfU81IQdramK2wqSI3NJKtV1UyluVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cFPMQP77; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFPMQP77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B861F00893;
	Sat,  3 Oct 2026 01:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991256;
	bh=7bAJTjg1QEHjZdwtGCaKNlCZjkd8j/B4bNjXUJSGC/I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cFPMQP77EsAs+iTZTLRLFa+z/GscOsvjg6M7gCv0d3v5JvWh1sImlKm+ybkNheS1i
	 OKuY5Xv/aa7pW5ewFo5rkkcKtaDQzAEwW4PM+TI6F335f1bavIRfJf/LLTPtGZw+T5
	 mMFg5XVL90RDLhoqgzFzwsZnZUybH5RTVB+kQDNTuxfWOKuvf1jIriiX7+yhIirZSd
	 fwMY9nGXg09EFIP1HNxMGdR1XV05tjJDyqDrhhkvPoaBRDKx4DDtQPa1N747XphPL6
	 V5oyPMGUiK/upTb0X7F2ex6lu2sPgI70M3pe61r57uyBtlrQLlzQDY+qVnLPKJiIer
	 O/kHP29kxnhzg==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 13/21] xfs: add XFS_BMAPI_UNWRITTEN to
 unmap unwritten extents in __xfs_bunmapi()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20261002223705.2175542-14-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-14-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:15 +0000
Message-Id: <20261003013416.14B861F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] xfs: __xfs_bunmapi data corruption on realtime fsverity files
--

commit 97b9c0f9cb7278bb7ab6643a57cb0d0f1ac3924b
Author: Andrey Albershteyn via Linux-f2fs-devel <linux-f2fs-devel@lists.sou=
rceforge.net>

xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()

The __xfs_bunmapi() is used to remove all extents past EOF. Add
XFS_BMAPI_UNWRITTEN to remove only unwritten extents, while leaving
written ones in place. This will be used in following patch to clean up
unwritten extents on fsverity inodes.

> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 19ca2043c2a8a..49b093ef0321f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5277,6 +5277,10 @@ __xfs_bunmapi(
>  		if (del.br_startoff + del.br_blockcount > end + 1)
>  			del.br_blockcount =3D end + 1 - del.br_startoff;
> =20
> +		if ((flags & XFS_BMAPI_UNWRITTEN) &&
> +		    del.br_state !=3D XFS_EXT_UNWRITTEN)
> +			goto skip;
> +

[Severity: High]
Does this check sufficiently protect written extents when operating on
realtime files?

If an unwritten extent is unaligned within a realtime block, the later
logic in __xfs_bunmapi() will fetch the contiguous written left neighbor
and unconditionally convert its tail into an unwritten extent:

fs/xfs/libxfs/xfs_bmap.c:__xfs_bunmapi() {
    ...
		mod =3D xfs_rtb_to_rtxoff(mp, del.br_startblock);
		if (mod) {
    ...
			} else if (del.br_state =3D=3D XFS_EXT_UNWRITTEN) {
				struct xfs_bmbt_irec	prev;
				xfs_fileoff_t		unwrite_start;

				/*
				 * This one is already unwritten.
				 * It must have a written left neighbor.
				 * Unwrite the killed part of that one and
				 * try again.
				 */
				if (!xfs_iext_prev_extent(ifp, &icur, &prev))
					ASSERT(0);
				ASSERT(prev.br_state =3D=3D XFS_EXT_NORM);
    ...
				prev.br_state =3D XFS_EXT_UNWRITTEN;
				error =3D xfs_bmap_add_extent_unwritten_real(tp,
						ip, whichfork, &icur, &cur,
						&prev, &logflags);

Could this unwrite the left neighbor even when XFS_BMAPI_UNWRITTEN is set,
destroying the adjacent written data (such as an fsverity Merkle tree)?

>  		if (!isrt || (flags & XFS_BMAPI_REMAP))
>  			goto delete;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D13
