From: Jan Kara <jack@suse.cz>
Subject: Re: Buffer state bits
Date: Thu, 27 Aug 2009 13:14:03 +0200
Message-ID: <20090827111403.GA14240@duck.novell.com>
References: <20090826200021.GA5716@duck.novell.com> <20090826212700.GB691@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbZH0LOD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Aug 2009 07:14:03 -0400
Content-Disposition: inline
In-Reply-To: <20090826212700.GB691@shareable.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 26-08-09 22:27:00, Jamie Lokier wrote:
> Jan Kara wrote:
> > BH_Dirty
> > - Ideally, this bit should mean "buffer has data that have to be
> >   written". But it is not quite true. The problem happens when
> >   someone calls set_page_dirty() on the page to which buffers are
> >   attached or similarly when buffers are attached to a dirty
> >   page. Then all buffers attached to the page are marked dirty -
> >   even those that are beyond end of file which obviously should not
> >   be written.
> > 
> >   When buffer is dirty, the page has to be dirty as well (mark
> >   buffer dirty takes care of that). It is not necessarily the other
> >   way around and buffer dirty bit is what ultimately decides whether
> >   the buffer goes to disk or not.
> 
> That last sentence implies page can be dirty while a buffer in the
> page is not dirty.
  Yes, that happens.

> In that case, do buffers beyond the end of file need to be set dirty
> by set_page_dirty()?  If yes, perhaps the text could explain why.
  No, they need not. But it's racy to check i_size in set_page_dirty
because we don't hold i_mutex... I'll add some explanation to the
paragraph.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
