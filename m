From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH][64-BIT] Enable 64-bitness in e2image.c
Date: Mon, 06 Apr 2009 01:33:21 -0400
Message-ID: <2273.1238996001@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:49092 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbZDFFjX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2009 01:39:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I tried to use e2image on a 32TiB FS  and was getting errors.

Add EXT2_FLAG_NEW_BITMAPS to the open_flags for the device.

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 misc/e2image.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index fb92881..5c4dde7 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -625,7 +625,7 @@ int main (int argc, char ** argv)
 	errcode_t retval;
 	ext2_filsys fs;
 	char *image_fn;
-	int open_flag = 0;
+	int open_flag = EXT2_FLAG_NEW_BITMAPS;
 	int raw_flag = 0;
 	int install_flag = 0;
 	int scramble_flag = 0;
-- 
1.6.0.3

