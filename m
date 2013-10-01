From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/31] e2p: Fix f[gs]etflags argument size mismatch
Date: Mon, 30 Sep 2013 18:27:21 -0700
Message-ID: <20131001012721.28415.97544.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22402 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3JAB1Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:27:25 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The EXT2_IOC_[GS]ETFLAGS ioctls take longs as arguments, however this code only
reserves enough storage for an int.  The kernel drivers (so far) don't transfer
more than an int but FUSE sees the long and assumes that it's ok to write the
full size of the long, which crashes if sizeof(long) > sizeof(int).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/e2p/fgetflags.c |    3 ++-
 lib/e2p/fsetflags.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/lib/e2p/fgetflags.c b/lib/e2p/fgetflags.c
index 2af8462..bfa87f2 100644
--- a/lib/e2p/fgetflags.c
+++ b/lib/e2p/fgetflags.c
@@ -66,7 +66,8 @@ int fgetflags (const char * name, unsigned long * flags)
 	return 0;
 #else /* !HAVE_STAT_FLAGS || (APPLE_DARWIN && HAVE_EXT2_IOCTLS) */
 #if HAVE_EXT2_IOCTLS
-	int fd, r, f, save_errno = 0;
+	int fd, r, save_errno = 0;
+	unsigned long f;
 
 	if (!lstat(name, &buf) &&
 	    !S_ISREG(buf.st_mode) && !S_ISDIR(buf.st_mode)) {
diff --git a/lib/e2p/fsetflags.c b/lib/e2p/fsetflags.c
index 167d16e..050cb4a 100644
--- a/lib/e2p/fsetflags.c
+++ b/lib/e2p/fsetflags.c
@@ -71,7 +71,8 @@ int fsetflags (const char * name, unsigned long flags)
 	return chflags (name, bsd_flags);
 #else /* !HAVE_CHFLAGS || (APPLE_DARWIN && HAVE_EXT2_IOCTLS) */
 #if HAVE_EXT2_IOCTLS
-	int fd, r, f, save_errno = 0;
+	int fd, r, save_errno = 0;
+	unsigned long f;
 	struct stat buf;
 
 	if (!lstat(name, &buf) &&

