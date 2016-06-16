From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Thu, 16 Jun 2016 12:42:13 +0200
Message-ID: <1466073736-30447-2-git-send-email-jack@suse.cz>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
	Jan Kara <jack@suse.cz>, stable@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1466073736-30447-1-git-send-email-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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

Reported-and-tested-by: Eryu Guan <eguan@redhat.com>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f7140ca66e3b..ba04d57656d4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2748,13 +2748,27 @@ retry:
 				done = true;
 			}
 		}
-		ext4_journal_stop(handle);
 		/* Submit prepared bio */
 		ext4_io_submit(&mpd.io_submit);
 		/* Unlock pages we didn't use */
 		mpage_release_unused_pages(&mpd, give_up_on_write);
-		/* Drop our io_end reference we got from init */
-		ext4_put_io_end(mpd.io_submit.io_end);
+		/*
+		 * Drop our io_end reference we got from init. We have to be
+		 * careful and use deferred io_end finishing as we can release
+		 * the last reference to io_end which may end up doing unwritten
+		 * extent conversion which we cannot do while holding
+		 * transaction handle.
+		 */
+		ext4_put_io_end_defer(mpd.io_submit.io_end);
+		/*
+		 * Caution: ext4_journal_stop() can wait for transaction commit
+		 * to finish which may depend on writeback of pages to complete
+		 * or on page lock to be released. So we can call it only
+		 * after we have submitted all the IO, released page locks
+		 * we hold, and dropped io_end reference (for extent conversion
+		 * to be able to complete).
+		 */
+		ext4_journal_stop(handle);
 
 		if (ret == -ENOSPC && sbi->s_journal) {
 			/*
-- 
2.6.6
