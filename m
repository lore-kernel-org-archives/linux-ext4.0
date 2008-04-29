From: akpm@linux-foundation.org
Subject: [patch 212/311] ext4: use non-racy method for proc entries creation
Date: Tue, 29 Apr 2008 01:02:08 -0700
Message-ID: <200804290802.m3T828lC009547@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, den@openvz.org, adobriyan@gmail.com,
	ebiederm@xmission.com, linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948AbYD2IKT (ORCPT
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

 fs/ext4/mballoc.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff -puN fs/ext4/mballoc.c~ext4-use-non-racy-method-for-proc-entries-creation fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-use-non-racy-method-for-proc-entries-creation
+++ a/fs/ext4/mballoc.c
@@ -2449,17 +2449,10 @@ static void ext4_mb_history_init(struct 
 	int i;
 
 	if (sbi->s_mb_proc != NULL) {
-		struct proc_dir_entry *p;
-		p = create_proc_entry("mb_history", S_IRUGO, sbi->s_mb_proc);
-		if (p) {
-			p->proc_fops = &ext4_mb_seq_history_fops;
-			p->data = sb;
-		}
-		p = create_proc_entry("mb_groups", S_IRUGO, sbi->s_mb_proc);
-		if (p) {
-			p->proc_fops = &ext4_mb_seq_groups_fops;
-			p->data = sb;
-		}
+		proc_create_data("mb_history", S_IRUGO, sbi->s_mb_proc,
+				 &ext4_mb_seq_history_fops, sb);
+		proc_create_data("mb_groups", S_IRUGO, sbi->s_mb_proc,
+				 &ext4_mb_seq_groups_fops, sb);
 	}
 
 	sbi->s_mb_history_max = 1000;
_
