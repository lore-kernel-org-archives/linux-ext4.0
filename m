From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/7] ext2: Avoid DAX zeroing to corrupt data
Date: Wed, 11 May 2016 11:58:49 +0200
Message-ID: <1462960733-29634-4-git-send-email-jack@suse.cz>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-nvdimm@lists.01.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1462960733-29634-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently ext2 zeroes any data blocks allocated for DAX inode however it
still returns them as BH_New. Thus DAX code zeroes them again in
dax_insert_mapping() which can possibly overwrite the data that has been
already stored to those blocks by a racing dax_io(). Avoid marking
pre-zeroed buffers as new.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
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

