From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] e2image: avoid potential divide by zero
Date: Fri,  3 Jan 2014 00:29:56 -0500
Message-ID: <1388726998-14349-3-git-send-email-tytso@mit.edu>
References: <1388726998-14349-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45549 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaACFaN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 00:30:13 -0500
In-Reply-To: <1388726998-14349-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's highly unlikely after five seconds that zero blocks would have
been written, but let's silence the Coverity warning.

Addresses-Coverity-ID: 1147780

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/e2image.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index ac62ffe..6c51137 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -634,7 +634,7 @@ more_blocks:
 			bscount = print_progress(total_written,
 						 meta_blocks_count);
 			duration = time(NULL) - start_time;
-			if (duration > 5) {
+			if (duration > 5 && total_written) {
 				time_t est = (duration * meta_blocks_count /
 					      total_written) - duration;
 				char buff[30];
-- 
1.8.5.rc3.362.gdf10213

