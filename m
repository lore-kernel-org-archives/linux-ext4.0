From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/5] resize2fs.8.in: clarify when on-line resizing is supported
Date: Sun, 24 Aug 2014 23:59:49 -0400
Message-ID: <1408939192-22656-2-git-send-email-tytso@mit.edu>
References: <1408939192-22656-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47270 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbaHYD75 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Aug 2014 23:59:57 -0400
In-Reply-To: <1408939192-22656-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Debian-Bug: #726760

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 resize/resize2fs.8.in | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
index a1f3099..86495c6 100644
--- a/resize/resize2fs.8.in
+++ b/resize/resize2fs.8.in
@@ -29,9 +29,10 @@ program will resize ext2, ext3, or ext4 file systems.  It can be used to
 enlarge or shrink an unmounted file system located on
 .IR device .
 If the filesystem is mounted, it can be used to expand the size of the
-mounted filesystem, assuming the kernel supports on-line resizing.  (As
-of this writing, the Linux 2.6 kernel supports on-line resize for
-filesystems mounted using ext3 and ext4.).
+mounted filesystem, assuming the kernel and the file system supports
+on-line resizing.  (Modern Linux 2.6 kernels will support on-line resize
+for file systems mounted using ext3 and ext4; ext3 file systems will
+require the use of file systems with the resize_inode feature enabled.)
 .PP
 The
 .I size
-- 
2.1.0

