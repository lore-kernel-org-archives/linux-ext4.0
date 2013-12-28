From: Jon Ernst <jonernst07@gmail.com>
Subject: [PATCH] libext2fs: delete unused "handle" variable
Date: Sat, 28 Dec 2013 03:03:41 -0500
Message-ID: <52BE85DD.7060902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:44719 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3L1IDn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 28 Dec 2013 03:03:43 -0500
Received: by mail-qe0-f43.google.com with SMTP id jy17so9725958qeb.16
        for <linux-ext4@vger.kernel.org>; Sat, 28 Dec 2013 00:03:42 -0800 (PST)
Received: from [192.168.1.7] (pool-96-241-155-28.washdc.fios.verizon.net. [96.241.155.28])
        by mx.google.com with ESMTPSA id n14sm55237597qav.8.2013.12.28.00.03.42
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 28 Dec 2013 00:03:42 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[PATCH] libext2fs: delete unused "handle" variable
after commit 62f17f36031102a2a40fac338e063c556f73b94a,
variable "handle" has no use. So delete it.

Signed-off-by: Jon Enrst <jonernst07@gmail.com>
---
  lib/ext2fs/symlink.c | 1 -
  1 file changed, 1 deletion(-)

diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index ad80444..b2ef66c 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -31,7 +31,6 @@
  errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t 
ino,
                          const char *name, char *target)
  {
-       ext2_extent_handle_t    handle;
         errcode_t               retval;
         struct ext2_inode       inode;
         ext2_ino_t              scratch_ino;
-- 
1.8.4.4

