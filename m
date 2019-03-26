Return-Path: <SRS0=u157=R5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80912C43381
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Mar 2019 21:39:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C78420811
	for <linux-ext4@archiver.kernel.org>; Tue, 26 Mar 2019 21:39:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="uha0P9Ck"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732796AbfCZVja (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 26 Mar 2019 17:39:30 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44809 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732052AbfCZVj2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Mar 2019 17:39:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id y7so12002325wrn.11
        for <linux-ext4@vger.kernel.org>; Tue, 26 Mar 2019 14:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=giE9oMpXmpevw0T86z+Qz19u88nE7l1bF9K6tKNcF6w=;
        b=uha0P9CkNsk8vC+XPUaNLlIIfbIESxx+1WAi6rWp51ffR50G8hg+UISN6x3+7pgsTH
         3297mkmXv9HvSERyLX9IPK/2534pnvZgmaC5KA1IjwC7EcgP1LjsVNhv2XJl3wbv82T1
         wXIOGVfDmYxoXmzdhq1nZjo5p05/IBE0XYstwDBZwq8roGISKYLNXdY1hsIToK9k8lKS
         baCDb/3thVw/uyz+XpngiN/X6eUrTAtLtaXYz3NUBp4+uq1LAr2CqWaNvpp6KV171ygS
         7l2ZlKX9NCqtEBQ4Cr7nqlTGhH95WlHGMRQEeSesKkumsXquf1SXCflEYa+uc2WpQRdv
         ZEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=giE9oMpXmpevw0T86z+Qz19u88nE7l1bF9K6tKNcF6w=;
        b=AoFfdlMLzaxfliuqKvWTW+0UaMJJV3tLT0ZM0ORXH4aScqpiA4Z5BPm9PBamjaBH8u
         Gkdjht1ADuQhxouhH1TeagchRtL95Iaa78iriW1jeAtVmNt691dwl8IqW9o0JhOWprLW
         NeG6O7TCGRkBIXYssM0ytR//xeDnAd7I3PC/kCyXIxwG3Pf23YW8GgjIQJr+KWwpIgHF
         A+0rga/0xpF6FfYexb8sX29Y/wTcjvpZrogjfA4ZlhkyzU3qo1g/EzYBK2GGOyBUXALp
         H0eaKm12htsKpqWvT5IxJOVLDYGkH7m5Izy0/UiWefpgl3XUC079sqVrzBOjwIC0KzOk
         fUnQ==
X-Gm-Message-State: APjAAAUFEHGwQVLqAdfDRZZKF43AdBv80szdAAu3/ypHZTJK+/0Zc9WW
        w1LXZ7xKV86D3eP+/9DZTn+q9A==
X-Google-Smtp-Source: APXvYqxT/Pq2RE0AOqMdrR/82C+x94EMS+ix0HlhmlG7rBez2SO8dZN4szlFOPELuXbTueJg4bEHiQ==
X-Received: by 2002:adf:fd88:: with SMTP id d8mr15003127wrr.320.1553636366584;
        Tue, 26 Mar 2019 14:39:26 -0700 (PDT)
Received: from pathfinder ([90.195.158.41])
        by smtp.gmail.com with ESMTPSA id a9sm20322687wrt.29.2019.03.26.14.39.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 26 Mar 2019 14:39:25 -0700 (PDT)
Date:   Tue, 26 Mar 2019 21:39:24 +0000
From:   Phillip Potter <phil@philpotter.co.uk>
To:     tytso@mit.edu
Cc:     amir73il@gmail.com, viro@zeniv.linux.org.uk,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 05/07] ext4: use common file type conversion
Message-ID: <20190326213924.GA20880@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Deduplicate the ext4 file type conversion implementation and define
EXT4_FT_* to match shared FT_* - file systems that use the same file
types as defined by POSIX do not need to define their own versions
and can use the common helper functions decared in fs_types.h and
implemented in fs_types.c

Common implementation can be found via commit:
bbe7449e2599 "fs: common implementation of file type"

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 82ffdacdc7fa..0bf97f21804f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1932,16 +1932,16 @@ struct ext4_dir_entry_tail {
  * Ext4 directory file types.  Only the low 3 bits are used.  The
  * other bits are reserved for now.
  */
-#define EXT4_FT_UNKNOWN		0
-#define EXT4_FT_REG_FILE	1
-#define EXT4_FT_DIR		2
-#define EXT4_FT_CHRDEV		3
-#define EXT4_FT_BLKDEV		4
-#define EXT4_FT_FIFO		5
-#define EXT4_FT_SOCK		6
-#define EXT4_FT_SYMLINK		7
+#define EXT4_FT_UNKNOWN		FT_UNKNOWN
+#define EXT4_FT_REG_FILE	FT_REG_FILE
+#define EXT4_FT_DIR		FT_DIR
+#define EXT4_FT_CHRDEV		FT_CHRDEV
+#define EXT4_FT_BLKDEV		FT_BLKDEV
+#define EXT4_FT_FIFO		FT_FIFO
+#define EXT4_FT_SOCK		FT_SOCK
+#define EXT4_FT_SYMLINK		FT_SYMLINK
 
-#define EXT4_FT_MAX		8
+#define EXT4_FT_MAX		FT_MAX
 
 #define EXT4_FT_DIR_CSUM	0xDE
 
@@ -2359,16 +2359,13 @@ static inline void ext4_update_dx_flag(struct inode *inode)
 	if (!ext4_has_feature_dir_index(inode->i_sb))
 		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
 }
-static const unsigned char ext4_filetype_table[] = {
-	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
-};
 
 static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
 {
-	if (!ext4_has_feature_filetype(sb) || filetype >= EXT4_FT_MAX)
+	if (!ext4_has_feature_filetype(sb))
 		return DT_UNKNOWN;
 
-	return ext4_filetype_table[filetype];
+	return fs_ftype_to_dtype(filetype);
 }
 extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size);
@@ -3066,22 +3063,12 @@ extern void initialize_dirent_tail(struct ext4_dir_entry_tail *t,
 extern int ext4_handle_dirty_dirent_node(handle_t *handle,
 					 struct inode *inode,
 					 struct buffer_head *bh);
-#define S_SHIFT 12
-static const unsigned char ext4_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
-	[S_IFREG >> S_SHIFT]	= EXT4_FT_REG_FILE,
-	[S_IFDIR >> S_SHIFT]	= EXT4_FT_DIR,
-	[S_IFCHR >> S_SHIFT]	= EXT4_FT_CHRDEV,
-	[S_IFBLK >> S_SHIFT]	= EXT4_FT_BLKDEV,
-	[S_IFIFO >> S_SHIFT]	= EXT4_FT_FIFO,
-	[S_IFSOCK >> S_SHIFT]	= EXT4_FT_SOCK,
-	[S_IFLNK >> S_SHIFT]	= EXT4_FT_SYMLINK,
-};
 
 static inline void ext4_set_de_type(struct super_block *sb,
 				struct ext4_dir_entry_2 *de,
 				umode_t mode) {
 	if (ext4_has_feature_filetype(sb))
-		de->file_type = ext4_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
+		de->file_type = fs_umode_to_ftype(mode);
 }
 
 /* readpages.c */
-- 
2.20.1

