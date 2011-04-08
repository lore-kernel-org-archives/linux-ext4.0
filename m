From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 09/11] e4defrag: Use EXT2_SUPER_MAGIC instead of EXT4_SUPER_MAGIC
Date: Fri, 08 Apr 2011 16:53:07 +0900
Message-ID: <4D9EBEE3.8010405@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39269 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab1DHIIk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 04:08:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsprogs has EXT2_SUPER_MAGIC defined for the magic number of
ext4 filesystem. e4defrag uses it instead of EXT4_SUPER_MAGIC.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 6365103..b87aae9 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -91,9 +91,6 @@
 #define FS_EXT4			"ext4"
 #define ROOT_UID		0
 
-/* Magic number for ext4 */
-#define EXT4_SUPER_MAGIC	0xEF53
