Return-Path: <SRS0=LrsA=T7=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68834C04AB6
	for <linux-ext4@archiver.kernel.org>; Fri, 31 May 2019 12:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BCF12687C
	for <linux-ext4@archiver.kernel.org>; Fri, 31 May 2019 12:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfEaMKY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 31 May 2019 08:10:24 -0400
Received: from relay.sw.ru ([185.231.240.75]:35534 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbfEaMKY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 31 May 2019 08:10:24 -0400
Received: from [172.16.24.163] (helo=snorch.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.91)
        (envelope-from <ptikhomirov@virtuozzo.com>)
        id 1hWgMU-0004eV-10; Fri, 31 May 2019 15:10:18 +0300
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     Theodore Ts'o <tytso@mit.edu>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: remove unnecessary gotos in ext4_xattr_set_entry
Date:   Fri, 31 May 2019 15:10:16 +0300
Message-Id: <20190531121016.11727-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

In the "out" label we only iput old/new_ea_inode-s, in all these places
these variables are always NULL so there is no point in goto to "out".

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 fs/ext4/xattr.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 491f9ee4040e..ac2ddd4446b3 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1601,8 +1601,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 		next = EXT4_XATTR_NEXT(last);
 		if ((void *)next >= s->end) {
 			EXT4_ERROR_INODE(inode, "corrupted xattr entries");
-			ret = -EFSCORRUPTED;
-			goto out;
+			return -EFSCORRUPTED;
 		}
 		if (!last->e_value_inum && last->e_value_size) {
 			size_t offs = le16_to_cpu(last->e_value_offs);
@@ -1620,8 +1619,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 			free += EXT4_XATTR_LEN(name_len) + old_size;
 
 		if (free < EXT4_XATTR_LEN(name_len) + new_size) {
-			ret = -ENOSPC;
-			goto out;
+			return -ENOSPC;
 		}
 
 		/*
@@ -1634,8 +1632,7 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 		    new_size && is_block &&
 		    (min_offs + old_size - new_size) <
 					EXT4_XATTR_BLOCK_RESERVE(inode)) {
-			ret = -ENOSPC;
-			goto out;
+			return -ENOSPC;
 		}
 	}
 
-- 
2.20.1

