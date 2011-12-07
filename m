From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/2] ext4: remove a wrong BUG_ON in ext4_ext_convert_to_initialized
Date: Wed,  7 Dec 2011 13:21:26 +0800
Message-ID: <1323235287-29806-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: achender@linux.vnet.ibm.com, hughd@google.com, tytso@mit.edu,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38694 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab1LGIXx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2011 03:23:53 -0500
Received: by ggnr5 with SMTP id r5so355546ggn.19
        for <linux-ext4@vger.kernel.org>; Wed, 07 Dec 2011 00:23:53 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a file is fallocated on a hole, map->m_lblk + map->m_len may be greater
than ee_block + ee_len.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6f0300e..29bb629 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2943,7 +2943,6 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	/* Pre-conditions */
 	BUG_ON(!ext4_ext_is_uninitialized(ex));
 	BUG_ON(!in_range(map->m_lblk, ee_block, ee_len));
-	BUG_ON(map->m_lblk + map->m_len > ee_block + ee_len);
 
 	/*
 	 * Attempt to transfer newly initialized blocks from the currently
-- 
1.7.5.1

