From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libext2fs: write only core inode in update_path()
Date: Tue, 16 Jun 2009 19:57:59 -0500
Message-ID: <4A383F97.1080002@redhat.com>
References: <4A381EC8.4010202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49200 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbZFQA56 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Jun 2009 20:57:58 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n5H0w1JU029281
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2009 20:58:01 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5H0w0E9025953
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2009 20:58:01 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n5H0vxVs027267
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2009 20:58:00 -0400
In-Reply-To: <4A381EC8.4010202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:

> I've been tearing my hair out all day on this and not getting anywhere
> yet, so punting to the list ;)
>
>
>   
Well, here's one problem.  I'm waiting for the reporter to confirm 
whether it fixes the bug.  I think it likely does but will report
back tomorrow.  Anyway patch follows, thanks valgrind!



libext2fs: write only core inode in update_path()

The ext2_extent_handle only has a struct ext2_inode allocated on
it, and the same amount copied into it in that same function, 
but in update_path() we're possibly writing out more than that - 
for example 256 bytes, from that address.  This causes uninitialized 
memory to get  written to disk, overwriting the parts of the 
inode past the osd2 member (the end of the smaller structure).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index b7eb617..0dfee62 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -547,7 +547,7 @@ static errcode_t update_path(ext2_extent_handle_t handle)
 
 	if (handle->level == 0) {
 		retval = ext2fs_write_inode_full(handle->fs, handle->ino,
-			   handle->inode, EXT2_INODE_SIZE(handle->fs->super));
+			   handle->inode, sizeof(struct ext2_inode));
 	} else {
 		ix = handle->path[handle->level - 1].curr;
 		blk = ext2fs_le32_to_cpu(ix->ei_leaf) +


