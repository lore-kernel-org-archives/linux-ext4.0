From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] ext4: ext4_mb_initialize_context() forgets to initialize some
	fields
Date: Fri, 10 Jul 2009 16:47:54 -0400
Message-ID: <20090710204754.18406.15771.stgit@mj.roinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36060 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZGJUsC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jul 2009 16:48:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

kmemcheck indicates that ext4_mb_store_histroy() accesses uninitialized
values of ac->ac_tail and ac->ac_buddy.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 fs/ext4/mballoc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 519a0a6..a5a9a35 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4223,6 +4223,8 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	ac->ac_groups_scanned = 0;
 	ac->ac_ex_scanned = 0;
 	ac->ac_found = 0;
+	ac->ac_tail = 0;
+	ac->ac_buddy = 0;
 	ac->ac_sb = sb;
 	ac->ac_inode = ar->inode;
 	ac->ac_o_ex.fe_logical = ar->logical;
