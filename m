From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] e2image: pass the correct size write_header
Date: Mon,  2 Dec 2013 14:55:23 -0500
Message-ID: <1386014125-13664-1-git-send-email-tytso@mit.edu>
References: <20131202182606.GA11204@thunk.org>
Cc: kwestneat@ddn.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35706 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab3LBTzx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Dec 2013 14:55:53 -0500
In-Reply-To: <20131202182606.GA11204@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit bf0449b1a654, which added the ability to write qcow2 files,
generalized the write_header() file to take the size of the header
structure which it writes out.  Unfortunately, it changed the call
which supported original e2image format to pass in fs->blocksize,
instead of the actual size of the e2image header structure (which is
substantially smaller than fs->blocksize).  This meant that we copied
in stack garbage into the e2image file, and it made valgrind quite
unhappy.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2image.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index 4a5bb22..aa363fb 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -165,7 +165,7 @@ static void write_image_file(ext2_filsys fs, int fd)
 	struct stat		st;
 	errcode_t		retval;
 
-	write_header(fd, NULL, fs->blocksize, fs->blocksize);
+	write_header(fd, NULL, sizeof(struct ext2_image_hdr), fs->blocksize);
 	memset(&hdr, 0, sizeof(struct ext2_image_hdr));
 
 	hdr.offset_super = ext2fs_llseek(fd, 0, SEEK_CUR);
@@ -214,7 +214,7 @@ static void write_image_file(ext2_filsys fs, int fd)
 	memcpy(hdr.fs_uuid, fs->super->s_uuid, sizeof(hdr.fs_uuid));
 
 	hdr.image_time = time(0);
-	write_header(fd, &hdr, fs->blocksize, fs->blocksize);
+	write_header(fd, &hdr, sizeof(struct ext2_image_hdr), fs->blocksize);
 }
 
 /*
-- 
1.8.5.rc3.362.gdf10213

