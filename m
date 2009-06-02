From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH-e2fsprogs] filefrag: accept positive ioctl return value
Date: Tue, 2 Jun 2009 08:59:14 -0400
Message-ID: <20090602125914.GT31943@mit.edu>
References: <1243944761-18673-1-git-send-email-bergwolf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51004 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbZFBM7V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:59:21 -0400
Content-Disposition: inline
In-Reply-To: <1243944761-18673-1-git-send-email-bergwolf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 02, 2009 at 08:12:41PM +0800, Peng Tao wrote:
> Some ioctl() returns non-negative value on success. filefrag_fiemap should
> treat positive ioctl() return values as success.
> This can be triggered by running filefrag on btrfs partitions.

Thanks for reporting this!

It turns out that wasn't the only bug in that code; the syscall
infrastructure will take a negative return value and maps that to -1,
and moves the (negative) error code to a positive value in errno.  So
the more appropriate patch is as follows.

						- Ted

commit e78968f7a42fb1fa75c356dd323d957b307b887f
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Jun 2 08:45:22 2009 -0400

    filefrag: Fix error checking for the fiemap ioctl
    
    Thanks to Peng Tao for reporting this problem.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 80ac05c..7095949 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -201,15 +201,14 @@ int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 		fiemap->fm_flags = flags;
 		fiemap->fm_extent_count = count;
 		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
-		if (rc == -EBADR) {
-			if (fiemap_incompat_printed == 0) {
+		if (rc < 0) {
+			if (errno == EBADR && fiemap_incompat_printed == 0) {
 				printf("FIEMAP failed with unsupported "
 				       "flags %x\n", fiemap->fm_flags);
 				fiemap_incompat_printed = 1;
 			}
-		}
-		if (rc)
 			return rc;
+		}
 
 		if (!verbose) {
 			*num_extents = fiemap->fm_mapped_extents;
