From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH v2] E2fsprogs: add missing usage for No_COW
Date: Wed, 13 Jun 2012 16:56:42 +0800
Message-ID: <1339577802-31343-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <linux-btrfs@vger.kernel.org>, <rm@romanrm.ru>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49658 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab2FMItZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2012 04:49:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add the missing usage for No_COW since we've supported No_COW flag.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
v1->v2: sort options alphabetically, thanks to Roman Mamedov.

 misc/chattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/chattr.c b/misc/chattr.c
index 141ea6e..24254cc 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -83,7 +83,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=AacDdeijsSu] [-v version] files...\n"),
+		_("Usage: %s [-RVf] [-+=AaCcDdeijsSu] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
-- 
1.6.5.2

