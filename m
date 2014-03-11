From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/49] mke2fs: set block_validity as a default mount option
Date: Mon, 10 Mar 2014 23:56:56 -0700
Message-ID: <20140311065656.30585.8614.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32854 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaCKG5O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:57:14 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The block_validity mount option spot-checks block allocations against
a bitmap of known group metadata blocks.  This helps us to prevent
self-inflicted catastrophic failures such as trying to "share"
critical metadata (think bitmaps) with file data, which usually
results in filesystem destruction.

In order to test the overhead of the mount option, I re-used the speed
tests in the metadata checksum testing script.  In short, the program
creates what looks like 15 copies of a kernel source tree, except that
it uses fallocate to strip out the overhead of writing the file data
so that we can focus on metadata overhead.  On a 64G RAM disk, the
overhead was generally about 0.9% and at most 1.6%.  On a 160G USB
disk, the overhead was about 0.8% and peaked at 1.2%.

When I changed the test to write out files instead of merely
fallocating space, the overhead was negligible.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/mke2fs.conf.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 4c5dba7..de0250d 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -1,6 +1,6 @@
 [defaults]
 	base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr
-	default_mntopts = acl,user_xattr
+	default_mntopts = acl,user_xattr,block_validity
 	enable_periodic_fsck = 0
 	blocksize = 4096
 	inode_size = 256

