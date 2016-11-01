From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 10/11] ext2: Use iomap_zero_range() for zeroing truncated page
 in DAX path
Date: Tue,  1 Nov 2016 22:06:20 +0100
Message-ID: <1478034381-19037-11-git-send-email-jack@suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ted Tso <tytso-3s7WtUTddSA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1478034381-19037-1-git-send-email-jack-AlSwsSmVLrQ@public.gmane.org>
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

Currently the last user of ext2_get_blocks() for DAX inodes was
dax_truncate_page(). Convert that to iomap_zero_range() so that all DAX
IO uses the iomap path.

Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/ext2/inode.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 335cd1e1f902..b723666124a7 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -846,6 +846,9 @@ struct iomap_ops ext2_iomap_ops = {
 	.iomap_begin		= ext2_iomap_begin,
 	.iomap_end		= ext2_iomap_end,
 };
+#else
+/* Define empty ops for !CONFIG_FS_DAX case to avoid ugly ifdefs */
+struct iomap_ops ext2_iomap_ops;
 #endif /* CONFIG_FS_DAX */
 
 int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
@@ -1289,9 +1292,11 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 
 	inode_dio_wait(inode);
 
-	if (IS_DAX(inode))
-		error = dax_truncate_page(inode, newsize, ext2_get_block);
-	else if (test_opt(inode->i_sb, NOBH))
+	if (IS_DAX(inode)) {
+		error = iomap_zero_range(inode, newsize,
+					 PAGE_ALIGN(newsize) - newsize, NULL,
+					 &ext2_iomap_ops);
+	} else if (test_opt(inode->i_sb, NOBH))
 		error = nobh_truncate_page(inode->i_mapping,
 				newsize, ext2_get_block);
 	else
-- 
2.6.6
