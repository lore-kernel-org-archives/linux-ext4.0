From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] e2fsck: make sure the extent tree is consistent after bogus node in the tree
Date: Thu, 20 Dec 2012 18:43:43 -0500
Message-ID: <1356047023-28367-3-git-send-email-tytso@mit.edu>
References: <20121220234229.GA22476@thunk.org>
 <1356047023-28367-1-git-send-email-tytso@mit.edu>
Cc: forrestl@synology.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39632 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2LTXnp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Dec 2012 18:43:45 -0500
In-Reply-To: <1356047023-28367-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 789bd401c3 ("e2fsck: fix incorrect interior node logical start
values") surfaced a bug where if e2fsck finds and removed an invalid
node in the extent tree, i.e.:

Inode 12 has an invalid extent node (blk 22, lblk 0)
Clear? yes

It was possible for starting logical blocks found in the interior
nodes of the extent tree.  Commit 789bd401c3 added the ability for
e2fsck to discover this problem, which resulted in the test
f_extent_bad_node to fail when the second pass of e2fsck reported the
following complaint:

Interior extent node level 0 of inode 12:
Logical start 0 does not match logical start 3 at next level.  Fix? yes

This patch fixes this by adding a call to ext2fs_extent_fix_parents()
after deleting the bogus node in the extent tree.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 2acbb53..a8231f4 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1809,6 +1809,7 @@ report_problem:
 					pctx->str = "ext2fs_extent_delete";
 					return;
 				}
+				ext2fs_extent_fix_parents(ehandle);
 				pctx->errcode = ext2fs_extent_get(ehandle,
 								  EXT2_EXTENT_CURRENT,
 								  &extent);
-- 
1.7.12.rc0.22.gcdd159b

