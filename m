From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH][RESEND] mke2fs: fix force option to create filesystem on
 mounted device
Date: Fri, 25 Oct 2013 17:40:35 +0900
Message-ID: <526A2E83.5050102@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:58572 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3JYIsa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Oct 2013 04:48:30 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r9P8mT6U015127
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 25 Oct 2013 17:48:29 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

According to mke2fs man, we can create a filesystem on the mounted device
when -FF option is specified.
However, currently we have to specify -F option third to force mke2fs.
This patch fixes the problem.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
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
