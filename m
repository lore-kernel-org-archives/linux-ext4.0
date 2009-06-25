From: Theodore Tso <tytso@mit.edu>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Date: Thu, 25 Jun 2009 16:37:43 -0400
Message-ID: <20090625203743.GD6472@mit.edu>
References: <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com> <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	penberg@cs.helsinki.fi, arjan@infradead.org,
	linux-kernel@vger.kernel.org, cl@linux-foundation.org,
	npiggin@suse.de, linux-ext4@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38479 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbZFYUiG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2009 16:38:06 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 25, 2009 at 01:18:59PM -0700, David Rientjes wrote:
> Isn't there also a problem in jbd2_journal_write_metadata_buffer(), 
> though?
> 
> 		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
		...
> 		memcpy(tmp, mapped_data + new_offset, jh2bh(jh_in)->b_size);
> 
> jbd2_alloc() is just a wrapper to __get_free_pages() and if it fails, it 
> appears as though the memcpy() would cause a NULL pointer.

Nicely spotted.  Yeah, that's a bug; we need to do something about
that one, too.  And what we're doing is a bit silly; it may make sense
to use __get_free_pages if filesystem blocksize == PAGE_SIZE, but
otherwise we should be using a sub-page allocator.  Right now, we're
chewing up a 16k PPC page for every 4k filesystem metadata page
allocated in journal_write_metadata_buffer(), and on x86, for the
(admittedly uncommon) 1k block filesystem, we'd be chewing up a 4k
page for a 1k block buffer.


Both of these problems exist for both ext3 and ext4.

     	      	       	     	      		- Ted
