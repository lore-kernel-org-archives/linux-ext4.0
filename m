Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7072C10F0E
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 03:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACD0C2082E
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 03:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfDJDjM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 9 Apr 2019 23:39:12 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40956 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726825AbfDJDjM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2019 23:39:12 -0400
Received: from callcc.thunk.org (guestnat-104-133-9-102.corp.google.com [104.133.9.102] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3A3d6x4029345
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 9 Apr 2019 23:39:08 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 07D88421A0D; Tue,  9 Apr 2019 23:39:05 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] ext4: protect journal inode's blocks using block_validity
Date:   Tue,  9 Apr 2019 23:38:59 -0400
Message-Id: <20190410033859.5328-1-tytso@mit.edu>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Add the blocks which belong to the journal inode to block_validity's
system zone so attempts to deallocate or overwrite the journal due a
corrupted file system where the journal blocks are also claimed by
another inode.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202879
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/block_validity.c | 48 ++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c          |  4 ++++
 2 files changed, 52 insertions(+)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 913061c0de1b..9409b1e11a22 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -137,6 +137,48 @@ static void debug_print_tree(struct ext4_sb_info *sbi)
 	printk(KERN_CONT "\n");
 }
 
+static int ext4_protect_reserved_inode(struct super_block *sb, u32 ino)
+{
+	struct inode *inode;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_map_blocks map;
+	u32 i = 0, err = 0, num, n;
+
+	if ((ino < EXT4_ROOT_INO) ||
+	    (ino > le32_to_cpu(sbi->s_es->s_inodes_count)))
+		return -EINVAL;
+	inode = ext4_iget(sb, ino, EXT4_IGET_SPECIAL);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	num = (inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
+	while (i < num) {
+		map.m_lblk = i;
+		map.m_len = num - i;
+		n = ext4_map_blocks(NULL, inode, &map, 0);
+		if (n < 0) {
+			err = n;
+			break;
+		}
+		if (n == 0) {
+			i++;
+		} else {
+			if (!ext4_data_block_valid(sbi, map.m_pblk, n)) {
+				ext4_error(sb, "blocks %llu-%llu from inode %u "
+					   "overlap system zone", map.m_pblk,
+					   map.m_pblk + map.m_len - 1, ino);
+				err = -EFSCORRUPTED;
+				break;
+			}
+			err = add_system_zone(sbi, map.m_pblk, n);
+			if (err < 0)
+				break;
+			i += n;
+		}
+	}
+	iput(inode);
+	return err;
+}
+
 int ext4_setup_system_zone(struct super_block *sb)
 {
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
@@ -171,6 +213,12 @@ int ext4_setup_system_zone(struct super_block *sb)
 		if (ret)
 			return ret;
 	}
+	if (ext4_has_feature_journal(sb) && sbi->s_es->s_journal_inum) {
+		ret = ext4_protect_reserved_inode(sb,
+				le32_to_cpu(sbi->s_es->s_journal_inum));
+		if (ret)
+			return ret;
+	}
 
 	if (test_opt(sb, DEBUG))
 		debug_print_tree(sbi);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 190f0478582a..609c8366d029 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -399,6 +399,10 @@ static int __check_block_validity(struct inode *inode, const char *func,
 				unsigned int line,
 				struct ext4_map_blocks *map)
 {
+	if (ext4_has_feature_journal(inode->i_sb) &&
+	    (inode->i_ino ==
+	     le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_journal_inum)))
+		return 0;
 	if (!ext4_data_block_valid(EXT4_SB(inode->i_sb), map->m_pblk,
 				   map->m_len)) {
 		ext4_error_inode(inode, func, line, map->m_pblk,
-- 
2.19.1

