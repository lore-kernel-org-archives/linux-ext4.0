Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4AD456E0B
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731718; cv=none; b=Guf57m3uPzEAuMoFjzAKqkJ0nFon8cDp3Lh8GkF75E8ybAltvKs4eldoUAK1ToK6CWPpTI+t8HDfdz8crzJRM2jR3Fx24KptFbiH9AGlg6D+G4cGcuUpNnAAHxnPRPZjv35SZAg9L8xarPCmO6TjZ1hPvYAoRmHEYHp37TiZLts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731718; c=relaxed/simple;
	bh=T9nr5PQweVsfiltPS2CGUwnTMs02qZxpRwR7Xk4nzuI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f38baf3T34niJ0OWIvfHzxubvW1hjrv17+Cy4TBse92ipFAhgqSR3NzErqasytvNJLjHPgfAV+C3wOkLxVwZC4wPJnVh/0UEE9DSAwYixE8jkPEPT+/NHVuyoBCHgmvT9Q+zDZkko/jOx7I72V0fYC/X335oTmpnzwhNodeZ5Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6jWjWlc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6jWjWlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75A11F000FF;
	Fri, 18 Sep 2026 11:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731716;
	bh=7gKPN0hMblgGC8DxLG02+2x9wbtW59QSEQ+NkfaoWU4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M6jWjWlc5NUL3Iu806TWSh2yZz/NLbcEP00BLMd7x5IpXMYUbgNPA7ju8keEZFWRR
	 M1lnfSCzDn2DNiQxL60GXH9lAsr5NphIKZ9arHhveMbL+ERfnw3wnkIUixNkuQAySy
	 DrSbPqw8NorUbezQZ9I3bM+SYF6IS2Hp/W9QA41FJyTLcVG4knonC4mV+4rZSdUX7e
	 ISW5gwhS+6tUNfqjPFFu2/YUDZa6r1lQrMwPSF3vY0j2EJQa6Og8G0fwoOPInXQW2u
	 nRL1QT4Yaz+7/+7qHsiKZQ8j6ebFnPWk/jlae44Ig6H1sxJl5u+lPclRIZEuZWeCFq
	 DCUniRDx/iOEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 14/21] xfs: don't remove written extents past EOF on
 fsverity inodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: dsterba@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260918111539.1003439-15-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-15-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:41:56 +0000
Message-Id: <20260918114156.A75A11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] xfs: unconditional transaction storm on fsverity inode eviction
- [Medium] xfs: permanent unwritten extent leak due to premature tag cleari=
ng
--

commit 6b94de2dc949e4cfdd882209710ec5c6ad8019cf
Author: Andrey Albershteyn <aalbersh@kernel.org>

xfs: don't remove written extents past EOF on fsverity inodes

This commit updates the EOF blocks cleanup logic to handle fsverity inodes.
It skips the removal of written extents past EOF for fully constructed
fsverity files. It also cleans up delayed preallocations and unwritten
extents used during Merkle tree construction.

> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 268d159339d06..7fd951992557d 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
[ ... ]
> @@ -553,6 +554,13 @@ xfs_can_free_eofblocks(
>  	if (last_fsb <=3D end_fsb)
>  		return false;
> =20
> +	/*
> +	 * Don't clean fsverity inodes which have merkle tree being built, the
> +	 * merkle tree is written beyond EOF
> +	 */
> +	if (xfs_iflags_test(ip, XFS_VERITY_CONSTRUCTION))
> +		return false;
> +

[Severity: High]
Looking at xfs_can_free_eofblocks() in fs/xfs/xfs_bmap_util.c, does the
subsequent lookup unconditionally find the written Merkle tree extents past
EOF for fully constructed fsverity files?

Because the Merkle tree is stored as written extents past EOF,
xfs_iext_lookup_extent() will find these blocks and return true.
This triggers xfs_free_eofblocks() on every cache eviction. Any
unprivileged user reading fsverity files could cause natural VFS
cache churn, potentially triggering an expensive transaction path
on every eviction.

[ ... ]
> @@ -593,15 +604,20 @@ xfs_free_eofblocks(
>  	 *
>  	 * Note that this means we also leave speculative preallocations in
>  	 * place for preallocated files.
> +	 *
> +	 * Clean up delalloc reservations for fsverity too as those won't be
> +	 * used
>  	 */
> -	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
> +	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND) ||
> +			has_verity) {
>  		if (ip->i_delayed_blks) {
>  			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK,
>  				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
>  				LLONG_MAX, NULL);
>  		}
>  		xfs_inode_clear_eofblocks_tag(ip);
> -		return 0;
> +		if (!has_verity)
> +			return 0;

[Severity: Medium]
Does clearing the EOF blocks tag here in xfs_free_eofblocks() permanently
leak unwritten extents if the subsequent transaction or truncation fails?

If xfs_trans_alloc() fails or xfs_itruncate_extents_flags() encounters an
error (for example, due to memory pressure during extent split in
xfs_bunmapi_range), the code jumps to err_cancel without restoring the
XFS_IEOFBLOCKS tag. Because the radix tree tag is missing, the background
blockgc worker will never revisit this inode to retry the cleanup.

>  	}
> =20
>  	error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> @@ -613,6 +629,9 @@ xfs_free_eofblocks(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
> =20
> +	if (has_verity)
> +		bmapi_flags |=3D XFS_BMAPI_UNWRITTEN;
> +
>  	/*
>  	 * Do not update the on-disk file size.  If we update the on-disk file
>  	 * size and then the system crashes before the contents of the file are
> @@ -620,7 +639,7 @@ xfs_free_eofblocks(
>  	 * bug).
>  	 */
>  	error =3D xfs_itruncate_extents_flags(&tp, ip, XFS_DATA_FORK,
> -				XFS_ISIZE(ip), XFS_BMAPI_NODISCARD);
> +				XFS_ISIZE(ip), bmapi_flags);

[Severity: High]
While no blocks are unmapped here (since the Merkle tree is written,
not unwritten), does xfs_itruncate_extents_flags() unconditionally
dirty the inode core via xfs_trans_log_inode() and commit the
transaction?

Coupled with xfs_can_free_eofblocks() unconditionally returning true
for fsverity files, this appears to cause severe write amplification
and unnecessary journal traffic every time a fully constructed,
read-only fsverity file is evicted from the VFS cache.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D14
