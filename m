Return-Path: <SRS0=zz4s=5Q=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86AEC2D0EE
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Mar 2020 10:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 806B521473
	for <linux-ext4@archiver.kernel.org>; Tue, 31 Mar 2020 10:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgCaKu0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 31 Mar 2020 06:50:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:51652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730334AbgCaKu0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 31 Mar 2020 06:50:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B4A1BAD9A;
        Tue, 31 Mar 2020 10:50:24 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 5EF481E1214; Tue, 31 Mar 2020 12:50:24 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] ext4: Do not zeroout extents beyond i_disksize
Date:   Tue, 31 Mar 2020 12:50:16 +0200
Message-Id: <20200331105016.8674-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

We do not want to create initialized extents beyond end of file because
for e2fsck it is impossible to distinguish them from a case of corrupted
file size / extent tree and so it complains like:

Inode 12, i_size is 147456, should be 163840.  Fix? no

Code in ext4_ext_convert_to_initialized() and
ext4_split_convert_extents() try to make sure it does not create
initialized extents beyond inode size however they check against
inode->i_size which is wrong. They should instead check against
EXT4_I(inode)->i_disksize which is the current inode size on disk.
That's what e2fsck is going to see in case of crash before all dirty
data is written. This bug manifests as generic/456 test failure (with
recent enough fstests where fsx got fixed to properly pass
FALLOC_KEEP_SIZE_FL flags to the kernel) when run with dioread_lock
mount option.

CC: stable@vger.kernel.org
Fixes: 21ca087a3891 ("ext4: Do not zero out uninitialized extents beyond i_size")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 954013d6076b..c5e190fd4589 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3532,8 +3532,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		(unsigned long long)map->m_lblk, map_len);
 
 	sbi = EXT4_SB(inode->i_sb);
-	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
-		inode->i_sb->s_blocksize_bits;
+	eof_block = (EXT4_I(inode)->i_disksize + inode->i_sb->s_blocksize - 1)
+			>> inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map_len)
 		eof_block = map->m_lblk + map_len;
 
@@ -3785,8 +3785,8 @@ static int ext4_split_convert_extents(handle_t *handle,
 		  __func__, inode->i_ino,
 		  (unsigned long long)map->m_lblk, map->m_len);
 
-	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
-		inode->i_sb->s_blocksize_bits;
+	eof_block = (EXT4_I(inode)->i_disksize + inode->i_sb->s_blocksize - 1)
+			>> inode->i_sb->s_blocksize_bits;
 	if (eof_block < map->m_lblk + map->m_len)
 		eof_block = map->m_lblk + map->m_len;
 	/*
-- 
2.16.4

