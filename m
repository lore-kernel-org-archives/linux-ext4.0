From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: remove redundant last-group check after ext2fs_group_last_block2
Date: Wed, 20 Jul 2011 16:49:59 -0500
Message-ID: <4E274D87.2040403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab1GTVuA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jul 2011 17:50:00 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6KLo0CV001299
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 17:50:00 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p6KLnxsc000944
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 17:49:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_group_last_block2() already properly calculates
the last block in the last group, so there is no need
to special-case this after the call.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index 7929cd9..7b68af4 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -53,8 +53,6 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
 			first_block = ext2fs_group_first_block2(fs, i);
 			last_block = ext2fs_group_last_block2(fs, i);
-			if (i == (fs->group_desc_count - 1))
-				last_block = ext2fs_blocks_count(fs->super)-1;
 		}
 
 		/*

