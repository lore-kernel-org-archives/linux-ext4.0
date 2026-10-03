Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CC338D686
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991264; cv=none; b=S8nq3+l38ip/9r6dIoGqlzygqZ7safuQSzlBDqG+dCN2BqkZMKzCzpRhb4wlbPhkma0zjflbd5ow6p1xbc0NntzhQw9V7jR8skbTsMUPyCYZWs83A2w4byrRsa/I8X3l3gcuVqmqkhOmrA+4hDQxtoW07ZSN3HNCoeM9P0IjFGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991264; c=relaxed/simple;
	bh=F+tHIKS1fnH+rnipL73Gf4B3bSniQXPQ1xCcfbajLk4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CBYjv2uVUmZeW/s58DGaYKegNuK3ZlTm6n+CfSwxv7bqNPxY5BEoZS1xPON69/W91CLGJGOKecIzJ2QrQIjv3m8piz4JQ8khINLliw/G4lx7ivSfRlOlbZXfKU+5J3E3c/i41Ry85lfaBeFUneNUycMF+Z2DtmYv1Ccs6w1VCFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TerrwNGh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TerrwNGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708321F00893;
	Sat,  3 Oct 2026 01:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991262;
	bh=x7vMuR5AcU1jSWw2WHJu8galDlc8EMn6cPwWJMVwloQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TerrwNGhhOKb/DzepP3rjV7a+qOKU43MvTZX9Q+MjD+YoejT73hEehDCxvF/GJkUR
	 X0Iy4Yl1GQ3dhAHKKxrH1Z/tY48bNoIU8l4nwCU9McJCFX7pMnkadvJH3sdgqALZ8Z
	 YBUzxy45QG4KGDiP/F8inLxwaT7GsZX589XnwMHmQSwlL8LzN3ANYF2mU1xICl4ocL
	 Jj4ZiZJWHUaJySuHLwCGSI10kXC2+XgsxHHV7O+4pAEeEFFgvmSTCqv1JfK0D8PW8d
	 dGH3LmKSjaV/1OyJX9C9rzwDiR922GQB20Mq4tUSVszbISxeMdKmwL4iaITnhf2dCC
	 jLrytqSumL4bg==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 15/21] xfs: add fs-verity support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20261002223705.2175542-16-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-16-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:22 +0000
Message-Id: <20261003013422.708321F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] xfs: AB-BA lock inversion deadlock in xfs_fsverity_delete_metadata
- [High] xfs: inconsistent on-disk state after fs-verity enablement optimiz=
ation failure
- [Medium] xfs: resource leak when fs-verity enablement is aborted
--

commit e2140f5468115bfa6cf4b74f36f51ee2780f1c23
Author: Andrey Albershteyn via Linux-f2fs-devel <linux-f2fs-devel@lists.sou=
rceforge.net>

xfs: add fs-verity support

This commit adds integration with fs-verity for XFS. It introduces reading
and writing the Merkle tree through the iomap interface and stores the
verity descriptor in the inode data fork past EOF.

> diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> index 976e05257bf90..8cffcafc19aa0 100644
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
> +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));

[Severity: High]
Could this lock ordering lead to an AB-BA deadlock?

In XFS, folio locks must generally be acquired before transaction allocation
to prevent deadlocks with memory reclaim or writeback threads that may hold
the folio lock while waiting for transaction log space.

Here, xfs_trans_alloc() is called before truncate_inode_pages(), which
acquires the folio locks.

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
> +	if (desc =3D=3D NULL)
> +		goto out;

[Severity: Medium]
Does this abort path leak blocks allocated for the Merkle tree past EOF?

When the core calls xfs_fsverity_end_enable() with desc =3D=3D NULL to sign=
al
an abort, this code jumps to the out label.

Because error is initialized to 0 and not updated here, the cleanup block
at the end of the function (which checks if error is non-zero) is skipped.

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
> +		error2 =3D xfs_fsverity_reset_inode(ip);

[Severity: High]
Can this sequence result in an inconsistent on-disk state?

If xfs_free_eofblocks() fails, the XFS_DIFLAG2_VERITY flag has already
been committed to disk in the previous transaction. The code then calls
xfs_fsverity_reset_inode() to revert the enablement in a new transaction.

If a system crash occurs between the two transactions, or if allocating
the second transaction fails, the file could be left permanently sealed
on disk, but unsealed in memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D15
