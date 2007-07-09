From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4-patch-queue rebased to 2.6.22
Date: Mon, 09 Jul 2007 17:15:41 -0400
Message-ID: <1184015741.3864.24.camel@localhost.localdomain>
References: <E1I7xBM-00044G-2v@candygram.thunk.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59667 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759362AbXGJAPk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2007 20:15:40 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6A0FeqF026486
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jul 2007 20:15:40 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6A0Fed5304986
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jul 2007 20:15:40 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6A0FdCU018745
	for <linux-ext4@vger.kernel.org>; Mon, 9 Jul 2007 20:15:39 -0400
In-Reply-To: <E1I7xBM-00044G-2v@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-07-09 at 13:37 -0400, Theodore Ts'o wrote:
> Per our discussion on the call, I've moved the fallocate patches back up
> to the front of the queue, and rebased the syscall numbers to 2.6.22.

I updated the ext4 patch queue.

It seem there is conflict to apply delayed allocation patch, fixed it.

Also I removed the ext4_no_inode_version mount option patch per our
discussion this morning.

At last, applied a few clean ups from Aneesh to the ext4 patch queue.

diff --git a/ext4-fallocate-1-syscall_i386_amd64_ppc
b/ext4-fallocate-1-syscall_i386_amd64_ppc
index 0f88bc9..91a8708 100644
--- a/ext4-fallocate-1-syscall_i386_amd64_ppc
+++ b/ext4-fallocate-1-syscall_i386_amd64_ppc
@@ -221,7 +221,7 @@ Index: linux-2.6.22-rc6/include/asm-x86_64/unistd.h
  __SYSCALL(__NR_timerfd, sys_timerfd)
  #define __NR_eventfd          284
  __SYSCALL(__NR_eventfd, sys_eventfd)
-+#define __NR_fallocate                284
++#define __NR_fallocate                285
 +__SYSCALL(__NR_fallocate, sys_fallocate)
  
  #ifndef __NO_STUBS
diff --git a/ext4-nanosecond-patch b/ext4-nanosecond-patch
index a8fb57e..e792cdd 100644
--- a/ext4-nanosecond-patch
+++ b/ext4-nanosecond-patch
@@ -3,7 +3,7 @@ From: Kalpak Shah <kalpak@clusterfs.com>
 This patch is a spinoff of the old nanosecond patches.

 It includes some cleanups and addition of a creation timestamp. The
-EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
+EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
 s_{min, want}_extra_isize fields in struct ext3_super_block.

 Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
diff --git a/ext4_remove_subdirs_limit.patch
b/ext4_remove_subdirs_limit.patch
index effd545..83f4d5a 100644
--- a/ext4_remove_subdirs_limit.patch
+++ b/ext4_remove_subdirs_limit.patch
@@ -1,4 +1,4 @@
-From: kalpak@clusterfs.com Thu May 17 17:21:08 2007
+From: Kalpak Shah <kalpak@clusterfs.com>
 Hi,


> So we're just waiting for Amit to make the minor on-disk format change
> Andreas suggested before we push to Linus.

Yep.

Thanks,
Mingming
