From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: disable defrag for metadata_csum file systems
Date: Thu, 18 Apr 2013 17:58:02 -0400
Message-ID: <1366322282-4673-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42698 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936231Ab3DRV6U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Apr 2013 17:58:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It looks like there is absolutely no support for metadata checksums in
fs/ext4/move_extent.c.  So if you try to defrag a file on a
metadata_csum, it leaves the file system corrupted.

We really, really should get this fixed ASAP, but until we do, let's
disable e4defrag on metadata_csum file systems so we avoid corrupting
file systems.

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ioctl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 9491ac0..2d043da 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -450,6 +450,15 @@ group_extend_out:
 			goto mext_out;
 		}
 
+		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+			ext4_msg(sb, KERN_ERR,
+				 "Online defrag not supported with "
+				 "metadata_csum");
+			err = -EOPNOTSUPP;
+			goto mext_out;
+		}
+
 		err = mnt_want_write_file(filp);
 		if (err)
 			goto mext_out;
-- 
1.7.12.rc0.22.gcdd159b

