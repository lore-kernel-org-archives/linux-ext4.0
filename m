From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] jbd2: complain about descriptor block checksum errors
Date: Thu, 8 Jan 2015 12:03:34 -0800
Message-ID: <20150108200334.GB9976@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We should complain in dmesg when journal recovery fails on account of
the descriptor block being corrupt, so that the diagnostic data can
be recovered.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/jbd2/recovery.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index bcbef08..b5128c6 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -524,6 +524,9 @@ static int do_one_pass(journal_t *journal,
 			if (descr_csum_size > 0 &&
 			    !jbd2_descr_block_csum_verify(journal,
 							  bh->b_data)) {
+				printk(KERN_ERR "JBD2: Invalid checksum "
+				       "recovering block %lu in log\n",
+				       next_log_block);
 				err = -EIO;
 				brelse(bh);
 				goto failed;
