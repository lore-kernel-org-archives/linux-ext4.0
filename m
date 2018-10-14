Return-Path: <SRS0=nu1L=M2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:38421 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbeJNWln (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 14 Oct 2018 18:41:43 -0400
Received: by mail-it1-f194.google.com with SMTP id i76-v6so24204763ita.3
        for <linux-ext4@vger.kernel.org>; Sun, 14 Oct 2018 08:00:29 -0700 (PDT)
From: nicholas.clark@gmail.com
To: linux-ext4@vger.kernel.org
Cc: Nicholas Clark <nicholas.clark@gmail.com>
Subject: [PATCH RESEND 1/2] Fuse2fs: fix 'mount' entry in some cases.
Date: Sun, 14 Oct 2018 09:00:24 -0600
Message-Id: <20181014150025.6477-2-nicholas.clark@gmail.com>
In-Reply-To: <20181014150025.6477-1-nicholas.clark@gmail.com>
References: <20181014150025.6477-1-nicholas.clark@gmail.com>
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
