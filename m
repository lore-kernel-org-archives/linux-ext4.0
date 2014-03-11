From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/49] resize2fs: add inline dirs for remapping
Date: Mon, 10 Mar 2014 23:55:27 -0700
Message-ID: <20140311065527.30585.97471.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21395 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaCKGzb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:55:31 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're looking for directory blocks for the inode remapping step,
we need to include inline_data directories in the remap process.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 7122b2f..f5f1337 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1712,6 +1712,13 @@ remap_blocks:
 				retval = pb.error;
 				goto errout;
 			}
+		} else if ((inode->i_flags & EXT4_INLINE_DATA_FL) &&
+			   (rfs->bmap || pb.is_dir)) {
+			/* inline data dir; update it too */
+			retval = ext2fs_add_dir_block2(rfs->old_fs->dblist,
+						       new_inode, 0, 0);
+			if (retval)
+				goto errout;
 		}
 	}
 	io_channel_flush(rfs->old_fs->io);

