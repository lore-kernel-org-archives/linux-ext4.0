From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Wed, 07 Mar 2012 18:40:52 -0500
Message-ID: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


We've recently discovered a workload at Google where the page
stablization patches (specifically commit 0e499890c1f: ext4: wait for
writeback to complete while making pages writable) resulted in a
**major** performance regression.  As in, kernel threads that were
writing to log files were getting hit by up to 2 seconds stalls, which
very badly hurt a particular application.  Reverting this commit fixed
the performance regression.

The main reason for the page stablizatoin patches was for DIF/DIX
support, right?   So I'm wondering if we should just disable the calls
to wait_on_page_writeback if CONFIG_BLKDEV_INTEGRITY is not defined.
i.e., something like this.

What do people think?  I have a feeling this is going to be very
controversial....

					- Ted

ext4: Disable page stablization if DIF/DIX not enabled

Requiring processes which are writing to files which are under writeback
until the writeback is complete can result in massive performance hits.
This is especially true if writes are being throttled due to I/O cgroup
limits and the application is running on an especially busy server.

If CONFIG_BLKDEV_INTEGRITY is not enabled, disable page stablization,
since that's the main case where this is needed, and page stablization
can be very painful.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/buffer.c b/fs/buffer.c
index 1a30db7..d25c60f 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2333,7 +2333,9 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
+#ifdef CONFIG_BLKDEV_INTEGRITY
 	wait_on_page_writeback(page);
+#endif
 	return 0;
 out_unlock:
 	unlock_page(page);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5f8081c..01f86c5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4638,8 +4638,10 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (page_has_buffers(page)) {
 		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
 					ext4_bh_unmapped)) {
+#ifdef CONFIG_BLKDEV_INTEGRITY
 			/* Wait so that we don't change page under IO */
 			wait_on_page_writeback(page);
+#endif
 			ret = VM_FAULT_LOCKED;
 			goto out;
 		}
