From: Shaohua Li <shli@kernel.org>
Subject: [RFC]jbd2: use GFP_NOFS for blkdev_issue_flush
Date: Fri, 13 Apr 2012 10:27:35 +0800
Message-ID: <4F878F17.2030900@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


flush request is issued in transaction commit code path, so looks using
GFP_KERNEL to allocate memory for flush request bio falls into the classic
deadlock issue.  I saw btrfs and dm get it right, but ext4, xfs and md are
using GFP_KERNEL, which makes me confused. Hoping filesystem developers
clarify.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
  fs/jbd2/commit.c |    4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/fs/jbd2/commit.c
===================================================================
--- linux.orig/fs/jbd2/commit.c	2012-04-13 09:57:51.785506925 +0800
+++ linux/fs/jbd2/commit.c	2012-04-13 09:58:29.585498773 +0800
@@ -723,7 +723,7 @@ start_journal_io:
  	if (commit_transaction->t_need_data_flush &&
  	    (journal->j_fs_dev != journal->j_dev) &&
  	    (journal->j_flags & JBD2_BARRIER))
-		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
+		blkdev_issue_flush(journal->j_fs_dev, GFP_NOFS, NULL);

  	/* Done it all: now write the commit record asynchronously. */
  	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
@@ -859,7 +859,7 @@ wait_for_iobuf:
  	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
  				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
  	    journal->j_flags & JBD2_BARRIER) {
-		blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL);
+		blkdev_issue_flush(journal->j_dev, GFP_NOFS, NULL);
  	}

  	if (err)
