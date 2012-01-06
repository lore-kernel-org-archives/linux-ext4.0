From: Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH] ext4: release donor reference when EXT4_IOC_MOVE_EXT ioctl
 fails
Date: Fri, 6 Jan 2012 22:50:13 +0100
Message-ID: <20120106215013.GA27957@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from numidia.opendz.org ([98.142.220.152]:60120 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab2AFVrS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jan 2012 16:47:18 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When the EXT4_IOC_MOVE_EXT ioctl() fails on bigalloc file systems, we
should jump to the 'mext_out' label to release the donor file reference.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/ext4/ioctl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a567968..034e147 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -237,7 +237,8 @@ setversion_out:
 			       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
 			ext4_msg(sb, KERN_ERR,
 				 "Online defrag not supported with bigalloc");
-			return -EOPNOTSUPP;
+			err = -EOPNOTSUPP;
+			goto mext_out;
 		}
 
 		err = mnt_want_write(filp->f_path.mnt);
-- 
1.7.1
