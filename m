Return-Path: <SRS0=nu1L=M2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:46834 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbeJNWj6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Oct 2018 18:39:58 -0400
Received: by mail-io1-f65.google.com with SMTP id t7-v6so12476074ioj.13
        for <linux-ext4@vger.kernel.org>; Sun, 14 Oct 2018 07:58:45 -0700 (PDT)
From: nicholas.clark@gmail.com
To: nicholas.clark@gmail.com, linux-ext4@vger.kernel.org
Subject: [PATCH RESEND 1/2] Fuse2fs: fix 'mount' entry in some cases.
Date: Sun, 14 Oct 2018 08:58:36 -0600
Message-Id: <20181014145837.6344-2-nicholas.clark@gmail.com>
In-Reply-To: <20181014145837.6344-1-nicholas.clark@gmail.com>
References: <20181014145837.6344-1-nicholas.clark@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Nicholas Clark <nicholas.clark@gmail.com>

FUSE's parser allows command-line options to be specified before
or after the device/image and mount-path. This commit changes the
value of the fsname mount option to be correct even if options are
specified before the target device/image.

Signed-off-by: Nicholas Clark <nicholas.clark@gmail.com>
---
 misc/fuse2fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 5c73895e..3214be4a 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -3845,7 +3845,7 @@ int main(int argc, char *argv[])
 	/* Set up default fuse parameters */
 	snprintf(extra_args, BUFSIZ, "-okernel_cache,subtype=ext4,use_ino,"
 		 "fsname=%s,attr_timeout=0" FUSE_PLATFORM_OPTS,
-		 argv[1]);
+		 fctx.device);
 	if (fctx.no_default_opts == 0)
 		fuse_opt_add_arg(&args, extra_args);
 
-- 
2.17.1
