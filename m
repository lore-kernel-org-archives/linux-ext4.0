From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/18] ext2: Avoid DAX zeroing to corrupt data
Date: Mon, 18 Apr 2016 23:35:28 +0200
Message-ID: <1461015341-20153-6-git-send-email-jack@suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	linux-mm@kvack.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm@lists.01.org,
	Matthew Wilcox <willy@linux.intel.com>,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1461015341-20153-1-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Currently ext2 zeroes any data blocks allocated for DAX inode however it
still returns them as BH_New. Thus DAX code zeroes them again in
dax_insert_mapping() which can possibly overwrite the data that has been
already stored to those blocks by a racing dax_io(). Avoid marking
pre-zeroed buffers as new.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 6bd58e6ff038..1f07b758b968 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -745,11 +745,11 @@ static int ext2_get_blocks(struct inode *inode,
 			mutex_unlock(&ei->truncate_mutex);
 			goto cleanup;
 		}
-	}
+	} else
+		set_buffer_new(bh_result);
 
 	ext2_splice_branch(inode, iblock, partial, indirect_blks, count);
 	mutex_unlock(&ei->truncate_mutex);
-	set_buffer_new(bh_result);
 got_it:
 	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
 	if (count > blocks_to_boundary)
-- 
2.6.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
