From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] e2fsprogs: Unify the upper limit of reserved blocks count
Date: Tue, 19 Apr 2011 15:11:34 +0900
Message-ID: <4DAD2796.5010409@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58421 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1DSGMO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Apr 2011 02:12:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In e2fsprogs, the upper limit of reserved blocks count is a half of
filesystem's blocks count. This patch fixes the incorrect checks of
reserved blocks count.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 lib/ext2fs/initialize.c |    2 +-
 misc/tune2fs.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index e1f229b..afefbfd 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -192,7 +192,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 
 	ext2fs_blocks_count_set(super, ext2fs_blocks_count(param));
 	ext2fs_r_blocks_count_set(super, ext2fs_r_blocks_count(param));
-	if (ext2fs_r_blocks_count(super) >= ext2fs_blocks_count(param)) {
+	if (ext2fs_r_blocks_count(super) > ext2fs_blocks_count(param) / 2) {
 		retval = EXT2_ET_INVALID_ARGUMENT;
 		goto cleanup;
 	}
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index bcada11..fad86c0 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1718,7 +1718,7 @@ retry_open:
 			reserved_ratio, ext2fs_r_blocks_count(sb));
 	}
 	if (r_flag) {
-		if (reserved_blocks >= ext2fs_blocks_count(sb)/2) {
+		if (reserved_blocks > ext2fs_blocks_count(sb) / 2) {
 			com_err(program_name, 0,
 				_("reserved blocks count is too big (%llu)"),
 				reserved_blocks);
