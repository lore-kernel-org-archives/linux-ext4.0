From: Jan Kara <jack@suse.cz>
Subject: Re: dead/wrong code in ext3/4_releasepage()
Date: Mon, 2 Jul 2012 19:09:59 +0200
Message-ID: <20120702170959.GJ6679@quack.suse.cz>
References: <4FEDDD63.4000800@ya.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrew Perepechko <anserper@ya.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab2GBRKB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 13:10:01 -0400
Content-Disposition: inline
In-Reply-To: <4FEDDD63.4000800@ya.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 29-06-12 20:52:51, Andrew Perepechko wrote:
> Hello!
> 
> The implementation of ext4_releasepage() for many kernel versions
> (as well as current git) is the following:
> 
> static int ext4_releasepage(struct page *page, gfp_t wait)
> {
>         journal_t *journal = EXT4_JOURNAL(page->mapping->host);
> 
>         trace_ext4_releasepage(page);
> 
>         WARN_ON(PageChecked(page));
>         if (!page_has_buffers(page))
>                 return 0;
>         if (journal)
>                 return jbd2_journal_try_to_free_buffers(journal,
> page, wait);
>         else
>                 return try_to_free_buffers(page);
> }
> 
> The "if (!page_has_buffers(page))" check seems to be attempting to
> handle the "nobh" case. However, the correct return value for this case
> seems to be 1 (success), not 0 (failure).
> 
> This does not lead to oom or any similar issue since calls to
> try_to_release_page()
> are accompanied by page_has_private() checks.
> 
> If ->release_page() can be called without a prior check, then
> the return code is wrong. Otherwise, the check is dead code.
> 
> What do you think?
  The check is a dead code because ->release_page() is called only if
PagePrivate bit is set.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
