From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 17/28] ext4: fix credits calculation for xattr inode
Date: Wed, 31 May 2017 01:15:06 -0700
Message-ID: <20170531081517.11438-17-tahsin@google.com>
References: <20170531081517.11438-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170531081517.11438-1-tahsin@google.com>
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
2.13.0.219.gdb65acc882-goog
