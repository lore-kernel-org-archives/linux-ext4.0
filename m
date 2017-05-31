From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 12/28] ext4: add missing le32_to_cpu(e_value_inum) conversions
Date: Wed, 31 May 2017 01:15:01 -0700
Message-ID: <20170531081517.11438-12-tahsin@google.com>
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

Two places in code missed converting xattr inode number using
le32_to_cpu().

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 8e855fc2eb03..4dd8be16d175 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1997,6 +1997,7 @@ ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 	struct ext4_inode *raw_inode;
 	struct ext4_iloc iloc;
 	struct ext4_xattr_entry *entry;
+	unsigned int ea_ino;
 	int credits = 3, error = 0;
 
 	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
@@ -2011,8 +2012,8 @@ ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 	     entry = EXT4_XATTR_NEXT(entry)) {
 		if (!entry->e_value_inum)
 			continue;
-		if (ext4_expand_ino_array(lea_ino_array,
-					  entry->e_value_inum) != 0) {
+		ea_ino = le32_to_cpu(entry->e_value_inum);
+		if (ext4_expand_ino_array(lea_ino_array, ea_ino) != 0) {
 			brelse(iloc.bh);
 			goto cleanup;
 		}
@@ -2044,8 +2045,8 @@ ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 	     entry = EXT4_XATTR_NEXT(entry)) {
 		if (!entry->e_value_inum)
 			continue;
-		if (ext4_expand_ino_array(lea_ino_array,
-					  entry->e_value_inum) != 0)
+		ea_ino = le32_to_cpu(entry->e_value_inum);
+		if (ext4_expand_ino_array(lea_ino_array, ea_ino) != 0)
 			goto cleanup;
 		entry->e_value_inum = 0;
 	}
-- 
2.13.0.219.gdb65acc882-goog
