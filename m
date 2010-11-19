From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] e4defrag: Fix the segfault occurred when removing defragging
 file
Date: Fri, 19 Nov 2010 16:51:25 +0900
Message-ID: <4CE62C7D.8030009@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: mkkp4x4@gmail.com
To: Theodore Tso <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:51011 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0KSHwv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 02:52:51 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This is for Red Hat Bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=641926

It is possible that e4defrag causes a segfault when someone removes
a defragging file. The following patch fixes this problem.

How to make the newest e4defrag:
1. Download e2fsprogs git tree
   # git pull http://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

2. Apply the patch I sent a while ago
   http://marc.info/?l=linux-ext4&m=128272690010784&w=4

3. Apply the attached patch 

Regards,
Kazuya Mio

Reported-by: Michal Piotrowski <mkkp4x4@gmail.com>
Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index db92e1c..eb3269a 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -936,7 +936,7 @@ static int get_file_extents(int fd, struct fiemap_extent_list **ext_list_head)
 		fiemap_buf->fm_start = pos;
 		memset(ext_buf, 0, ext_buf_size);
 		ret = ioctl(fd, FS_IOC_FIEMAP, fiemap_buf);
-		if (ret < 0)
+		if (ret < 0 || fiemap_buf->fm_mapped_extents == 0)
 			goto out;
 		for (i = 0; i < fiemap_buf->fm_mapped_extents; i++) {
 			ext_list = NULL;
