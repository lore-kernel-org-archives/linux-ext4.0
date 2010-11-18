From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 4/6] Ext4: fail if we try to use hole punch
Date: Wed, 17 Nov 2010 20:46:18 -0500
Message-ID: <1290044780-2902-5-git-send-email-josef@redhat.com>
References: <1290044780-2902-1-git-send-email-josef@redhat.com>
To: david@fromorbit.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
	cluster-dev
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1290044780-2902-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4 doesn't have the ability to punch holes yet, so make sure we return
EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
be added later.  Thanks,

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/ext4/extents.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0554c48..35bca73 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3622,6 +3622,10 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 	struct ext4_map_blocks map;
 	unsigned int credits, blkbits = inode->i_blkbits;
 
+	/* We only support the FALLOC_FL_KEEP_SIZE mode */
+	if (mode && (mode != FALLOC_FL_KEEP_SIZE))
+		return -EOPNOTSUPP;
+
 	/*
 	 * currently supporting (pre)allocate mode for extent-based
 	 * files _only_
-- 
1.6.6.1
