From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH] tune2fs: Fix overflow of interval check
Date: Tue, 19 Apr 2011 15:11:39 +0900
Message-ID: <4DAD279B.8070905@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58472 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1DSGMZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Apr 2011 02:12:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add the check of maximum check interval.
s_checkinterval is 32bit variable, so it cannot be set more than 2^32.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/tune2fs.c |    6 ++++++
 1 file changed, 6 insertions(+)
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index bcada11..625866f 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1705,6 +1705,12 @@ retry_open:
 		printf(_("Setting reserved blocks gid to %lu\n"), resgid);
 	}
 	if (i_flag) {
+		if (interval >= (1ULL << 32)) {
+			com_err(program_name, 0,
+				_("interval between checks is too big (%lu)"),
+				interval);
+			exit(1);
+		}
 		sb->s_checkinterval = interval;
 		ext2fs_mark_super_dirty(fs);
 		printf(_("Setting interval between checks to %lu seconds\n"),
