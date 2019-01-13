Return-Path: <SRS0=NEJw=PV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.12]:60996 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbfAMAgn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Jan 2019 19:36:43 -0500
From: Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu, Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] ext4: don't update s_rev_level if not required
Date: Sat, 12 Jan 2019 17:36:40 -0700
Message-Id: <1547339800-50257-1-git-send-email-adilger@dilger.ca>
In-Reply-To: <CAMuHMdULrGHfgF+RRGf5gXAc=V3KaB4549NezxEc3CvfsKWOyA@mail.gmail.com>
References: <CAMuHMdULrGHfgF+RRGf5gXAc=V3KaB4549NezxEc3CvfsKWOyA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't update the superblock s_rev_level during mount if it isn't
actually necessary, only if superblock features are being set by
the kernel.  This was originally added for ext3 since it always
set the INCOMPAT_RECOVER and HAS_JOURNAL features during mount,
but this is not needed since no journal mode was added to ext4.

That will allow Geert to mount his 20-year-old ext2 rev 0.0 m68k
filesystem, as a testament of the backward compatibility of ext4.

Fixes: 0390131ba84f ("ext4: Allow ext4 to run without a journal")
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h  | 3 +++
 fs/ext4/inode.c | 1 -
 fs/ext4/super.c | 1 -
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 185a05d..a1357f3 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1670,6 +1670,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 } \
 static inline void ext4_set_feature_##name(struct super_block *sb) \
 { \
+	ext4_update_dynamic_rev(sb); \
 	EXT4_SB(sb)->s_es->s_feature_compat |= \
 		cpu_to_le32(EXT4_FEATURE_COMPAT_##flagname); \
 } \
@@ -1687,6 +1688,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 } \
 static inline void ext4_set_feature_##name(struct super_block *sb) \
 { \
+	ext4_update_dynamic_rev(sb); \
 	EXT4_SB(sb)->s_es->s_feature_ro_compat |= \
 		cpu_to_le32(EXT4_FEATURE_RO_COMPAT_##flagname); \
 } \
@@ -1704,6 +1706,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 } \
 static inline void ext4_set_feature_##name(struct super_block *sb) \
 { \
+	ext4_update_dynamic_rev(sb); \
 	EXT4_SB(sb)->s_es->s_feature_incompat |= \
 		cpu_to_le32(EXT4_FEATURE_INCOMPAT_##flagname); \
 } \
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 34d7e07..f21f2ac 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5351,7 +5351,6 @@ static int ext4_do_update_inode(handle_t *handle,
 		err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
 		if (err)
 			goto out_brelse;
-		ext4_update_dynamic_rev(sb);
 		ext4_set_feature_large_file(sb);
 		ext4_handle_sync(handle);
 		err = ext4_handle_dirty_super(handle, sb);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fb12d3c..6e4cac6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2249,7 +2249,6 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 		es->s_max_mnt_count = cpu_to_le16(EXT4_DFL_MAX_MNT_COUNT);
 	le16_add_cpu(&es->s_mnt_count, 1);
 	ext4_update_tstamp(es, s_mtime);
-	ext4_update_dynamic_rev(sb);
 	if (sbi->s_journal)
 		ext4_set_feature_journal_needs_recovery(sb);
 
-- 
1.8.0
