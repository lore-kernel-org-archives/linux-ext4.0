From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] jbd2: fix kernel-doc notation
Date: Thu, 13 Mar 2008 17:02:06 -0700
Message-ID: <20080313170206.ffc12730.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:38589 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898AbYCNADk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 20:03:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc notation in jbd2.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/jbd2/journal.c     |    5 +++--
 fs/jbd2/transaction.c |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

--- mmotm-2008-0312-2333.orig/fs/jbd2/journal.c
+++ mmotm-2008-0312-2333/fs/jbd2/journal.c
@@ -1007,13 +1007,14 @@ fail:
  */
 
 /**
- *  journal_t * jbd2_journal_init_dev() - creates an initialises a journal structure
+ *  journal_t * jbd2_journal_init_dev() - creates and initialises a journal structure
  *  @bdev: Block device on which to create the journal
  *  @fs_dev: Device which hold journalled filesystem for this journal.
  *  @start: Block nr Start of journal.
  *  @len:  Length of the journal in blocks.
  *  @blocksize: blocksize of journalling device
- *  @returns: a newly created journal_t *
+ *
+ *  Returns: a newly created journal_t *
  *
  *  jbd2_journal_init_dev creates a journal which maps a fixed contiguous
  *  range of blocks on an arbitrary block device.
--- mmotm-2008-0312-2333.orig/fs/jbd2/transaction.c
+++ mmotm-2008-0312-2333/fs/jbd2/transaction.c
@@ -1462,7 +1462,8 @@ int jbd2_journal_stop(handle_t *handle)
 	return err;
 }
 
-/**int jbd2_journal_force_commit() - force any uncommitted transactions
+/**
+ * int jbd2_journal_force_commit() - force any uncommitted transactions
  * @journal: journal to force
  *
  * For synchronous operations: force any uncommitted transactions
