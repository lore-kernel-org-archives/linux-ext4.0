From: "Kazuya Mio" <k-mio@sx.jp.nec.com>
Subject: [PATCH v2] mke2fs: fix force option to create filesystem on mounted device
Date: Fri, 29 Nov 2013 15:30:41 +0900
Message-ID: <003b01ceeccc$869135b0$93b3a110$@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, "'Andreas Dilger'" <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61158 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3K2Guk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Nov 2013 01:50:40 -0500
Content-Language: ja
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is v2 patch added reviewed-by.
Could you check and merge this patch if possible?


According to mke2fs man, we can create a filesystem on the mounted device
when -FF option is specified.
However, currently we have to specify -F option third to force mke2fs.
This patch fixes the problem.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 misc/util.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/util.c b/misc/util.c
index 6c93e1c..40c8858 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -150,7 +150,7 @@ void check_mount(const char *device, int force, const char *type)
 	}
 	if (mount_flags & EXT2_MF_MOUNTED) {
 		fprintf(stderr, _("%s is mounted; "), device);
-		if (force > 2) {
+		if (force >= 2) {
 			fputs(_("mke2fs forced anyway.  Hope /etc/mtab is "
 				"incorrect.\n"), stderr);
 			return;
@@ -162,7 +162,7 @@ void check_mount(const char *device, int force, const char *type)
 	if (mount_flags & EXT2_MF_BUSY) {
 		fprintf(stderr, _("%s is apparently in use by the system; "),
 			device);
-		if (force > 2) {
+		if (force >= 2) {
 			fputs(_("mke2fs forced anyway.\n"), stderr);
 			return;
 		}


