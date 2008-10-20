From: akpm@linux-foundation.org
Subject: - jbd-abort-when-failed-to-log-metadata-buffers.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:48 -0700
Message-ID: <200810202035.m9KKZmDF011224@imap1.linux-foundation.org>
To: hidehiro.kawai.ez@hitachi.com, jack@suse.cz,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616AbYJTUg1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Oct 2008 16:36:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd: abort when failed to log metadata buffers
has been removed from the -mm tree.  Its filename was
     jbd-abort-when-failed-to-log-metadata-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -762,6 +762,9 @@ wait_for_iobuf:
 		/* AKPM: bforget here */
 	}
 
+	if (err)
+		journal_abort(journal, err);
+
 	jbd_debug(3, "JBD: commit phase 6\n");
 
 	if (journal_write_commit_record(journal, commit_transaction))
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

origin.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-add-checks-for-errors-from-jbd.patch
jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch

