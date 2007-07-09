From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [e2fsprogs] Bug in salvage_directory
Date: Mon, 09 Jul 2007 15:02:02 +0530
Message-ID: <1183973522.3889.10.camel@garfield.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:44983 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXGIJbM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2007 05:31:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

Recently, one of our customers found this message in pass2 of e2fsck while doing some regression testing:
"Entry '4, 0x695a, 0x81ff, 0x0040, 0x8320, 0xa192, 0x0021' in ??? (136554) has
rec_len of 14200, should be 26908."

Both the displayed rec_len and the "should be" value are bogus. The reason is that salvage_directory sets a offset beyond blocksize leading to bogus messages.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: e2fsprogs-1.39/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/pass2.c
+++ e2fsprogs-1.39/e2fsck/pass2.c
@@ -690,7 +690,10 @@ static void salvage_directory(ext2_filsy
 	 */
 	if (prev && dirent->rec_len && (dirent->rec_len % 4) == 0) {
 		prev->rec_len += dirent->rec_len;
-		*offset += dirent->rec_len;
+		if (*offset + dirent->rec_len <= fs->blocksize)
+			*offset += dirent->rec_len;
+		else
+			*offset = fs->blocksize;
 		return;
 	}
 	/*


Thanks,
Kalpak.
