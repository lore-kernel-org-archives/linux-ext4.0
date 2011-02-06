From: Coly Li <i@coly.li>
Subject: [PATCH 4/5] mballoc: change comments to ac_g_ex
Date: Sun, 06 Feb 2011 12:54:08 +0800
Message-ID: <4D4E2970.8050709@coly.li>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>, Theodore Tso <tytso@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:40224 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752519Ab1BFE1p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 23:27:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current comments to ac_g_ex, the member of struct
ext4_allocation_context is,
	/* goal request (after normalization) */
This is a little bit confused. In order to make it easier to be
understood, this patch modify the comments as,
	/* goal request (normalized ac_o_ex) */
which means ac_g_ex is a normalized value of ac_o_ex.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: Alex Tomas <alex@clusterfs.com>
Cc: Theodore Tso <tytso@google.com>
---
  fs/ext4/mballoc.h |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index b619322..22bd4d7 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -169,7 +169,7 @@ struct ext4_allocation_context {
  	/* original request */
  	struct ext4_free_extent ac_o_ex;

-	/* goal request (after normalization) */
+	/* goal request (normalized ac_o_ex) */
  	struct ext4_free_extent ac_g_ex;

  	/* the best found extent */
-- 
1.7.3.4
