Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05CD4DBD62
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731663; cv=none; b=oYREAms9/N9+EqLtaFZ1S5kDxwWgbYaKjX4jwtnFM54TbiMOa9dan+3/4kAjZ1Xm1AWMAsVUjWLL8WBHiUDdW1lSgwqZ9B/it+uFpWONPndf5bjBJtB/zzEYcTNZzmN2YVsM5g++2Ue+r5j9g339JeZmsabcL9W06JsOCHhB7GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731663; c=relaxed/simple;
	bh=wteXjEC+cQabTsH73C5cNlaPYJOAF/m5J3l1sFOgs0w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AdyNKwlPrrPE+7Rtr0d/HmUfbHtFEiIAErg3BFWFxIkZ2GPX8CXu41gzRhfowtIVN4VIN7/LcFPsQddIg3R/15SM+zZzaQR8GD1rCkDTiIVpm/HD8JIL5EeJBh7EXEg1pLbanrMx9v82jw2v6GP+wASZjIQCszUAzVf7mJU34es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMlxJ7Er; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMlxJ7Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FB31F00893;
	Fri, 18 Sep 2026 11:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731661;
	bh=+eJALgUHc3YHzFaD8zqe+hk2DZQ3LU4K2L7km27t8uE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jMlxJ7EriCkLgUzptgUiQYo94IttZ6mEKSp9FzBA5TlaJFBA/AtWnbzgDmTtNX6ow
	 1v/ouFiVhbje2r4NrpfRKuN5nphUYIDUzJLVimaTSlsDvVjRxtvEVQZHrP2caeJC/m
	 NLEvJ+VpaBUj06rIHUX5b6D5veJ5jSBW7OisLrNhhCna6wjFxpLi6tuMYgwPFMFZLe
	 lH7LfglM3FPgyJRkZ6B/hj7ljxChnDSYx6qnt75auyhDI/vx2p/OneI7+DW1yPGbY3
	 95++7FbbhXBcTR2kHsoGn/jNDEXdcQr/hOxHvJPlH0I/Qdn6y2yuOYD1PysvTnMAiI
	 5BiPiYg4wCSkQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 19/21] xfs: check and repair the verity inode flag
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: dsterba@suse.cz, linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260918111539.1003439-20-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-20-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:40:59 +0000
Message-Id: <20260918114100.E7FB31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] xfs: scrub silently removes fs-verity protection on capability mis=
match
- [High] xfs: TOCTOU race in fsverity open triggers kernel panic
--

commit f41f7f55dbc0aa68b4ef7ee729b6b2e8b291d72f
Author: Darrick J. Wong <djwong@kernel.org>
Subject: xfs: check and repair the verity inode flag state

If an inode has the incore verity iflag set, make sure that we can
actually activate fsverity on that inode.  If activation fails due to
a fsverity metadata validation error, clear the flag.  The usage model
for fsverity requires that any program that cares about verity state is
required to call statx/getflags to check that the flag is set after
opening the file, so clearing the flag will not compromise that model.

> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index e5233e31abb75..02b68bf4c5127 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
[ ... ]
> @@ -1754,3 +1756,56 @@ xchk_inode_count_blocks(
> +int
> +xchk_inode_setup_verity(
> +	struct xfs_scrub	*sc)
> +{
> +	int			error;
> +
> +	if (!fsverity_active(VFS_I(sc->ip)))
> +		return 0;
> +
> +	error =3D fsverity_ensure_verity_info(VFS_I(sc->ip));
> +	switch (error) {
> +	case 0:
> +		/* fsverity is active */
> +		break;
> +	case -ENODATA:
> +	case -EMSGSIZE:
> +	case -EINVAL:
> +	case -EFSCORRUPTED:
> +	case -EFBIG:
> +	case -ERANGE:
> +	case -EBADMSG:
> +		/*
> +		 * The nonzero errno codes above are the error codes that can
> +		 * be returned from fsverity on metadata validation errors.
> +		 */
> +		return 0;

[Severity: High]
Does this code silently remove fs-verity protection on capability mismatche=
s?

The switch statement in xchk_inode_setup_verity() returns 0 for compatibili=
ty
mismatch errors like -EINVAL and -EFBIG from fsverity_ensure_verity_info().
This treats capability/compatibility mismatch errors as metadata corruption,
allowing xchk_inode_verity_broken() to flag the inode as corrupt because
fsverity_get_info() failed.

As a result, running xfs_scrub on a valid fsverity file system mounted on a
platform with different capabilities (e.g., 64K block size mounted on a 4K
page system, or lacking a specific hash algorithm) will silently and
permanently strip the file's verity protection.

> +	default:
> +		/* runtime errors */
> +		return error;
> +	}
> +
> +	return 0;
> +}
[ ... ]
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index abfcab86928e6..b43b39662b687 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
[ ... ]
> @@ -2035,6 +2041,27 @@ xrep_inode_unlinked(
> +STATIC int
> +xrep_inode_verity(
> +	struct xfs_scrub	*sc)
> +{
> +	struct inode		*inode =3D VFS_I(sc->ip);
> +
> +	if (xchk_inode_verity_broken(sc->ip)) {
> +		sc->ip->i_diflags2 &=3D ~XFS_DIFLAG2_VERITY;
> +		inode_set_flags(inode, 0, S_VERITY);

[Severity: High]
Can this code trigger a race condition and a kernel panic?

When xrep_inode_verity() clears S_VERITY from the inode here locklessly, it
can race with the VFS open path. If Thread A opens an fsverity file and
fsverity_file_open() locklessly checks IS_VERITY(inode) successfully, Threa=
d B
could concurrently clear S_VERITY during scrub here.

When Thread A proceeds to xfs_fsverity_get_descriptor(), it will execute
ASSERT(inode->i_flags & S_VERITY) before taking the XFS ILOCK, causing a
panic on debug kernels because Thread B just cleared the flag.

Additionally, this is where the security protection is permanently deleted
from the inode based on the assumption in xchk_inode_setup_verity() regardi=
ng
compatibility mismatch errors.

> +
> +		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
> +	}
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D19
