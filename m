From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Mon, 4 Jul 2016 10:14:35 -0400
Message-ID: <20160704141435.GA29557@thunk.org>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-2-git-send-email-jack@suse.cz>
 <20160630150548.GC2028@thunk.org>
 <20160701090950.GB22922@quack2.suse.cz>
 <20160701165339.GB6075@thunk.org>
 <20160701174041.GA30040@quack2.suse.cz>
 <20160701212634.GA14277@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160701212634.GA14277@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is what I'm currently testing; do you have objections to this?

It will make it harder if we ever want to teach lockdep how to notice
problems like this, but we don't at the moment, and it will make a
scalability difference in the common case...

						- Ted

>From 646caa9c8e196880b41cd3e3d33a2ebc752bdb85 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 4 Jul 2016 10:14:01 -0400
Subject: [PATCH] ext4: fix deadlock during page writeback

Commit 06bd3c36a733 (ext4: fix data exposure after a crash) uncovered a
deadlock in ext4_writepages() which was previously much harder to hit.
After this commit xfstest generic/130 reproduces the deadlock on small
filesystems.

The problem happens when ext4_do_update_inode() sets LARGE_FILE feature
and marks current inode handle as synchronous. That subsequently results
in ext4_journal_stop() called from ext4_writepages() to block waiting for
transaction commit while still holding page locks, reference to io_end,
and some prepared bio in mpd structure each of which can possibly block
transaction commit from completing and thus results in deadlock.

Fix the problem by releasing page locks, io_end reference, and
submitting prepared bio before calling ext4_journal_stop().

[ Changed to defer the call to ext4_journal_stop() only if the handle
  is synchronous.  --tytso ]

Reported-and-tested-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 44ee5d9..321a31c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2754,13 +2754,36 @@ retry:
 				done = true;
 			}
 		}
-		ext4_journal_stop(handle);
+		/*
+		 * Caution: If the handle is synchronous,
+		 * ext4_journal_stop() can wait for transaction commit
+		 * to finish which may depend on writeback of pages to
+		 * complete or on page lock to be released.  In that
+		 * case, we have to wait until after after we have
+		 * submitted all the IO, released page locks we hold,
+		 * and dropped io_end reference (for extent conversion
+		 * to be able to complete) before stopping the handle.
+		 */
+		if (!ext4_handle_valid(handle) || handle->h_sync == 0) {
+			ext4_journal_stop(handle);
+			handle = NULL;
+		}
 		/* Submit prepared bio */
 		ext4_io_submit(&mpd.io_submit);
 		/* Unlock pages we didn't use */
 		mpage_release_unused_pages(&mpd, give_up_on_write);
-		/* Drop our io_end reference we got from init */
-		ext4_put_io_end(mpd.io_submit.io_end);
+		/*
+		 * Drop our io_end reference we got from init. We have
+		 * to be careful and use deferred io_end finishing if
+		 * we are still holding the transaction as we can
+		 * release the last reference to io_end which may end
+		 * up doing unwritten extent conversion.
+		 */
+		if (handle) {
+			ext4_put_io_end_defer(mpd.io_submit.io_end);
+			ext4_journal_stop(handle);
+		} else
+			ext4_put_io_end(mpd.io_submit.io_end);
 
 		if (ret == -ENOSPC && sbi->s_journal) {
 			/*
-- 
2.5.0
