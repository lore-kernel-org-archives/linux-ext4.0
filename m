Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38640 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729387AbeK0UWc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 27 Nov 2018 15:22:32 -0500
From: Maurizio Lombardi <mlombard@redhat.com>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
Subject: [PATCH] ext4: missing unlock/put_page() in ext4_try_to_write_inline_data()
Date: Tue, 27 Nov 2018 10:25:05 +0100
Message-Id: <1543310705-11051-1-git-send-email-mlombard@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In case of error, ext4_try_to_write_inline_data() should unlock
and release the page it holds.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 fs/ext4/inline.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 9c4bac1..27373d8 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -705,8 +705,11 @@ int ext4_try_to_write_inline_data(struct address_space *mapping,
 
 	if (!PageUptodate(page)) {
 		ret = ext4_read_inline_page(inode, page);
-		if (ret < 0)
+		if (ret < 0) {
+			unlock_page(page);
+			put_page(page);
 			goto out_up_read;
+		}
 	}
 
 	ret = 1;
-- 
Maurizio Lombardi
