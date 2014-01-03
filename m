From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] e2fsck: fix possible double free when searching for config file
Date: Fri,  3 Jan 2014 18:12:28 -0500
Message-ID: <1388790748-18973-2-git-send-email-tytso@mit.edu>
References: <1388790748-18973-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45737 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbaACXMg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 18:12:36 -0500
In-Reply-To: <1388790748-18973-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This happens if there is an error while scanning a directory for
config file fragments.  This is rarely used, which is why we didn't
notice this.

Addresses-Coverity-Bug: #1138576

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/profile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/e2fsck/profile.c b/e2fsck/profile.c
index 92aa893..9cfab37 100644
--- a/e2fsck/profile.c
+++ b/e2fsck/profile.c
@@ -320,6 +320,7 @@ profile_init(const char **files, profile_t *ret_profile)
 	    for (fs = files; !PROFILE_LAST_FILESPEC(*fs); fs++) {
 		if (array)
 			free_list(array);
+		array = NULL;
 		retval = get_dirlist(*fs, &array);
 		if (retval == 0) {
 			if (!array)
-- 
1.8.5.rc3.362.gdf10213

