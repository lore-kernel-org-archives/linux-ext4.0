From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 23/42] ext4: Renumber EXT4_IOC_MIGRATE
Date: Thu,  9 Oct 2008 00:05:41 -0400
Message-ID: <1223525160-9887-24-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
 <1223525160-9887-6-git-send-email-tytso@mit.edu>
 <1223525160-9887-7-git-send-email-tytso@mit.edu>
 <1223525160-9887-8-git-send-email-tytso@mit.edu>
 <1223525160-9887-9-git-send-email-tytso@mit.edu>
 <1223525160-9887-10-git-send-email-tytso@mit.edu>
 <1223525160-9887-11-git-send-email-tytso@mit.edu>
 <1223525160-9887-12-git-send-email-tytso@mit.edu>
 <1223525160-9887-13-git-send-email-tytso@mit.edu>
 <1223525160-9887-14-git-send-email-tytso@mit.edu>
 <1223525160-9887-15-git-send-email-tytso@mit.edu>
 <1223525160-9887-16-git-send-email-tytso@mit.edu>
 <1223525160-9887-17-git-send-email-tytso@mit.edu>
 <1223525160-9887-18-git-send-email-tytso@mit.edu>
 <1223525160-9887-19-git-send-email-tytso@mit.edu>
 <1223525160-9887-20-git-send-email-tytso@mit.edu>
 <1223525160-9887-21-git-send-email-tytso@mit.edu>
 <1223525160-9887-22-git-send-email-tytso@mit.edu>
 <1223525160-9887-23-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54495 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757541AbYJIEGM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:12 -0400
In-Reply-To: <1223525160-9887-23-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Pick an ioctl number for EXT4_IOC_MIGRATE that won't conflict with
other ext4 ioctl's.  Since there haven't been any major userspace
users of this ioctl, we can afford to change this now, to avoid
potential problems later.

Also, reorder the ioctl numbers in ext4.h to avoid this sort of
mistake in the future.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 068adc1..50a4846 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -291,8 +291,6 @@ struct ext4_new_group_data {
 #define	EXT4_IOC_SETFLAGS		FS_IOC_SETFLAGS
 #define	EXT4_IOC_GETVERSION		_IOR('f', 3, long)
 #define	EXT4_IOC_SETVERSION		_IOW('f', 4, long)
-#define EXT4_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
-#define EXT4_IOC_GROUP_ADD		_IOW('f', 8, struct ext4_new_group_input)
 #define	EXT4_IOC_GETVERSION_OLD		FS_IOC_GETVERSION
 #define	EXT4_IOC_SETVERSION_OLD		FS_IOC_SETVERSION
 #ifdef CONFIG_JBD2_DEBUG
@@ -300,7 +298,10 @@ struct ext4_new_group_data {
 #endif
 #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
-#define EXT4_IOC_MIGRATE		_IO('f', 7)
+#define EXT4_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
+#define EXT4_IOC_GROUP_ADD		_IOW('f', 8, struct ext4_new_group_input)
+#define EXT4_IOC_MIGRATE		_IO('f', 9)
+ /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
 
 /*
  * ioctl commands in 32 bit emulation
-- 
1.5.6.1.205.ge2c7.dirty

