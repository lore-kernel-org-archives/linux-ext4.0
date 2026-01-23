Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007763382DB;
	Fri, 23 Jan 2026 07:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769153121; cv=none; b=m5FefhLfyuaq54P+0hRWb2afERGyGhIseEWWAA1fG+f5C9fuwFVaNdCQfiRY1blr3lWVkYKJBnz2vN6vXQBsQuShwepUp649DznQ3zYJIPWvOZeToKwIC6T6hSCgW9D8HU73NCSEI/z+qo86P/Zm8heTegU+TAZBbmTH0xWKDmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769153121; c=relaxed/simple;
	bh=2iQj3NVwRa1h1Br3tJlYAFXoIJ/SDM7T0y4t89MLmxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oz2uM4tmGmV/sJ1TxbUGLGIu2V3g8sRRRMHffyH1NBUyantsyJayZL1LrUXBges0DB1EZXj7WuLYQQuEbRhyIhvP+PruGXco5SnJr+6JvyO37qfu4sq9XAsu5Qg27JVlsstuUR/4v1dtfap0FmQndu6Q1FYoS5QJPaOFUNe2hgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CanYp7RL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CanYp7RL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3EDC4CEF1;
	Fri, 23 Jan 2026 07:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769153120;
	bh=2iQj3NVwRa1h1Br3tJlYAFXoIJ/SDM7T0y4t89MLmxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CanYp7RLVaLj52wNbtaMcyixECOzLmRczYmz6Pz3O4m44GBUI80gmjY3F1RJjJbC8
	 xXIOT2/4gnzvIa0z3JoRZ6TMyRICwWGQMGQnIrl5vlAspDwIv7cxuosKN2iPhQJ5ws
	 zF5GflLV/RPpkxcktkMryNxadoSfNZANui+/UaVN1JIvRP9anzihAn0HrC7QAeWa02
	 1WWu53Izxqp0btpWC6SqblNX+T6GEww3out8ddiooEJO04jEUGhkgFJ4P7sbFOKTpU
	 KEZG8tvO85aCe1TxgOuNRWnsHGku7oidNWFZeVlysEmWWV4MInW2dUytpDrf531mhB
	 ZmMKy7F1W0mew==
Date: Thu, 22 Jan 2026 23:25:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	fsverity@lists.linux.dev
Subject: Re: [PATCH 08/11] ext4: consolidate fsverity_info lookup
Message-ID: <20260123072520.GM5910@frogsfrogsfrogs>
References: <20260122082214.452153-1-hch@lst.de>
 <20260122082214.452153-9-hch@lst.de>
 <20260122215457.GH5910@frogsfrogsfrogs>
 <20260123051836.GD24123@lst.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123051836.GD24123@lst.de>

On Fri, Jan 23, 2026 at 06:18:36AM +0100, Christoph Hellwig wrote:
> On Thu, Jan 22, 2026 at 01:54:57PM -0800, Darrick J. Wong wrote:
> > > +			if (folio->index <
> > > +			    DIV_ROUND_UP(inode->i_size, PAGE_SIZE))
> > 
> > I keep seeing this predicate, maybe it should go into fsverity.h as a
> > helper function with the comment about mmap that I was muttering about
> > in the previous patch?
> 
> Right now it is not generic.  Nothing in the generic fsverity code
> known about the offset, ext4 and f2fs just happened to chose the
> same constant (and the ext4 one leak to buffer.c), while btrfs stores
> the verity hashed totally differently.  I hope the xfs works ends up
> with a consolidated way of doing this, at which point such a helper
> would be useful.
> 
> > Or maybe a "get verity info for given folio index" helper?
> 
> How would that make sense?
> 
> > /*
> >  * Grab the fsverity context needed to verify the contents of the folio.
> >  *
> >  * <Big fat comment from before, about mmap and whatnot>
> >  */
> > static inline struct fsverity_info *vi
> > fsverity_folio_info(const struct folio *folio)
> > {
> > 	struct inode *inode = folio->mapping->host;
> > 
> > 	if (folio->index < DIV_ROUND_UP(inode->i_size, PAGE_SIZE))
> > 		return fsverity_get_info(inode);
> > 	return NULL;
> > }
> 
> Tthe offset right now is entirely file system specific,
> so we can't do this.  Maybe that'll change with further consolidation.

<nod> Ok, I think I'll defer all this talk of helpers until whichever
series cleans up all the post-eof pagecache stuff, and then we can make
all four filesystems pick the same offset for the cached merkle trees.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
