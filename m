From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] ext4: fix big-endian bug in extent migration code
Date: Wed, 10 Apr 2013 00:02:26 -0400
Message-ID: <1365566549-23325-1-git-send-email-tytso@mit.edu>
References: <20130410040151.GB4862@thunk.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130410040151.GB4862@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c1c0094..fa85ce8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4760,7 +4760,7 @@ int ext4_ind_migrate(struct inode *inode)
 	eh = ext_inode_hdr(inode);
 	ex  = EXT_FIRST_EXTENT(eh);
 	if (ext4_blocks_count(es) > EXT4_MAX_BLOCK_FILE_PHYS ||
-	    eh->eh_depth != 0 || eh->eh_entries > 1) {
+	    eh->eh_depth != 0 || le16_to_cpu(eh->eh_entries) > 1) {
 		ret = -EOPNOTSUPP;
 		goto errout;
 	}
-- 
1.7.12.rc0.22.gcdd159b
