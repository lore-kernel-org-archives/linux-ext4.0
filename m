From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] JBD2: fix debug config option
Date: Thu, 7 Jun 2007 23:45:24 -0500
Message-ID: <20070607234524.345d404d@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:57590 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbXFHEps (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jun 2007 00:45:48 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l584jmHR006481
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jun 2007 00:45:48 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l584jheD241188
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jun 2007 22:45:48 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l584jhKR003190
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jun 2007 22:45:43 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l584jhpX003183
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jun 2007 22:45:43 -0600
Received: from gara (sig-9-65-25-65.mts.ibm.com [9.65.25.65])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l584jf0X048646
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jun 2007 23:45:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When the JBD code was forked to create the new JBD2 code base, the
references to CONFIG_JBD_DEBUG where never changed to
CONFIG_JBD2_DEBUG.  This patch fixes that.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
---
Index: linux-2.6.22-rc3/fs/jbd2/journal.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/jbd2/journal.c	2007-06-04 11:01:20.828305672 -0500
+++ linux-2.6.22-rc3/fs/jbd2/journal.c	2007-06-07 23:10:58.838650182 -0500
@@ -529,7 +529,7 @@ int jbd2_log_wait_commit(journal_t *jour
 {
 	int err = 0;
 
-#ifdef CONFIG_JBD_DEBUG
+#ifdef CONFIG_JBD2_DEBUG
 	spin_lock(&journal->j_state_lock);
 	if (!tid_geq(journal->j_commit_request, tid)) {
 		printk(KERN_EMERG
@@ -2011,7 +2011,7 @@ void jbd2_slab_free(void *ptr,  size_t s
  * Journal_head storage management
  */
 static struct kmem_cache *jbd2_journal_head_cache;
-#ifdef CONFIG_JBD_DEBUG
+#ifdef CONFIG_JBD2_DEBUG
 static atomic_t nr_journal_heads = ATOMIC_INIT(0);
 #endif
 
@@ -2049,7 +2049,7 @@ static struct journal_head *journal_allo
 	struct journal_head *ret;
 	static unsigned long last_warning;
 
-#ifdef CONFIG_JBD_DEBUG
+#ifdef CONFIG_JBD2_DEBUG
 	atomic_inc(&nr_journal_heads);
 #endif
 	ret = kmem_cache_alloc(jbd2_journal_head_cache, GFP_NOFS);
@@ -2070,7 +2070,7 @@ static struct journal_head *journal_allo
 
 static void journal_free_journal_head(struct journal_head *jh)
 {
-#ifdef CONFIG_JBD_DEBUG
+#ifdef CONFIG_JBD2_DEBUG
 	atomic_dec(&nr_journal_heads);
 	memset(jh, JBD_POISON_FREE, sizeof(*jh));
 #endif
@@ -2255,12 +2255,12 @@ void jbd2_journal_put_journal_head(struc
 /*
  * /proc tunables
  */
-#if defined(CONFIG_JBD_DEBUG)
+#if defined(CONFIG_JBD2_DEBUG)
 int jbd2_journal_enable_debug;
 EXPORT_SYMBOL(jbd2_journal_enable_debug);
 #endif
 
-#if defined(CONFIG_JBD_DEBUG) && defined(CONFIG_PROC_FS)
+#if defined(CONFIG_JBD2_DEBUG) && defined(CONFIG_PROC_FS)
 
 static struct proc_dir_entry *proc_jbd_debug;
 
@@ -2398,7 +2398,7 @@ static int __init journal_init(void)
 
 static void __exit journal_exit(void)
 {
-#ifdef CONFIG_JBD_DEBUG
+#ifdef CONFIG_JBD2_DEBUG
 	int n = atomic_read(&nr_journal_heads);
 	if (n)
 		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
Index: linux-2.6.22-rc3/fs/jbd2/recovery.c
===================================================================
--- linux-2.6.22-rc3.orig/fs/jbd2/recovery.c	2007-05-25 21:55:14.000000000 -0500
+++ linux-2.6.22-rc3/fs/jbd2/recovery.c	2007-06-07 23:10:58.841983286 -0500
@@ -295,7 +295,7 @@ int jbd2_journal_skip_recovery(journal_t
 		printk(KERN_ERR "JBD: error %d scanning journal\n", err);
 		++journal->j_transaction_sequence;
 	} else {
-#ifdef CONFIG_JBD_DEBUG
+#ifdef CONFIG_JBD2_DEBUG
 		int dropped = info.end_transaction - be32_to_cpu(sb->s_sequence);
 #endif
 		jbd_debug(0,
Index: linux-2.6.22-rc3/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/ext4_fs.h	2007-06-04 11:01:21.688246570 -0500
+++ linux-2.6.22-rc3/include/linux/ext4_fs.h	2007-06-07 23:10:58.841983286 -0500
@@ -245,7 +245,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
 #define	EXT4_IOC_GETVERSION_OLD		FS_IOC_GETVERSION
 #define	EXT4_IOC_SETVERSION_OLD		FS_IOC_SETVERSION
-#ifdef CONFIG_JBD_DEBUG
+#ifdef CONFIG_JBD2_DEBUG
 #define EXT4_IOC_WAIT_FOR_READONLY	_IOR('f', 99, long)
 #endif
 #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
@@ -261,7 +261,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC32_GETRSVSZ		_IOR('f', 5, int)
 #define EXT4_IOC32_SETRSVSZ		_IOW('f', 6, int)
 #define EXT4_IOC32_GROUP_EXTEND		_IOW('f', 7, unsigned int)
-#ifdef CONFIG_JBD_DEBUG
+#ifdef CONFIG_JBD2_DEBUG
 #define EXT4_IOC32_WAIT_FOR_READONLY	_IOR('f', 99, int)
 #endif
 #define EXT4_IOC32_GETVERSION_OLD	FS_IOC32_GETVERSION
Index: linux-2.6.22-rc3/include/linux/ext4_fs_sb.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/ext4_fs_sb.h	2007-06-04 11:01:18.411805086 -0500
+++ linux-2.6.22-rc3/include/linux/ext4_fs_sb.h	2007-06-07 23:10:58.841983286 -0500
@@ -76,7 +76,7 @@ struct ext4_sb_info {
 	struct list_head s_orphan;
 	unsigned long s_commit_interval;
 	struct block_device *journal_bdev;
-#ifdef CONFIG_JBD_DEBUG
+#ifdef CONFIG_JBD2_DEBUG
 	struct timer_list turn_ro_timer;	/* For turning read-only (crash simulation) */
 	wait_queue_head_t ro_wait_queue;	/* For people waiting for the fs to go read-only */
 #endif
Index: linux-2.6.22-rc3/include/linux/jbd2.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/jbd2.h	2007-06-04 11:01:20.778309108 -0500
+++ linux-2.6.22-rc3/include/linux/jbd2.h	2007-06-07 23:10:58.845316391 -0500
@@ -50,11 +50,11 @@
  */
 #define JBD_DEFAULT_MAX_COMMIT_AGE 5
 
-#ifdef CONFIG_JBD_DEBUG
+#ifdef CONFIG_JBD2_DEBUG
 /*
  * Define JBD_EXPENSIVE_CHECKING to enable more expensive internal
  * consistency checks.  By default we don't do this unless
- * CONFIG_JBD_DEBUG is on.
+ * CONFIG_JBD2_DEBUG is on.
  */
 #define JBD_EXPENSIVE_CHECKING
 extern int jbd2_journal_enable_debug;



-JRS
