From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 25/37] ext4: use get/put_endian helpers
Date: Thu, 29 May 2008 13:18:51 -0700
Message-ID: <1212092331.28403.127.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-arch <linux-arch@vger.kernel.org>,
	ext-devel <linux-ext4@vger.kernel.org>,
	"Stephen C. Tweedie" <sct@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:41560 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897AbYE2USw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 May 2008 16:18:52 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3083442wfd.4
        for <linux-ext4@vger.kernel.org>; Thu, 29 May 2008 13:18:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/ext4/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 09d9359..fc9959a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3006,8 +3006,8 @@ static int ext4_statfs (struct dentry * dentry, struct kstatfs * buf)
 	buf->f_ffree = percpu_counter_sum_positive(&sbi->s_freeinodes_counter);
 	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT4_NAME_LEN;
-	fsid = le64_to_cpup((void *)es->s_uuid) ^
-	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
+	fsid = get_le64((void *)es->s_uuid) ^
+	       get_le64((void *)es->s_uuid + sizeof(__le64));
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
 	return 0;
-- 
1.5.6.rc0.277.g804cf


