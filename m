From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 4/4] ext4: trace punch_hole correctly in ext4_ext_map_blocks
Date: Wed, 26 Oct 2011 15:11:52 +0800
Message-ID: <1319613112-16807-4-git-send-email-xiaoqiangnk@gmail.com>
References: <1319613112-16807-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49521 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab1JZJH5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 05:07:57 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so1511707iab.19
        for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2011 02:07:57 -0700 (PDT)
In-Reply-To: <1319613112-16807-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext4_ext_map_blocks() is called by punch_hole, trace should
trace blocks punched out.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 49b4e28..58af095 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4173,12 +4173,12 @@ out2:
 		ext4_ext_drop_refs(path);
 		kfree(path);
 	}
-	trace_ext4_ext_map_blocks_exit(inode, map->m_lblk,
-		newblock, map->m_len, err ? err : allocated);
