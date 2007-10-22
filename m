From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libe2p: Use lstat() instead of stat() in fsetflags() and fgetflags()
Date: Mon, 22 Oct 2007 09:30:05 -0400
Message-ID: <1193059807-7933-1-git-send-email-tytso@mit.edu>
References: <20071022125504.GB29220@thunk.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53213 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbXJVNaT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2007 09:30:19 -0400
In-Reply-To: <20071022125504.GB29220@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We can't set the flags on symbolic links, so check for them using
lstat().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/e2p/fgetflags.c |    2 +-
 lib/e2p/fsetflags.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/e2p/fgetflags.c b/lib/e2p/fgetflags.c
index 0aed6c8..372304f 100644
--- a/lib/e2p/fgetflags.c
+++ b/lib/e2p/fgetflags.c
@@ -65,7 +65,7 @@ int fgetflags (const char * name, unsigned long * flags)
 #if HAVE_EXT2_IOCTLS
 	int fd, r, f, save_errno = 0;
 
-	if (!stat(name, &buf) &&
+	if (!lstat(name, &buf) &&
 	    !S_ISREG(buf.st_mode) && !S_ISDIR(buf.st_mode)) {
 		goto notsupp;
 	}
diff --git a/lib/e2p/fsetflags.c b/lib/e2p/fsetflags.c
index 2f1277f..3a05324 100644
--- a/lib/e2p/fsetflags.c
+++ b/lib/e2p/fsetflags.c
@@ -71,7 +71,7 @@ int fsetflags (const char * name, unsigned long flags)
 #if HAVE_EXT2_IOCTLS
 	int fd, r, f, save_errno = 0;
 
-	if (!stat(name, &buf) &&
+	if (!lstat(name, &buf) &&
 	    !S_ISREG(buf.st_mode) && !S_ISDIR(buf.st_mode)) {
 		goto notsupp;
 	}
-- 
1.5.3.4.1232.g9991d-dirty
