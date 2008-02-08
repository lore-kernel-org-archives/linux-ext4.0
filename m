From: akpm@linux-foundation.org
Subject: [patch 232/233] ext3 can fail badly when device stops accepting BIO_RW_BARRIER requests
Date: Fri, 08 Feb 2008 04:22:13 -0800
Message-ID: <200802081221.m18CLsLH024624@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, neilb@suse.de,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51104 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753777AbYBHM3b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2008 07:29:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Neil Brown <neilb@suse.de>

Some devices - notably dm and md - can change their behaviour in response
to BIO_RW_BARRIER requests.  They might start out accepting such requests
but on reconfiguration, they find out that they cannot any more.

ext3 (and other filesystems) deal with this by always testing if
BIO_RW_BARRIER requests fail with EOPNOTSUPP, and retrying the write
requests without the barrier (probably after waiting for any pending writes
to complete).

However there is a bug in the handling for this for ext3.

When ext3 (jbd actually) decides to submit a BIO_RW_BARRIER request, it
sets the buffer_ordered flag on the buffer head.  If the request completes
successfully, the flag STAYS SET.

Other code might then write the same buffer_head after the device has been
reconfigured to not accept barriers.  This write will then fail, but the
"other code" is not ready to handle EOPNOTSUPP errors and the error will be
treated as fatal.

This can be seen without having to reconfigure a device at exactly the
wrong time by putting:

		if (buffer_ordered(bh))
			printk("OH DEAR, and ordered buffer\n");

in the while loop in "commit phase 5" of journal_commit_transaction.

If it ever prints the "OH DEAR ..." message (as it does sometimes for
me), then that request could (in different circumstances) have failed
with EOPNOTSUPP, but that isn't tested for.

My proposed fix is to clear the buffer_ordered flag after it has been
used, as in the following patch.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/jbd/commit.c~ext3-can-fail-badly-when-device-stops-accepting-bio_rw_barrier-requests fs/jbd/commit.c
--- a/fs/jbd/commit.c~ext3-can-fail-badly-when-device-stops-accepting-bio_rw_barrier-requests
+++ a/fs/jbd/commit.c
@@ -131,6 +131,8 @@ static int journal_write_commit_record(j
 		barrier_done = 1;
 	}
 	ret = sync_dirty_buffer(bh);
+	if (barrier_done)
+		clear_buffer_ordered(bh);
 	/* is it possible for another commit to fail at roughly
 	 * the same time as this one?  If so, we don't want to
 	 * trust the barrier flag in the super, but instead want
@@ -148,7 +150,6 @@ static int journal_write_commit_record(j
 		spin_unlock(&journal->j_state_lock);
 
 		/* And try again, without the barrier */
-		clear_buffer_ordered(bh);
 		set_buffer_uptodate(bh);
 		set_buffer_dirty(bh);
 		ret = sync_dirty_buffer(bh);
_
