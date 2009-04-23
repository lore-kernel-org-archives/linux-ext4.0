From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Fix potential inode allocation soft lockup in Orlov allocator
Date: Wed, 22 Apr 2009 21:30:57 -0400
Message-ID: <1240450257-26045-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:57501 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZDWBbA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Apr 2009 21:31:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the Orlov allocator is having trouble finding an appropriate block
group, the fallback code could loop forever, causing a soft lockup
warning in find_group_orlov():

BUG: soft lockup - CPU#0 stuck for 61s! [cp:11728]
     ...
Pid: 11728, comm: cp Not tainted (2.6.30-rc1-dirty #77) Lenovo
EIP: 0060:[<c021650e>] EFLAGS: 00000246 CPU: 0
EIP is at ext4_get_group_desc+0x54/0x9d
    ...
Call Trace:
 [<c0218021>] find_group_orlov+0x2ee/0x334
 [<c0120a5f>] ? sched_clock+0x8/0xb
 [<c02188e3>] ext4_new_inode+0x2cf/0xb1a

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ialloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index cbce5aa..f18e0a0 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -585,6 +585,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 fallback:
 	ngroups = sbi->s_groups_count;
 	avefreei = freei / ngroups;
+fallback_retry:
 	parent_group = EXT4_I(parent)->i_block_group;
 	for (i = 0; i < ngroups; i++) {
 		grp = (parent_group + i) % ngroups;
@@ -602,7 +603,7 @@ fallback:
 		 * filesystems the above test can fail to find any blockgroups
 		 */
 		avefreei = 0;
-		goto fallback;
+		goto fallback_retry;
 	}
 
 	return -1;
-- 
1.5.6.3

