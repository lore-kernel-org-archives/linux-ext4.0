Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52F6376BD0;
	Mon,  2 Feb 2026 15:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770045481; cv=none; b=UD7YeQpcRhJedyxKC8qZkjhe1nArmUfG5xazmqODNo2IR7XBM0KGM9jeAO6+SOYiBgCOENrLEaslqoPZmPCzL4+zNYfwXi1Up6FiIVx7Gy3jeFu0Zp8MpXPegIBWJ95Q2sSSdPSjE0OqpXLMRZfhDgMTy9dOvLQ2ubBIUfVjBY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770045481; c=relaxed/simple;
	bh=ItSKWaumOM7HpYyVcNPQ+V1Q1W6mCW+aJwTafDtYBIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GvCC6GqMdJBbkwlKIpzTZvfNgNY0ts0zptl80yvgK2rq4oixEFlTh2aK3hDD4IFd+Rqidk5DNUeBPa9/FgDLmlceQj+RD6kLKM31dN3PjrKGCgXcX42j1GCISsIQmHSmZj/1jbcukVprqAp2kKtj+UmIbajD9tZsiWfvMC6AXRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B67D168B05; Mon,  2 Feb 2026 16:17:55 +0100 (CET)
Date: Mon, 2 Feb 2026 16:17:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	fsverity@lists.linux.dev
Subject: Re: [PATCH 02/11] readahead: push invalidate_lock out of
 page_cache_ra_unbounded
Message-ID: <20260202151755.GA22756@lst.de>
References: <20260202060754.270269-1-hch@lst.de> <20260202060754.270269-3-hch@lst.de> <aYC-set6OAK9F9GE@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYC-set6OAK9F9GE@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 02, 2026 at 03:11:45PM +0000, Matthew Wilcox wrote:
> On Mon, Feb 02, 2026 at 07:06:31AM +0100, Christoph Hellwig wrote:
> > +++ b/fs/f2fs/file.c
> > @@ -4418,7 +4418,9 @@ static int redirty_blocks(struct inode *inode, pgoff_t page_idx, int len)
> >  	pgoff_t redirty_idx = page_idx;
> >  	int page_len = 0, ret = 0;
> >  
> > +	filemap_invalidate_lock_shared(mapping);
> >  	page_cache_ra_unbounded(&ractl, len, 0);
> > +	filemap_invalidate_unlock_shared(mapping);
> 
> Why is f2fs calling page_cache_ra_unbounded() here?

From tracing the callers is seems to be able to be called from the
garbage collector, which might have to move fsverity files.  Not sure if
that was the reason or is incidental.

(using the pagecache for GC is generally a very bad idea, and there is
at least one academic paper showing it is a huge performance problem in
f2fs, and my initial attempts at using the pagecache for GC in zoned XFS
also showed horrible results)

> >  	unsigned int nofs = memalloc_nofs_save();
> >  
> > +	lockdep_assert_held_read(&mapping->invalidate_lock);
> 
> Hm, why are we asserting that it's not write-locked?  For the
> purposes of this function, I'd think we want to just
> lockdep_assert_held()?

Fine with me.

> In the tree I'm looking at, there are also calls to
> page_cache_ra_unbounded() in fs/ext4/verity.c and fs/f2fs/verity.c
> which probably need the lock taken too?

I consolidated those into the single call in fs/verity/pagecache.c
in the previous iteration of this series, and Eric merged the
first few patches including that one into the fsverity tree.
