From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2.6.33.y 38/40] ext4: Conditionally define compat ioctl numbers
Date: Tue,  1 Jun 2010 08:03:25 -0400
Message-ID: <1275393807-14369-38-git-send-email-tytso@mit.edu>
References: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47257 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab0FAMDd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 08:03:33 -0400
In-Reply-To: <1275393807-14369-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Ben Hutchings <ben@decadent.org.uk>

commit 899ad0cea6ad7ff4ba24b16318edbc3cbbe03fad upstream (as of v2.6.34-git13)

It is unnecessary, and in general impossible, to define the compat
ioctl numbers except when building the filesystem with CONFIG_COMPAT
defined.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1b4835f..ef12e95 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -468,6 +468,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
 
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
  * ioctl commands in 32 bit emulation
  */
@@ -483,6 +484,7 @@ struct ext4_new_group_data {
 #endif
 #define EXT4_IOC32_GETVERSION_OLD	FS_IOC32_GETVERSION
 #define EXT4_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
+#endif
 
 
 /*
-- 
1.6.6.1.1.g974db.dirty

