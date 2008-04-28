From: akpm@linux-foundation.org
Subject: [patch 260/307] ext2: convert byte order of constant instead of variable
Date: Mon, 28 Apr 2008 02:16:00 -0700
Message-ID: <200804280916.m3S9G0Me019021@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, marcin.slusarz@gmail.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761664AbYD1JU4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:20:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Marcin Slusarz <marcin.slusarz@gmail.com>

Convert byte order of constant instead of variable which can be done at
compile time (vs run time).

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/ext2/super.c~ext2-convert-byte-order-of-constant-instead-of-variable fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-convert-byte-order-of-constant-instead-of-variable
+++ a/fs/ext2/super.c
@@ -51,8 +51,7 @@ void ext2_error (struct super_block * sb
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		sbi->s_mount_state |= EXT2_ERROR_FS;
-		es->s_state =
-			cpu_to_le16(le16_to_cpu(es->s_state) | EXT2_ERROR_FS);
+		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
 		ext2_sync_super(sb, es);
 	}
 
@@ -1126,10 +1125,9 @@ void ext2_write_super (struct super_bloc
 	if (!(sb->s_flags & MS_RDONLY)) {
 		es = EXT2_SB(sb)->s_es;
 
-		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS) {
+		if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 			ext2_debug ("setting valid to 0\n");
-			es->s_state = cpu_to_le16(le16_to_cpu(es->s_state) &
-						  ~EXT2_VALID_FS);
+			es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
 			es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 			es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 			es->s_mtime = cpu_to_le32(get_seconds());
_
