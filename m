From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 3/3] e4defrag: avoid unsuccessful return in non-privileged
 user
Date: Wed, 30 Sep 2009 16:22:37 +0900
Message-ID: <4AC3073D.9070606@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39468 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZI3H1D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Sep 2009 03:27:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If non-privileged user does e4defrag, e4defrag returns 1 despite
its success. This patch fixes this problem.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---

 e4defrag.c |    1 +
 1 file changed, 1 insertion(+)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 94f8529..98dda92 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -2025,6 +2025,7 @@ int main(int argc, char *argv[])
 				if (!(mode_flag & DETAIL) &&
 						current_uid != ROOT_UID) {
 					printf(" Done.\n");
+					success_flag = 1;
 					continue;
 				}
