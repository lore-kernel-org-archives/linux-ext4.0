From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] ext3: PTR_ERR return of wrong pointer in setup_new_group_blocks()
Date: Mon, 07 Dec 2009 14:50:11 +0100
Message-ID: <4B1D0813.4070502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:56629 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934927AbZLGNs6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2009 08:48:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/ext3/resize.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 8359e7b..5f83b61 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -266,7 +266,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 			goto exit_bh;
 
 		if (IS_ERR(gdb = bclean(handle, sb, block))) {
-			err = PTR_ERR(bh);
+			err = PTR_ERR(gdb);
 			goto exit_bh;
 		}
 		ext3_journal_dirty_metadata(handle, gdb);
