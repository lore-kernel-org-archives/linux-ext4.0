From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] resize2fs: don't require fsck to print min size
Date: Wed, 10 Dec 2014 09:19:56 -0600
Message-ID: <5488649C.8020809@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40400 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569AbaLJPT7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Dec 2014 10:19:59 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 52FC560F96A9
	for <linux-ext4@vger.kernel.org>; Wed, 10 Dec 2014 09:19:58 -0600 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

My previous change ended up requiring that the filesystem
be fsck'd after the last mount, even if we are only querying
the minimum size.  This is a bit draconian, and it burned
the Fedora installer, which wants to calculate minimum size
for every filesystem in the box at install time, which in turn
requires a full fsck of every filesystem.

Try this one more time, and separate out the tests to make things
a bit more clear.  If we're only printing the min size, don't
require the fsck, as this is a bit less dangerous/critical.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/resize/main.c b/resize/main.c
index 983d8c2..d40a741 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -321,10 +321,31 @@ int main (int argc, char ** argv)
 	}
 	fs->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
 
-	if (!(mount_flags & EXT2_MF_MOUNTED)) {
-		if (!force && ((fs->super->s_lastcheck < fs->super->s_mtime) ||
-			       (fs->super->s_state & EXT2_ERROR_FS) ||
-			       ((fs->super->s_state & EXT2_VALID_FS) == 0))) {
+	/*
+	 * Before acting on an unmounted filesystem, make sure it's ok,
+	 * unless the user is forcing it.
+	 *
+	 * We do ERROR and VALID checks even if we're only printing the
+	 * minimimum size, because traversal of a badly damaged filesystem
+	 * can cause issues as well.  We don't require it to be fscked after
+	 * the last mount time in this case, though, as this is a bit less
+	 * risky.
+	 */
+	if (!force && !(mount_flags & EXT2_MF_MOUNTED)) {
+		int checkit = 0;
+
+		if (fs->super->s_state & EXT2_ERROR_FS)
+			checkit = 1;
+		
+		if ((fs->super->s_state & EXT2_VALID_FS) == 0)
+			checkit = 1;
+
+		if (fs->super->s_lastcheck < fs->super->s_mtime) {
+			if (!print_min_size)
+				checkit = 1;
+		}
+
+		if (checkit) {
 			fprintf(stderr,
 				_("Please run 'e2fsck -f %s' first.\n\n"),
 				device_name);

