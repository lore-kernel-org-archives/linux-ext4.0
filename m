From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: open device writable for trim/discard
Date: Tue, 17 Nov 2009 15:49:03 -0600
Message-ID: <4B031A4F.5080105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbZKQVtG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Nov 2009 16:49:06 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAHLnBT2000563
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 16:49:12 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id nAHLn3hH015141
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 16:49:11 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry about that, the discard ioctl doesn't actually work
unless you open the file with write capabilities...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 94b4c81..0aa31d8 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1877,7 +1877,7 @@ static void mke2fs_discard_blocks(ext2_filsys fs)
 	range[0] = 0;
 	range[1] = blocks * blocksize;
 
-	fd = open64(fs->device_name, O_RDONLY);
+	fd = open64(fs->device_name, O_RDWR);
 
 	/*
 	 * We don't care about whether the ioctl succeeds; it's only an

