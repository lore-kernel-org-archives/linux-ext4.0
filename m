From: akpm@linux-foundation.org
Subject: [patch 214/311] jbd2: use non-racy method for proc entries creation
Date: Tue, 29 Apr 2008 01:02:11 -0700
Message-ID: <200804290802.m3T82BOs009555@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, den@openvz.org, adobriyan@gmail.com,
	ebiederm@xmission.com, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221AbYD2IKT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2008 04:10:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: <linux-ext4@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN fs/jbd2/journal.c~jbd2-use-non-racy-method-for-proc-entries-creation fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-use-non-racy-method-for-proc-entries-creation
+++ a/fs/jbd2/journal.c
@@ -904,19 +904,10 @@ static void jbd2_stats_proc_init(journal
 	snprintf(name, sizeof(name) - 1, "%s", bdevname(journal->j_dev, name));
 	journal->j_proc_entry = proc_mkdir(name, proc_jbd2_stats);
 	if (journal->j_proc_entry) {
-		struct proc_dir_entry *p;
-		p = create_proc_entry("history", S_IRUGO,
-				journal->j_proc_entry);
-		if (p) {
-			p->proc_fops = &jbd2_seq_history_fops;
-			p->data = journal;
-			p = create_proc_entry("info", S_IRUGO,
-						journal->j_proc_entry);
-			if (p) {
-				p->proc_fops = &jbd2_seq_info_fops;
-				p->data = journal;
-			}
-		}
+		proc_create_data("history", S_IRUGO, journal->j_proc_entry,
+				 &jbd2_seq_history_fops, journal);
+		proc_create_data("info", S_IRUGO, journal->j_proc_entry,
+				 &jbd2_seq_info_fops, journal);
 	}
 }
 
_
