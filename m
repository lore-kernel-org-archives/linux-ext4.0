From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH 1/2] Use 'inode' variable that is already dereferenced
Date: Mon, 15 Oct 2012 12:06:48 -0700
Message-ID: <1350328009-22740-1-git-send-email-anatol.pomozov@gmail.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>
To: tytso@mit.edu, wenqing.lz@taobao.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:58077 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2JOTHf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2012 15:07:35 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so662316ggm.1
        for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2012 12:07:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Tested: xfs tests

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 fs/ext4/page-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 68e896e..0fd16e6 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -111,7 +111,7 @@ static int ext4_end_io(ext4_io_end_t *io)
 		inode_dio_done(inode);
 	/* Wake up anyone waiting on unwritten extent conversion */
 	if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
-		wake_up_all(ext4_ioend_wq(io->inode));
+		wake_up_all(ext4_ioend_wq(inode));
 	return ret;
 }
 
-- 
1.8.0.rc1

