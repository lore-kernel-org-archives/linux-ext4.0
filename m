From: Jan Kara <jack@suse.cz>
Subject: Reversing order of transaction start and page_lock for ext3/4
Date: Thu, 13 Mar 2008 19:05:20 +0100
Message-ID: <20080313180519.GL12523@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49550 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754306AbYCMSFV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 14:05:21 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  As Mark Fasheh pointed out, we cannot take page_lock inside a transaction
commit because that could possibly deadlock with other thread holding the
page_lock and waiting for commit to finish in journal_start. This is
kind-of blocker for my new approach of handling of ordered mode in JBD.

So first, I'd like to ask what other people think about reversing locking
order of page_lock and transaction start in ext3/4? I personally find it a
good thing anyway (I've stumbled on problems with the current locking order
several times, but so far I could always workaround them), logically it
simply "makes sence" as transaction handle is naturally more long-lived
than a lock on one page.

For the case that we agree we want to reverse the order, I've looked into
how hard would it be. Ordinary write path is trivial. If we provide
page_mkwrite function (which should be quite simple), we don't have to be
afraid of instantiating holes in writepage so that makes things in
writepage simpler (although we'd pay the some performance for writing page
of zeros into the hole and later writing real data in writepage - currently
we do only the second write together with block allocation). With
page_mkwrite, we don't have to start transaction at all in writepage in
writeback and ordered modes. In data=journal mode, we still have to start
the transaction. So we'd have to do something like unlocking the page,
starting the transaction, locking the page, then carefully check whether
the page didn't get truncated etc... It is a question for discussion, whether
this moment wouldn't be appropriate for substituting journal=data mode with
an ordered mode but I guess the feature removal will take longer.

And as far as I can see that's all :). Comments, ideas, opinions welcome :).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
