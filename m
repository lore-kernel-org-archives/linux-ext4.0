From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] jbd2: fix infinite loop when recovering corrupt journal
 blocks
Date: Fri, 15 Aug 2014 13:43:52 -0700
Message-ID: <20140815204352.16444.79311.stgit@birch.djwong.org>
References: <20140815204346.16444.14064.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23718 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaHOUn6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2014 16:43:58 -0400
In-Reply-To: <20140815204346.16444.14064.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

When recovering the journal, don't fall into an infinite loop if we
encounter a corrupt journal block.  Instead, just skip the block and
return an error, which fails the mount and thus forces the user to run
a full filesystem fsck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/jbd2/recovery.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 3b6bb19..00e9703 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
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
