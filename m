From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] ext2: fix comment on ext2_try_to_allocate()
Date: Sun, 26 Sep 2010 15:31:00 +0900
Message-ID: <1285482660-9937-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Jiri Kosina <trivial@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50462 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0IZGbK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 Sep 2010 02:31:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

@handle doesn't exist in ext2. Remove it.
Also, fit comment header into kernel-doc format.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext2/balloc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index c6c684b..0d06f4e 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -646,10 +646,9 @@ find_next_usable_block(int start, struct buffer_head *bh, int maxblocks)
 	return here;
 }
 
-/*
+/**
  * ext2_try_to_allocate()
  * @sb:			superblock
- * @handle:		handle to this transaction
  * @group:		given allocation block group
  * @bitmap_bh:		bufferhead holds the block bitmap
  * @grp_goal:		given target block within the group
-- 
1.7.2.2

