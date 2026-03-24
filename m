Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB2F376BD1;
	Tue, 24 Mar 2026 05:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774331086; cv=none; b=R04PKbCAWLkrbYvea2+dOdqEz4Z5YoNsTrIzzCWYGWmrVcQIE4Ltq1FsndHApE/Ah/83TLWe+qoYRNfvz+t/JwXys6OWBJifUsJjdyqL+5CYlPuDG1n1nY/AhON9IpywHsWJmVEyizWhT3demtDWIepZa0BWbcmr4wC8YCmiGZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774331086; c=relaxed/simple;
	bh=u80CsZODeG6irf5u2xOUtJrKJf7L4g4lX/U0gO/66/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aTTVUfrWSGrxGLXxQ5aZ5BlaI2rPfrjJL2MOyBTj305eH5VuGhIA6rXMmPaiA+Iwm2LirRKUzsvbFwvyarULlr8aExl9rc2nN2PCyYiDVsU9IV26ZPA0SplXvn13Mcn5kV78zRreOGZg4d5FByr7A8KGF9TbtSmJm8Ft6SJxiJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dEGXd9XL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dEGXd9XL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TJSpyLlDxsX0ZK8TeLmNwhtIyO/N8+F7Fznx2ukIrjM=; b=dEGXd9XLuMSNvA3shZW+Yw6uUz
	ljv7S2+TIsFyS4iakEw2OIJnajy67gH9ZTteJDB8uFEyCEuWHY7WCVrTGDrksamMb+F6fTrO4nyGL
	Nz1pFn5RvAFwlXp9EhfejJzhqMOC3FPE5q7A/JDLhmgXYw9Cgcdh9iAqIJmOjSpxv40BqHOhtu/n+
	Y8cm6DHlXB9Ij8LLNJRJ6wG7JWA7xvghX4JhXRumRIB9k6ZSRCwXneAicC8dUrI1XiHZf/03gt6gA
	TCH/CrHPaZr8eDGf3BygnAR3om49oI8lgXrHpKQ3FwoIMGcC6SV0BW9RgjhtAnGtSMidm6MxS1ifS
	OevD0W4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uZI-00000000cHo-1CP3;
	Tue, 24 Mar 2026 05:44:44 +0000
Date: Mon, 23 Mar 2026 22:44:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 27/41] fs: Fold fsync_buffers_list() into
 sync_mapping_buffers()
Message-ID: <acIkzIW07H1UUVvu@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-68-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-68-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
> -		get_bh(bh);
> -		mapping = bh->b_assoc_map;
> -		__remove_assoc_queue(bh);
> -		/* Avoid race with mark_buffer_dirty_inode() which does
> -		 * a lockless check and we rely on seeing the dirty bit */
> -		smp_mb();
> -		if (buffer_dirty(bh)) {
> -			list_add(&bh->b_assoc_buffers,
> -				 &mapping->i_private_list);
> -			bh->b_assoc_map = mapping;
> -		}
> -		spin_unlock(lock);
> -		wait_on_buffer(bh);
> -		if (!buffer_uptodate(bh))
> -			err = -EIO;
> -		brelse(bh);
> -		spin_lock(lock);
> -	}
> -	
> -	spin_unlock(lock);
> -	return err;
> -}
> -
>  /*
>   * Invalidate any and all dirty buffers on a given inode.  We are
>   * probably unmounting the fs, but that doesn't mean we have already
> -- 
> 2.51.0
> 
> 
---end quoted text---
