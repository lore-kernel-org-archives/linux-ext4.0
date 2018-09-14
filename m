From: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH v2 1/3] ext4, dax: add ext4_bmap to ext4_dax_aops
Date: Fri, 14 Sep 2018 08:51:12 -0600
Message-ID: <20180914145114.11122-2-toshi.kani@hpe.com>
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

Ext4 mount path calls .bmap to the journal inode. This currently
works for the DAX mount case because ext4_iget() always set
'ext4_da_aops' to any regular files.

In preparation to fix ext4_iget() to set 'ext4_dax_aops' for ext4
DAX files, add ext4_bmap() to 'ext4_dax_aops'. .bmap works for
DAX inodes. [1]

[1]: https://lkml.org/lkml/2018/9/12/803
Fixes: 5f0663bb4a64 ("ext4, dax: introduce ext4_dax_aops")
Signed-off-by: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Suggested-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 fs/ext4/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d0dd585add6a..e4acaa980467 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3948,6 +3948,7 @@ static const struct address_space_operations ext4_dax_aops = {
 	.writepages		= ext4_dax_writepages,
 	.direct_IO		= noop_direct_IO,
 	.set_page_dirty		= noop_set_page_dirty,
+	.bmap			= ext4_bmap,
 	.invalidatepage		= noop_invalidatepage,
 };
