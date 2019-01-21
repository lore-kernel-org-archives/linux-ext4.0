Return-Path: <SRS0=MuWy=P5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9451EC282F1
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 08:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B9F20823
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 08:09:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="y5KGbn/S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfAUIJ4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Jan 2019 03:09:56 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34943 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728275AbfAUIJz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2019 03:09:55 -0500
Received: by mail-wr1-f68.google.com with SMTP id 96so22164649wrb.2
        for <linux-ext4@vger.kernel.org>; Mon, 21 Jan 2019 00:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=g2pwAxxnRqmK6UpMSZkTtNDyPXMXCJYQJ4n71D5SADc=;
        b=y5KGbn/Sp9d7pEjFW4LRU7j6S7wjKgk21oP+uQ3dVvEtTK3RzBg9m8kTgpZLPof3Q5
         cbVkvNf/xz2aXGyhCzQ/IOtPmdZ1m+xl+UZ8sUXSelI+5fZxznGREm+ZXNpzDA2qTjTd
         qvyFI2gQeFq6zmQ/K5C5paWx7RnrJ6v01U57jQV5/7ZIFvonLXBZNEd1IdhiS1RrhzgB
         jkuEuAnS54woKRABVCQnvQkRcbhs4pmcQ/S+l+qzDrvKLYhS2e4rr4MS5OozwFPaxk/m
         HsBMHY/brlS7Rx08lZ83Fk0GRaCLcGMW+jZUIkrGZSG2puFQ9kyz+XNtqgEpgsCy1HfB
         eTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=g2pwAxxnRqmK6UpMSZkTtNDyPXMXCJYQJ4n71D5SADc=;
        b=ZmholesAN9d6UteVbnn0cj73lUP0yFQbL5dML61ceduXIlWRzdQh4DrFXtJ09qe+mU
         LH5V4oTamQMrfhq0WA0hAUokrD9p2d+agBkIThC1JmIjqdStaWu1N6eDsZ1EPhZg42CF
         R2yofITsKtCnBwpJMb56LpsUeh4S6MhN2SEP4gbAVaG6Pv0ff+84jtc0ixIIyH8yaFd+
         5PWrANO5lIyNwyWfRnqw3edlXJm42wt9HMbsQXX2+kRUfLuk0h3Z1aBC4KasxzfNiGvP
         ZwmfrXmVPj4AGxtPKjt0S7fyuXs8WDXhKubZhHnylNmNA9vuXXaL0d8v8HSxNvECQ3rO
         6coA==
X-Gm-Message-State: AJcUukc1Ctq/X/EnzAFDOby/IjZJzBg3dfRiF+9or+fz+uHlwRlC6xhl
        J4X4qZu+9qaLYxbhRXu38NIlRLuA3qfnGSRi
X-Google-Smtp-Source: ALg8bN6/sn4JXVfqiPI4as1E5Akfc8byW0ijvuPuijdke1ibMJJigXeh5tsUvDiOAUW6pypv3WO0/A==
X-Received: by 2002:adf:f785:: with SMTP id q5mr24952841wrp.9.1548032072851;
        Sun, 20 Jan 2019 16:54:32 -0800 (PST)
Received: from pathfinder ([90.222.17.17])
        by smtp.gmail.com with ESMTPSA id g67sm101302456wmd.38.2019.01.20.16.54.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 20 Jan 2019 16:54:32 -0800 (PST)
Date:   Mon, 21 Jan 2019 00:54:31 +0000
From:   Phillip Potter <phil@philpotter.co.uk>
To:     jack@suse.cz
Cc:     amir73il@gmail.com, viro@zeniv.linux.org.uk,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC][PATCH v5 04/09] ext2: use common file type conversion
Message-ID: <20190121005431.GA32343@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Deduplicate the ext2 file type conversion implementation and remove
EXT2_FT_* definitions - file systems that use the same file types as
defined by POSIX do not need to define their own versions and can
use the common helper functions decared in fs_types.h and implemented
in fs_types.c

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---
 fs/ext2/dir.c  | 35 ++++++-----------------------------
 fs/ext2/ext2.h | 16 ----------------
 2 files changed, 6 insertions(+), 45 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 3b8114def693..13318e255ebf 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -252,33 +252,10 @@ ext2_validate_entry(char *base, unsigned offset, unsigned mask)
 	return (char *)p - base;
 }
 
