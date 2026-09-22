Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508353F58D7;
	Tue, 22 Sep 2026 04:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790052634; cv=none; b=ryliU61vyZiw+MQEAdt16Xu4rYK6izgMW3YwIVySzwA23kPvzkybohuqdEAE8AeVh6Y+zXYaaoc3Fml2qglCTDI+J8G8drKpz0DFoRT7d9meD6F9owGbS50lK5ArvUL1Vzq5w/DwChRXUSsr3EGxKsHVU75HFvoWVYGw0GxWa7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790052634; c=relaxed/simple;
	bh=PEP/Q0fLyjjVisI1vEah+1WYgiBoNp6hMMjrhwC22b8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ro/6yDb2T0+/I31fah1DE7sCVl1yVy+z6XhkbNfGEZ4HJz578PT24Y8zNuOKuLemhzS6l90T3RMnIYwcEje2cTKxZ1QlCbwoJH73eIPTy5PT2oQ10ecNZyyx1u7GfzheUrakVfW1SDcnlWgnAnwrI+EjJCCnp0kYH4X40xvaUVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVMQm9iL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVMQm9iL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BF0BF1F0089A;
	Tue, 22 Sep 2026 04:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790052629;
	bh=ojcEIkTjlUsOgOJG1uIbX85ioLtE3VCueZKAgiOoZDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RVMQm9iLHkBaGYRYy85Thk68h0HyKum/oan8ckhZUWTeqZ+6Zh0MwfsMlm08rSKlq
	 zXHkEJpRixKcJEXYQg6/uF0gk0LgMruHHNzwNL2CC5/77nUO4NxRdIa4Z3rnBlVlf6
	 KgClFJJeqtmcRJly80fY/WNjaQEH45DLIqNdeYwGuxZnhAM7JgZ3r9bnCBjZjsHW1X
	 0rOf9X0mMRo+ojr6rDSlhkfxw3iKm+E+kXDqfKEG+gA8Rm2RdrArJDJWpbktfM9oIV
	 UfXOUGGb4fOK8Lt34d0h5cycr2c/yr0qoI99OJOVMRVXIvnaSs3v1ksKAgv+HJEJ/9
	 yt95GwEaNVFng==
Date: Mon, 21 Sep 2026 21:50:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-ext4@vger.kernel.org,
	dsterba@suse.cz, tytso@mit.edu
Subject: Re: [PATCH v16 15/21] xfs: add fs-verity support
Message-ID: <20260922045029.GB6239@frogsfrogsfrogs>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-16-aalbersh@kernel.org>
 <20260918114308.03C7F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260918114308.03C7F1F000FF@smtp.kernel.org>

On Fri, Sep 18, 2026 at 11:43:07AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] xfs: AB-BA lock inversion in xfs_fsverity_delete_metadata()
> - [High] xfs: verity metadata destroyed after commit on xfs_free_eofblocks failure
> - [Low] xfs: duplicate xfs_fsverity_delete_metadata call on cleanup failure
> --
> 
> commit 2cf0e89721e69aa45ac23d60792bafc833b86f51
> Author: Andrey Albershteyn <aalbersh@kernel.org>
> 
> xfs: add fs-verity support
> 
> This commit integrates fs-verity with XFS, storing the Merkle tree and 
> descriptor in the data fork past EOF. It sets up the enablement process
> and handles read and write operations for the verity metadata.
> 
> > --- a/fs/xfs/xfs_fsverity.c
> > +++ b/fs/xfs/xfs_fsverity.c
> [ ... ]
> > +static int
> > +xfs_fsverity_delete_metadata(
> > +	struct xfs_inode	*ip)
> > +{
> > +	struct xfs_trans	*tp;
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	int			error;
> > +
> > +	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> > +	if (error) {
> > +		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> > +		return error;
> > +	}
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, 0);
> > +
> > +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> 
> [Severity: High]
> Does this sequence create a lock inversion between the page/folio locks and
> the XFS_ILOCK?
> 
> XFS lock ordering rules require folio locks to be acquired before the log space
> reservation (xfs_trans_alloc) and the XFS_ILOCK. Because truncate_inode_pages
> sequentially locks folios, calling it while holding XFS_ILOCK_EXCL could cause
> an AB-BA deadlock if a background thread (like writeback) has locked a folio
> and is concurrently trying to acquire the XFS_ILOCK for block mapping.
> 
> Could truncate_inode_pages be moved outside the transaction and before
> acquiring XFS_ILOCK_EXCL?

Yes, it should.

> 
> [ ... ]
> > +static int
> > +xfs_fsverity_end_enable(
> > +	struct file		*file,
> > +	const void		*desc,
> > +	size_t			desc_size,
> > +	u64			merkle_tree_size)
> > +{
> > +	struct inode		*inode = file_inode(file);
> > +	struct xfs_inode	*ip = XFS_I(inode);
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_trans	*tp;
> > +	int			error = 0;
> > +	loff_t			range_start = xfs_fsverity_metadata_offset(ip);
> > +
> > +	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
> > +
> > +	/* fs-verity failed, just cleanup */
> > +	if (desc == NULL) {
> > +		error = xfs_fsverity_delete_metadata(ip);
> > +		goto out;
> > +	}
> [ ... ]
> > +	/*
> > +	 * Ensure that we've persisted the verity information before we enable
> > +	 * it on the inode and tell the caller we have sealed the inode.
> > +	 */
> > +	ip->i_diflags2 |= XFS_DIFLAG2_VERITY;
> > +
> > +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > +	xfs_trans_set_sync(tp);
> > +
> > +	error = xfs_trans_commit(tp);
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	if (error)
> > +		goto out;
> > +
> > +	inode_set_flags(inode, S_VERITY, S_VERITY);
> > +
> > +	/*
> > +	 * Proactively remove unwritten extents left by COW preallocations and
> > +	 * write preallocation in the merkle tree holes and past descriptor,
> > +	 * and any delayed preallocations
> > +	 */
> > +	error = xfs_free_eofblocks(ip);
> > +out:
> > +	if (error) {
> > +		int	error2;
> > +
> > +		error2 = xfs_fsverity_delete_metadata(ip);
> 
> [Severity: Low]
> Is it intentional to call xfs_fsverity_delete_metadata a second time if the
> initial early cleanup fails?
> 
> If desc is NULL at the start of the function, xfs_fsverity_delete_metadata is
> called. If that call returns an error, it jumps to the out label. Because
> error is preserved, this block executes and calls xfs_fsverity_delete_metadata
> again with the exact same failed state.
> 
> [Severity: High]
> Can a failure in xfs_free_eofblocks cause the metadata of a fully committed
> verity inode to be destroyed?
> 
> If the verity enablement is successful, the transaction is committed via
> xfs_trans_commit and the inode is permanently marked with XFS_DIFLAG2_VERITY.
> If the subsequent post-commit optimization call to xfs_free_eofblocks fails
> (for example, due to memory constraints or space issues), it returns an error,
> which leads directly to this unconditional cleanup path.
> 
> This deletes the Merkle tree and descriptor extents. Because the on-disk flag
> was already committed, the file remains verity-enabled but loses its metadata.
> This would permanently fail verity validation and lock the user out of their
> file.
> 
> Should this cleanup be skipped if the transaction has already been committed?
> 
> > +		if (error2)
> > +			xfs_alert(ip->i_mount,
> > +"ino 0x%llx failed to clean up new fsverity metadata, err %d",
> > +					I_INO(ip), error2);
> > +	}
> > +
> > +	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
> > +	return error;
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260918111539.1003439-1-aalbersh@kernel.org?part=15
> 
