Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C76A451981
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703326; cv=none; b=q8qW2Opqma+PWK7wE9qimm9bVV3llU1975YnzY3MONY5dW2mW0XNP64KvgICB8xP4jivYbuq5Rb1F5SK1jXJi2GQjOBj4MBQsUplXsTvnrJmSpxJLrkJvER62hhCM0kRuOAgHBG2XO0N9mt22CDtlPMBD31H+jqLEHUoVLhJKCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703326; c=relaxed/simple;
	bh=HbMXl5IP2jBCC2mnCxaeUQ692U3RHM5JAjiGqup7qgo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=svVx3WDFslTvbYn8wtOZTdNMojFuJ1ZGFV6OFQbS2fZCEyIGubvqhAxmmS34WMI6qEo0B6oPmrCtvSilA6YtDvC75P8AMoy05M0PZAgHa+Nwebi7AOkw3cZ6m0JlQox8g4WkB/2dgJ/J++nGnkKaCYmwJVcM25I1OfuD4wJhteY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Al2yaQI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Al2yaQI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF8F1F00A3A;
	Fri, 14 Aug 2026 10:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786703317;
	bh=/pMhFEa/915+8Dkl+IKeUuSp7/tpcPd5Kd8gG/nM6Fo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Al2yaQI5raynFo4ixyHtVQsP4tNuL3qBF7rcQOFz8I1VXmnMpxeGzEelxdbPcD/ri
	 DIOLf9wVhtXYmFDiNuiZ/QijOQJL+PkcB+fUMMENEspaQxMYJrirmEie08V6XsUIEJ
	 jMfWmSAKJr3TUv2OOfTn7TYNhy6iTMsGml6MFPkxNI9pmFiEKdPjYz6VgERuboJ6Aw
	 k8HLMYjmetwONZgpowi5fljaFAhCcW64mw7fUcuFS1uXUAh8Hi3gbbzW93VH1DRrKe
	 eH2m2avLFICk/UqFjgyNuXPPtELqEJAuJkvmBRYT8+1GTZo4mZwX3YI7hyFZX9oS3c
	 jLM81CpqLYbUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 26/32] ext4: submit and wait for disksize-grow
 I/O in fallocate paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-27-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-27-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:28:37 +0000
Message-Id: <20260814102837.9BF8F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] In `ext4_do_fallocate` with `O_SYNC`, the fast commit can execute =
before the workqueue updates `i_disksize`, resulting in lost file extension=
 on crash.
--

--- Patch [26]: [PATCH -next v5 26/32] ext4: submit and wait for disksize-g=
row I/O in fallocate paths ---
commit 918bb376bb323b629f0c4b2e5c84c055d7c4c754
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: submit and wait for disksize-grow I/O in fallocate paths

Collapse range and insert range update i_disksize directly under
i_data_sem. If the operation runs while the zeroed EOF block is still
awaiting writeback, i_disksize could advance past the zeroed boundary
before the zeroed data is persisted, exposing stale data on crash.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index fc5aa2dbefcff..dda6d50e96e30 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4928,10 +4938,20 @@ static long ext4_do_fallocate(struct file *file, =
loff_t offset,
>  	if (ret)
>  		goto out;
> =20
> -	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) &&
> -	    EXT4_SB(inode->i_sb)->s_journal) {
> -		ret =3D ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
> -					EXT4_I(inode)->i_sync_tid);
> +	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
> +		/*
> +		 * Sync the pending zeroed EOF block to ensure the
> +		 * i_disksize update is persisted.
> +		 */
> +		if (new_size) {
> +			ret =3D ext4_iomap_sync_zeroed_eof(inode, 0, LLONG_MAX);
> +			if (ret)
> +				goto out;
> +		}
> +		if (EXT4_SB(inode->i_sb)->s_journal) {
> +			ret =3D ext4_fc_commit(EXT4_SB(inode->i_sb)->s_journal,
> +						EXT4_I(inode)->i_sync_tid);
> +		}

[Severity: High]
Can this fast commit execute before the workqueue updates i_disksize,
potentially losing the file extension on a crash?

Looking at the bio completion path in fs/ext4/page-io.c:ext4_iomap_end_bio(=
):

	if (io_mode =3D=3D EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO)
		ext4_iomap_clear_disksize_pending(ioend->io_inode);
=09
	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
	if (list_empty(&ei->i_rsv_conversion_list))
		queue_work(EXT4_SB(ioend->io_inode->i_sb)->rsv_conversion_wq,
		           ...);

It appears the EXT4_STATE_DISKSIZE_GROW_PENDING flag is cleared before the
workqueue is actually dispatched and executed.

If ext4_iomap_sync_zeroed_eof() wakes up immediately after the flag is
cleared, could it proceed to ext4_fc_commit() before the workqueue gets a
chance to update i_disksize?

If a crash happens right after the fast commit in this scenario, would it
persist the inode with the old i_disksize, causing a regression by
violating the requested O_SYNC guarantees?

>  	}
>  out:
>  	trace_ext4_fallocate_exit(inode, offset,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D26
