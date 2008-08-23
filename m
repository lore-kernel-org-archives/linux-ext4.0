From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] debugfs : Close the file handle and return in case of errors.
Date: Sat, 23 Aug 2008 21:41:25 +0530
Message-ID: <ea11fea30808230911s74d94a8ancee99cfe4bc46e22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mkatiyar@gmail.com
To: "Theodore Tso" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:1153 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbYHWQL2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2008 12:11:28 -0400
Received: by ti-out-0910.google.com with SMTP id b6so542473tic.23
        for <linux-ext4@vger.kernel.org>; Sat, 23 Aug 2008 09:11:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Close the filehandle and return in case if we are unable to expand the
directory during write.

Signed-off-by: "Manish Katiyar" <mkatiyar@gmail.com>

---
 debugfs/debugfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 7039340..ab40de8 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1366,6 +1366,7 @@ void do_write(int argc, char *argv[])
 		retval = ext2fs_expand_dir(current_fs, cwd);
 		if (retval) {
 			com_err(argv[0], retval, "while expanding directory");
+			close(fd);
 			return;
 		}
 		retval = ext2fs_link(current_fs, cwd, argv[2], newfile,
-- 
1.5.4.3


Thanks -
Manish
