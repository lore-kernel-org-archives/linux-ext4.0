From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: instrument jh on wrong transaction BUG_ON's
Date: Sun, 14 Aug 2011 22:06:52 -0400
Message-ID: <20110815020652.GE3524@thunk.org>
References: <1313290418-12695-1-git-send-email-tytso@mit.edu>
 <CAO81RMauzwN6HmutW+3fqH_Oif0trm34G1BPUiyZz6qmiZkY8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43221 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab1HOCG5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Aug 2011 22:06:57 -0400
Content-Disposition: inline
In-Reply-To: <CAO81RMauzwN6HmutW+3fqH_Oif0trm34G1BPUiyZz6qmiZkY8w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 14, 2011 at 01:01:01PM -0700, Curt Wohlgemuth wrote:
> 
> It seems that  jh->b_transaction is NULL, and deferencing it to print
> out jh->b_transaction->t_tid causes the NULL pointer deref.

Hmm, if jh->b_transaction is null, then
jbd2_journal_get_write_access() must not have been called on the
journal_head.  But the relevant code from ext4_journalled_writepage() is:

	ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
				do_journal_get_write_access);

	err = walk_page_buffers(handle, page_bufs, 0, len, NULL,
				write_end_fn);

(write_end_fn is the function which calls which ultimately calls
ext4_handle_dirty_metadata which then calls
jbd2_journal_dirty_metadata(), which is where you're seeing the BUG_ON).

I suspect what is going on is do_get_write_access() is returning an
error, which means we never set jh->b_transaction.  Hence when we call
jbd2_journal_data_metadata(), we trigger the BUG.

OK, what could cause do_get_write_access() to return an error?  Two
conditions: if the handle is aborted (due to a previous error), in
which case it returns -EROFS, or if it can't get the memory needed
make a copy of the buffer, in which case there should have been a
"do_get_write_access: OOM for frozen buffer" error message earlier in
the log.  (No, it's not prefixed with JBD2 --- it probably should be.)

Any chance you're seeing any indication of either possibility in the
messages before the BUG message?

						- Ted
