From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_da_block_invalidatepages() question
Date: Wed, 27 Jan 2010 13:25:28 +0100
Message-ID: <20100127122528.GB3149@quack.suse.cz>
References: <20100126133608.GC25407@localhost>
 <20100126153222.GI3187@quack.suse.cz>
 <20100127015339.GA8132@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51283 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab0A0MZV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jan 2010 07:25:21 -0500
Content-Disposition: inline
In-Reply-To: <20100127015339.GA8132@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 27-01-10 09:53:39, Wu Fengguang wrote:
> On Tue, Jan 26, 2010 at 08:32:22AM -0700, Jan Kara wrote:
> 
> > @@ -2127,17 +2127,16 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
> >  			break;
> >  		for (i = 0; i < nr_pages; i++) {
> >  			struct page *page = pvec.pages[i];
> > -			index = page->index;
> > -			if (index > end)
> > +			if (page->index > end)
> >  				break;
> > -			index++;
> > -
> >  			BUG_ON(!PageLocked(page));
> >  			BUG_ON(PageWriteback(page));
> >  			block_invalidatepage(page, 0);
> >  			ClearPageUptodate(page);
> >  			unlock_page(page);
> >  		}
> > +		index = pvec.pages[nr_pages - 1]->index + 1;
> > +		pagevec_release(&pvec);
> >  	}
> >  	return;
> >  }
> 
> The patch includes a cleanup and a bug fix, both looks OK to me.
> But if we can split it, the bug fix would be good candidate for
> the stable kernel?
  I don't think we want to push this to -stable kernel. As I wrote, this
code is called only in case user is going to loose written data which is a
bug on it's own so loosing a few page references is nothing compared to
that.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
