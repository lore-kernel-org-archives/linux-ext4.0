Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA46322DAF;
	Thu,  9 Jul 2026 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783604811; cv=none; b=cHTex22LWF7mbBkdtdFiAJfhe9j68f8vUOLlfS+0VFsagdJ7Yy/flTR80jEqsC2IFuOhWTmMAB7v9wD7beZL4o18p7wiqxsnyI0VqNOCz7OcyKWbIZDUqMAylhfUjjYZMyq3GugjLsZHlUYapUeREnZShfmyK7OlNXVFbt+m83A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783604811; c=relaxed/simple;
	bh=oGHg4067996uNiEtNixTYXz6HafokbvtLz/6EMplmuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bF16pYX1XNhgKMdIWYYn5fVYEkf7/2IQVqEjLzUzwGjqG6sIEzGtUN7Iv3ti73srzc1pDR0Knwf5tF0Ug6mmguKbgu5sUeWseiGuLZT+8zwDdpvKc5dlbAn5G2VhGo3Y75fYiuhK2HW7lrboO4yyr5NQb7ZCws4ChYVCw/fgK+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lf0nvBCM; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lf0nvBCM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2osXVDxgVvuGU+T2YOX7g61cy9uE4ngVaflraIX5Kjs=; b=lf0nvBCMYSHnQRhvptl+at6CaC
	EvJMHEFfJWWszDemx7tscb7Ycv2hjjWE2JqXJ2TT2xLFWfTSPlF9Kuk4eeMdf2MIUCg5aOcxc09Fp
	BX2vcZkhK3Dn5xVXUS2ZPNeOqnE7RYl27Nzr0KSEeDabX9yGWaDyhatT/mCsrogktEST072KUoaa3
	rFMtCJa6VxFMuN+fKtw+qqbVwECq6f+OQyA+vmlyd4DVz9zgz27DnvE2FdgbEGJ01KyRZ4ksPfBsl
	9t8n7Lkhc+1OVUXakQnHWKiiDoT9Khayoi7TZAPbYtOWCDrtZa7GY2+5VopVVRi9QF/qFMba+Io1c
	P7yw5Pqg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whp5P-00000004vCI-3e6I;
	Thu, 09 Jul 2026 13:46:43 +0000
Date: Thu, 9 Jul 2026 14:46:43 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Longxing Li <coregee2000@gmail.com>, Theodore Ts'o <tytso@mit.edu>
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix use-after-free in ext4 delayed I/O completion
Message-ID: <ak-mQ2DnbaxIO_WU@casper.infradead.org>
References: <20260709075613.854-1-coregee2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709075613.854-1-coregee2000@gmail.com>

On Thu, Jul 09, 2026 at 03:56:13PM +0800, Longxing Li wrote:
> ext4_add_complete_io() queues the inode's i_rsv_conversion_work without
> holding an extra reference to the inode. If the inode is unlinked and
> evicted before the delayed work runs, the inode slab object gets freed.
> When ext4_do_flush_completed_IO() later accesses io_end->inode, it is
> accessing a freed/reallocated object -- a use-after-free detected by KASAN.
> 
> Take igrab(inode) when first queueing the work (only when list is empty to
> avoid duplicate references), and drop the reference in
> ext4_do_flush_completed_IO() after processing all io_ends.
> A per-inode bit (i_rsv_need_iput) tracks whether the extra reference
> was taken.
> 
> This is a defense-in-depth fix complementary to the upstream fix
> c678bdc99875 ("ext4: fix inode use after free in ext4_end_io_rsv_work()")
> which adds consistency checks in ext4_io_end_defer_completion(). Both fixes
> address the same root race but from different angles.

Um.  You've cc'd everybody except the maintainer.  And this is already
fixed, but you want to fix it even more?  I don't get it.

(also if this patch isn't AI slop, it's doing a Really Good Job of
pretending to be AI slop.  Why would you choose 'unsigned short' as
the type?)

> Fixes: ce51afb8cc5e ("ext4: abort journal on data writeback failure if in data_err=abort mode")
> Reported-by: Longxing Li <coregee2000@gmail.com>
> Signed-off-by: Longxing Li <coregee2000@gmail.com>
> ---
>  fs/ext4/ext4.h    |  2 ++
>  fs/ext4/page-io.c | 15 +++++++++++++--
>  fs/ext4/super.c   |  1 +
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 56112f201cac..239e6c0a3d3c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1179,6 +1179,8 @@ struct ext4_inode_info {
>  
>  	/* Lock protecting lists below */
>  	spinlock_t i_completed_io_lock;
> +	/* Track if ext4_add_complete_io() took an extra inode reference. */
> +	unsigned short i_rsv_need_iput:1;
>  	/*
>  	 * Completed IOs that need unwritten extents handling and have
>  	 * transaction reserved
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 39abfeec5f36..294c0bcbbb7f 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -262,8 +262,12 @@ static void ext4_add_complete_io(ext4_io_end_t *io_end)
>  
>  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>  	wq = sbi->rsv_conversion_wq;
> -	if (list_empty(&ei->i_rsv_conversion_list))
> -		queue_work(wq, &ei->i_rsv_conversion_work);
> +	if (list_empty(&ei->i_rsv_conversion_list)) {
> +		if (igrab(io_end->inode)) {
> +			ei->i_rsv_need_iput = 1;
> +			queue_work(wq, &ei->i_rsv_conversion_work);
> +		}
> +	}
>  	list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
>  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>  }
> @@ -291,6 +295,13 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
>  		if (unlikely(!ret && err))
>  			ret = err;
>  	}
> +
> +	/* Release inode reference from ext4_add_complete_io. */
> +	if (ei->i_rsv_need_iput) {
> +		ei->i_rsv_need_iput = 0;
> +		iput(&ei->vfs_inode);
> +	}
> +
>  	return ret;
>  }
>  
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 87205660c5d0..10a5d863d9b9 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1418,6 +1418,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  	ei->jinode = NULL;
>  	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
>  	spin_lock_init(&ei->i_completed_io_lock);
> +	ei->i_rsv_need_iput = 0;
>  	ei->i_sync_tid = 0;
>  	ei->i_datasync_tid = 0;
>  	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
> -- 
> 2.34.1
> 
