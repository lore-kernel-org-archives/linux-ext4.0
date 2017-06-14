From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 29/31] ext4: reserve space for xattr entries/names
Date: Wed, 14 Jun 2017 10:23:26 -0700
Message-ID: <20170614172326.18670-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

New ea_inode feature allows putting large xattr values into external
inodes. struct ext4_xattr_entry and the attribute name however have to
remain in the inode extra space or external attribute block. Once that
space is exhausted, no further entries can be added. Some of that space
could also be used by values that fit in there at the time of addition.

So, a single xattr entry whose value barely fits in the external block
could prevent further entries being added.

To mitigate the problem, this patch introduces a notion of reserve in
the
external attribute block that cannot be used by value data. This reserve
is enforced when ea_inode feature is enabled. The amount of reserve is
arbitrarily chosen to be min(block_size/8, 1024). The table below shows
how much space is reserved for each block size and the guaranteed
mininum
number of entries that can be placed in the external attribute block.

block size     reserved bytes  entries (name length = 16)
 1k            128              3
 2k            256              7
 4k            512             15
 8k            1024            31
16k            1024            31
32k            1024            31
64k            1024            31

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 3ad1fc62cbf0..c9579d220a0c 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1428,6 +1428,12 @@ static int ext4_xattr_inode_lookup_create(handle_t *handle, struct inode *inode,
 	return 0;
 }
 
+/*
+ * Reserve min(block_size/8, 1024) bytes for xattr entries/names if ea_inode
+ * feature is enabled.
+ */
+#define EXT4_XATTR_BLOCK_RESERVE(inode)	min(i_blocksize(inode)/8, 1024U)
+
 static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 				struct ext4_xattr_search *s,
 				handle_t *handle, struct inode *inode)
@@ -1487,6 +1493,20 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 			ret = -ENOSPC;
 			goto out;
 		}
+
+		/*
+		 * If storing the value in an external inode is an option,
+		 * reserve space for xattr entries/names in the external
+		 * attribute block so that a long value does not occupy the
+		 * whole space and prevent futher entries being added.
+		 */
+		if (ext4_has_feature_ea_inode(inode->i_sb) && new_size &&
+		    (s->end - s->base) == i_blocksize(inode) &&
+		    (min_offs + old_size - new_size) <
+					EXT4_XATTR_BLOCK_RESERVE(inode)) {
+			ret = -ENOSPC;
+			goto out;
+		}
 	}
 
 	/*
-- 
2.13.1.508.gb3defc5cc-goog
