From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 07/11 RESEND] e4defrag: Fix memory leak in file_defrag()
Date: Wed, 15 Jun 2011 15:36:54 +0900
Message-ID: <4DF85306.9010508@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49944 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1FOGmf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jun 2011 02:42:35 -0400
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

