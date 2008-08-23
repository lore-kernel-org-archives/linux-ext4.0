From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] debugfs : Print the progname instead of argv[0] in error message.
Date: Sat, 23 Aug 2008 22:28:05 +0530
Message-ID: <ea11fea30808230958j16cfbd31hf8b548ff34b97917@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:7098 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYHWQ6G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2008 12:58:06 -0400
Received: by ti-out-0910.google.com with SMTP id b6so547918tic.23
        for <linux-ext4@vger.kernel.org>; Sat, 23 Aug 2008 09:58:05 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Trivial fix to print the progname instead of argv[0] in error message.

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 debugfs/debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index ab40de8..935df81 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1514,7 +1514,7 @@ try_again:
 	if (retval == EXT2_ET_DIR_NO_SPACE) {
 		retval = ext2fs_expand_dir(current_fs, parent);
 		if (retval) {
-			com_err("argv[0]", retval, "while expanding directory");
+			com_err(argv[0], retval, "while expanding directory");
 			return;
 		}
 		goto try_again;
-- 
1.5.4.3


Thanks-
Manish
