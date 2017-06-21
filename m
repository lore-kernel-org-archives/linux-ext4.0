From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 17/32] ext4: fix credits calculation for xattr inode
Date: Wed, 21 Jun 2017 14:21:27 -0700
Message-ID: <20170621212142.16581-17-tahsin@google.com>
References: <20170621212142.16581-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When there is no space for a value in xattr block, it may be stored
in an xattr inode even if the value length is less than
EXT4_XATTR_MIN_LARGE_EA_SIZE(). So the current assumption in credits
calculation is wrong.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 739f73a5a345..dcf7ec98f138 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1590,8 +1590,7 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 	if (error)
 		return error;
 
-	if ((value_len >= EXT4_XATTR_MIN_LARGE_EA_SIZE(sb->s_blocksize)) &&
-	    ext4_has_feature_ea_inode(sb)) {
+	if (ext4_has_feature_ea_inode(sb)) {
 		int nrblocks = (value_len + sb->s_blocksize - 1) >>
 					sb->s_blocksize_bits;
 
-- 
2.13.1.611.g7e3b11ae1-goog
