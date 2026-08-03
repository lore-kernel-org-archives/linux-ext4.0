Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A591420E71;
	Mon,  3 Aug 2026 17:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785779954; cv=none; b=C/PBLbek2ns8nWiWU72FUOcCiZn1Ou+WtWW3EaxHBiAOnn6XvNgFM2VSSwl5lowFNWL71Zyul4LKsUkFoN6+D37bqFk+dBU+1hUI+kjBqnTL4UY+nymP3ayujSPMIHJUSJPkmedLp5imALQLnH1JNpnwHRSw5x4Ol19ah54FRcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785779954; c=relaxed/simple;
	bh=8RCmJrQvQt9kaO5S3tvZXhEV2GqZTqHZBuaZwdzQ+hU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGYLmoiqEe5PQHj9gXkygNgjzdPlCSXkLPIlo6Au8qO1UNrIRgq+LV0iP+pUVOx4+9qO6l7Fwwvql001f0n852RK9rPLtiSZlVKKy3xgeheuO6m+WFdunwI+CbHhf5O68xIG/qv4T+lCJLnSvbnJvIc9avsLnwyay4agIi27Iks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nADF1MGn; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nADF1MGn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Pl2c7BrlzOJDYlK1aKyoCoiFIyQVulE69kQ5jyLfEE8=; b=nADF1MGn6rH+57qpwk1+QoxflY
	6ZQI9eEBKabPcY+qCcfGoYnkvLAL4+1kB9+/b5B6lL+1HYAwQEV+6owC+zI9kSUQ5NR9wPJcgLPRg
	JyJnCKBwEe7w6sgm+4ICX4rHfGMr7kVwSKQ7Rx94S9qb4ykErYTOjBJUGh1+DozNvoDzBR/dyUt+M
	/NsE3zDJcn1kwTINiTlfoiuNkEY4ii+foYvSE0zPmr6eZqBKJclpsiDkKP5pIXftjleN4AlmwYavy
	C1lrK4t4c8rpVj51zMNvikhjL7cUT8/s12XBadrWHbJrS1kR0RmVupsOsY/RdmmXkaXK8JQYaI8FP
	7MCfhqUg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wqwwH-0000000E9qE-1bTv;
	Mon, 03 Aug 2026 17:59:01 +0000
Date: Mon, 3 Aug 2026 18:59:01 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Chao Shi <coshi036@gmail.com>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] buffer: allow a buffer_head to point at memory
 outside the page cache
Message-ID: <anDW5UTbF2d0EQmr@casper.infradead.org>
References: <cover.1785621505.git.coshi036@gmail.com>
 <41c6fee66724e374d4682124a1eb80041e22efb9.1785621505.git.coshi036@gmail.com>
 <z5jfe6bsxhgqqgjtxcm7ass2fslc4ynizvpmzlqxtr6rrfaopu@fxzntlxafmxj>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <z5jfe6bsxhgqqgjtxcm7ass2fslc4ynizvpmzlqxtr6rrfaopu@fxzntlxafmxj>

On Mon, Aug 03, 2026 at 06:13:19PM +0200, Jan Kara wrote:
> On Sat 01-08-26 18:00:46, Chao Shi wrote:
> > jbd2 builds a temporary buffer_head to write out the frozen copy of a
> > metadata block, and that copy lives in slab memory.  Today jbd2 points the
> > temporary buffer at the slab folio backing it.  A slab folio's ->mapping is
> > not an address_space, so anything that follows bh->b_folio->mapping there
> > gets garbage rather than NULL; mark_buffer_write_io_error() does exactly
> > that, and we are about to start calling it on this buffer.
> > 
> > Rather than teach every such helper about slab folios, allow bh->b_folio to
> > be NULL and let b_data point straight at the memory.  Code that needs the
> > folio has to check.  There are two places in this file:
> > 
> >  - __bh_submit() adds the data by virtual address using
> >    bio_add_virt_nofail(), and skips the cgroup accounting: a buffer that is
> >    not in the page cache has no owning folio to attribute writeback to.
> > 
> >  - buffer_set_crypto_ctx() returns early.  fscrypt has no interest in a
> >    buffer that is not part of a file mapping, which is why it already
> >    returns when folio_mapping() comes back NULL.
> > 
> > Nothing sets b_folio to NULL yet, so this patch is a no-op on its own.
> > 
> > This is deliberately not a general capability.  Buffers over highmem have
> > no permanent kernel virtual address, which is why folio_set_bh() records a
> > folio and an offset instead of an address.  A folio-less buffer_head is
> > only valid over memory that is always mapped, and must not be passed to
> > bh_offset().
> 
> There are much more things you cannot do with a bh that doesn't have valid
> b_folio - touch_buffer(), end_buffer_async_read(), ... and many more. But
> that's a bussiness of the code that sets up such temporary bhs. I agree
> that setting b_folio to NULL will if nothing else lead to much more obvious
> failures than when we accidentally get slab folio. So I'd prefer we update
> the description a bit in this direction but otherwise feel free to add:

Yes, agreed.  I think it's fine to add in some 'if (!bh->b_folio)'
tests, but only where they're needed for the occasional consumer.  This
really is a rare (but legitimate) case.

> >  static void buffer_set_crypto_ctx(struct bio *bio, const struct buffer_head *bh,
> >  				  gfp_t gfp_mask)
> >  {
> > -	const struct address_space *mapping = folio_mapping(bh->b_folio);
> > +	const struct address_space *mapping;
> >  
> >  	/*
> >  	 * The ext4 journal (jbd2) can submit a buffer_head it directly created
> > -	 * for a non-pagecache page.  fscrypt doesn't care about these.
> > +	 * for memory that is not in the page cache at all.  fscrypt doesn't
> > +	 * care about these.
> >  	 */
> > +	if (!bh->b_folio)
> > +		return;
> > +	mapping = folio_mapping(bh->b_folio);
> >  	if (!mapping)
> >  		return;

Do we want to call folio_mapping() here?  The only case where I can see
this being useful is if we attach a buffer_head to an anonymous folio,
and I don't see a good reason to do that.  I think this can just be

	mapping = bh->b_folio->mapping;

