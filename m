From: amir73il@users.sourceforge.net
Subject: [PATCH] libext2fs: fix the range validation in bitmap_range2 funcs
Date: Tue, 14 Jun 2011 18:16:32 +0300
Message-ID: <1308064592-29935-1-git-send-email-amir73il@users.sourceforge.net>
Cc: Amir Goldstein <amir73il@users.sf.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1FNPRQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jun 2011 11:17:16 -0400
Received: by wwa36 with SMTP id 36so5992264wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jun 2011 08:17:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

The condition ((start+num) & ~0xffffffffULL) in bitmap_ragne2
and generic_bmap_range funcs in get_bitmap64.c was wrong and
inconsistent with the condition (start+num-1 > bmap->real_end)
in generic_bitmap_range funcs in get_bitmap.c.

I got the following error from tune2fs on a 16TB fs:
Illegal block number passed to ext2fs_unmark_block_bitmap #4294967295
for block bitmap for 16TB.img
tune2fs: Invalid argument while reading bitmaps

Fix to condition to ((start+num-1) & ~0xffffffffULL), because
the bit (start+num) is not going to be changed by the funcs.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 lib/ext2fs/gen_bitmap64.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index df095ac..69c399a 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -382,7 +382,7 @@ errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap bmap,
 		return EINVAL;
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
-		if ((start+num) & ~0xffffffffULL) {
+		if ((start+num-1) & ~0xffffffffULL) {
 			ext2fs_warn_bitmap2(bmap, EXT2FS_UNMARK_ERROR,
 					    0xffffffff);
 			return EINVAL;
@@ -405,7 +405,7 @@ errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap bmap,
 		return EINVAL;
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
-		if ((start+num) & ~0xffffffffULL) {
+		if ((start+num-1) & ~0xffffffffULL) {
 			ext2fs_warn_bitmap2(bmap,
 					    EXT2FS_UNMARK_ERROR, 0xffffffff);
 			return EINVAL;
@@ -476,7 +476,7 @@ int ext2fs_test_block_bitmap_range2(ext2fs_block_bitmap bmap,
 						 bmap, block);
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
-		if ((block+num) & ~0xffffffffULL) {
+		if ((block+num-1) & ~0xffffffffULL) {
 			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
 					    EXT2FS_UNMARK_ERROR, 0xffffffff);
 			return EINVAL;
@@ -498,7 +498,7 @@ void ext2fs_mark_block_bitmap_range2(ext2fs_block_bitmap bmap,
 		return;
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
-		if ((block+num) & ~0xffffffffULL) {
+		if ((block+num-1) & ~0xffffffffULL) {
 			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
 					    EXT2FS_UNMARK_ERROR, 0xffffffff);
 			return;
@@ -526,7 +526,7 @@ void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap bmap,
 		return;
 
 	if (EXT2FS_IS_32_BITMAP(bmap)) {
-		if ((block+num) & ~0xffffffffULL) {
+		if ((block+num-1) & ~0xffffffffULL) {
 			ext2fs_warn_bitmap2((ext2fs_generic_bitmap) bmap,
 					    EXT2FS_UNMARK_ERROR, 0xffffffff);
 			return;
-- 
1.7.4.1

