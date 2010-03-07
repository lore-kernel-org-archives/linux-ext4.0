From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode
Date: Sun, 7 Mar 2010 21:32:10 +0100
Message-ID: <201003072132.10579.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:47542 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab0CGUcO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Mar 2010 15:32:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have an x86_64 kernel with i386 userspace. e4defrag fails on the
EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
case. It seems that struct move_extent is compat save, only types
with fixed widths are used:
{
        __u32 reserved;         /* should be zero */
        __u32 donor_fd;         /* donor file descriptor */
        __u64 orig_start;       /* logical start offset in block for orig */
        __u64 donor_start;      /* logical start offset in block for donor */
        __u64 len;              /* block length to be moved */
        __u64 moved_len;        /* moved block length */
};

Lets just wire up EXT4_IOC_MOVE_EXT for the compat case.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
CCed: Akira Fujita <a-fujita@rs.jp.nec.com> 

---
 fs/ext4/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -375,6 +375,8 @@ long ext4_compat_ioctl(struct file *file
 		break;
 	case EXT4_IOC_GROUP_ADD:
 		break;
+	case EXT4_IOC_MOVE_EXT:
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
