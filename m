From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4:Make ext4_split_extent() handle error correctly.
Date: Sat, 14 May 2011 15:05:05 +0800
Message-ID: <BANLkTintPx6Tugitnodou++sLR1m6SOunA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mingming Cao <cmm@us.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48697 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1ENHFG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 May 2011 03:05:06 -0400
Received: by vxi39 with SMTP id 39so2281082vxi.19
        for <linux-ext4@vger.kernel.org>; Sat, 14 May 2011 00:05:05 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e363f21..b7b667f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2716,6 +2716,8 @@ static int ext4_split_extent(handle_t *handle,
 				       EXT4_EXT_MARK_UNINIT2;
 		err = ext4_split_extent_at(handle, inode, path,
 				map->m_lblk + map->m_len, split_flag1, flags1);
+		if (err)
+			goto out;
 	}

 	ext4_ext_drop_refs(path);
-- 
1.7.5.1

--
