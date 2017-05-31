From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 14/28] ext4: fix ext4_xattr_make_inode_space() value size calculation
Date: Wed, 31 May 2017 01:15:03 -0700
Message-ID: <20170531081517.11438-14-tahsin@google.com>
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

ext4_xattr_make_inode_space() is interested in calculating the inline
space used in an inode. When a xattr entry refers to an external inode
the value size indicates the external inode size, not the value size in
the inline area. Change the function to take this into account.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 681a9b5eefd8..6a6bee246873 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1747,9 +1747,10 @@ static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
 		last = IFIRST(header);
 		/* Find the entry best suited to be pushed into EA block */
 		for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
-			total_size =
-			EXT4_XATTR_SIZE(le32_to_cpu(last->e_value_size)) +
-					EXT4_XATTR_LEN(last->e_name_len);
+			total_size = EXT4_XATTR_LEN(last->e_name_len);
+			if (!last->e_value_inum)
+				total_size += EXT4_XATTR_SIZE(
+					       le32_to_cpu(last->e_value_size));
 			if (total_size <= bfree &&
 			    total_size < min_total_size) {
 				if (total_size + ifree < isize_diff) {
@@ -1768,8 +1769,10 @@ static int ext4_xattr_make_inode_space(handle_t *handle, struct inode *inode,
 		}
 
 		entry_size = EXT4_XATTR_LEN(entry->e_name_len);
-		total_size = entry_size +
-			EXT4_XATTR_SIZE(le32_to_cpu(entry->e_value_size));
+		total_size = entry_size;
+		if (!entry->e_value_inum)
+			total_size += EXT4_XATTR_SIZE(
+					      le32_to_cpu(entry->e_value_size));
 		error = ext4_xattr_move_to_block(handle, inode, raw_inode,
 						 entry);
 		if (error)
-- 
2.13.0.219.gdb65acc882-goog
