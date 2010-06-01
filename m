From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.34.y 07/28] ext4: check s_log_groups_per_flex in online resize code
Date: Tue,  1 Jun 2010 12:12:54 -0400
Message-ID: <1275408795-17487-7-git-send-email-tytso@mit.edu>
References: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56891 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757119Ab0FAQNW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 12:13:22 -0400
In-Reply-To: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

commit 42007efd569f1cf3bfb9a61da60ef6c2179508ca upstream (as of v2.6.34-git13)

If groups_per_flex < 2, sbi->s_flex_groups[] doesn't get filled out,
and every other access to this first tests s_log_groups_per_flex;
same thing needs to happen in resize or we'll wander off into
a null pointer when doing an online resize of the file system.

Thanks to Christoph Biedl, who came up with the trivial testcase:

# truncate --size 128M fsfile
# mkfs.ext3 -F fsfile
# tune2fs -O extents,uninit_bg,dir_index,flex_bg,huge_file,dir_nlink,extra_isize fsfile
# e2fsck -yDf -C0 fsfile
# truncate --size 132M fsfile
# losetup /dev/loop0 fsfile
# mount /dev/loop0 mnt
# resize2fs -p /dev/loop0

	https://bugzilla.kernel.org/show_bug.cgi?id=13549

Reported-by: Alessandro Polverini <alex@nibbles.it>
Test-case-by: Christoph Biedl  <bugzilla.kernel.bpeb@manchmal.in-ulm.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 5692c48..6df797e 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -911,7 +911,8 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb));
 
-	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	    sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group;
 		flex_group = ext4_flex_group(sbi, input->group);
 		atomic_add(input->free_blocks_count,
-- 
1.6.6.1.1.g974db.dirty

