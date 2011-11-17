From: Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 2/2] Fs: ext4: extents: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 07:28:26 -0700
Message-ID: <1321540106-4321-1-git-send-email-zac.3.14159@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Zac Storer <zac.3.14159@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48211 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480Ab1KQO2e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Nov 2011 09:28:34 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..6544208 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4017,7 +4017,7 @@ got_allocated_blocks:
 	ext4_ext_store_pblock(&newex, newblock + offset);
 	newex.ee_len = cpu_to_le16(ar.len);
 	/* Mark uninitialized */
-	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT){
+	if (flags & EXT4_GET_BLOCKS_UNINIT_EXT) {
 		ext4_ext_mark_uninitialized(&newex);
 		/*
 		 * io_end structure was created for every IO write to an
-- 
1.7.7.3

