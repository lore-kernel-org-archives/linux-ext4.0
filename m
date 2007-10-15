From: Coly Li <coyli@suse.de>
Subject: [PATCH][e2fsprogs] extend bg_itable_unused into 32bit
Date: Mon, 15 Oct 2007 15:34:35 +0800
Message-ID: <4713180B.5080000@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39823 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbXJOHcQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2007 03:32:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Current bg_itable_unused in ext2_group_desc and ext4_group_desc is 16bit, which can present 64K
inode offset in inodes table at most. For 4KB ext4 block, the inode bitmap can present 32K inodes in
inodes table at most.

It is very easy to encounter this size limitation in future ext4 development -- we need to extend
this field into 32bit for ext4.

In latest e2fsprogs git, it seems only adding a bg_itable_unused_hi in struct ext4_group_desc is OK
(do not interfere current e2fsprogs and kernel code).

Signed-off-by: Coly Li <coyli@suse.de>
---

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..2aeb6d4 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -167,7 +167,7 @@ struct ext4_group_desc
 	__u16	bg_free_blocks_count_hi;/* Free blocks count MSB */
 	__u16	bg_free_inodes_count_hi;/* Free inodes count MSB */
 	__u16	bg_used_dirs_count_hi;	/* Directories count MSB */
-	__u16   bg_pad;
+	__u16	bg_itable_unused_hi;	/* Unused inodes count MSB */
 	__u32	bg_reserved2[3];
 };


-- 
Coly Li
SuSE PRC Labs
