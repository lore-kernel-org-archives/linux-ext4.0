From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libe2p: Change iterate_on_dir so that it counts non-zero returns
Date: Mon, 22 Oct 2007 09:30:06 -0400
Message-ID: <1193059807-7933-2-git-send-email-tytso@mit.edu>
References: <20071022125504.GB29220@thunk.org>
 <1193059807-7933-1-git-send-email-tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53210 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbXJVNaT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2007 09:30:19 -0400
In-Reply-To: <1193059807-7933-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

To allow error messages to be reflected up, if the callback function
returns a non-zero value, bump a counter and return the number of
times the callback function signals an error by returning a non-zero
status code.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/e2p/iod.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/e2p/iod.c b/lib/e2p/iod.c
index 808d3a3..84c9709 100644
--- a/lib/e2p/iod.c
+++ b/lib/e2p/iod.c
@@ -27,7 +27,7 @@ int iterate_on_dir (const char * dir_name,
 {
 	DIR * dir;
 	struct dirent *de, *dep;
-	int	max_len = -1, len;
+	int	max_len = -1, len, ret = 0;
 
 #if HAVE_PATHCONF && defined(_PC_NAME_MAX) 
 	max_len = pathconf(dir_name, _PC_NAME_MAX);
@@ -64,9 +64,10 @@ int iterate_on_dir (const char * dir_name,
 			len = max_len;
 #endif
 		memcpy(de, dep, len);
-		(*func) (dir_name, de, private);
+		if ((*func)(dir_name, de, private))
+			ret++;
 	}
 	free(de);
 	closedir(dir);
-	return 0;
+	return ret;
 }
-- 
1.5.3.4.1232.g9991d-dirty
