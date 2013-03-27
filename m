From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: page eviction from the buddy cache
Date: Wed, 27 Mar 2013 11:07:43 -0400
Message-ID: <20130327150743.GC14900@thunk.org>
References: <51504A40.6020604@ya.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, alexey.lyashkov@gmail.com,
	akpm@linux-foundation.org, hughd@google.com
To: Andrew Perepechko <anserper@ya.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56397 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab3C0PHq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 11:07:46 -0400
Content-Disposition: inline
In-Reply-To: <51504A40.6020604@ya.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrew,

Thanks for your analysis!  Since I'm not a mm developer, I'm not sure
what's the best way to more aggressively mark a page as one that we'd
really like to keep in the page cache --- whether it's calling
lru_add_drain(), or calling activate_page(page), etc.

So I've added Andrew Morton and Hugh Dickens to the cc list as mm
experts in the hopes they could give us some advice about the best way
to achieve this goal.  Andrew, Hugh, could you give us some quick
words of wisdom?

Thanks,

					- Ted
On Mon, Mar 25, 2013 at 04:59:44PM +0400, Andrew Perepechko wrote:
> Hello!
> 
> Our recent investigation has found that pages from
> the buddy cache are evicted too often as compared
> to the expectation from their usage pattern. This
> introduces additional reads during large writes under
> our workload and really hurts overall performance.
> 
> ext4 uses find_get_page() and find_or_create_page()
> to look for buddy cache pages, but these pages don't
> get a chance to become activated until the following
> lru_add_drain() call, because mark_page_accessed()
> does not activate pages which are not PageLRU().
> 
> As can be found from a kprobe-based test, these pages
> are often moved on the inactive LRU as a result of
> shrink_inactive_list()->lru_add_drain() and immediately
> evicted.
> 
> From a quick look into linux-2.6.git, the issue seems
> to exist in the current code as well.
> 
> A possible and, perhaps, non-optimal solution would be
> to call lru_add_drain() each time a buddy cache page
> is used.
> 
> Any other suggestions?
> 
> Thank you,
> Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
