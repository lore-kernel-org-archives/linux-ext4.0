From: Aditya Kali <adityakali@google.com>
Subject: [PATCH] ext4: Avoid unnecessary calls to ext4_mb_load_buddy while
 reading mb_groups proc file
Date: Fri, 14 Jan 2011 14:05:15 -0800
Message-ID: <AANLkTimPwhK1NggZAkCzB8Q29Ogf5SswH1kBbH8WAjX7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5833 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab1ANWFi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Jan 2011 17:05:38 -0500
Received: from kpbe18.cbf.corp.google.com (kpbe18.cbf.corp.google.com [172.25.105.82])
	by smtp-out.google.com with ESMTP id p0EM5bLI009037
	for <linux-ext4@vger.kernel.org>; Fri, 14 Jan 2011 14:05:37 -0800
Received: from pxi2 (pxi2.prod.google.com [10.243.27.2])
	by kpbe18.cbf.corp.google.com with ESMTP id p0EM5aIg005162
	for <linux-ext4@vger.kernel.org>; Fri, 14 Jan 2011 14:05:36 -0800
Received: by pxi2 with SMTP id 2so551750pxi.12
        for <linux-ext4@vger.kernel.org>; Fri, 14 Jan 2011 14:05:36 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently ext4_mb_load_buddy is called for every group, irrespective
of whether the group info is already in memory, while reading
/proc/fs/ext4/<partition>/mb_groups proc file. For the purpose of
mb_groups proc file, it is unnecessary to load the file group info
from disk if it was loaded in past. These calls to ext4_mb_load_buddy
make reading the mb_groups proc file expensive.
Also, the locks around ext4_get_group_info are not required.
This patch modifies the code to call ext4_mb_load_buddy only if the
group info had never been loaded into memory in past. It also removes
the mb group locking around ext4_get_group_info call.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 fs/ext4/mballoc.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 851f49b..5738082 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2171,8 +2171,9 @@ static int ext4_mb_seq_groups_show(struct
seq_file *seq, void *v)
 	struct super_block *sb = seq->private;
 	ext4_group_t group = (ext4_group_t) ((unsigned long) v);
 	int i;
-	int err;
+	int err, buddy_loaded = 0;
 	struct ext4_buddy e4b;
+	struct ext4_group_info *grinfo;
 	struct sg {
 		struct ext4_group_info info;
 		ext4_grpblk_t counters[16];
@@ -2189,15 +2190,21 @@ static int ext4_mb_seq_groups_show(struct
seq_file *seq, void *v)

 	i = (sb->s_blocksize_bits + 2) * sizeof(sg.info.bb_counters[0]) +
 		sizeof(struct ext4_group_info);
-	err = ext4_mb_load_buddy(sb, group, &e4b);
-	if (err) {
-		seq_printf(seq, "#%-5u: I/O error\n", group);
-		return 0;
+	grinfo = ext4_get_group_info(sb, group);
+	/* Load the group info in memory only if not already loaded. */
+	if (unlikely(EXT4_MB_GRP_NEED_INIT(grinfo))) {
+		err = ext4_mb_load_buddy(sb, group, &e4b);
+		if (err) {
+			seq_printf(seq, "#%-5u: I/O error\n", group);
+			return 0;
+		}
+		buddy_loaded = 1;
 	}
-	ext4_lock_group(sb, group);
+
 	memcpy(&sg, ext4_get_group_info(sb, group), i);
-	ext4_unlock_group(sb, group);
-	ext4_mb_unload_buddy(&e4b);
+
+	if (buddy_loaded)
+		ext4_mb_unload_buddy(&e4b);

 	seq_printf(seq, "#%-5u: %-5u %-5u %-5u [", group, sg.info.bb_free,
 			sg.info.bb_fragments, sg.info.bb_first_free);
-- 
1.7.3.1
