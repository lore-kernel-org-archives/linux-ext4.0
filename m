From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsck: don't try to stop mmp if there is no superblock set
 up
Date: Fri, 16 Aug 2013 12:05:55 -0500
Message-ID: <520E5BF3.5090502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Hubert Kario <hkario@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab3HPRF5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Aug 2013 13:05:57 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7GH5vVU032535
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 16 Aug 2013 13:05:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Under some failure cases, we can get to fatal_error()
without even having a superblock set up.  In that case,
ext2fs_mmp_stop() will segfault when it tries to dereference
fs->super.

Check for the existence of a superblock before we go
down the ext2fs_mmp_stop() path to avoid this problem.

Reported-by: Hubert Kario <hkario@redhat.com>
Addresses-Red-Hat-Bugzilla: #997972
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/e2fsck/util.c b/e2fsck/util.c
index 9eaf557..18005f4 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -55,7 +55,7 @@ void fatal_error(e2fsck_t ctx, const char *msg)
 		fprintf (stderr, "e2fsck: %s\n", msg);
 	if (!fs)
 		goto out;
-	if (fs->io) {
+	if (fs->io && fs->super) {
 		ext2fs_mmp_stop(ctx->fs);
 		if (ctx->fs->io->magic == EXT2_ET_MAGIC_IO_CHANNEL)
 			io_channel_flush(ctx->fs->io);
