From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 07/11] e4defrag: Fix memory leak in file_defrag()
Date: Fri, 08 Apr 2011 16:52:39 +0900
Message-ID: <4D9EBEC7.5070504@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:56649 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab1DHIII (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 04:08:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

'donor_list' is allocated in get_file_extents(), but it's not freed.
This patch fixes it.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |    1 +
 1 file changed, 1 insertion(+)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index f4ced9a..ba0d424 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1191,6 +1191,7 @@ out:
 	if (donor_fd != -1)
 		close(donor_fd);
 	free_ext(orig_list);
+	free_ext(donor_list);
 	free_exts_group(orig_group_head);
 	return 0;
 }
