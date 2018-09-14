From: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH v2 3/3] ext2, dax: set ext2_dax_aops for dax files
Date: Fri, 14 Sep 2018 08:51:14 -0600
Message-ID: <20180914145114.11122-4-toshi.kani@hpe.com>
References: <20180914145114.11122-1-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso-3s7WtUTddSA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jack-AlSwsSmVLrQ@public.gmane.org,
	dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180914145114.11122-1-toshi.kani-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

Sync syscall to DAX file needs to flush processor cache, but it
currently does not flush to existing DAX files.  This is because
'ext2_da_aops' is set to address_space_operations of existing DAX
files, instead of 'ext2_dax_aops', since S_DAX flag is set after
ext2_set_aops() in the open path.

Similar to ext4, change ext2_iget() to initialize i_flags before
ext2_set_aops().

Fixes: fb094c90748f ("ext2, dax: introduce ext2_dax_aops")
Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Suggested-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 fs/ext2/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 7f7ee18fe179..e4bb9386c045 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1448,6 +1448,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 	}
 	inode->i_blocks = le32_to_cpu(raw_inode->i_blocks);
 	ei->i_flags = le32_to_cpu(raw_inode->i_flags);
+	ext2_set_inode_flags(inode);
 	ei->i_faddr = le32_to_cpu(raw_inode->i_faddr);
 	ei->i_frag_no = raw_inode->i_frag;
 	ei->i_frag_size = raw_inode->i_fsize;
@@ -1517,7 +1518,6 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 			   new_decode_dev(le32_to_cpu(raw_inode->i_block[1])));
 	}
 	brelse (bh);
-	ext2_set_inode_flags(inode);
 	unlock_new_inode(inode);
 	return inode;
 	
