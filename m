From: Eric Sandeen <esandeen@redhat.com>
Subject: [PATCH] 16T fixes for JBD
Date: Wed, 20 Sep 2006 15:19:26 -0500
Message-ID: <4511A24E.1010002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:28889 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1750721AbWITUT1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Sep 2006 16:19:27 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k8KKJRFP007826
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 16:19:27 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k8KKJRXR024470
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 16:19:27 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id k8KKJQEH020893
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 16:19:26 -0400
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

These are a few places I've found in jbd that look like they
may not be 16T-safe, or consistent with the use of unsigned
longs for block containers.

(well, some of these have come from the ext4 work on jbd
as well - although I think some of the ext4/jbd2 modifications
may not be needed, see my earlier messages today).

I think there's one more possibility that the wrap()
function may not be safe IF your last block in the journal
butts right up against the 2^32 block boundary, but that seems
like a VERY remote possibility, and I'm not worrying about it
at this point.  

Comments?  I'll send this upstream if it looks good.

Thanks,

-Eric

Signed-off-by: Eric Sandeen <esandeen@redhat.com>

Index: linux-2.6.17-1.2654.el5/fs/jbd/journal.c
===================================================================
--- linux-2.6.17-1.2654.el5.orig/fs/jbd/journal.c
+++ linux-2.6.17-1.2654.el5/fs/jbd/journal.c
@@ -271,7 +271,7 @@ static void journal_kill_thread(journal_
 int journal_write_metadata_buffer(transaction_t *transaction,
 				  struct journal_head  *jh_in,
 				  struct journal_head **jh_out,
-				  int blocknr)
+				  unsigned long blocknr)
 {
 	int need_copy_out = 0;
 	int done_copy_out = 0;
@@ -696,7 +696,7 @@ fail:
  *  @bdev: Block device on which to create the journal
  *  @fs_dev: Device which hold journalled filesystem for this journal.
  *  @start: Block nr Start of journal.
- *  @len:  Lenght of the journal in blocks.
+ *  @len:  Length of the journal in blocks.
  *  @blocksize: blocksize of journalling device
  *  @returns: a newly created journal_t *
  *  
@@ -820,7 +820,7 @@ static void journal_fail_superblock (jou
 static int journal_reset(journal_t *journal)
 {
 	journal_superblock_t *sb = journal->j_superblock;
-	unsigned int first, last;
+	unsigned long first, last;
 
 	first = be32_to_cpu(sb->s_first);
 	last = be32_to_cpu(sb->s_maxlen);
Index: linux-2.6.17-1.2654.el5/include/linux/jbd.h
===================================================================
--- linux-2.6.17-1.2654.el5.orig/include/linux/jbd.h
+++ linux-2.6.17-1.2654.el5/include/linux/jbd.h
@@ -732,7 +732,7 @@ struct journal_s
 	 */
 	struct block_device	*j_dev;
 	int			j_blocksize;
-	unsigned int		j_blk_offset;
+	unsigned long		j_blk_offset;
 
 	/*
 	 * Device which holds the client fs.  For internal journal this will be
@@ -866,7 +866,7 @@ extern int 
 journal_write_metadata_buffer(transaction_t	  *transaction,
 			      struct journal_head  *jh_in,
 			      struct journal_head **jh_out,
-			      int		   blocknr);
+			      unsigned long	   blocknr);
 
 /* Transaction locking */
 extern void		__wait_on_journal (journal_t *);


