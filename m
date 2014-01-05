From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/4] libss: fix potential memory leak on realloc() failure
Date: Sun,  5 Jan 2014 01:26:40 -0500
Message-ID: <1388903203-5067-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@google.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46014 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaAEG0q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jan 2014 01:26:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Theodore Ts'o <tytso@google.com>

Addresses-Coverity-ID: #295143

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ss/invocation.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/ss/invocation.c b/lib/ss/invocation.c
index 61c2e35..924427a 100644
--- a/lib/ss/invocation.c
+++ b/lib/ss/invocation.c
@@ -28,7 +28,7 @@ int ss_create_invocation(const char *subsystem_name, const char *version_string,
 {
 	register int sci_idx;
 	register ss_data *new_table;
-	register ss_data **table;
+	register ss_data **table, **rt;
 
 	*code_ptr = 0;
 	table = _ss_table;
@@ -42,10 +42,10 @@ int ss_create_invocation(const char *subsystem_name, const char *version_string,
 
 	for (sci_idx = 1; table[sci_idx] != (ss_data *)NULL; sci_idx++)
 		;
-	table = (ss_data **) realloc((char *)table,
-				     ((unsigned)sci_idx+2)*size);
-	if (table == NULL) {
-		*code_ptr = errno;
+	rt = (ss_data **) realloc((char *)table, ((unsigned)sci_idx+2)*size);
+	if (rt == NULL) {
+		*code_ptr = ENOMEM;
+		free(table);
 		return 0;
 	}
 	table[sci_idx+1] = (ss_data *) NULL;
-- 
1.8.5.rc3.362.gdf10213

