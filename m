From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC] ext3 data=guarded v5
Date: Thu, 30 Apr 2009 13:38:23 +0200
Message-ID: <20090430113823.GC29220@duck.suse.cz>
References: <1240941840.15136.44.camel@think.oraclecorp.com> <20090429085632.GA18273@duck.suse.cz> <1241014093.20099.28.camel@think.oraclecorp.com> <20090429191533.GB22936@duck.suse.cz> <1241034089.20099.60.camel@think.oraclecorp.com> <20090429200412.GA27924@duck.suse.cz> <1241037421.20099.70.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34016 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760762AbZD3Li1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Apr 2009 07:38:27 -0400
Content-Disposition: inline
In-Reply-To: <1241037421.20099.70.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 29-04-09 16:37:01, Chris Mason wrote:
> On Wed, 2009-04-29 at 22:04 +0200, Jan Kara wrote:
> 
> > > What we don't want to do is have a call to write() over existing blocks
> > > in the file add new things to the data=ordered list.  I don't see how we
> > > can avoid that without datanew.
> >   Yes, what I suggest would do exactly that:
> > In ordered_writepage() in the beginning we do:
> >   page_bufs = page_buffers(page);
> >   if (!walk_page_buffers(NULL, page_bufs, 0, PAGE_CACHE_SIZE,
> >                          NULL, buffer_unmapped)) {
> >   	return block_write_full_page(page, NULL, wbc);
> >   }
> > So we only get to starting a transaction and file some buffers if some buffer
> > in the page is unmapped. Write() maps / allocates all buffers in write_begin()
> > so they are never added to ordered lists in writepage().
> 
> Right, writepage doesn't really need datanew.
> 
> >  We rely on write_end
> > to do it. So the only case where not all buffers in the page are mapped is
> > when we have to allocate in writepage() (mmaped write) or the two cases I
> > describe above.
> 
> But I still think write_end does need datanew.  That's where 99% of the
> ordered buffers are going to come from when we overwrite the contents of
> an existing file.
  Ah, true, buffer_new() can be cleared in __block_prepare_write() in some
cases. Frankly, I don't see a reason why that happens but that's another
story.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
