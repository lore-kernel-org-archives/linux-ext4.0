From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.34.y 27/28] ext4: Fix compat EXT4_IOC_ADD_GROUP
Date: Tue,  1 Jun 2010 12:13:14 -0400
Message-ID: <1275408795-17487-27-git-send-email-tytso@mit.edu>
References: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56872 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab0FAQNV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 12:13:21 -0400
In-Reply-To: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Ben Hutchings <ben@decadent.org.uk>

commit 4d92dc0f00a775dc2e1267b0e00befb783902fe7 upstream (as of v2.6.34-git13)

struct ext4_new_group_input needs to be converted because u64 has
only 32-bit alignment on some 32-bit architectures, notably i386.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |   16 ++++++++++++++++
 fs/ext4/ioctl.c |   25 +++++++++++++++++++++++--
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0419018..2e31640 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -29,6 +29,9 @@
 #include <linux/wait.h>
 #include <linux/blockgroup_lock.h>
 #include <linux/percpu_counter.h>
+#ifdef __KERNEL__
+#include <linux/compat.h>
+#endif
 
 /*
  * The fourth extended filesystem constants/structures
@@ -409,6 +412,18 @@ struct ext4_new_group_input {
 	__u16 unused;
 };
 
+#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
+struct compat_ext4_new_group_input {
+	u32 group;
+	compat_u64 block_bitmap;
+	compat_u64 inode_bitmap;
+	compat_u64 inode_table;
+	u32 blocks_count;
+	u16 reserved_blocks;
+	u16 unused;
+};
+#endif
+
 /* The struct ext4_new_group_input in kernel space, with free_blocks_count */
 struct ext4_new_group_data {
 	__u32 group;
@@ -486,6 +501,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC32_GETRSVSZ		_IOR('f', 5, int)
 #define EXT4_IOC32_SETRSVSZ		_IOW('f', 6, int)
 #define EXT4_IOC32_GROUP_EXTEND		_IOW('f', 7, unsigned int)
+#define EXT4_IOC32_GROUP_ADD		_IOW('f', 8, struct compat_ext4_new_group_input)
 #ifdef CONFIG_JBD2_DEBUG
 #define EXT4_IOC32_WAIT_FOR_READONLY	_IOR('f', 99, int)
 #endif
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 66fa0b0..6ddec84 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -373,8 +373,29 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC32_SETRSVSZ:
 		cmd = EXT4_IOC_SETRSVSZ;
 		break;
-	case EXT4_IOC_GROUP_ADD:
-		break;
+	case EXT4_IOC32_GROUP_ADD: {
+		struct compat_ext4_new_group_input __user *uinput;
+		struct ext4_new_group_input input;
+		mm_segment_t old_fs;
+		int err;
+
+		uinput = compat_ptr(arg);
+		err = get_user(input.group, &uinput->group);
+		err |= get_user(input.block_bitmap, &uinput->block_bitmap);
+		err |= get_user(input.inode_bitmap, &uinput->inode_bitmap);
+		err |= get_user(input.inode_table, &uinput->inode_table);
+		err |= get_user(input.blocks_count, &uinput->blocks_count);
+		err |= get_user(input.reserved_blocks,
+				&uinput->reserved_blocks);
+		if (err)
+			return -EFAULT;
+		old_fs = get_fs();
+		set_fs(KERNEL_DS);
+		err = ext4_ioctl(file, EXT4_IOC_GROUP_ADD,
+				 (unsigned long) &input);
+		set_fs(old_fs);
+		return err;
+	}
 	case EXT4_IOC_MOVE_EXT:
 		break;
 	default:
-- 
1.6.6.1.1.g974db.dirty

