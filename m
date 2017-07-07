From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v4 1/3] ext4: Add missing locking around iomap_seek_{hole,data}
Date: Fri,  7 Jul 2017 23:27:59 +0200
Message-ID: <1499462881-4238-2-git-send-email-agruenba@redhat.com>
References: <1499462881-4238-1-git-send-email-agruenba@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1499462881-4238-1-git-send-email-agruenba@redhat.com>
In-Reply-To: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
References: <CAHc6FU4u+G1gtZVr3CUbJi2i+GwWhfDUOZemQ4Nnde=uiOmjXA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add back the inode locking that "ext4: Switch to iomap for SEEK_HOLE /
SEEK_DATA" blew away.  We can use inode_lock_shared instead of
inode_lock instead, though.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/ext4/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 02bbf2c..699a676 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -459,10 +459,14 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 		return generic_file_llseek_size(file, offset, whence,
 						maxbytes, i_size_read(inode));
 	case SEEK_HOLE:
+		inode_lock_shared(inode);
 		offset = iomap_seek_hole(inode, offset, &ext4_iomap_ops);
+		inode_unlock_shared(inode);
 		break;
 	case SEEK_DATA:
+		inode_lock_shared(inode);
 		offset = iomap_seek_data(inode, offset, &ext4_iomap_ops);
+		inode_unlock_shared(inode);
 		break;
 	}
 
-- 
2.7.5
