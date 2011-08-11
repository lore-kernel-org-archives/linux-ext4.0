From: Josef Bacik <josef@redhat.com>
Subject: Can a metadata buffer end up in journal_unmap_buffer?
Date: Thu, 11 Aug 2011 09:32:22 -0400
Message-ID: <4E43D9E6.9030503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab1HKNcc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2011 09:32:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have this weird bug that has been plaguing me for a while where
t_outstanding_credits will end up less than t_nr_buffers.  I have done
all sorts of things to try and catch when it happens but nothing seems
to catch it.  At some point I had thought that we were screwing up in
journal_unmap_buffer.  If a buffer is not on a transaction but is still
a part of a checkpoint we will do a journal_file_buffer() onto the
current running transaction's forget list.  The thing is we can still
have b_modified set since we only clear it on
do_get_write_access/journal_get_create_access if it isn't a part of the
transaction yet.  So if we do the journal_file_buffer() before anybody
calls do_get_write_access/journal_get_create_access we will short
circuit these checks and b_modified will never be cleared and so when we
do journal_dirty_metadata we won't account for the new buffer and it
will end up inc'ing t_nr_buffers but not t_outstanding_credits.

I had thought this was the problem before and put in a jh->b_modified =
0 in __dispose_buffer, but apparently the problem still happened.  But
that support person/customer were not entirely reliable so I'm back to
thinking this is what happened and they just didn't run with my patch.

The problem is I don't think we can call journal_unmap_buffer() on just
a normal metadata block (that is with data=ordered), it only gets called
by ext3_invalidatepage() which is only called on pages on the inodes
address space, so not metadata.  However, Jan had a patch to delay the
free'ing of buffers for orphan reasons, with commit

86963918965eb8fe0c8ae009e7c1b4c630f533d5

which makes it seem like metadata can come through
journal_unmap_buffer()?  Does anybody know for sure one way or the
other?  And if you happen to have a theory on the actual problem itself
I would _love_ to hear it :).  Thanks,

Josef
