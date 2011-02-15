From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: mark objects for local use as static
Date: Tue, 15 Feb 2011 20:43:18 +0100
Message-ID: <1297798998-19306-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875Ab1BOTnX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Feb 2011 14:43:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Certain object in ext4 code are supposed to be used only locally, but
are not defined as static. Fix it by adding static into definition.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/mballoc.c |    3 ++-
 fs/ext4/super.c   |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d1fe09a..ae4d7f5 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4753,7 +4753,8 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
  * bitmap. Then issue a TRIM command on this extent and free the extent in
  * the group buddy bitmap. This is done until whole group is scanned.
  */
-ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
+static ext4_grpblk_t
+ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 		ext4_grpblk_t start, ext4_grpblk_t max, ext4_grpblk_t minblocks)
 {
 	void *bitmap;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f6a318f..5fe6d1b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -54,9 +54,9 @@
 
 static struct proc_dir_entry *ext4_proc_root;
 static struct kset *ext4_kset;
-struct ext4_lazy_init *ext4_li_info;
-struct mutex ext4_li_mtx;
-struct ext4_features *ext4_feat;
+static struct ext4_lazy_init *ext4_li_info;
+static struct mutex ext4_li_mtx;
+static struct ext4_features *ext4_feat;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
 			     unsigned long journal_devnum);
-- 
1.7.4

