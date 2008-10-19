From: akpm@linux-foundation.org
Subject: [patch 088/148] jbd: abort when failed to log metadata buffers
Date: Sat, 18 Oct 2008 20:27:53 -0700
Message-ID: <200810190327.m9J3Rrw7032702@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, hidehiro.kawai.ez@hitachi.com,
	jack@suse.cz, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbYJSDeB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Oct 2008 23:34:01 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
