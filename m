From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 stable page writes question
Date: Tue, 9 Apr 2013 16:28:05 +0200
Message-ID: <20130409142805.GF13672@quack.suse.cz>
References: <87txnf4yeq.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929Ab3DIO2H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Apr 2013 10:28:07 -0400
Content-Disposition: inline
In-Reply-To: <87txnf4yeq.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 09-04-13 17:38:21, Dmitry Monakhov wrote:
> According to stable write assumptions (1d1d1a767206fb)
> grab_cache_page_write_begin() now calls relaxed method wait_for_stable_page()
> which will wait for writeback to finish only if bdi demand that.
  Yes.

> Commit message states that ext4 may not wait
> But there are a lot of write-paths where we expect that:
> BUG_ON(!PageLocked(page));
> BUG_ON(PageWriteback(page));
  Really? The only places I can find are in writeback path and there we
have wait_on_page_writeback() (either in write_cache_pages() or in
ext4_da_writepages()).

> And the only reason we avoid this bugon is because of commit 47564bfb95b
> which use following trick to avoid lock inversion over journal_start:
> page = grab_cache_page_write_begin()
> unlock_page(page);
> ext4_journal_start()
> lock_page(page);
> wait_on_page_writeback(page); <<<< unconditional wait
  No, I think this is really independent. ext4 should be fine when write &
writeback are running in parallel for a page.

> So as far as I understand this was done just by occasion because
> ext4_page_mkwrite() use wait_for_stable_page().
> 
> So here is my question:  Do we have to wait for page's writeback to
> finish for all write paths in ext4 code or we may use
> wait_for_stable_page() and should cleanup all places where 
> we may trigger BUG_ON(PageWriteback(page));
  If there's any such place, please tell me how we could trigger it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
