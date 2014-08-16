From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/27] e2fsck: fix infinite loop when recovering corrupt
 journal blocks
Date: Sat, 16 Aug 2014 16:46:55 -0700
Message-ID: <20140816234655.11171.49022.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43454 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbaHPXrA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:47:00 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When recovering the journal, don't fall into an infinite loop if we
encounter a corrupt journal block.  Instead, just skip the block and
proceed with the full filesystem fsck.

The test case for this will be "j_corrupt_journal_block" further on
in the patch series.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/recovery.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index e4c7519..0e194be 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -426,6 +426,7 @@ static int do_one_pass(journal_t *journal,
 	int			tag_bytes = journal_tag_bytes(journal);
 	__u32			crc32_sum = ~0; /* Transactional Checksums */
 	int			descr_csum_size = 0;
+	int			block_error = 0;
 
 	/*
 	 * First thing is to establish what we expect to find in the log
@@ -598,7 +599,8 @@ static int do_one_pass(journal_t *journal,
 						       "checksum recovering "
 						       "block %llu in log\n",
 						       blocknr);
-						continue;
+						block_error = 1;
+						goto skip_write;
 					}
 
 					/* Find a buffer for the new
@@ -797,7 +799,8 @@ static int do_one_pass(journal_t *journal,
 				success = -EIO;
 		}
 	}
