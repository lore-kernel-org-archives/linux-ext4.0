From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] E2fsprogs: add missing usage for No_COW
Date: Wed, 13 Jun 2012 15:47:13 +0800
Message-ID: <1339573633-31023-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <linux-btrfs@vger.kernel.org>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add the missing usage for No_COW since we've supported No_COW flag.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
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
+		_("Usage: %s [-RVf] [-+=AacDdeijsSuC] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
-- 
1.6.5.2

