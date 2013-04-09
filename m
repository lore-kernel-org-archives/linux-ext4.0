From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: ext4 stable page writes question
Date: Tue, 09 Apr 2013 17:38:21 +0400
Message-ID: <87txnf4yeq.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:39674 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223Ab3DINi0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2013 09:38:26 -0400
Received: by mail-lb0-f171.google.com with SMTP id v10so6866142lbd.30
        for <linux-ext4@vger.kernel.org>; Tue, 09 Apr 2013 06:38:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


According to stable write assumptions (1d1d1a767206fb)
grab_cache_page_write_begin() now calls relaxed method wait_for_stable_page()
which will wait for writeback to finish only if bdi demand that.
Commit message states that ext4 may not wait
But there are a lot of write-paths where we expect that:
BUG_ON(!PageLocked(page));
BUG_ON(PageWriteback(page));
And the only reason we avoid this bugon is because of commit 47564bfb95b
which use following trick to avoid lock inversion over journal_start:
page = grab_cache_page_write_begin()
unlock_page(page);
ext4_journal_start()
lock_page(page);
wait_on_page_writeback(page); <<<< unconditional wait

So as far as I understand this was done just by occasion because
ext4_page_mkwrite() use wait_for_stable_page().

So here is my question:  Do we have to wait for page's writeback to
finish for all write paths in ext4 code or we may use
wait_for_stable_page() and should cleanup all places where 
we may trigger BUG_ON(PageWriteback(page));
 
