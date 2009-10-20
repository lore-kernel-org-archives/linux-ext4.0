From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH v2 3/4] e4defrag: avoid unsuccessful return in non-privileged
 user
Date: Tue, 20 Oct 2009 17:16:12 +0900
Message-ID: <4ADD71CC.4030605@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
	Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:59151 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZJTIUS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2009 04:20:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If non-privileged user does e4defrag, e4defrag returns 1 despite
its success. This patch fixes this problem.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---

 e4defrag.c |    1 +
 1 file changed, 1 insertion(+)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index f19b6e6..ea04e60 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -2028,6 +2028,7 @@ int main(int argc, char *argv[])
 				if (!(mode_flag & DETAIL) &&
 						current_uid != ROOT_UID) {
 					printf(" Done.\n");
+					success_flag = 1;
 					continue;
 				}

