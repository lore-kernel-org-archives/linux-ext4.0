From: Greg KH <gregkh@suse.de>
Subject: [patch 18/36] jbd2: Add barrier not supported test to
	journal_wait_on_commit_record
Date: Wed, 18 Feb 2009 14:29:30 -0800
Message-ID: <20090218222930.GS10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:34909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757896AbZBRWcJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 17:32:09 -0500
Content-Disposition: inline; filename="jbd2-add-barrier-not-supported-test-to-journal_wait_on_commit_record.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Theodore Ts'o" <tytso@mit.edu>

(cherry picked from commit fd98496f467b3d26d05ab1498f41718b5ef13de5)

Xen doesn't report that barriers are not supported until buffer I/O is
reported as completed, instead of when the buffer I/O is submitted.
Add a check and a fallback codepath to journal_wait_on_commit_record()
to detect this case, so that attempts to mount ext4 filesystems on
LVM/devicemapper devices on Xen guests don't blow up with an "Aborting
journal on device XXX"; "Remounting filesystem read-only" error.

Thanks to Andreas Sundstrom for reporting this issue.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd2/commit.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -24,6 +24,7 @@
 #include <linux/crc32.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
+#include <linux/bio.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -170,12 +171,34 @@ static int journal_submit_commit_record(
  * This function along with journal_submit_commit_record
  * allows to write the commit record asynchronously.
  */
-static int journal_wait_on_commit_record(struct buffer_head *bh)
+static int journal_wait_on_commit_record(journal_t *journal,
+					 struct buffer_head *bh)
 {
 	int ret = 0;
 
+retry:
 	clear_buffer_dirty(bh);
 	wait_on_buffer(bh);
+	if (buffer_eopnotsupp(bh) && (journal->j_flags & JBD2_BARRIER)) {
+		printk(KERN_WARNING
+		       "JBD2: wait_on_commit_record: sync failed on %s - "
+		       "disabling barriers\n", journal->j_devname);
+		spin_lock(&journal->j_state_lock);
+		journal->j_flags &= ~JBD2_BARRIER;
+		spin_unlock(&journal->j_state_lock);
+
+		lock_buffer(bh);
+		clear_buffer_dirty(bh);
+		set_buffer_uptodate(bh);
+		bh->b_end_io = journal_end_buffer_io_sync;
+
+		ret = submit_bh(WRITE_SYNC, bh);
+		if (ret) {
+			unlock_buffer(bh);
+			return ret;
+		}
+		goto retry;
+	}
 
 	if (unlikely(!buffer_uptodate(bh)))
 		ret = -EIO;
@@ -795,7 +818,7 @@ wait_for_iobuf:
 			__jbd2_journal_abort_hard(journal);
 	}
 	if (!err && !is_journal_aborted(journal))
-		err = journal_wait_on_commit_record(cbh);
+		err = journal_wait_on_commit_record(journal, cbh);
 
 	if (err)
 		jbd2_journal_abort(journal, err);

