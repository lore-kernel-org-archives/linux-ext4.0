From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH 2/5][64-BIT] Enable 64-bitness in e2image.c
Date: Wed, 08 Apr 2009 17:46:26 -0400
Message-ID: <11643.1239227186@alphaville.usa.hp.com>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org,
	Valerie Aurora <vaurora@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:35647 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479AbZDHVqZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2009 17:46:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


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
1.6.0.6

