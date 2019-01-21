Return-Path: <SRS0=MuWy=P5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIMWL_WL_MED,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61192C282DB
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 07:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E2D02084A
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 07:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="mQkKOq2M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfAUHxY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:53:24 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35358 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbfAUHxY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2019 02:53:24 -0500
Received: by mail-wr1-f65.google.com with SMTP id 96so22110407wrb.2
        for <linux-ext4@vger.kernel.org>; Sun, 20 Jan 2019 23:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=GPJFHkvNVUYGWUif3SNSEtU8iMpkiMe9hRfFKZgGxFQ=;
        b=mQkKOq2MgH7QrCk3XxsrWSnKOqSWvAnORAMmjBmxU0qDB6EhFXXjOVzLBpMEcX/99w
         Tb4JxvV5+3/kIVoXMRVW8mo3sJh9UFZcXTWoukC6ooZBoO5VXZpYfhLizsZEWtCZPso6
         LlLx0x83h4OBw7IoChuWp1jVrVBWllc+xcxSrbQ1+f2r4jn9NMqUS5XyytjraNxAMz0I
         8IFsMscQ19RTJAkooeQilkAasKQRqQEzAe0wQcimMIAHvplFyyX3Nyk/5H9ZDdM7c0MV
         UhOOSsIohOr6NFPNZ0JxMAr0VWJwILJQn6yqIN9JKwlTne1n4oCY6D0X/8+JDxVzqOBL
         Xk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=GPJFHkvNVUYGWUif3SNSEtU8iMpkiMe9hRfFKZgGxFQ=;
        b=PZpYTyZmCV7qLS0u1rPaIb9JI3jUtSi/fRk2XQQe8fPV9jkg+5u/1qCacD08xhXA0w
         sAdnFAjG59elSAIS4AoOGw3/xgpp7CFj7qdqP7irrcAgixeLYuIoEKJib97Jkjt28+NA
         N/rSTTe2MLOszkkoREvKgn2+xuOlbx0omqaz0UrSMrQbmM66IZ4LQGBSIhhCW/66BqEA
         d0ayaDOEhbivY9XlerIihufkU+TzW7xEJY4auiJdXoEw4fiq5StBfMqlCJUAuFUp9tVI
         WW1h6gvSK9PL5ro0fhkwFiNYGn9tUQb9bkqLin0oPqioJna8Ub+5csYVGZ1ubuMB+Rk0
         m5og==
X-Gm-Message-State: AJcUukd8vEY/n7urcqq/1paaHxlplgykAldcoRV1GVCLX6V7YL0KJkOj
        laI2CyKJ05dsfw7es182KElusbJToiUyGn+h
X-Google-Smtp-Source: ALg8bN6xt++620FobN8wu20+Gfpy7fhG8jh94x58XBe0q/PF2oc9ESuOWnYwJe7eYn5wszEEGoLl8Q==
X-Received: by 2002:a5d:4a0c:: with SMTP id m12mr25252240wrq.38.1548032076513;
        Sun, 20 Jan 2019 16:54:36 -0800 (PST)
Received: from pathfinder ([90.222.17.17])
        by smtp.gmail.com with ESMTPSA id g67sm101303111wmd.38.2019.01.20.16.54.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 20 Jan 2019 16:54:35 -0800 (PST)
Date:   Mon, 21 Jan 2019 00:54:35 +0000
From:   Phillip Potter <phil@philpotter.co.uk>
To:     tytso@mit.edu
Cc:     amir73il@gmail.com, viro@zeniv.linux.org.uk,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC][PATCH v5 07/09] ext4: use common file type conversion
Message-ID: <20190121005435.GA32365@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Deduplicate the ext4 file type conversion implementation and define
EXT4_FT_* to match shared FT_* - file systems that use the same file
types as defined by POSIX do not need to define their own versions
and can use the common helper functions decared in fs_types.h and
implemented in fs_types.c

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---
 fs/ext4/ext4.h | 37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 185a05d3257e..f43d002a30fd 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1925,16 +1925,16 @@ struct ext4_dir_entry_tail {
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
 
@@ -2357,16 +2357,13 @@ static inline void ext4_update_dx_flag(struct inode *inode)
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
@@ -3065,22 +3062,12 @@ extern void initialize_dirent_tail(struct ext4_dir_entry_tail *t,
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

