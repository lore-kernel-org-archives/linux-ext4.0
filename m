From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 08/28] ext4: fix ref counting for ea_inode
Date: Wed, 31 May 2017 01:14:57 -0700
Message-ID: <20170531081517.11438-8-tahsin@google.com>
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

The ref count on ea_inode is incremented by
ext4_xattr_inode_orphan_add() which is supposed to be decremented by
ext4_xattr_inode_array_free(). The decrement is conditioned on whether
the ea_inode is currently on the orphan list. However, the orphan list
addition only happens when journaling is enabled. In non-journaled case,r
we fail to release the ref count causing an error message like below.

"VFS: Busy inodes after unmount of sdb. Self-destruct in 5 seconds.
Have a nice day..."

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 32ad2f2870e9..13daf634244b 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2098,8 +2098,7 @@ ext4_xattr_inode_array_free(struct inode *inode,
 		if (err)
 			continue;
 		/* for inode's i_count get from ext4_xattr_delete_inode */
-		if (!list_empty(&EXT4_I(ea_inode)->i_orphan))
-			iput(ea_inode);
+		iput(ea_inode);
 		clear_nlink(ea_inode);
 		iput(ea_inode);
 	}
-- 
2.13.0.219.gdb65acc882-goog
