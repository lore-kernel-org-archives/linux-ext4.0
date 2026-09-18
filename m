Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E2B495AE2
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731789; cv=none; b=fK6Lg1JKg6eaQOa+UBgmiUd57Swpb2wPwlXvVDDeWMFvQv/lAWcbRb+bXXBIbLSeT2LbNhc5B2EXUOuDsX/EnBURVpFko+BJTQqGQSRSwz3rlGQITHvu+Yh+F1q5mIKOOn8hcD/NgVnMeFkQ6oehJTvvpRhhkgeU0U4DHkr9NiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731789; c=relaxed/simple;
	bh=MoNvXJkjpXnC+EUf2feqd5x8dq+0PhchZIriJ42xFAA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=c60JGqcIH8i3XGBDctNOj/d6TCnUczE2KtpgqeD0PZR8SxXN95lwSzU7y7cjcJ7Z34jkwDMRLZZlevg+q6IdyzgrKQuyNRpB7gBd6wO8vzJeqPiWNeSO09nYK3sqrxbNr07kXhHjjOjYNEoeQgORNNrhvcIISOLLS2V7RFZidJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cA8BZKg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cA8BZKg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C7F1F000FF;
	Fri, 18 Sep 2026 11:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731788;
	bh=Q71i5kTa96nOTCRVpBQuMdczpbPJNlsfA36GNAlWFKo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cA8BZKg2XyEHZvr1r583+y1IPRx4lRyzi3ZRXm+VwPB3V0THT6bToCVOFbrDL7ri8
	 q5dSW+pyfq6ZTRB32A3nU9Q3pLiCJFFGDQpWuag5uqn+AHiLCpEud3xn7L7S9OJRle
	 FMAteTJX3b2rQke021uQEIQIVdirOg0+gl6zEQtQZOs1zw/IIYCH+1CNR0rNsBstFm
	 Hb4aIz1mXU+ULUFS0TaG+8hP7NtMdh5fUaRk6cVjBirD9aZ2FZ4I59sG7+vuer+WfK
	 caWgGBQRXjMr5fE3OumZvWlC8NqmzyCM5SNGyrz7ZhdIwzTmO0e2yU/cS0uRuSASf7
	 IotmRywBt2jQw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 15/21] xfs: add fs-verity support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20260918111539.1003439-16-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-16-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:43:07 +0000
Message-Id: <20260918114308.03C7F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] xfs: AB-BA lock inversion in xfs_fsverity_delete_metadata()
- [High] xfs: verity metadata destroyed after commit on xfs_free_eofblocks =
failure
- [Low] xfs: duplicate xfs_fsverity_delete_metadata call on cleanup failure
--

commit 2cf0e89721e69aa45ac23d60792bafc833b86f51
Author: Andrey Albershteyn <aalbersh@kernel.org>

xfs: add fs-verity support

This commit integrates fs-verity with XFS, storing the Merkle tree and=20
descriptor in the data fork past EOF. It sets up the enablement process
and handles read and write operations for the verity metadata.

> --- a/fs/xfs/xfs_fsverity.c
> +++ b/fs/xfs/xfs_fsverity.c
[ ... ]
> +static int
> +xfs_fsverity_delete_metadata(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_trans	*tp;
> +	struct xfs_mount	*mp =3D ip->i_mount;
> +	int			error;
> +
> +	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> +	error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> +	if (error) {
> +		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> +		return error;
> +	}
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));

[Severity: High]
Does this sequence create a lock inversion between the page/folio locks and
the XFS_ILOCK?

XFS lock ordering rules require folio locks to be acquired before the log s=
pace
reservation (xfs_trans_alloc) and the XFS_ILOCK. Because truncate_inode_pag=
es
sequentially locks folios, calling it while holding XFS_ILOCK_EXCL could ca=
use
an AB-BA deadlock if a background thread (like writeback) has locked a folio
and is concurrently trying to acquire the XFS_ILOCK for block mapping.

Could truncate_inode_pages be moved outside the transaction and before
acquiring XFS_ILOCK_EXCL?

[ ... ]
> +static int
> +xfs_fsverity_end_enable(
> +	struct file		*file,
> +	const void		*desc,
> +	size_t			desc_size,
> +	u64			merkle_tree_size)
> +{
> +	struct inode		*inode =3D file_inode(file);
> +	struct xfs_inode	*ip =3D XFS_I(inode);
> +	struct xfs_mount	*mp =3D ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			error =3D 0;
> +	loff_t			range_start =3D xfs_fsverity_metadata_offset(ip);
> +
> +	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
> +
> +	/* fs-verity failed, just cleanup */
> +	if (desc =3D=3D NULL) {
> +		error =3D xfs_fsverity_delete_metadata(ip);
> +		goto out;
> +	}
[ ... ]
> +	/*
> +	 * Ensure that we've persisted the verity information before we enable
> +	 * it on the inode and tell the caller we have sealed the inode.
> +	 */
> +	ip->i_diflags2 |=3D XFS_DIFLAG2_VERITY;
> +
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	xfs_trans_set_sync(tp);
> +
> +	error =3D xfs_trans_commit(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	if (error)
> +		goto out;
> +
> +	inode_set_flags(inode, S_VERITY, S_VERITY);
> +
> +	/*
> +	 * Proactively remove unwritten extents left by COW preallocations and
> +	 * write preallocation in the merkle tree holes and past descriptor,
> +	 * and any delayed preallocations
> +	 */
> +	error =3D xfs_free_eofblocks(ip);
> +out:
> +	if (error) {
> +		int	error2;
> +
> +		error2 =3D xfs_fsverity_delete_metadata(ip);

[Severity: Low]
Is it intentional to call xfs_fsverity_delete_metadata a second time if the
initial early cleanup fails?

If desc is NULL at the start of the function, xfs_fsverity_delete_metadata =
is
called. If that call returns an error, it jumps to the out label. Because
error is preserved, this block executes and calls xfs_fsverity_delete_metad=
ata
again with the exact same failed state.

[Severity: High]
Can a failure in xfs_free_eofblocks cause the metadata of a fully committed
verity inode to be destroyed?

If the verity enablement is successful, the transaction is committed via
xfs_trans_commit and the inode is permanently marked with XFS_DIFLAG2_VERIT=
Y.
If the subsequent post-commit optimization call to xfs_free_eofblocks fails
(for example, due to memory constraints or space issues), it returns an err=
or,
which leads directly to this unconditional cleanup path.

This deletes the Merkle tree and descriptor extents. Because the on-disk fl=
ag
was already committed, the file remains verity-enabled but loses its metada=
ta.
This would permanently fail verity validation and lock the user out of their
file.

Should this cleanup be skipped if the transaction has already been committe=
d?

> +		if (error2)
> +			xfs_alert(ip->i_mount,
> +"ino 0x%llx failed to clean up new fsverity metadata, err %d",
> +					I_INO(ip), error2);
> +	}
> +
> +	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
> +	return error;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D15
