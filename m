Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794389793;
	b=tVbCgW1jZjJ/vWYSCXElART9DYvNAEAB3fn9b29pFLKwkVYB5Kk8/pDprRCp7nNM6Li+
	 tqSxO6TkVUA1KKsl0nJXP1vl+AVYLBRDPMx1fYKPRoC905mdVKlLcaEnbk2Iu/4l1qzYU
	 nHEBn70ckCQMFPBrPxHV9rPWH5nDqDMWwN/l/9Uvr7GZwqy5B1GatFzjjm3CtFPwD2+Eb
	 92L5wsjodnu+wcZjz5KfyMkVyc1O128Mwrx5SyWdHnlIbIHlQn8xP90bnqVTvegu93OoE
	 AnHjU9F+YmpwmaUDu/Zqrz3yzf941kO+D5jqFfLsWY3eCwSfyeAbzIJmcPPkQ/FT6wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794389793;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LJNb3lZ6t5sFOGVn3CCAi04LzEeZdHbIsSE+XUn+En8=;
	b=kCAvl2rKdDNJeSEqJWtx7I0DCuYqLBKqXwZc4UasvTaKGLn4uOQzD5VGr3vzXdh/biwl
	 itEEFbULTPPFO2yDdd0jtAvXKc7YngOVBHUKuJxcAcgJqzrk/SaRuQEabs0BLNCrM8gfr
	 mho7MnukV6oq5UZMPuIHcKOnFplNnWbp4tLZLqWuMDmTUJMPZC9ukgmKqsNxA72sjMjCG
	 qiX5HLc5SLF4RltI/fZYGk05MN/4te21H+/T+oGzaHkz8NNnieOKfra2/5m1S10/U1/Nf
	 ilBKhTQzQ7AHwe6LFkr7oddjKslmCtlRIeNmCTeoGDw/qLuCS3bXCN6SlZnTgs9S1PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnAJOnka;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A4D606A321;
	Wed, 11 Nov 2026 09:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hnAJOnka
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851D61F00A05;
	Wed, 11 Nov 2026 09:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389793;
	bh=LJNb3lZ6t5sFOGVn3CCAi04LzEeZdHbIsSE+XUn+En8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hnAJOnkaTiUIgD29xN8uy/N56NBdY8A0ox3+/FrL5khLxHOW6B2l8W6nLGQl0PrYn
	 YRIvPTe6YF/F3tDZ1iLBZGjGcQRZYlJw5bXJPcMcr4qQhGB4HxcWH9xifBMAN/DXpi
	 QWygDMgiN3z6tAu8U0RscVHXhqpoNah8jj1ZzNOEaeU23RuYUbjC936+XyAQaUulCP
	 ZSxB3xwlGnJ8DdjO6p2DUu/+Hkvccj4/VCaDe1sJf8V2z8QoHYGPeGCbdY4UVTKsk7
	 roysdqQ5a7H/LXUQtnyn7UPieCP10CHPFcxaoYQl/wQsVAGM/0iByy97QqdujK4SQx
	 NdUm0GDBliRRg==
Date: Wed, 11 Nov 2026 10:36:26 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 26/34] gfs2: don't set SB_RDONLY on withdraw
Message-ID: <20261111-sangen-klagen-klonen-331f995b9cdc@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-26-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191245@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191245@kernel.org>

On Fri, Oct 30, 2026 at 04:10:10PM +0000, sashiko-bot@kernel.org wrote:
> which submits writes for those dirty resource group buffers to the block
> device without reaching gfs2_write_inode(). Should gfs2_aspace_writepages()
> also check gfs2_withdrawn(sdp)?

No. sd_inode comes from new_inode() and is never hashed so
__mark_inode_dirty() never puts it on a writeback list.
sync_filesystem() doesn't write it back.

> If a freeze is triggered via freeze_store() in fs/gfs2/sys.c or
> gfs2_freeze_func() in fs/gfs2/super.c (which call VFS freeze_super()
> directly rather than gfs2_freeze_super()), or if a withdraw completes during
> the msleep(1000) retry loop in gfs2_freeze_super() after the initial
> gfs2_withdrawn(sdp) check above, won't freeze_super() succeed on the
> withdrawn filesystem and leave s_writers locked? Should gfs2_freeze_fs()
> check gfs2_withdrawn(sdp) outside the SDF_JOURNAL_LIVE check?

freeze_super() succeeded on a withdrawn filesystem before as well via
the read-only shortcut. Now it takes s_writers and thaw_super()
releases them again because SB_RDONLY doesn't change in between. That's
the point of the patch. A withdraw during the retry loop makes
gfs2_lock_fs_check_clean() fail and the freeze is undone.

> When gfs2_lock_fs_check_clean(sdp) fails in gfs2_freeze_super(), doesn't
> calling gfs2_do_thaw() below re-initialize sdp->sd_freeze_gh while it is
> already queued and holding sdp->sd_freeze_gl in LM_ST_SHARED mode?

Pre-existing.
