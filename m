From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 7/7] mke2fs: Use io_manager discard_zeroes_data property
Date: Tue, 26 Oct 2010 19:54:18 +0200
Message-ID: <1288115658-7004-8-git-send-email-lczerner@redhat.com>
References: <1288115658-7004-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, adilger@dilger.ca,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0JZRym (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Oct 2010 13:54:42 -0400
In-Reply-To: <1288115658-7004-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We already have discard_zeroes_data variable in struct_io_manager
structure, so we do nod need mke2fs_discard_zeroes_data() function
anymore.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/mke2fs.c |   27 +--------------------------
 1 files changed, 1 insertions(+), 26 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 09ce711..114987c 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1900,31 +1900,6 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	return retval;
 }
 
-#ifdef __linux__
-
-#ifndef BLKDISCARDZEROES
-#define BLKDISCARDZEROES _IO(0x12,124)
-#endif
-
-static int mke2fs_discard_zeroes_data(ext2_filsys fs)
-{
-	int fd;
-	int ret;
-	int discard_zeroes_data = 0;
-
-	fd = open64(fs->device_name, O_RDWR);
-
-	if (fd > 0) {
-		ioctl(fd, BLKDISCARDZEROES, &discard_zeroes_data);
-		close(fd);
-	}
-	return discard_zeroes_data;
-}
-#else
-#define mke2fs_discard_blocks(fs)	1
-#define mke2fs_discard_zeroes_data(fs)	0
-#endif
