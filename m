Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB72E3E6DD5;
	Tue,  4 Aug 2026 14:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785852434; cv=none; b=h7AKsUpDlx96k18p82FIEU/FmOqDI9PoEhg+D14IHV32s9nD4sod2QcubzzfTxIbc6KxP1H+8hFpG9X3cn8KDbjHRac//h7djJxl+pCRDVF6+5yiyt2HUKDdTV037TqRh5dRtlytcghKpL4hB3s3VXRrIB7SbaX6hF43z3Soyrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785852434; c=relaxed/simple;
	bh=Bm5Vnjc63amehXyOZ5PfBGvIgD0AdigchQjFXrx5X/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=codxBbYfninI5kqceKiL2o4VTqJDMf7BVgP5xB4H2LN9zy+e40sK1RlOjWVOynDHNirifn3/4MUq3NQQgz/HLf0CvnTmeUPol1XwfDSkcgijPl5Mi4pwn5pXnq8zDW3pz/BeAYG73sVC9Lt+Oir0qmo47C8xZ14TySCDEgDtwxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZxZ+jWDS; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZxZ+jWDS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6F+JwN7DO/cd0y1I7bzDtc5rv4FM9PTauEYvrCLg2R4=; b=ZxZ+jWDSIo89DonIl351mZ1aKN
	C8M1WIyMLHeQP9vUNH778dS9Vj5V7H6SteQhtNNJy2BTQE1+zjtcaQ8PrQfKmDW+tH64c/2lJIx5J
	/TOtGEGQrpnofoFUfT/WWL0Cv+GbnIIdqCj2GXk2CGMZRCh6SPvwrX9rqI4/CUjnksBFXXGaBhOJq
	qra1V3IGRbnAnLNmJq9onijewsXstNFJ3aQxGvPDmdTulS27dOlm1p6q8VRTzlCnSSwI1rxIqb7SD
	LYOtWhQtngxle5bdUDKicIhmAj76xqeZLYNdlNU5olvVQcjM9g+ddP1bq4LuD3cDkrwDnzWOSdsjL
	JFKpbBbA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrFnI-00000003xve-3IqV;
	Tue, 04 Aug 2026 14:07:00 +0000
Date: Tue, 4 Aug 2026 15:07:00 +0100
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
Message-ID: <anHyBATDe8yQEFNi@casper.infradead.org>
References: <cover.1785621505.git.coshi036@gmail.com>
 <41c6fee66724e374d4682124a1eb80041e22efb9.1785621505.git.coshi036@gmail.com>
 <z5jfe6bsxhgqqgjtxcm7ass2fslc4ynizvpmzlqxtr6rrfaopu@fxzntlxafmxj>
 <anDW5UTbF2d0EQmr@casper.infradead.org>
 <74ts4lwsq73mce3rvc7imisot436742ykzahnogysnbklot45b@q3nhfq55knx3>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74ts4lwsq73mce3rvc7imisot436742ykzahnogysnbklot45b@q3nhfq55knx3>

On Tue, Aug 04, 2026 at 10:07:39AM +0200, Jan Kara wrote:
> > Yes, agreed.  I think it's fine to add in some 'if (!bh->b_folio)'
> > tests, but only where they're needed for the occasional consumer.  This
> > really is a rare (but legitimate) case.
> 
> Yes. If we were to write this code from scratch, I'd rather push for
> forming and submitting the bio directly instead of trying to bend the bh
> layer for these temporary bhs. Eventually we might want to do this cleanup
> anyway (since bhs don't really buy us much in this path) but not in this
> patch set.

I think that would be better, but it is out of scope.

> > > >  static void buffer_set_crypto_ctx(struct bio *bio, const struct buffer_head *bh,
> > > >  				  gfp_t gfp_mask)
> > > >  {
> > > > -	const struct address_space *mapping = folio_mapping(bh->b_folio);
> > > > +	const struct address_space *mapping;
> > > >  
> > > >  	/*
> > > >  	 * The ext4 journal (jbd2) can submit a buffer_head it directly created
> > > > -	 * for a non-pagecache page.  fscrypt doesn't care about these.
> > > > +	 * for memory that is not in the page cache at all.  fscrypt doesn't
> > > > +	 * care about these.
> > > >  	 */
> > > > +	if (!bh->b_folio)
> > > > +		return;
> > > > +	mapping = folio_mapping(bh->b_folio);
> > > >  	if (!mapping)
> > > >  		return;
> > 
> > Do we want to call folio_mapping() here?  The only case where I can see
> > this being useful is if we attach a buffer_head to an anonymous folio,
> > and I don't see a good reason to do that.  I think this can just be
> > 
> > 	mapping = bh->b_folio->mapping;
> 
> For all I know yes, bh->b_folio->mapping should be enough here. But I
> thought folio_mapping() is kind of preferred to open-coding?

It rather depends on the path we're talking about.  Looking at the
implementation of folio_mapping(), it's actually mildly dangerous
to call folio_mapping() in this path.  If we were ever to point a
buffer_head at some memory on a page in swap cache, we'd get a pointer
to a swap_address_space.  I think we'd safely crash in that case because
mapping->host would be NULL, but in other contexts doing things to a
swap mapping would be quite bad.

So I think this should just be folio->mapping; don't risk getting a
pointer to a swap mapping.
