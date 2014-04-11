From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e4defrag: fix error reporting when ext2fs_open fails
Date: Thu, 10 Apr 2014 23:17:58 -0400
Message-ID: <1397186278-20622-1-git-send-email-tytso@mit.edu>
References: <CAGW2f1HpTEihjEaSk+bTxDBFhSuxxUpLq2wdzoo59xQHOPC+3A@mail.gmail.com>
Cc: jonernst07@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52747 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbaDKDSH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 23:18:07 -0400
In-Reply-To: <CAGW2f1HpTEihjEaSk+bTxDBFhSuxxUpLq2wdzoo59xQHOPC+3A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e4defrag.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index a1224bb..0db5e4b 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1797,10 +1797,10 @@ int main(int argc, char *argv[])
 			ret = ext2fs_open(dev_name, EXT2_FLAG_64BITS, 0,
 					  block_size, unix_io_manager, &fs);
 			if (ret) {
-				if (mode_flag & DETAIL) {
-					perror("Can't get super block info");
-					PRINT_FILE_NAME(argv[i]);
-				}
+				if (mode_flag & DETAIL)
+					com_err(argv[1], ret,
+						"while trying to open file system: %s",
+						dev_name);
 				continue;
 			}
 
-- 
1.9.0

