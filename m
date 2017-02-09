From: Nathan Howard <adanhawthorn@gmail.com>
Subject: [PATCH] fs: ext4: block_validity.c
Date: Thu,  9 Feb 2017 13:57:21 -0500
Message-ID: <1486666641-15658-1-git-send-email-adanhawthorn@gmail.com>
Cc: Nathan Howard <adanhawthorn@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixed coding style issues.

Signed-off-by: Nathan Howard <adanhawthorn@gmail.com>
---
 fs/ext4/block_validity.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index fdb1954..fead1f9 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -124,16 +124,16 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
 	struct ext4_system_zone *entry;
 	int first = 1;
 
-	printk(KERN_INFO "System zones: ");
+	pr_info("System zones: ");
 	node = rb_first(&sbi->system_blks);
 	while (node) {
 		entry = rb_entry(node, struct ext4_system_zone, node);
-		printk(KERN_CONT "%s%llu-%llu", first ? "" : ", ",
+		pr_cont("%s%llu-%llu", first ? "" : ", ",
 		       entry->start_blk, entry->start_blk + entry->count - 1);
 		first = 0;
 		node = rb_next(node);
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 int ext4_setup_system_zone(struct super_block *sb)
@@ -153,7 +153,7 @@ int ext4_setup_system_zone(struct super_block *sb)
 	if (EXT4_SB(sb)->system_blks.rb_node)
 		return 0;
 
-	for (i=0; i < ngroups; i++) {
+	for (i = 0; i < ngroups; i++) {
 		if (ext4_bg_has_super(sb, i) &&
 		    ((i < 5) || ((i % flex_size) == 0)))
 			add_system_zone(sbi, ext4_group_first_block_no(sb, i),
-- 
2.7.4
