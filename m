From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v2 10/12] e4defrag: Use EXT2_SUPER_MAGIC instead of EXT4_SUPER_MAGIC
Date: Wed, 17 Aug 2011 16:48:00 +0900
Message-ID: <4E4B7230.50103@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:42977 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1HQIOT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 04:14:19 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id p7H8EIxW021939
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 17:14:18 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsprogs has EXT2_SUPER_MAGIC defined for the magic number of
ext4 filesystem. e4defrag uses it instead of EXT4_SUPER_MAGIC.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index f0a843e..ec1b15a 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -92,9 +92,6 @@
 #define FS_EXT4			"ext4"
 #define ROOT_UID		0
 
-/* Magic number for ext4 */
-#define EXT4_SUPER_MAGIC	0xEF53
