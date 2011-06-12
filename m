From: "Yury V. Zaytsev" <yury@shurup.com>
Subject: Re: [PATCH] mke2fs: check that auto-detected blocksize <=
 sys_page_size
Date: Mon, 13 Jun 2011 00:46:31 +0200
Message-ID: <1307918791.2872.18.camel@newpride>
References: <1307524998.2467.41.camel@newpride>
	 <BANLkTikGv=OZgV0iwZroDDnPi+TiyxDzVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>, Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgateway3.uni-freiburg.de ([132.230.2.213]:39495 "EHLO
	mailgateway3.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369Ab1FLWqh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Jun 2011 18:46:37 -0400
In-Reply-To: <BANLkTikGv=OZgV0iwZroDDnPi+TiyxDzVg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2011-06-08 at 15:50 +0300, Amir Goldstein wrote:

> The only thing you screwed up is sending the patch as an attachment.
> People here expect it to be as plain text in the email, so that they
> can reply and comment inline. Other than that, the fix looks good (and
> well explained) to me.

Hi Amir!

Thank you for reviewing my submission. I apologize for attaching the
patch the wrong way. Hopefully, this time I will be able to make my mail
program to include it inline.

I have refreshed patch against the latest "next" branch since it no
longer properly applied and hopefully it can now be included!

--Yury.

>From 1f8e5ad235694f2918fb442135619d4988366434 Mon Sep 17 00:00:00 2001
From: "Yury V. Zaytsev" <yury@shurup.com>
Date: Mon, 13 Jun 2011 00:35:05 +0200
Subject: [PATCH] mke2fs: check that auto-detected blocksize <= sys_page_size

Block size can be specified manually via the -b option or deduced
automatically. Unfortunately, the check that it is still smaller than
the system page size is only performed right after the command line
options are parsed.

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
index 5ff3f9f..d699b46 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1516,17 +1516,6 @@ profile_error:
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
 		fs_blocks_count = parse_num_blocks2(argv[optind++],
 						   fs_param.s_log_block_size);
@@ -1825,6 +1814,19 @@ profile_error:
 
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



