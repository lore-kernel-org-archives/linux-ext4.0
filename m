Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46032 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbeKUKn1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2018 05:43:27 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH] ext2fs: Fix build of new superblock fields on BE machines
Date: Tue, 20 Nov 2018 19:11:27 -0500
Message-Id: <20181121001127.1868-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

New superblock fields must be byte swapped before being accessed in Big
Endian machines.

Not tested on an actual BE machine.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---

I just noticed this today.  I don't see the patch that includes this
field already pushed to kernel.org, so if you want to squash this one to
that patch before pushing to make the result more bisectable in BE
machines, I am ok with that.

 lib/ext2fs/swapfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index b168a2f20208..a1560045d073 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -129,8 +129,11 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_lpf_ino = ext2fs_swab32(sb->s_lpf_ino);
 	sb->s_prj_quota_inum = ext2fs_swab32(sb->s_prj_quota_inum);
 	sb->s_checksum_seed = ext2fs_swab32(sb->s_checksum_seed);
+	/* s_*_time_hi are __u8 and does not need swabbing */
+	sb->s_encoding = ext2fs_swab16(sb->s_encoding);
+	sb->s_encoding_flags = ext2fs_swab16(sb->s_encoding_flags);
 	/* catch when new fields are used from s_reserved */
-	EXT2FS_BUILD_BUG_ON(sizeof(sb->s_reserved) != 98 * sizeof(__le32));
+	EXT2FS_BUILD_BUG_ON(sizeof(sb->s_reserved) != 95 * sizeof(__le32));
 	sb->s_checksum = ext2fs_swab32(sb->s_checksum);
 }
 
-- 
2.19.1
