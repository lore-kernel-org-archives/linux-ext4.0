From: Jan Kara <jack@suse.cz>
Subject: [PATCH 5/5] mke2fs: Add orphan_file feature into mke2fs.conf
Date: Tue, 26 May 2015 09:51:09 +0200
Message-ID: <1432626669-6643-6-git-send-email-jack@suse.cz>
References: <1432626669-6643-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbbEZHvV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 May 2015 03:51:21 -0400
In-Reply-To: <1432626669-6643-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Enable orphan_file feature by default in larger filesystems. Since the
feature is COMPAT, older kernels will just ignore it and happily work
with the filesystem as well.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 misc/mke2fs.conf.in | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 106ee806a165..f75def015a36 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -11,21 +11,23 @@
 		features = has_journal
 	}
 	ext4 = {
-		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,orphan_file
 		auto_64-bit_support = 1
 		inode_size = 256
 	}
 	ext4dev = {
-		features = has_journal,extent,huge_file,flex_bg,metadata_csum,inline_data,64bit,dir_nlink,extra_isize
+		features = has_journal,extent,huge_file,flex_bg,metadata_csum,inline_data,64bit,dir_nlink,extra_isize,orphan_file
 		inode_size = 256
 		options = test_fs=1
 	}
 	small = {
+		default_features = ^orphan_file
 		blocksize = 1024
 		inode_size = 128
 		inode_ratio = 4096
 	}
 	floppy = {
+		default_features = ^orphan_file
 		blocksize = 1024
 		inode_size = 128
 		inode_ratio = 8192
-- 
2.1.4

