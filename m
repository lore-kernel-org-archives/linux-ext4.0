From: Salman Qazi <sqazi@google.com>
Subject: [PATCH 2/2] ext4: remove mb_groups before tearing buddy_cache
Date: Tue, 29 May 2012 16:36:14 -0700
Message-ID: <20120529233614.12259.28652.stgit@dungbeetle.mtv.corp.google.com>
References: <20120529233422.12259.959.stgit@dungbeetle.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@google.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:47741 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab2E2XgQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2012 19:36:16 -0400
Received: by bkty5 with SMTP id y5so266491bkt.1
        for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 16:36:15 -0700 (PDT)
In-Reply-To: <20120529233422.12259.959.stgit@dungbeetle.mtv.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We can't have references held on pages in the s_buddy_cache while we are
trying to truncate its pages and put the inode.  All the pages must be
gone before we reach clear_inode.  This can only be gauranteed if we
can prevent new users from grabbing references to s_buddy_cache's pages.

The original bug can be reproduced and the bug fix can be verified by:

while true; do mount -t ext4 /dev/ram0 /export/hda3/ram0; \
	umount /export/hda3/ram0; done &

while true; do cat /proc/fs/ext4/ram0/mb_groups; done

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 fs/ext4/mballoc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5c315ab..6b0a57e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2517,6 +2517,9 @@ int ext4_mb_release(struct super_block *sb)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct kmem_cache *cachep = get_groupinfo_cache(sb->s_blocksize_bits);
 
+	if (sbi->s_proc)
+		remove_proc_entry("mb_groups", sbi->s_proc);
+
 	if (sbi->s_group_info) {
 		for (i = 0; i < ngroups; i++) {
 			grinfo = ext4_get_group_info(sb, i);
@@ -2564,8 +2567,6 @@ int ext4_mb_release(struct super_block *sb)
 	}
 
 	free_percpu(sbi->s_locality_groups);
-	if (sbi->s_proc)
-		remove_proc_entry("mb_groups", sbi->s_proc);
 
 	return 0;
 }

