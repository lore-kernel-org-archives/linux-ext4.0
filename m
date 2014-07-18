From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/24] debugfs: allow bmap to allocate blocks
Date: Fri, 18 Jul 2014 15:52:43 -0700
Message-ID: <20140718225243.31374.87869.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35405 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762724AbaGRWws (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:52:48 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow set_inode_field's bmap command in debugfs to allocate blocks,
which enables us to allocate blocks for indirect blocks and internal
extent tree blocks.  True, we could do this manually, but seems like
unnecessary bookkeeping activity for humans.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/set_fields.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index b4ca546..c5f865e 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -556,8 +556,9 @@ static errcode_t parse_bmap(struct field_set_info *info,
 	}
 
 	retval = ext2fs_bmap2(current_fs, set_ino,
-			     (struct ext2_inode *) &set_inode,
-			     NULL, BMAP_SET, array_idx, NULL, &blk);
+			      (struct ext2_inode *) &set_inode,
+			      NULL, BMAP_ALLOC | BMAP_SET, array_idx, NULL,
+			      &blk);
 	if (retval) {
 		com_err("set_inode", retval, "while setting block map");
 	}

