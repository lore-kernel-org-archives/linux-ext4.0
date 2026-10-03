Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95E838DC77
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991265; cv=none; b=qXZ7N57rdvKJzq0DpBvuIBDvxrbby8R83I7t7E92YrNe5vw5JJd+TkCCI/Q19rDZcx9iozsJLdyaXePathzdn3QTrAOTE/19z66Rcj9JmQswqvp2Ln6WrTFUj6Y6wND+/qm0pI4F3crU66TEB2RBEytZCJhgLav0yYG8Qf7GJPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991265; c=relaxed/simple;
	bh=Ue/aXPLQ5AYPNUDTdSeGr4IFZEsAy3wwnRUV49usvTE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UwFOS+9fiCupWR4knqm8J8QxRyYcEKdJgWMp4l61E08HCo7tK+OYiJgZY5lQzmEO0nGvxy5mcCX2ZYEsUFu84LZipXIuAJSV5G9zWqoH8q95uHWc3eXxzZgKUhy0XWGT8qeSHpws1Bd1py259hTqq8xr46CfUL2pW9OjtjPzWxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJA/EodF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJA/EodF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F4E1F00899;
	Sat,  3 Oct 2026 01:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991263;
	bh=iAc2SJPMx1kpAYE7t6Ztsj/T6PG+UB1BAqXGjjzUQiA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZJA/EodFPHV96PyxnGvMoT0+G0GL8MCdeDz74QiGlgPH5u+ySh7qAJPGrTz7/W6zI
	 h2LTA6NnN+KtutkD6OYry5tqOHFje16kC//D908PKPPjyAve+a9ljF2CueGUozX4pG
	 dIOq/QIasq6GDZaRsxzqoZ+F2bPdRBs+I5b3DBFUj//vJbMuPMz5StTI48yBO0vkvb
	 TGMhibjM2pu71/O9vpWkKuwe9oKHIgcM7u6vLQFVAlAIUaDqkS+dMB27JRSnFAGX2F
	 F+BCUFf9N5X53sWBsiMXQ3vZxHlYswrxeU0Q7fcvORb7Ai3NFpMxkuV7CkJojqub4E
	 GajwD2iwSPuOA==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 12/21] xfs: use read ioend for fsverity
 data verification
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dsterba@suse.cz
In-Reply-To: <20261002223705.2175542-13-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-13-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:22 +0000
Message-Id: <20261003013423.33F4E1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] xfs: deadlock in per-CPU bio completion due to mempool_alloc() wit=
h GFP_NOFS
--

commit ea1a0b2023bf04b556e0f9d798eb8d673f0e72ca
Author: Andrey Albershteyn via Linux-f2fs-devel <linux-f2fs-devel@lists.sou=
rceforge.net>

xfs: use read ioend for fsverity data verification

This commit uses read ioends for fsverity verification, moving fsverity
metadata I/O to a separate workqueue to avoid deadlocks. It passes
fsverity_info from the iomap context down to the ioend and adds a helper to
check for file data.

> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 19640e4e3ed12..a36f840884b49 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
[ ... ]
> @@ -623,11 +624,13 @@ static const struct iomap_read_ops xfs_iomap_read_o=
ps =3D {
> =20
>  static inline const struct iomap_read_ops *
>  xfs_get_iomap_read_ops(
> -	const struct address_space	*mapping)
> +	const struct address_space	*mapping,
> +	loff_t				pos)
>  {
>  	struct xfs_inode		*ip =3D XFS_I(mapping->host);
> =20
> -	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
> +	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev) ||
> +	    xfs_fsverity_is_file_data(ip, pos))
>  		return &xfs_iomap_read_ops;

[Severity: High]
Does this logic route fsverity metadata reads through xfs_iomap_read_ops if
the block device has integrity checksums?=20

Using xfs_iomap_read_ops causes xfs_bio_submit_read() to call
xfs_ioend_submit_read(), which sets BIO_COMPLETE_IN_TASK on the bio. This
means the completions for these metadata reads will be queued to the per-CPU
bio completion worker.

>  	return &iomap_bio_read_ops;
>  }

[ ... ]
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index e70be5b86f0b7..f4c1bbc03714f 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
[ ... ]
> @@ -117,6 +138,24 @@ xfs_end_io_read(
>  		}
>  	}
> =20
> +	/*
> +	 * If we have fsverity on this bio, we need to run fsverity verification
> +	 * of data folios from a separate fsverity workqueue. This is necessary
> +	 * to avoid deadlocking due to fsverity issuing more reads of fsverity
> +	 * metadata which would be processed by the same worker in the BIO
> +	 * completion workqueue.
> +	 */
> +	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
> +			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
> +		fsv_ioend =3D mempool_alloc(&xfs_fsverity_ioend_pool,
> +				GFP_NOFS);

[Severity: High]
Can this result in an ABBA deadlock under memory pressure?

If the memory pool is empty, mempool_alloc() with GFP_NOFS will sleep and
block the per-CPU bio completion worker in xfs_end_io_read().

As noted in xfs_get_iomap_read_ops() above, if the block device has integri=
ty
checksums enabled, fsverity metadata reads will use xfs_iomap_read_ops
and their completions will also be queued to this same per-CPU bio completi=
on
worker.

Since this worker could be blocked in mempool_alloc() waiting for the
fsverity workqueue to finish verifying data, and the fsverity workqueue
could concurrently be waiting on a metadata read completion that is queued =
on
this blocked worker, can this cause a hang?

> +		fsv_ioend->ioend =3D ioend;
> +		INIT_WORK(&fsv_ioend->work, xfs_end_fsverity_io_read);
> +
> +		fsverity_enqueue_verify_work(&fsv_ioend->work);
> +		return;
> +	}
> +
>  	iomap_finish_ioends(ioend, error);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D12
