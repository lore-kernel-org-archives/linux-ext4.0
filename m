From: Marc Thomas <marc@dragonfly.plus.com>
Subject: [PATCH 2/2] e4defrag: fix GCC7.x compiler warning
Date: Mon, 26 Jun 2017 16:40:39 +0100
Message-ID: <17cefd39-75bf-45e5-38fa-2eac38f6e081@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avasout01.plus.net ([84.93.230.227]:38113 "EHLO
        avasout01.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdFZPkm (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 11:40:42 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by anvil.lan (8.15.2/8.15.2) with ESMTP id v5QFee4N003961
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 16:40:40 +0100
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

../../misc/e4defrag.c:1821:8: warning: statement will never be executed
[-Wswitch-unreachable]
    int mount_dir_len = 0;

Also fix a typo in a few comments.

Signed-off-by: Marc Thomas <marc@dragonfly.plus.com>
---
 misc/e4defrag.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 84501d17..62860eb1 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1676,6 +1676,7 @@ int main(int argc, char *argv[])
 	int	flags = FTW_PHYS | FTW_MOUNT;
 	int	arg_type = -1;
 	int	success_flag = 0;
+	int	mount_dir_len = 0;
 	char	dir_name[PATH_MAX + 1];
 	char	dev_name[PATH_MAX + 1];
 	struct stat64	buf;
@@ -1818,7 +1819,6 @@ int main(int argc, char *argv[])
 		}
  		switch (arg_type) {
-			int mount_dir_len = 0;
  		case DIRNAME:
 			if (!(mode_flag & STATISTIC))
@@ -1830,11 +1830,11 @@ int main(int argc, char *argv[])
 			strncat(lost_found_dir, "/lost+found",
 				PATH_MAX - strnlen(lost_found_dir, PATH_MAX));
 -			/* Not the case("e4defrag  mount_piont_dir") */
+			/* Not the case("e4defrag  mount_point_dir") */
 			if (dir_name[mount_dir_len] != '\0') {
 				/*
-				 * "e4defrag mount_piont_dir/lost+found"
-				 * or "e4defrag mount_piont_dir/lost+found/"
+				 * "e4defrag mount_point_dir/lost+found"
+				 * or "e4defrag mount_point_dir/lost+found/"
 				 */
 				if (strncmp(lost_found_dir, dir_name,
 					    strnlen(lost_found_dir,
@@ -1848,7 +1848,7 @@ int main(int argc, char *argv[])
 					continue;
 				}
 -				/* "e4defrag mount_piont_dir/else_dir" */
+				/* "e4defrag mount_point_dir/else_dir" */
 				memset(lost_found_dir, 0, PATH_MAX + 1);
 			}
 		case DEVNAME:
-- 
2.13.0
