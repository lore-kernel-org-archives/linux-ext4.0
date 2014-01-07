From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 09/10] badblocks: print warning if set_o_direct() fails
Date: Tue,  7 Jan 2014 09:53:13 -0500
Message-ID: <1389106394-31898-9-git-send-email-tytso@mit.edu>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46605 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbaAGOxW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 09:53:22 -0500
In-Reply-To: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Coverity-Id: #1049148

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/badblocks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/misc/badblocks.c b/misc/badblocks.c
index 912ef28..e5024f6 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -300,7 +300,8 @@ static void set_o_direct(int dev, unsigned char *buffer, size_t size,
 		flag = fcntl(dev, F_GETFL);
 		if (flag > 0) {
 			flag = (flag & ~O_DIRECT) | new_flag;
-			fcntl(dev, F_SETFL, flag);
+			if (fcntl(dev, F_SETFL, flag) < 0)
+				perror("set_o_direct");
 		}
 		current_O_DIRECT = new_flag;
 	}
-- 
1.8.5.rc3.362.gdf10213

