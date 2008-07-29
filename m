From: akpm@linux-foundation.org
Subject: + jbd-abort-when-failed-to-log-metadata-buffers.patch added to -mm tree
Date: Mon, 28 Jul 2008 23:57:44 -0700
Message-ID: <200807290657.m6T6vi4Y019825@imap1.linux-foundation.org>
Cc: hidehiro.kawai.ez@hitachi.com, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbYG2G5w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2008 02:57:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd: abort when failed to log metadata buffers
has been added to the -mm tree.  Its filename is
     jbd-abort-when-failed-to-log-metadata-buffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-abort-ext3-if-the-journal-has-aborted.patch
jbd-dont-dirty-original-metadata-buffer-on-abort.patch

