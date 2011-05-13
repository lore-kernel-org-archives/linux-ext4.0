From: Edward Goggin <egoggin@vmware.com>
Subject: [PATCH 1/1] jbd,jbd2 : Fix __log_start_commit for both jbd and jbd2
 to return 1 instead of 0 if target transaction is actively being committed.
Date: Fri, 13 May 2011 06:54:47 -0700
Message-ID: <4C88517147624A459A766BC451FA1BA4049532CED2@EXCH-MBX-4.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: 'Jan Kara' <jack@suse.cz>
To: "'linux-ext4@vger.kernel.org'" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:10073 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754509Ab1EMNyt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 May 2011 09:54:49 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

__log_start_commit for both jbd and jbd2 returns zero even when
the actively committing transaction has not yet completed. All
current callers of both __log_start_commit and its wrapper
function log_start_commit ignore the return value, but
ext4_sync_file does not. Unfortunately a return value of zero
from the call to log_start_commit in ext4_sync_file causes
ext4_sync_file to not call jbd2_log_wait_commit.

If jbd2_log_wait_commit is not called it is possible for the
calling context to return from ext4 without having persisted
the updates to the meta data (assume a write to a previously
unallocated region of a file) associated with the current ext4
operation. If the context calling ext4_sync_file is an nfs daemon,
the daemon has the potential of acknowledging the nfs write
request to its client before the ext4 meta data (assume journal
mode of (data=ordered) is persistent. Data corruption (lost write)
is possible if after the reply for the nfs request is sent, a
power outage, kernel panic, or other similar unorderly shutdown
precludes the actual committing of the jbd2 transaction required
to later retrieve the data written to the file.

This issue appears to be addressed for ext3 by
http://kerneltrap.org/mailarchive/linux-ext4/2010/4/26/6884343.
It is not clear why similar changes were not applied to ext4/jbd2
at that time.

Signed-off-by: Ed Goggin <egoggin@vmware.com>

diff -uprN linux-2.6.38.5//fs/jbd/journal.c linux-2.6.38.5.fix//fs/jbd/journal.c
--- linux-2.6.38.5//fs/jbd/journal.c    2011-05-02 16:30:53.000000000 +0000
+++ linux-2.6.38.5.fix//fs/jbd/journal.c        2011-05-12 21:27:04.000000000 +0000
@@ -452,6 +452,16 @@ int __log_start_commit(journal_t *journa
                wake_up(&journal->j_wait_commit);
                return 1;
        }
+        else if (journal->j_commit_request == target) {
+                /*
+                 * Return 1 so caller will wait for actively committing
+                 * transaction if they depend on this return value.
+                 */
+                jbd_debug(1, "JBD: requesting commit is current commit %d/%d\n",
+                          journal->j_commit_request,
+                          journal->j_commit_sequence);
+                return 1;
+        }
        return 0;
 }

diff -uprN linux-2.6.38.5//fs/jbd2/journal.c linux-2.6.38.5.fix//fs/jbd2/journal.c
--- linux-2.6.38.5//fs/jbd2/journal.c   2011-05-02 16:30:53.000000000 +0000
+++ linux-2.6.38.5.fix//fs/jbd2/journal.c       2011-05-12 21:26:53.000000000 +0000
@@ -494,6 +494,16 @@ int __jbd2_log_start_commit(journal_t *j
                wake_up(&journal->j_wait_commit);
                return 1;
        }
+        else if (journal->j_commit_request == target) {
+                /*
+                 * Return 1 so caller will wait for actively committing
+                 * transaction if they depend on this return value.
+                 */
+                jbd_debug(1, "JBD: requesting commit is current commit %d/%d\n",
+                          journal->j_commit_request,
+                          journal->j_commit_sequence);
+                return 1;
+        }
        return 0;
 }