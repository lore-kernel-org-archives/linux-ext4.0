From: akpm@linux-foundation.org
Subject: - jbd2-use-non-racy-method-for-proc-entries-creation.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:46:53 -0700
Message-ID: <200804300546.m3U5krC5029649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd2: use non-racy method for proc entries creation
has been removed from the -mm tree.  Its filename was
     jbd2-use-non-racy-method-for-proc-entries-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd2: use non-racy method for proc entries creation
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

