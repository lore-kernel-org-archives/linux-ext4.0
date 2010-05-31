From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 34/53] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode
Date: Sun, 30 May 2010 22:49:47 -0400
Message-ID: <1275274206-3900-34-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44645 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496Ab0EaCuW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:22 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit b684b2ee9409f2890a8b3aea98525bbe5f84e276 upstream (as of v2.6.34-git13)

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
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
CC: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 016d024..66fa0b0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -375,6 +375,8 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	case EXT4_IOC_GROUP_ADD:
 		break;
+	case EXT4_IOC_MOVE_EXT:
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
1.6.6.1.1.g974db.dirty

