From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Take 2]e2fsprogs: Undo I/O manager
Date: Fri, 20 Jul 2007 08:35:09 +0530
Message-ID: <46A02665.9090200@linux.vnet.ibm.com>
References: <11848678881380-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20070719212027.GB26752@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:52716 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970AbXGTDFS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Jul 2007 23:05:18 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6K3SOod271198
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 13:28:25 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6K38jlP211038
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 13:08:45 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6K35CPN006921
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 13:05:12 +1000
In-Reply-To: <20070719212027.GB26752@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Theodore Tso wrote:
> On Thu, Jul 19, 2007 at 11:28:06PM +0530, Aneesh Kumar K.V wrote:
>> This patch fixes some bugs found during testing of the large
>> inode migration patches.
> 
> How are you testing it?  I notice you haven't wired these into any of
> the existing e2fsprogs programs.
> 
> Regards,
> 


Attaching below is a simple test program i used to verify this. I also used
this along with the ext3 ext4 migration tool.

-aneesh


diff --git a/test.aneesh/test.c b/test.aneesh/test.c
new file mode 100644
index 0000000..7d0a3e3
--- /dev/null
+++ b/test.aneesh/test.c
@@ -0,0 +1,25 @@
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+
+main(int argc, char *argv[])
+{
+	char *dev_name, *file_name;
+	int flags, superblock = 0;
+	unsigned int block_size = 0;
+	ext2_filsys current_fs = NULL;
+
+	dev_name = argv[1];
+	file_name = argv[2];
+	flags = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_RW;
+	set_undo_io_backing_manager(unix_io_manager);
+	set_undo_io_backup_file(file_name);
+	ext2fs_open2(dev_name, 0,
+			flags, superblock, block_size,
+			undo_io_manager, &current_fs);
+
+	/* Now write super block with junk */
+	memcpy(current_fs->super, "crash me", 8);
+	ext2fs_mark_super_dirty(current_fs);
+	ext2fs_close(current_fs);
+}
