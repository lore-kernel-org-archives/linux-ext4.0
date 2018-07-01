From: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>
Subject: [PATCH 2/3] fs/ext2/inode: Fix a type cast error for fsdax
Date: Sun,  1 Jul 2018 14:18:47 +0800
Message-ID: <20180701061848.7036-2-yehs2007@zoho.com>
References: <20180701061848.7036-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180701061848.7036-1-yehs2007-ytc+IHgoah0@public.gmane.org>
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

From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>

The type of offset within struct iomap is loff_t, which represents
file offset of mapping.

In ext2_iomap_begin, iomap->offset shall be given a type cast as
loff_t instead of u64.

Signed-off-by: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
---
 fs/ext2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 7163590..ca211bd 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -816,7 +816,7 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 
 	iomap->flags = 0;
 	iomap->bdev = inode->i_sb->s_bdev;
-	iomap->offset = (u64)first_block << blkbits;
+	iomap->offset = (loff_t)first_block << blkbits;
 	iomap->dax_dev = sbi->s_daxdev;
 
 	if (ret == 0) {
-- 
1.8.3.1
