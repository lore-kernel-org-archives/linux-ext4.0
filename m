From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH resend] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode
Date: Fri, 12 Mar 2010 08:01:51 +0100
Message-ID: <201003120801.51249.borntraeger@de.ibm.com>
References: <201003072132.10579.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	Eric Sandeen <sandeen@redhat.com>
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201003072132.10579.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted, can you consider this patch for ext4?

From: Christian Borntraeger <borntraeger@de.ibm.com>

I have an x86_64 kernel with i386 userspace. e4defrag fails on the
EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
case. It seems that 
struct move_extent is compat save, only types with fixed widths are used.
{
        __u32 reserved;         /* should be zero */
        __u32 donor_fd;         /* donor file descriptor */
        __u64 orig_start;       /* logical start offset in block for orig */
        __u64 donor_start;      /* logical start offset in block for donor */
        __u64 len;              /* block length to be moved */
        __u64 moved_len;        /* moved block length */
};


Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Akira Fujita <a-fujita@rs.jp.nec.com> 

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
