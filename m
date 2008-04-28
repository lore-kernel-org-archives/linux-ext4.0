From: akpm@linux-foundation.org
Subject: [patch 268/307] ext3: convert byte order of constant instead of variable
Date: Mon, 28 Apr 2008 02:16:06 -0700
Message-ID: <200804280916.m3S9G6I6019125@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760683AbYD1JUx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:20:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Marcin Slusarz <marcin.slusarz@gmail.com>

Convert byte order of constant instead of variable which can be done at
compile time (vs run time).

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/super.c~ext3-convert-byte-order-of-constant-instead-of-variable fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-convert-byte-order-of-constant-instead-of-variable
+++ a/fs/ext3/super.c
@@ -1219,7 +1219,7 @@ static int ext3_setup_super(struct super
                    inconsistencies, to force a fsck at reboot.  But for
                    a plain journaled filesystem we can keep it set as
                    valid forever! :) */
-	es->s_state = cpu_to_le16(le16_to_cpu(es->s_state) & ~EXT3_VALID_FS);
+	es->s_state &= cpu_to_le16(~EXT3_VALID_FS);
 #endif
 	if (!(__s16) le16_to_cpu(es->s_max_mnt_count))
 		es->s_max_mnt_count = cpu_to_le16(EXT3_DFL_MAX_MNT_COUNT);
_
