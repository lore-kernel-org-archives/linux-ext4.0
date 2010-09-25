From: Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 09/10] Fs: ext4: mballoc.c: whitespace cleanup
Date: Sat, 25 Sep 2010 14:32:00 -0400
Message-ID: <1285439521-2557-9-git-send-email-tdent48227@gmail.com>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>,
	Tracey Dent <tden48227@gmail.com>
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tracey Dent <Tdent48227@gmail.com>

Fixed whitespace and indent issues that checkpatch.pl had an issue with

Signed-off-by: Tracey Dent <tden48227@gmail.com>
---
 fs/ext4/mballoc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4b4ad4b..0bc545c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2410,9 +2410,9 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	i = (sb->s_blocksize_bits + 2) * sizeof(*sbi->s_mb_offsets);
 
 	sbi->s_mb_offsets = kmalloc(i, GFP_KERNEL);
-	if (sbi->s_mb_offsets == NULL) {
+	if (sbi->s_mb_offsets == NULL) 
 		return -ENOMEM;
-	}
+	
 
 	i = (sb->s_blocksize_bits + 2) * sizeof(*sbi->s_mb_maxs);
 	sbi->s_mb_maxs = kmalloc(i, GFP_KERNEL);
@@ -3908,7 +3908,7 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 			(int)ac->ac_criteria);
 	printk(KERN_ERR "EXT4-fs: %lu scanned, %d found\n", ac->ac_ex_scanned,
 		ac->ac_found);
-	printk(KERN_ERR "EXT4-fs: groups: \n");
+	printk(KERN_ERR "EXT4-fs: groups:\n");
 	ngroups = ext4_get_groups_count(sb);
 	for (i = 0; i < ngroups; i++) {
 		struct ext4_group_info *grp = ext4_get_group_info(sb, i);
@@ -3923,14 +3923,14 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 			ext4_get_group_no_and_offset(sb, pa->pa_pstart,
 						     NULL, &start);
 			spin_unlock(&pa->pa_lock);
-			printk(KERN_ERR "PA:%u:%d:%u \n", i,
+			printk(KERN_ERR "PA:%u:%d:%u\n", i,
 			       start, pa->pa_len);
 		}
 		ext4_unlock_group(sb, i);
 
 		if (grp->bb_free == 0)
 			continue;
-		printk(KERN_ERR "%u: %d/%d \n",
+		printk(KERN_ERR "%u: %d/%d\n",
 		       i, grp->bb_free, grp->bb_fragments);
 	}
 	printk(KERN_ERR "\n");
-- 
1.7.3
