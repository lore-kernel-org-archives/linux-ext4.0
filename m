From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 1/2] ext4: Conditionally define compat ioctl numbers
Date: Fri, 21 May 2010 00:30:22 +0100
Message-ID: <1274398223.2257.0.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39918 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab0ETXaa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 May 2010 19:30:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It is unnecessary, and in general impossible, to define the compat
ioctl numbers except when building the filesystem with CONFIG_COMPAT
defined.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/ext4.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf938cf..f5c9941 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -398,6 +398,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
 
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
  * ioctl commands in 32 bit emulation
  */
@@ -413,6 +414,7 @@ struct ext4_new_group_data {
 #endif
 #define EXT4_IOC32_GETVERSION_OLD	FS_IOC32_GETVERSION
 #define EXT4_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
+#endif
 

 /*
-- 
1.7.1



