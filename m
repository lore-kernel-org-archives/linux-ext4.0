From: Marc Thomas <marc@dragonfly.plus.com>
Subject: [PATCH] e4defrag: Add a version number
Date: Fri, 9 Jun 2017 13:58:32 +0100
Message-ID: <115cbcc0-1e18-f45a-d043-237508e89a08@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avasout01.plus.net ([84.93.230.227]:36770 "EHLO
        avasout01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751545AbdFIM6f (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Jun 2017 08:58:35 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by anvil.lan (8.15.2/8.15.2) with ESMTP id v59CwWhU003597
        for <linux-ext4@vger.kernel.org>; Fri, 9 Jun 2017 13:58:32 +0100
Content-Language: en-GB
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add the e2fsprogs version number to e4defrag.
Display the version number prior to the usage message.

Signed-off-by: Marc Thomas <marc@dragonfly.plus.com>
---
 misc/e4defrag.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 1d1b4f41..86056fdd 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -40,6 +40,7 @@
 #include <sys/stat.h>
 #include <sys/statfs.h>
 #include <sys/vfs.h>
+#include "../version.h"
  /* A relatively new ioctl interface ... */
 #ifndef EXT4_IOC_MOVE_EXT
@@ -2026,6 +2027,7 @@ int main(int argc, char *argv[])
 	exit(1);
  out:
+	printf("e4defrag %s (%s)\n", E2FSPROGS_VERSION, E2FSPROGS_DATE);
 	printf(MSG_USAGE);
 	exit(1);
 }
-- 
2.13.0
