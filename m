From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 09/50] ext3/4: fix uninitialized bs in ext3/4_xattr_set_handle()
Date: Fri, 06 Jun 2008 18:02:24 -0700
Message-ID: <20080607010554.457330224@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Tiger Yang <tiger.yang@oracle.com>,
	<linux-ext4@vger.kernel.org>, Andreas Gruenbacher <agruen@suse.de>,
	Andreas Dilger <adilger@sun.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:42575 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735AbYFGBJe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:34 -0400
Content-Disposition: inline; filename=ext3-4-fix-uninitialized-bs-in-ext3-4_xattr_set_handle.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Tiger Yang <tiger.yang@oracle.com>

commit 7e01c8e5420b6c7f9d85d34c15d8c7a15c9fc720 upstream

This fix the uninitialized bs when we try to replace a xattr entry in
ibody with the new value which require more than free space.

This situation only happens we format ext3/4 with inode size more than 128 and
we have put xattr entries both in ibody and block.  The consequences about
this bug is we will lost the xattr block which pointed by i_file_acl with all
xattr entires in it.  We will alloc a new xattr block and put that large value
entry in it.  The old xattr block will become orphan block.

Signed-off-by: Tiger Yang <tiger.yang@oracle.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 fs/ext3/xattr.c |    5 +++++
 fs/ext4/xattr.c |    5 +++++
 2 files changed, 10 insertions(+)

--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -1000,6 +1000,11 @@ ext3_xattr_set_handle(handle_t *handle, 
 			i.value = NULL;
 			error = ext3_xattr_block_set(handle, inode, &i, &bs);
 		} else if (error == -ENOSPC) {
+			if (EXT3_I(inode)->i_file_acl && !bs.s.base) {
+				error = ext3_xattr_block_find(inode, &i, &bs);
+				if (error)
+					goto cleanup;
+			}
 			error = ext3_xattr_block_set(handle, inode, &i, &bs);
 			if (error)
 				goto cleanup;
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1011,6 +1011,11 @@ ext4_xattr_set_handle(handle_t *handle, 
 			i.value = NULL;
 			error = ext4_xattr_block_set(handle, inode, &i, &bs);
 		} else if (error == -ENOSPC) {
+			if (EXT4_I(inode)->i_file_acl && !bs.s.base) {
+				error = ext4_xattr_block_find(inode, &i, &bs);
+				if (error)
+					goto cleanup;
+			}
 			error = ext4_xattr_block_set(handle, inode, &i, &bs);
 			if (error)
 				goto cleanup;

-- 
