From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] Add "big" and "huge" types to mke2fs.conf
Date: Tue,  4 Oct 2011 00:26:59 -0400
Message-ID: <1317702420-31085-1-git-send-email-tytso@mit.edu>
References: <20111004040033.GM6684@thunk.org>
Cc: sandeen@sandeen.net, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47291 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab1JDE1D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 00:27:03 -0400
In-Reply-To: <20111004040033.GM6684@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mke2fs attempts to use the "big" and "huge" types, and now that mke2fs
will complain if there are file system types which are undefined,
let's add definitions for them.

Thanks to Richard Jones for reporting this problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs-hurd.conf |    6 ++++++
 misc/mke2fs.conf      |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/misc/mke2fs-hurd.conf b/misc/mke2fs-hurd.conf
index 52ed7e5..4f0527d 100644
--- a/misc/mke2fs-hurd.conf
+++ b/misc/mke2fs-hurd.conf
@@ -21,6 +21,12 @@
 	floppy = {
 		inode_ratio = 8192
 	}
+	big = {
+		inode_ratio = 32768
+	}
+	huge = {
+		inode_ratio = 65536
+	}
 	news = {
 		inode_ratio = 4096
 	}
diff --git a/misc/mke2fs.conf b/misc/mke2fs.conf
index 775e046..0871f77 100644
--- a/misc/mke2fs.conf
+++ b/misc/mke2fs.conf
@@ -30,6 +30,12 @@
 		inode_size = 128
 		inode_ratio = 8192
 	}
+	big = {
+		inode_ratio = 32768
+	}
+	huge = {
+		inode_ratio = 65536
+	}
 	news = {
 		inode_ratio = 4096
 	}
-- 
1.7.4.1.22.gec8e1.dirty

