From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] ext4: fix trivial typo in the comment for extents.c/ext4_split_unwritten_extents
Date: Sun, 15 Jul 2012 11:41:08 +0800
Message-ID: <50023BD4.2050809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37561 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab2GODlT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Jul 2012 23:41:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Put the sign '/' to the right position.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7f6fb48..f394e0f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3241,7 +3241,7 @@ out:
  * to an uninitialized extent.
  *
  * Writing to an uninitialized extent may result in splitting the uninitialized
- * extent into multiple /initialized uninitialized extents (up to three)
+ * extent into multiple initialized/uninitialized extents (up to three)
  * There are three possibilities:
  *   a> There is no split required: Entire extent should be uninitialized
  *   b> Splits in two extents: Write is happening at either end of the extent
-- 
1.7.1

