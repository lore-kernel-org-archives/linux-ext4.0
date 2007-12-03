From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/4] ext4: Address various akpm jbd2 stats comments
Date: Mon, 03 Dec 2007 17:29:47 -0600
Message-ID: <4754916B.2060607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbXLCX3s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Dec 2007 18:29:48 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lB3NTmnA032613
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 18:29:48 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lB3NTlpP016216
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 18:29:47 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id lB3NTlfm022144
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 18:29:47 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(Andrew, cc'ing you since these address your original review comments; feel free
to just pick the patch up via Ted/Mingming if you prefer)

Address several of akpm's comments on the jbd2 stats patch:

o return -ENOMEM not -EIO on memory failure
o avoid unneeded casts of void pointers
o minor formatting changes
o size bdevname char arrays with BDEVNAME_SIZE
o use "#ifdef" vs. "#if defined()" for single test

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc3/fs/jbd2/journal.c
===================================================================
--- linux-2.6.24-rc3.orig/fs/jbd2/journal.c
+++ linux-2.6.24-rc3/fs/jbd2/journal.c
@@ -747,12 +747,12 @@ static int jbd2_seq_history_open(struct 
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (s == NULL)
-		return -EIO;
+		return -ENOMEM;
 	size = sizeof(struct transaction_stats_s) * journal->j_history_max;
 	s->stats = kmalloc(size, GFP_KERNEL);
 	if (s->stats == NULL) {
 		kfree(s);
-		return -EIO;
+		return -ENOMEM;
 	}
 	spin_lock(&journal->j_history_lock);
 	memcpy(s->stats, journal->j_history, size);
@@ -762,7 +762,7 @@ static int jbd2_seq_history_open(struct 
 
 	rc = seq_open(file, &jbd2_seq_history_ops);
 	if (rc == 0) {
-		struct seq_file *m = (struct seq_file *)file->private_data;
+		struct seq_file *m = file->private_data;
 		m->private = s;
 	} else {
 		kfree(s->stats);
@@ -774,8 +774,9 @@ static int jbd2_seq_history_open(struct 
 
 static int jbd2_seq_history_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq = (struct seq_file *)file->private_data;
+	struct seq_file *seq = file->private_data;
 	struct jbd2_stats_proc_session *s = seq->private;
+
 	kfree(s->stats);
 	kfree(s);
 	return seq_release(inode, file);
@@ -802,6 +803,7 @@ static void *jbd2_seq_info_next(struct s
 static int jbd2_seq_info_show(struct seq_file *seq, void *v)
 {
 	struct jbd2_stats_proc_session *s = seq->private;
+
 	if (v != SEQ_START_TOKEN)
 		return 0;
 	seq_printf(seq, "%lu transaction, each upto %u blocks\n",
@@ -847,12 +849,12 @@ static int jbd2_seq_info_open(struct ino
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (s == NULL)
-		return -EIO;
+		return -ENOMEM;
 	size = sizeof(struct transaction_stats_s);
 	s->stats = kmalloc(size, GFP_KERNEL);
 	if (s->stats == NULL) {
 		kfree(s);
-		return -EIO;
+		return -ENOMEM;
 	}
 	spin_lock(&journal->j_history_lock);
 	memcpy(s->stats, &journal->j_stats, size);
@@ -861,7 +863,7 @@ static int jbd2_seq_info_open(struct ino
 
 	rc = seq_open(file, &jbd2_seq_info_ops);
 	if (rc == 0) {
-		struct seq_file *m = (struct seq_file *)file->private_data;
+		struct seq_file *m = file->private_data;
 		m->private = s;
 	} else {
 		kfree(s->stats);
@@ -873,7 +875,7 @@ static int jbd2_seq_info_open(struct ino
 
 static int jbd2_seq_info_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq = (struct seq_file *)file->private_data;
+	struct seq_file *seq = file->private_data;
 	struct jbd2_stats_proc_session *s = seq->private;
 	kfree(s->stats);
 	kfree(s);
@@ -892,7 +894,7 @@ static struct proc_dir_entry *proc_jbd2_
 
 static void jbd2_stats_proc_init(journal_t *journal)
 {
-	char name[64];
+	char name[BDEVNAME_SIZE];
 
 	snprintf(name, sizeof(name) - 1, "%s", bdevname(journal->j_dev, name));
 	journal->j_proc_entry = proc_mkdir(name, proc_jbd2_stats);
@@ -915,7 +917,7 @@ static void jbd2_stats_proc_init(journal
 
 static void jbd2_stats_proc_exit(journal_t *journal)
 {
-	char name[64];
+	char name[BDEVNAME_SIZE];
 
 	snprintf(name, sizeof(name) - 1, "%s", bdevname(journal->j_dev, name));
 	remove_proc_entry("info", journal->j_proc_entry);
@@ -2207,7 +2209,7 @@ static void __exit jbd2_remove_debugfs_e
 
 #endif
 
-#if defined(CONFIG_PROC_FS)
+#ifdef CONFIG_PROC_FS
 
 #define JBD2_STATS_PROC_NAME "fs/jbd2"
 

 
