From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4 ENOSPC Bug
Date: Tue, 2 Dec 2008 02:57:12 -0500
Message-ID: <20081202075712.GA16172@mit.edu>
References: <200811291418.24672.andres@anarazel.de> <200812011335.00366.andres@anarazel.de> <20081201194204.GZ3186@webber.adilger.int> <200812012116.08510.andres@anarazel.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Cc: Andreas Dilger <adilger@sun.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Andres Freund <andres@anarazel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51510 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750755AbYLBH5Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 02:57:16 -0500
Content-Disposition: inline
In-Reply-To: <200812012116.08510.andres@anarazel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andres,

What we suspect may be happening is that somehow, there is something
in your workload which is causing a leak or a double-increment of the
number of blocks reserved so that delayed allocation will succeed.
Basically, when the system writes to a block that hasn't been
previously allocated by filesystme, we reserve a data block so that
when we finally do the late delayed allocation, we know that a free
block will be available.  When we do finally determine where the block
will be located on the filesystem, we decrement the reserved block
counter.  If somehow the reserved block counter is growing and not
shrinking when it should, that could lead to the problem which you
describe.

So.... could you apply this patch, attached below.  You can trigger it
using the attached program, debug-ioctl.  If the filesystem is
quiscent, and you've typed sync once or twice, you should get the
following in your printk logs:

[ 2742.603886] ext4 debug delalloc of dm-4
[ 2742.603948] ext4: dirty blocks 0 free blocks 7324359
[ 2742.603960] ext4 debug delalloc done

If you do have some dirty blocks that haen't been flushed out to disk,
it might look liket this:

[ 2758.653682] ext4 debug delalloc of dm-4
[ 2758.653697] ext4: dirty blocks 172 free blocks 7324439
[ 2758.653703] s_dirty list:
[ 2758.653708] ino 401167: 79 2
[ 2758.653713] ino 401200: 2 2
[ 2758.653718] ino 401197: 3 2
  	       	   ....
[ 2758.653828] ext4 debug delalloc done

If our theory is correct, I suspect you will start to see the number
of dirty blocks grown over time, even before you start seeing ENOSPC
errors (which will happen when the number of dirty blocks exceeds the
number of free blocks).

In that case, the list of inodes that have data and metadata blocks
reserved will hopefully tell us soemthing about what might be going
on.  Just run the debug-ioctl command giving a filename or directory
within the filesystem where you want to deump out the debugging
information; it will be dumpd out in the dmesg buffer.

							- Ted


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=debug-delalloc-patch

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ba18b81..43f12f6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -313,6 +313,8 @@ struct ext4_new_group_data {
 #define EXT4_IOC_FIEMAP_INO		_IOWR('f', 18, struct fiemap_ino)
 #define EXT4_IOC_MOVE_VICTIM		_IOW('f', 19, struct ext4_extents_info)
 
+#define EXT4_IOC_DEBUG_DELALLOC		_IO('f', 42)
+
 /*
  * ioctl commands in 32 bit emulation
  */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 15050d3..be60cfc 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -18,6 +18,17 @@
 #include "ext4_jbd2.h"
 #include "ext4.h"
 
+static void print_inode_dealloc_info(struct inode *inode)
+{
+	if (!EXT4_I(inode)->i_reserved_data_blocks ||
+	    !EXT4_I(inode)->i_reserved_meta_blocks)
+		return;
+
+	printk(KERN_DEBUG "ino %lu: %u %u\n", inode->i_ino,
+	       EXT4_I(inode)->i_reserved_data_blocks,
+	       EXT4_I(inode)->i_reserved_meta_blocks);
+}
+
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_dentry->d_inode;
@@ -346,6 +357,42 @@ setversion_out:
 		return err;
 	}
 
+	case EXT4_IOC_DEBUG_DELALLOC:
+	{
+		extern spinlock_t inode_lock;
+		struct super_block *sb = inode->i_sb;
+		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+		struct inode *inode;
+		
+		printk(KERN_DEBUG "ext4 debug delalloc of %s\n", sb->s_id);
+		printk(KERN_DEBUG "ext4: dirty blocks %lld free blocks %lld\n",
+		       percpu_counter_sum(&sbi->s_dirtyblocks_counter),
+		       percpu_counter_sum(&sbi->s_freeblocks_counter));
+		spin_lock(&inode_lock);
+		if (!list_empty(&sb->s_dirty)) {
+			printk(KERN_DEBUG "s_dirty list:\n");
+			list_for_each_entry(inode, &sb->s_dirty, i_list) {
+				print_inode_dealloc_info(inode);
+			}
+		}
+		if (!list_empty(&sb->s_io)) {
+			printk(KERN_DEBUG "s_io list:\n");
+			list_for_each_entry(inode, &sb->s_io, i_list) {
+				print_inode_dealloc_info(inode);
+			}
+		}
+		if (!list_empty(&sb->s_more_io)) {
+			printk(KERN_DEBUG "s_more_io list:\n");
+			list_for_each_entry(inode, &sb->s_more_io, i_list) {
+				print_inode_dealloc_info(inode);
+			}
+		}
+		spin_unlock(&inode_lock);
+		printk(KERN_DEBUG "ext4 debug delalloc done\n");
+		return 0;
+	}
+
+
 	default:
 		return -ENOTTY;
 	}
@@ -389,6 +436,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		cmd = EXT4_IOC_SETRSVSZ;
 		break;
 	case EXT4_IOC_GROUP_ADD:
+	case EXT4_IOC_DEBUG_DELALLOC:
 		break;
 	default:
 		return -ENOIOCTLCMD;

--Nq2Wo0NMKNjxTN9z
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="debug-ioctl.c"

/*
 * trigger the debugging ioctl 
 */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/mount.h>

/* For Linux, define BLKFLSBUF if necessary */
#if (!defined(EXT4_IOC_DEBUG_DELALLOC) && defined(__linux__))
#define EXT4_IOC_DEBUG_DELALLOC		_IO('f', 42)
#endif

const char *progname;

static void usage(void)
{
	fprintf(stderr, "Usage: %s disk\n", progname);
	exit(1);
}

int main(int argc, char **argv)
{
	int	fd;

	progname = argv[0];
	if (argc != 2)
		usage();

	fd = open(argv[1], O_RDONLY, 0);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
#ifdef EXT4_IOC_DEBUG_DELALLOC
	if (ioctl(fd, EXT4_IOC_DEBUG_DELALLOC, 0) < 0) {
		perror("ioctl BLKFLSBUF");
		exit(1);
	}
	return 0;
#else
	fprintf(stderr,
		"EXT4_IOC_DEBUG_DELALLOC ioctl not supported!\n");
	return 1;
#endif
}

--Nq2Wo0NMKNjxTN9z--
