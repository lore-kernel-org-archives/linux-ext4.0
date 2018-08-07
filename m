From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] ext4: Close race between direct IO and
 ext4_break_layouts()
Date: Tue, 07 Aug 2018 15:11:37 -0700
Message-ID: <153367989755.37314.6889218648604435494.stgit@djiang5-desk3.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 hch-jcswGhMUV9g@public.gmane.org
To: tytso-3s7WtUTddSA@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
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

From: Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

If the refcount of a page is lowered between the time that it is returned
by dax_busy_page() and when the refcount is again checked in
ext4_break_layouts() => ___wait_var_event(), the waiting function
ext4_wait_dax_page() will never be called.  This means that
ext4_break_layouts() will still have 'retry' set to false, so we'll stop
looping and never check the refcount of other pages in this inode.

Instead, always continue looping as long as dax_layout_busy_page() gives us
a page which it found with an elevated refcount.

Note that this works around the race exposed by my unit test, but I think
that there is another race that needs to be addressed, probably with
additional synchronization added between direct I/O and
{ext4,xfs}_break_layouts().

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/ext4/inode.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8f6ad7667974..d2663a1e3ec2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4191,9 +4191,8 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
 	return 0;
 }
 
-static void ext4_wait_dax_page(struct ext4_inode_info *ei, bool *did_unlock)
+static void ext4_wait_dax_page(struct ext4_inode_info *ei)
 {
-	*did_unlock = true;
 	up_write(&ei->i_mmap_sem);
 	schedule();
 	down_write(&ei->i_mmap_sem);
@@ -4203,14 +4202,12 @@ int ext4_break_layouts(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct page *page;
-	bool retry;
 	int error;
 
 	if (WARN_ON_ONCE(!rwsem_is_locked(&ei->i_mmap_sem)))
 		return -EINVAL;
 
 	do {
-		retry = false;
 		page = dax_layout_busy_page(inode->i_mapping);
 		if (!page)
 			return 0;
@@ -4218,8 +4215,8 @@ int ext4_break_layouts(struct inode *inode)
 		error = ___wait_var_event(&page->_refcount,
 				atomic_read(&page->_refcount) == 1,
 				TASK_INTERRUPTIBLE, 0, 0,
-				ext4_wait_dax_page(ei, &retry));
-	} while (error == 0 && retry);
+				ext4_wait_dax_page(ei));
+	} while (error == 0);
 
 	return error;
 }
