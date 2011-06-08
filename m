From: "Yury V. Zaytsev" <yury@shurup.com>
Subject: [PATCH] mke2fs: check that auto-detected blocksize <= sys_page_size
Date: Wed, 08 Jun 2011 11:23:18 +0200
Message-ID: <1307524998.2467.41.camel@newpride>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-buozqC0pXRgFrfHzt0h/"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgateway3.uni-freiburg.de ([132.230.2.213]:49658 "EHLO
	mailgateway3.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510Ab1FHJ7K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Jun 2011 05:59:10 -0400
Received: from bccn.uni-freiburg.de ([132.230.2.123] helo=uni-freiburg.de) port 51704
	by mailgateway3.uni-freiburg.de with esmtp
	(Exim 4.68 #1 built 28-Nov-2007 14:57:47 running on Gentoo)
	id 1QUEyu-000683-WC
	for linux-ext4@vger.kernel.org; Wed, 08 Jun 2011 11:23:21 +0200
Received: from [93.132.247.252] (account yuriy.zaytsev@bcf.uni-freiburg.de HELO [192.168.1.102])
  by uni-freiburg.de (CommuniGate Pro SMTP 5.3.11)
  with ESMTPSA id 161297242 for linux-ext4@vger.kernel.org; Wed, 08 Jun 2011 11:23:20 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-buozqC0pXRgFrfHzt0h/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi!

I have recently stumbled upon a RHEL6.1 installation problem on an SSD
drive that was working fine with older kernels, where created file
systems could not be mounted and the installation was aborting.

It turned out that the drive had a firmware bug and was exposing a
minimum_io_size of 8912, whereas my x86_64 system had a page size of
4096 bytes.

mkfs in turn was silently creating file systems with 8912 bytes block
size, because it was auto-detected as opposed to specified via the -b
option from the command line.

This made the problem hard to debug, hence I attach a tentative patch to
fix this issue. I'd like to acknowledge Mike Snitzer for directing me to
this list.

I'm not subscribed, so please CC: me upon replies and be mindful that
it's my first contribution of this kind, so even though I did my best to
do it the right way, I might have screwed something up.

Thanks!

-- 
Sincerely yours,
Yury V. Zaytsev


--=-buozqC0pXRgFrfHzt0h/
Content-Disposition: attachment; filename*0=0001-mke2fs-check-that-auto-detected-blocksize-sys_page_s.pat; filename*1=ch
Content-Type: text/x-patch; name="0001-mke2fs-check-that-auto-detected-blocksize-sys_page_s.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 5dcc3266d46ee3846bd8707c7b99bd312fe2276b Mon Sep 17 00:00:00 2001
From: "Yury V. Zaytsev" <yury@shurup.com>
Date: Wed, 8 Jun 2011 11:12:54 +0200
Subject: [PATCH] mke2fs: check that auto-detected blocksize <= sys_page_size

Block size can be specified manually via the -b option or deduced
automatically. Unfortunately, the check that it is still smaller than
the system page size is only performed right after the command line
options were parsed.

Therefore, if buggy or inappropriately installed/configured hardware
hints that larger block sizes have to be used, mkfs will silently create
a file system which can not be mounted on the system in question.

By moving the check beyond the last assignment to blocksize it is now
ensured, that mkfs will issue a warning even if inappropriate blocksize
was auto-detected.

The new behavior can be easily tested, by exporting the following
variables before running mkfs:

    export MKE2FS_DEVICE_SECTSIZE=8912
    export MKE2FS_DEVICE_PHYS_SECTSIZE=8912

Signed-off-by: Yury V. Zaytsev <yury@shurup.com>
---
 misc/mke2fs.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index e28828e..b600617 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1526,17 +1526,6 @@ static void PRS(int argc, char *argv[])
 		ext2fs_close(jfs);
 	}
 
-	if (blocksize > sys_page_size) {
-		if (!force) {
-			com_err(program_name, 0,
-				_("%d-byte blocks too big for system (max %d)"),
-				blocksize, sys_page_size);
-			proceed_question();
-		}
-		fprintf(stderr, _("Warning: %d-byte blocks too big for system "
-				  "(max %d), forced to continue\n"),
-			blocksize, sys_page_size);
-	}
 	if (optind < argc) {
 		fs_param.s_blocks_count = parse_num_blocks(argv[optind++],
 				fs_param.s_log_block_size);
@@ -1811,6 +1800,19 @@ got_size:
 
 	blocksize = EXT2_BLOCK_SIZE(&fs_param);
 
+	/* This check should happen beyond the last assignment to blocksize */
+	if (blocksize > sys_page_size) {
+		if (!force) {
+			com_err(program_name, 0,
+				_("%d-byte blocks too big for system (max %d)"),
+				blocksize, sys_page_size);
+			proceed_question();
+		}
+		fprintf(stderr, _("Warning: %d-byte blocks too big for system "
+				  "(max %d), forced to continue\n"),
+			blocksize, sys_page_size);
+	}
+
 	lazy_itable_init = 0;
 	if (access("/sys/fs/ext4/features/lazy_itable_init", R_OK) == 0)
 		lazy_itable_init = 1;
-- 
1.7.5.4


--=-buozqC0pXRgFrfHzt0h/--

