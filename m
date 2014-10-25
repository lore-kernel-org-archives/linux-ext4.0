From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/39] e2fsck: fix dangling pointer when dir_info array is
 resized
Date: Sat, 25 Oct 2014 13:58:12 -0700
Message-ID: <20141025205812.532.67790.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sami Liedes <sami.liedes@iki.fi>, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44051 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaJYU64 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:58:56 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsck uses an array to store directory usage information during pass
3; the usage context also contains a pointer to the last directory
looked up.  When expanding the dir_info array, this cache pointer
needs to be cleared if the array resize changed the pointer location,
or else we'll later walk off the end of this dead pointer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Sami Liedes <sami.liedes@iki.fi>
---
 e2fsck/dirinfo.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/e2fsck/dirinfo.c b/e2fsck/dirinfo.c
index 4a9019b..dab5a13 100644
--- a/e2fsck/dirinfo.c
+++ b/e2fsck/dirinfo.c
@@ -121,7 +121,7 @@ static void setup_db(e2fsck_t ctx)
 void e2fsck_add_dir_info(e2fsck_t ctx, ext2_ino_t ino, ext2_ino_t parent)
 {
 	struct dir_info_db 	*db;
-	struct dir_info 	*dir, ent;
+	struct dir_info		*dir, ent, *old_array;
 	int			i, j;
 	errcode_t		retval;
 	unsigned long		old_size;
@@ -136,6 +136,7 @@ void e2fsck_add_dir_info(e2fsck_t ctx, ext2_ino_t ino, ext2_ino_t parent)
 	if (ctx->dir_info->count >= ctx->dir_info->size) {
 		old_size = ctx->dir_info->size * sizeof(struct dir_info);
 		ctx->dir_info->size += 10;
+		old_array = ctx->dir_info->array;
 		retval = ext2fs_resize_mem(old_size, ctx->dir_info->size *
 					   sizeof(struct dir_info),
 					   &ctx->dir_info->array);
@@ -147,6 +148,8 @@ void e2fsck_add_dir_info(e2fsck_t ctx, ext2_ino_t ino, ext2_ino_t parent)
 			ctx->dir_info->size -= 10;
 			return;
 		}
+		if (old_array != ctx->dir_info->array)
+			ctx->dir_info->last_lookup = NULL;
 	}
 
 	ent.ino = ino;

