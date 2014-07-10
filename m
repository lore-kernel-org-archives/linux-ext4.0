From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH] ext4: fix wrong size computation in ext4_mb_normalize_request()
Date: Thu, 10 Jul 2014 13:40:36 +0800
Message-ID: <1404970836-21357-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <mlombard@redhat.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56097 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750708AbaGJFlI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 01:41:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As the member fe_len defined in struct ext4_free_extent is expressed as
number of clusters, the variable "size" computation is wrong, we need to
first translate it to block number, then to bytes.

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
---
 fs/ext4/mballoc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7f72f50..9a543b5 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3076,7 +3076,8 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 		size = 8 * 1024 * 1024;
 	} else {
 		start_off = (loff_t)ac->ac_o_ex.fe_logical << bsbits;
-		size	  = ac->ac_o_ex.fe_len << bsbits;
+		size	  = EXT4_C2B(EXT4_SB(ac->ac_sb),
+				     ac->ac_o_ex.fe_len) << bsbits;
 	}
 	size = size >> bsbits;
 	start = start_off >> bsbits;
-- 
1.8.2.1

