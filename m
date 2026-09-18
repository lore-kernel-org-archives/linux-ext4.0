Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EBF4E3229
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731401; cv=none; b=h8gLYh1QJ5MosHB2ItCmiLPSReqJtYNkoslfnQKDpbIpvuMe7UQA0Be4FEPgQADq310P6LqeAiYYvJpzJJhSfOOzsOQ5cgNtkT80ny508HLoyjYYrRLLSspDExwWrsB1GI6WHSE+0VgJm2ZHviRZ7t0VFW3p3M0OFotIxdcWWVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731401; c=relaxed/simple;
	bh=os+Fdbqj6Genp7+IImenkIzRTpEBH36Wh2XBT9Fmg1g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kkJYDjsERSfDF2R8vdq8bqghBHjOjBzS6fWfl56RnXCiqqwJxiColsPWwBS881iwtRHcMbDg7MM0iGrGTFiPyPoXaOztVas5ZIUSPUYHRDQfUreFREXS4vdi8lml5ltwK8yYv3LcKAVDlHBSeLJvj/ivLpNYVwGTynsV6zjzgRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BY8AiBp9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BY8AiBp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052551F000FF;
	Fri, 18 Sep 2026 11:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731399;
	bh=BhT3u8j7C2XJ8L17T1ghMcue/OamOHBCznbCOTSJdHU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BY8AiBp9q0bT+4nYqOtbqsqPn6C2YVZxQBuUq+HnMA5Ym5t5RH4zhXuMNVS7DzNAa
	 LVZjYlu6FLaZKyWwa4iYI3d66PJ1tFMnZOGs6Vx6YL9+VJFI4aPLt+5gNJjiiwoNKy
	 6N4Ftf1XyM6pjIory7Q6on/76IQHVmP+udwlWgYpEH5OprWe/G5vwuYQt5bTQUR8rf
	 1qqHxfykGRcG3byCGXePT5IK8cK3xtEfC0NlUyPJ3XZyaLLZHUf3z3tMh0yjiBnw0O
	 ObcNE2pI9awkZp0UYmiuaWFLzhN0uv4girCqkest4/HXnQ5yMJHYvouoNQQQftwWdq
	 P+n7q68hdDFXw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 12/21] xfs: use read ioend for fsverity data
 verification
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: linux-ext4@vger.kernel.org, dsterba@suse.cz, tytso@mit.edu
In-Reply-To: <20260918111539.1003439-13-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-13-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:36:38 +0000
Message-Id: <20260918113639.052551F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] xfs: memory reclaim deadlock and forward progress violation in xfs=
_end_io_read()
- [High] xfs: synchronous Merkle tree read stalls bio completion in xfs_end=
_io_read()
- [Medium] xfs: memory leak of xfs_parent_args_cache on init error path
--

commit 798d972634a53a99bff867f7211b6d47638362a9
Author: Andrey Albershteyn <aalbersh@kernel.org>

xfs: use read ioend for fsverity data verification
   =20
This commit uses read ioends for fsverity verification instead of using
the same workqueue for fsverity metadata IO. It passes fsverity_info from
the iomap context down to the ioend, and adds a helper to check if file
data needs verification.

> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index e70be5b86f0b7..2f46855b052fd 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c

[ ... ]

> @@ -117,6 +138,36 @@ xfs_end_io_read(
>  		}
>  	}
> =20
> +	/*
> +	 * If we have fsverity and block device integrity attached to this bio,
> +	 * we need to run fsverity verification of data folios from a separate
> +	 * fsverity workqueue. This is necessary to avoid deadlocking due to
> +	 * fsverity issuing more reads of fsverity metadata which would be
> +	 * processed by the same worker in the BIO completion workqueue.
> +	 *
> +	 * Without block device integrity, fsverity metadata IO will not use
> +	 * ioends for completion.
> +	 */
> +	if (IS_ENABLED(CONFIG_FS_VERITY) && !error && ioend->io_vi &&
> +			xfs_fsverity_is_file_data(ip, ioend->io_offset)) {
> +		if (ioend->io_flags & IOMAP_IOEND_INTEGRITY) {
> +			fsv_ioend =3D kmem_cache_zalloc(xfs_fsverity_ioend_cache,
> +					GFP_KERNEL);

[Severity: High]
Does this allocation risk a deadlock? xfs_end_io_read() executes in a block=
 IO
completion context (like task_work or the block layer bio_complete_wq). Usi=
ng
GFP_KERNEL here allows direct memory reclaim, which can block waiting for
dirty pages to be written back and their IO completions processed. Waiting
inside an IO completion worker could create a cyclical deadlock. Should this
use a mempool with GFP_NOIO or GFP_NOWAIT to ensure forward progress?

> +			if (!fsv_ioend) {
> +				iomap_finish_ioends(ioend, -ENOMEM);
> +				return;
> +			}

[Severity: High]
Could failing the IO with -ENOMEM break forward progress guarantees under
memory pressure? It seems that memory allocations in the block IO completion
path need to be backed by a mempool to avoid spurious IO failures when
memory is tight.

> +			fsv_ioend->ioend =3D ioend;
> +			INIT_WORK(&fsv_ioend->work, xfs_end_fsverity_io_read);
> +
> +			fsverity_enqueue_verify_work(&fsv_ioend->work);
> +			return;
> +		}
> +
> +		fsverity_verify_bio(ioend->io_vi, &ioend->io_bio);

[Severity: High]
Can this synchronous verification stall bio completion? When
fsverity_verify_bio() requires Merkle tree blocks that aren't in the page
cache, it synchronously reads them from disk by calling read_mapping_folio()
and waits via wait_on_folio_locked_killable().

Since xfs_end_io_read() is executing in a bio completion context, blocking
here to wait for another disk IO can stall all other async IO completions
queued behind it. Should this verification always be deferred to a dedicated
workqueue?

> +		error =3D blk_status_to_errno(ioend->io_bio.bi_status);
> +	}
> =20
>  	iomap_finish_ioends(ioend, error);
>  }

> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 5a06132aa3846..f34c9645767d5 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c

[ ... ]

> @@ -2516,8 +2516,20 @@ xfs_init_caches(void)
>  	if (!xfs_parent_args_cache)
>  		goto out_destroy_xmi_cache;
> =20
> +#ifdef CONFIG_FS_VERITY
> +	xfs_fsverity_ioend_cache =3D kmem_cache_create("xfs_fsverity_ioend",
> +					     sizeof(struct xfs_fsverity_ioend),
> +					     0, 0, NULL);
> +	if (!xfs_fsverity_ioend_cache)
> +		goto out_destroy_fsverity_ioend_cache;
> +#endif
> +
>  	return 0;
> =20
> +#ifdef CONFIG_FS_VERITY
> + out_destroy_fsverity_ioend_cache:
> +	kmem_cache_destroy(xfs_fsverity_ioend_cache);
> +#endif
>   out_destroy_xmi_cache:

[Severity: Medium]
If the allocation of xfs_fsverity_ioend_cache fails, the error path jumps to
out_destroy_fsverity_ioend_cache. Does this permanently leak the memory
allocated for xfs_parent_args_cache? The error path seems to fall through
to out_destroy_xmi_cache, entirely skipping the destruction of the parent
args cache.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D12
