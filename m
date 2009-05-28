From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 08/11] vfs: Unmap underlying metadata of new data
	buffers only when buffer is mapped
Date: Thu, 28 May 2009 11:44:34 +0200
Message-ID: <20090528094434.GG29199@duck.suse.cz>
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <1243429268-3028-9-git-send-email-jack@suse.cz> <20090527153559.GB19989@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	npiggin@suse.de, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53284 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZE1Joe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 05:44:34 -0400
Content-Disposition: inline
In-Reply-To: <20090527153559.GB19989@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 27-05-09 21:05:59, Aneesh Kumar K.V wrote:
> On Wed, May 27, 2009 at 03:01:05PM +0200, Jan Kara wrote:
> > When we do delayed allocation of some buffer, we want to signal to VFS that
> > the buffer is new (set buffer_new) so that it properly zeros out everything.
> > But we don't have the buffer mapped yet so we cannot really unmap underlying
> > metadata in this state. Make VFS avoid doing unmapping of metadata when the
> > buffer is not yet mapped.
> > 
...
> > @@ -2683,7 +2685,7 @@ int nobh_write_begin(struct file *file, struct address_space *mapping,
> >  			goto failed;
> >  		if (!buffer_mapped(bh))
> >  			is_mapped_to_disk = 0;
> > -		if (buffer_new(bh))
> > +		if (buffer_new(bh) && buffer_mapped(bh))
> >  			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
> >  		if (PageUptodate(page)) {
> >  			set_buffer_uptodate(bh);
> 
> Both xfs and ext4 return mapped delay buffer_head when we do a get_block
> with delayed allocation in write_begin phase.
  Yeah, I knew about ext4 doing this. Thanks for pointing this out. I
wanted to trigger a separate discussion about this and similar problems -
the current state of buffer bits is quite messy (I think Ted complained
about this as well recently) and we should somehow clean it up.
  In this particular case: What's the point in returning the buffer mapped?
It does not make any sence logically (block *does not* have any physical
location assigned) and technically you have to map it to some fake block
and later remap it correctly when you do block allocation. So maybe I'm
missing some good reason but from what I can see, it just does not make
sence...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
