From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: ext4_da_block_invalidatepages() question
Date: Wed, 27 Jan 2010 09:53:39 +0800
Message-ID: <20100127015339.GA8132@localhost>
References: <20100126133608.GC25407@localhost> <20100126153222.GI3187@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55154 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab0A0CjI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jan 2010 21:39:08 -0500
Content-Disposition: inline
In-Reply-To: <20100126153222.GI3187@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 26, 2010 at 08:32:22AM -0700, Jan Kara wrote:

> @@ -2127,17 +2127,16 @@ static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
>  			break;
>  		for (i = 0; i < nr_pages; i++) {
>  			struct page *page = pvec.pages[i];
> -			index = page->index;
> -			if (index > end)
> +			if (page->index > end)
>  				break;
> -			index++;
> -
>  			BUG_ON(!PageLocked(page));
>  			BUG_ON(PageWriteback(page));
>  			block_invalidatepage(page, 0);
>  			ClearPageUptodate(page);
>  			unlock_page(page);
>  		}
> +		index = pvec.pages[nr_pages - 1]->index + 1;
> +		pagevec_release(&pvec);
>  	}
>  	return;
>  }

The patch includes a cleanup and a bug fix, both looks OK to me.
But if we can split it, the bug fix would be good candidate for
the stable kernel?

Thanks,
Fengguang
