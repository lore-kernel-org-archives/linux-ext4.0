From: Nicolas Kaiser <nikai@nikai.net>
Subject: [PATCH] ext4: fix unbalanced mutex unlock
Date: Tue, 26 Oct 2010 01:15:34 +0200
Message-ID: <20101026011534.0bb7cb64@absol.kitzblitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:49074 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757676Ab0JYXUd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 19:20:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Although the mutex isn't locked yet, if ext4_li_request_new
fails, the mutex would get unlocked on the error path.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 fs/ext4/super.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d0c3328..8bca022 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2915,10 +2915,8 @@ static int ext4_register_li_request(struct super_block *sb,
 	}
 
 	elr = ext4_li_request_new(sb, first_not_zeroed);
-	if (!elr) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!elr)
+		return -ENOMEM;
 
 	mutex_lock(&ext4_li_mtx);
 
-- 
1.7.2.2
