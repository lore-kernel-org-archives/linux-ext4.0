From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 15/18] e2fsck: clear badblocks inode when checksum fails
Date: Fri, 25 Jul 2014 17:35:12 -0700
Message-ID: <20140726003512.28334.62413.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17363 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaGZAfQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:35:16 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the badblocks inode fails checksum verification, just clear the
inode and move on.  If we don't do this, we can end up importing a lot
of garbage into the badblocks list, which will then cause fsck to try
to regenerate anything that was sitting atop the supposedly damaged
blocks.  Given that most hardware will remap bad sectors transparently
from ext4, the number of people this could affect adversely is pretty
low.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 3734645..c02f5e9 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1015,8 +1015,10 @@ void e2fsck_pass1(e2fsck_t ctx)
 			struct process_block_struct pb;
 			int flags;
 
-			if ((inode->i_mode || inode->i_uid || inode->i_gid ||
-			     inode->i_links_count || inode->i_file_acl) &&
+			if ((failed_csum || inode->i_mode || inode->i_uid ||
+			     inode->i_gid || inode->i_links_count ||
+			     (inode->i_flags & EXT4_INLINE_DATA_FL) ||
+			     inode->i_file_acl) &&
 			    fix_problem(ctx, PR_1_INVALID_BAD_INODE, &pctx)) {
 				memset(inode, 0, sizeof(struct ext2_inode));
 				e2fsck_write_inode(ctx, ino, inode,

