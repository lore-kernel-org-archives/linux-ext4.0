From: Niu <niu@whamcloud.com>
Subject: Re: e2fsprogs: Avoid infinite loop in ext2fs_find_block_device()
Date: Fri, 04 Nov 2011 20:50:38 +0800
Message-ID: <4EB3DF9E.7010601@whamcloud.com>
References: <4EB23889.1010807@whamcloud.com> <4EB2A983.6070203@redhat.com> <121461D1-4A28-4B65-960D-7549D2782FFA@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54974 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab1KDMuz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Nov 2011 08:50:55 -0400
Received: by iage36 with SMTP id e36so2504330iag.19
        for <linux-ext4@vger.kernel.org>; Fri, 04 Nov 2011 05:50:54 -0700 (PDT)
In-Reply-To: <121461D1-4A28-4B65-960D-7549D2782FFA@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>From 81bfd58b3980f940c23f87f891365a289df776ec Mon Sep 17 00:00:00 2001
From: Niu Yawei <niu@whamcloud.com>
Date: Wed, 2 Nov 2011 04:31:11 +0800
Subject: [PATCH] e2fsprogs: maximum nested link count

Define EXT2FS_MAX_NESTED_LINKS as 8, and check the link count
not exceeding it in ext2fs_find_block_device() and follow_link().

Signed-off-by: Niu Yawei <niu@whamcloud.com>
---
 lib/ext2fs/ext2fsP.h |    2 ++
 lib/ext2fs/finddev.c |    5 +++++
 lib/ext2fs/namei.c   |    3 ++-
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index b182d7f..82e1ba0 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -11,6 +11,8 @@
 
 #include "ext2fs.h"
 
+#define EXT2FS_MAX_NESTED_LINKS  8
+
 /*
  * Badblocks list
  */
diff --git a/lib/ext2fs/finddev.c b/lib/ext2fs/finddev.c
index 13ef14b..311608d 100644
--- a/lib/ext2fs/finddev.c
+++ b/lib/ext2fs/finddev.c
@@ -34,6 +34,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext2fsP.h"
 
 struct dir_list {
 	char	*name;
@@ -128,6 +129,7 @@ char *ext2fs_find_block_device(dev_t device)
 	struct dir_list *list = 0, *new_list = 0;
 	struct dir_list *current;
 	char	*ret_path = 0;
+	int    level = 0;
 
 	/*
 	 * Add the starting directories to search...
@@ -154,6 +156,9 @@ char *ext2fs_find_block_device(dev_t device)
 		if (list == 0) {
 			list = new_list;
 			new_list = 0;
+			/* Avoid infinite loop */
+			if (++level >= EXT2FS_MAX_NESTED_LINKS)
+				break;
 		}
 	}
 	free_dirlist(&list);
diff --git a/lib/ext2fs/namei.c b/lib/ext2fs/namei.c
index 6bbb124..a936474 100644
--- a/lib/ext2fs/namei.c
+++ b/lib/ext2fs/namei.c
@@ -20,6 +20,7 @@
 
 #include "ext2_fs.h"
 #include "ext2fs.h"
+#include "ext2fsP.h"
 
 static errcode_t open_namei(ext2_filsys fs, ext2_ino_t root, ext2_ino_t base,
 			    const char *pathname, size_t pathlen, int follow,
@@ -45,7 +46,7 @@ static errcode_t follow_link(ext2_filsys fs, ext2_ino_t root, ext2_ino_t dir,
 		*res_inode = inode;
 		return 0;
 	}
-	if (link_count++ > 5) {
+	if (link_count++ >= EXT2FS_MAX_NESTED_LINKS) {
 		return EXT2_ET_SYMLINK_LOOP;
 	}
 	/* FIXME-64: Actually, this is FIXME EXTENTS */
-- 
1.7.1



> On Nov 3, 2011, at 10:47 AM, Eric Sandeen wrote:
>
>> My only concern would be that depth 5 isn't totally unreasonable in real life, and this causes it to silently stop searching, right?
>> Would there be much harm in making the limit much higher, to be fairly sure that it has wandered off into the weeds?
> Agreed, the kernel currently uses a limit of 8.  And we should use a #define for this in lib/ext2fs/ext2fsP.h, and use it for both finddev.c and lib/ext2fs/namei.c.
>
> -- Ted
>

