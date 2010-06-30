From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] e2fsprogs: Add missed ext2fs_close
Date: Wed, 30 Jun 2010 15:24:48 +0400
Message-ID: <87wrtgbw5b.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60333 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab0F3LYw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2010 07:24:52 -0400
Received: by bwz1 with SMTP id 1so308852bwz.19
        for <linux-ext4@vger.kernel.org>; Wed, 30 Jun 2010 04:24:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

Today i've accidentally overwrote first GB of 400Gb ext4 filesystem with
zeroes :) . So journal, group descriptors, rootdir and etc was destroyed.
Surprisingly i've able to recover some of my data after long fsck
process. I've met only one trivial bug in initialization stage.
See patch attached.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-e2fsprogs-Add-missed-ext2fs_close.patch

>From 57f41b37a08581f4be8e87c54d8da42d5cb62ddd Mon Sep 17 00:00:00 2001
From: root <root@ws-qual.sw.ru>
Date: Wed, 30 Jun 2010 15:06:36 +0400
Subject: [PATCH] e2fsprogs: Add missed ext2fs_close


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 e2fsck/unix.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index bae3b38..273dbef 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1061,6 +1061,8 @@ restart:
 			orig_retval = retval;
 			retval = try_open_fs(ctx, flags, io_ptr, &fs);
 			if ((orig_retval == 0) && retval != 0) {
+				if (fs)
+					ext2fs_close(fs);
 				com_err(ctx->program_name, retval,
 					"when using the backup blocks");
 				printf(_("%s: going back to original "
-- 
1.6.5.2


--=-=-=--
