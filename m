From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 03/11] vfs: Add better VFS support for page_mkwrite
	when blocksize < pagesize
Date: Wed, 27 May 2009 13:06:48 -0400
Message-ID: <20090527170648.GF14035@dhcp231-156.rdu.redhat.com>
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <1243429268-3028-4-git-send-email-jack@suse.cz> <20090527160005.GA14035@dhcp231-156.rdu.redhat.com> <20090527164504.GC19989@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59417 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbZE0RGc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2009 13:06:32 -0400
Content-Disposition: inline
In-Reply-To: <20090527164504.GC19989@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 27, 2009 at 10:15:04PM +0530, Aneesh Kumar K.V wrote:
> On Wed, May 27, 2009 at 12:00:06PM -0400, Josef Bacik wrote:
> > On Wed, May 27, 2009 at 03:01:00PM +0200, Jan Kara wrote:
> .....
> ....
> 
> > >  		if (offset > inode->i_sb->s_maxbytes)
> > >  			goto out_big;
> > > -		i_size_write(inode, offset);
> > > +		do_extend_i_size(inode, offset, 0);
> > >  	} else {
> > >  		struct address_space *mapping = inode->i_mapping;
> > >
> > 
> > Sorry if I'm being a bit dense, I'm just kind of confused.  In the case you
> > outlined, we only allocate one block, as we should, but then the truncate
> > extends i_size so that when writepage() comes along, its valid to write the
> > whole page out, except we didn't allocate blocks for the whole page sine
> > blocksize < pagesize.
> 
> We can't do block allocation in writepage because we can't handler
> ENOSPC during writepage. So the patch attempt to make sure we do
> all block allocation in the process context. For mmap we should
> do it in page_mkwrite and for write in write_begin.
> 

Right, I get that part, its the next part that confused me.

> > 
> > But if we didn't extend i_size, writepage would only have written the block's
> > worth of data correct?  If thats the case, why don't we just make it so that
> > happens in this case as well? 
> 
> That is what is done in the patch i posted
> http://article.gmane.org/gmane.comp.file-systems.ext4/13468
> 
> But that is not just enough. We also need to make sure we get a
> page_fault when we try to write at another offset via mmap address so
> that we can do block allocation via page_mkwrite. To do that all code
> path that extend i_size should mark the page write protect.
> 

Thank you, this is where I was confused.  I didn't think about the fact that
we'd not hit page_mkwrite() on that page anymore even though we would need to
allocate more blocks to actually write out the entire page.
> 
> >Technically only one part of the page is dirty,
> > so we just need to write that out, not the whole thing.  I assume there is a way
> > to do this, since it presumably happens in the case where i_size < page size.
> > If thats not possible then I guess this way is a good answer, it just seems
> > overly complicated to me.
> 
> 
> __block_write_full_page already does that. It looks at the last_block
> 

Gotcha.  Thanks for explaining this to me,

Josef