-static unsigned char ext2_filetype_table[EXT2_FT_MAX] = {
-	[EXT2_FT_UNKNOWN]	= DT_UNKNOWN,
-	[EXT2_FT_REG_FILE]	= DT_REG,
-	[EXT2_FT_DIR]		= DT_DIR,
-	[EXT2_FT_CHRDEV]	= DT_CHR,
-	[EXT2_FT_BLKDEV]	= DT_BLK,
-	[EXT2_FT_FIFO]		= DT_FIFO,
-	[EXT2_FT_SOCK]		= DT_SOCK,
-	[EXT2_FT_SYMLINK]	= DT_LNK,
-};
-
-#define S_SHIFT 12
-static unsigned char ext2_type_by_mode[S_IFMT >> S_SHIFT] = {
-	[S_IFREG >> S_SHIFT]	= EXT2_FT_REG_FILE,
-	[S_IFDIR >> S_SHIFT]	= EXT2_FT_DIR,
-	[S_IFCHR >> S_SHIFT]	= EXT2_FT_CHRDEV,
-	[S_IFBLK >> S_SHIFT]	= EXT2_FT_BLKDEV,
-	[S_IFIFO >> S_SHIFT]	= EXT2_FT_FIFO,
-	[S_IFSOCK >> S_SHIFT]	= EXT2_FT_SOCK,
-	[S_IFLNK >> S_SHIFT]	= EXT2_FT_SYMLINK,
-};
-
 static inline void ext2_set_de_type(ext2_dirent *de, struct inode *inode)
 {
-	umode_t mode = inode->i_mode;
 	if (EXT2_HAS_INCOMPAT_FEATURE(inode->i_sb, EXT2_FEATURE_INCOMPAT_FILETYPE))
-		de->file_type = ext2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
+		de->file_type = fs_umode_to_ftype(inode->i_mode);
 	else
 		de->file_type = 0;
 }
@@ -293,14 +270,14 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
 	unsigned long n = pos >> PAGE_SHIFT;
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(ext2_chunk_size(inode)-1);
-	unsigned char *types = NULL;
 	bool need_revalidate = !inode_eq_iversion(inode, file->f_version);
+	bool has_filetype;
 
 	if (pos > inode->i_size - EXT2_DIR_REC_LEN(1))
 		return 0;
 
-	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FILETYPE))
-		types = ext2_filetype_table;
+	has_filetype =
+		EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FILETYPE);
 
 	for ( ; n < npages; n++, offset = 0) {
 		char *kaddr, *limit;
@@ -335,8 +312,8 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
 			if (de->inode) {
 				unsigned char d_type = DT_UNKNOWN;
 
-				if (types && de->file_type < EXT2_FT_MAX)
-					d_type = types[de->file_type];
+				if (has_filetype)
+					d_type = fs_ftype_to_dtype(de->file_type);
 
 				if (!dir_emit(ctx, de->name, de->name_len,
 						le32_to_cpu(de->inode),
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index e770cd100a6a..93fcfe7bbb3b 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -603,22 +603,6 @@ struct ext2_dir_entry_2 {
 	char	name[];			/* File name, up to EXT2_NAME_LEN */
 };
 
-/*
- * Ext2 directory file types.  Only the low 3 bits are used.  The
- * other bits are reserved for now.
- */
-enum {
-	EXT2_FT_UNKNOWN		= 0,
-	EXT2_FT_REG_FILE	= 1,
-	EXT2_FT_DIR		= 2,
-	EXT2_FT_CHRDEV		= 3,
-	EXT2_FT_BLKDEV		= 4,
-	EXT2_FT_FIFO		= 5,
-	EXT2_FT_SOCK		= 6,
-	EXT2_FT_SYMLINK		= 7,
-	EXT2_FT_MAX
-};
-
 /*
  * EXT2_DIR_PAD defines the directory entries boundaries
  *
-- 
2.20.1

