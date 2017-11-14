From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v2 4/7] debugfs: 64bit inode support
Date: Tue, 14 Nov 2017 10:04:37 +0300
Message-ID: <20171114070440.79510-5-artem.blagodarenko@gmail.com>
References: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:55336 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752360AbdKNHEz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Nov 2017 02:04:55 -0500
Received: by mail-lf0-f65.google.com with SMTP id e143so21061924lfg.12
        for <linux-ext4@vger.kernel.org>; Mon, 13 Nov 2017 23:04:54 -0800 (PST)
In-Reply-To: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

New dirdata type EXT2_DIRENT_INODE is added.

Lustre-bug: https://jira.hpdd.intel.com/browse/LU-9309
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 debugfs/ls.c         | 6 ++++--
 lib/ext2fs/ext2_fs.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/debugfs/ls.c b/debugfs/ls.c
index 5655933e..b67c0800 100644
--- a/debugfs/ls.c
+++ b/debugfs/ls.c
@@ -64,11 +64,13 @@ static void list_dirdata(struct list_dir_struct *ls,
 
 		dlen = data[0];
 
-		if (dirdata_mask == EXT2_DIRENT_LUFID) {
+		if (dirdata_mask == EXT2_DIRENT_INODE)
+			fprintf(ls->f, "ino64:%04\n", *(__u32 *)(data + 1));
+		else if (dirdata_mask == EXT2_DIRENT_LUFID) {
 			struct lu_fid *fid = (struct lu_fid *)(data + 1);
 
 			fid_be_to_cpu(fid, fid);
-			fprintf(ls->f, DFID, PFID(fid));
+			fprintf(ls->f, "fid:"DFID, PFID(fid));
 		} else {
 			int i;
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index f0cab391..90294ed0 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -1041,6 +1041,7 @@ struct ext2_dir_entry_tail {
 /* lu_fid size and NUL char */
 #define EXT2_DIRENT_LUFID_SIZE		16
 #define EXT2_DIRENT_LUFID		0x10
+#define EXT2_DIRENT_INODE		0x20
 
 /*
  * Constants for ext4's extended time encoding
-- 
2.13.6 (Apple Git-96)
