Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F338037C0E6
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731891; cv=none; b=U+aVlsOhILGYER3ZKcgfj0TUi51tUYvDIkSlUkkXhMv6JevUUplEjuaPSCPqIpC02DhB71VTV7QWeLfUPCRysIsJbYnTTdoIwCBKXOYa8waeP8HODPpnyTxiwNY81aMWLaP+XWHLqxqhPsXBx4PXF/4+1k0TAd+nnCeAubEvrrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731891; c=relaxed/simple;
	bh=hCFzw5Zifihh7sSHvCZVO2uGf/4b47tBZwbu15stffQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P+e8NE5pQ/aTbxmUWWYsqOIWz0aUTcOSzuBl0eFXTWW/ar2k2B6Ix3FZtJ1nyeOKLEZ8r9RYcJqUp3VwObqbo70ZVyvQX/byreh3Ps0GAUzY1/X7iNcWCL2hPWbCZUsoocMuU7C4IJ6sNfSnZ17Ozjl5cZ0Yp8LbdsYv9NHKoB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=isW/zg8E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="isW/zg8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4356A1F00898;
	Fri, 18 Sep 2026 11:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731889;
	bh=vrGoiMrnG3+9hattNYyYXyuGYXnGM4W1qznofM2oEEQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=isW/zg8EM/upCNbHib54U3wH7mfCkIsioAVl88ETNSnqBSNzK0Tv5pcPXHJJi47Ui
	 yr63N/2uw5cT6pCd8cxAsDTtUEex7i73Yr+MJBaQz9N+RAgj32IV6abNPdk/iDwXaS
	 cs04PRcwJO78u+BWwBqtVBXX6e8vjADjRW5Z8jqJtaPTBg46WmlSERYqUwwf1Hmzzg
	 2DpvTHicwFnyN6CxDmlxLAvACkijYigkl00zmYM02YF/GI3ba6kHcw/3sZlr1ZDNan
	 Vf1MV43foPL63nYYGZulG8xZDHmtpjWtV1lW74oiKqNa8MyVmLbY8KHVjhGdbjQzaT
	 HZQTXj/qwiX3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 21/21] xfs: enable ro-compat fs-verity flag
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: dsterba@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260918111539.1003439-22-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-22-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:44:48 +0000
Message-Id: <20260918114449.4356A1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] xfs: fsverity enablement failure bricks inode due to un-cleared XF=
S_DIFLAG2_VERITY
--

commit 3c41daf7bf4b1b9da289ed99189425637499f418
Author: Andrey Albershteyn <aalbersh@kernel.org>

xfs: enable ro-compat fs-verity flag

Finalize fs-verity integration in XFS by making kernel fs-verity
aware with ro-compat flag.

> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index f728e7d1eb325..7190fb069d1a8 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -378,8 +378,9 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
>  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> -		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
> -		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
> +		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
> +		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
> +		 XFS_SB_FEAT_RO_COMPAT_VERITY)

[Severity: High]
While reviewing the fsverity enablement, I noticed a potential issue in the
error handling path of xfs_fsverity_end_enable().

If xfs_free_eofblocks() fails, such as due to ENOMEM or quota limits, the e=
rror
path deletes the verity metadata but appears to leave the permanently commi=
tted
XFS_DIFLAG2_VERITY flag set:

fs/xfs/xfs_fsverity.c:xfs_fsverity_end_enable() {
[ ... ]
	ip->i_diflags2 |=3D XFS_DIFLAG2_VERITY;

	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
	xfs_trans_set_sync(tp);

	error =3D xfs_trans_commit(tp);
	xfs_iunlock(ip, XFS_ILOCK_EXCL);
	if (error)
		goto out;

	inode_set_flags(inode, S_VERITY, S_VERITY);

	/*
	 * Proactively remove unwritten extents left by COW preallocations and
	 * write preallocation in the merkle tree holes and past descriptor,
	 * and any delayed preallocations
	 */
	error =3D xfs_free_eofblocks(ip);
out:
	if (error) {
		int	error2;

		error2 =3D xfs_fsverity_delete_metadata(ip);
[ ... ]
}

Does this leave the on-disk inode permanently marked as an fsverity file wh=
ile
the metadata has been deleted?

If so, could this cause subsequent attempts to open the file to fail with
-ENODATA or -EIO when fsverity_file_open() fails to find the descriptor,
resulting in localized data loss unless an offline or online repair tool cl=
ears
the flag?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D21
