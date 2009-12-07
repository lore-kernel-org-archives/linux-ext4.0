From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] ext4: PTR_ERR return of wrong pointer in setup_new_group_blocks()
Date: Mon, 07 Dec 2009 14:51:47 +0100
Message-ID: <4B1D0873.90004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:46861 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934993AbZLGNud (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Dec 2009 08:50:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/ext4/resize.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 3cfc343..3b2c554 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -247,7 +247,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 			goto exit_bh;
 
 		if (IS_ERR(gdb = bclean(handle, sb, block))) {
-			err = PTR_ERR(bh);
+			err = PTR_ERR(gdb);
 			goto exit_bh;
 		}
 		ext4_handle_dirty_metadata(handle, NULL, gdb);
