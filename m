From: akpm@linux-foundation.org
Subject: - jbd-abort-when-failed-to-log-metadata-buffers.patch removed from -mm tree
Date: Mon, 09 Jun 2008 15:12:11 -0700
Message-ID: <200806092212.m59MCBS2010896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, jack@suse.cz,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: abort when failed to log metadata buffers
has been removed from the -mm tree.  Its filename was
     jbd-abort-when-failed-to-log-metadata-buffers.patch

This patch was dropped because I don't think we want to go read-only on file data write errors

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: abort when failed to log metadata buffers
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

If we failed to write metadata buffers to the journal space and succeeded
to write the commit record, stale data can be written back to the
filesystem as metadata in the recovery phase.

To avoid this, when we failed to write out metadata buffers, abort the
journal before writing the commit record.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/commit.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/jbd/commit.c~jbd-abort-when-failed-to-log-metadata-buffers fs/jbd/commit.c
--- a/fs/jbd/commit.c~jbd-abort-when-failed-to-log-metadata-buffers
+++ a/fs/jbd/commit.c
@@ -734,6 +734,9 @@ wait_for_iobuf:
 		/* AKPM: bforget here */
 	}
 
+	if (err)
+		journal_abort(journal, err);
+
 	jbd_debug(3, "JBD: commit phase 6\n");
 
 	if (journal_write_commit_record(journal, commit_transaction))
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-abort-ext3-if-the-journal-has-aborted.patch
ext3-abort-ext3-if-the-journal-has-aborted-warning-fix.patch

