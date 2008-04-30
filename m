From: akpm@linux-foundation.org
Subject: - ext4-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:49 -0700
Message-ID: <200804300546.m3U5knt0029643@imap1.linux-foundation.org>
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756682AbYD3FrV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 01:47:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     ext4-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: use non-racy method for proc entries creation
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

Patches currently in -mm which might be from den@openvz.org are

origin.patch
drivers-use-non-racy-method-for-proc-entries-creation-2-rio.patch
sunrpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree.patch
net-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv6-assign-pde-data-before-gluing-pde-into-proc-tree.patch
atm-assign-pde-data-before-gluing-pde-into-proc-tree.patch
vlan-assign-pde-data-before-gluing-pde-into-proc-tree.patch
cciss-assign-pde-data-before-gluing-pde-into-proc-tree.patch
powerpc-assign-pde-data-before-gluing-pde-into-proc-tree.patch
ipv4-assign-pde-data-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-fops-before-gluing-pde-into-proc-tree.patch
netfilter-assign-pde-data-before-gluing-pde-into-proc-tree-2.patch
netns-assign-pde-data-before-gluing-entry-into-proc-tree.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

