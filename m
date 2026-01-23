Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7A137F115;
	Fri, 23 Jan 2026 05:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769146055; cv=none; b=MR1Hn6RkZ0381ipCFe/zGEl8AqUb5M3OqTrK0DOzzVpqh3fz3Fz0qoTIhOqb8w9qzTUS/1dx5kbTZ4dpg7xSQJTlRsw6pmgHWmi9lBRkVw4OFcM8TV0rt8BEYMcNmmDa140vRgJFqDVHR+9P2yhmfMwW1Hy5gsc+ZG4697QZLsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769146055; c=relaxed/simple;
	bh=EhNJrIWlevEMHFg7O5W5zHE6itZIjyXAlI6MIoUhDFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vqx1KEqNkAzzKIMKAe52mMjWa0tC1srXSt+s12RKp57VtwcgnZ3PWDMgMe4ZIY94a5MOPdi+rgMyFStKJOYNNK0ulPvYH51OC/NK+DJNi9n8AF4No25vz2m9ae/xdnxTFNPeAdB8kDA8WlhE7vYmaIHZiS5fF6w1f+h0IBWAo2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BF760227AAE; Fri, 23 Jan 2026 06:27:23 +0100 (CET)
Date: Fri, 23 Jan 2026 06:27:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	fsverity@lists.linux.dev
Subject: Re: [PATCH 11/11] fsverity: use a hashtable to find the
 fsverity_info
Message-ID: <20260123052723.GE24123@lst.de>
References: <20260122082214.452153-1-hch@lst.de> <20260122082214.452153-12-hch@lst.de> <20260122220420.GI5910@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122220420.GI5910@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 22, 2026 at 02:04:20PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 22, 2026 at 09:22:07AM +0100, Christoph Hellwig wrote:
> > Use the kernel's resizable hash table to find the fsverity_info.  This
> 
> Oh is that what the 'r' stands for?  I thought it was rcu.  Maybe it's
> both. :P

From the lib/rhashtable.c:

 * Resizable, Scalable, Concurrent Hash Table

> > Because insertation into the hash table now happens before S_VERITY is
> > set, fsverity just becomes a barrier and a flag check and doesn't have
> > to look up the fsverity_info at all, so there is only one two two
> 
> "one two two" <confused>?

one or two, sorry.  The cover letter actually explains this in more
detail, which this should be updated to.

> > +static const struct rhashtable_params fsverity_info_hash_params = {
> > +	.key_len		= sizeof(struct inode *),
> 
> 	.key_len		= sizeof_field(struct fsverity_info, inode),
> 
> Perhaps?

That should work, yes.

> > -	kfree(vi->tree_params.hashstate);
> > -	kvfree(vi->hash_block_verified);
> > -	kmem_cache_free(fsverity_info_cachep, vi);
> > +	return rhashtable_lookup_fast(&fsverity_info_hash, &inode,
> > +			fsverity_info_hash_params);
> 
> Hrm.  The rhashtable stores a pointer to the rhash_head, but now we're
> returning that as if it were a fsverity_info pointer.  Can I be pedantic
> and ask for a proper container_of() to avoid leaving a landmine if the
> struct layout ever changes?

rhashtable_lookup_fast returns the struct containing the rhash_head.
The paramters store the rhead_offset for that purpose.  See rht_obj
as used by rhashtable_lookup.

> > @@ -323,9 +323,9 @@ fsverity_init_verification_context(struct fsverity_verification_context *ctx,
> >  				   struct fsverity_info *vi)
> >  {
> >  	ctx->inode = inode;
> > -	ctx->vi = vi;
> 
> Can this function drop its @vi argument?

No..

> 
> > +	ctx->vi = fsverity_get_info(inode);

... but this extra lookup should have been removed and got messed up by a
rebase, causing a pointless extra lookup.  (Which still is completely
in the noise in my runs).

