From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Reserve FEATURE_RO_COMPAT and INO flag
Date: Thu, 25 Apr 2013 16:39:20 +0200
Message-ID: <1366900760-18899-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab3DYOjY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Apr 2013 10:39:24 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3PEdNvK007120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 25 Apr 2013 10:39:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT4_FEATURE_RO_COMPAT_REPLICA and EXT4_REPLICA_INO are reserved in
e2fsprogs for non-upstream feature. However it has never been reserved
in kernel, fix this. Thanks to Radek Pazdera to pointing it out.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3b83cd6..6369c28 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -241,6 +241,7 @@ struct ext4_io_submit {
 #define EXT4_UNDEL_DIR_INO	 6	/* Undelete directory inode */
 #define EXT4_RESIZE_INO		 7	/* Reserved group descriptors inode */
 #define EXT4_JOURNAL_INO	 8	/* Journal inode */
+#define EXT4_REPLICA_INO	 10	/* Used by non-upstream feature */
 
 /* First non-reserved inode for old ext4 filesystems */
 #define EXT4_GOOD_OLD_FIRST_INO	11
@@ -1481,6 +1482,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
  * GDT_CSUM bits are mutually exclusive.
  */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
+/* Reserved for non-upstream feature */
+#define EXT4_FEATURE_RO_COMPAT_REPLICA		0x0800
 
 #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
-- 
1.7.7.6

