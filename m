From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 3/3] xfs: reject removal of realtime flag when datadev
 doesn't support DAX
Date: Thu, 15 Feb 2018 10:42:44 -0700
Message-ID: <151871656418.27617.17216472781436196968.stgit@djiang5-desk3.ch.intel.com>
References: <151871644696.27617.4390718895806529377.stgit@djiang5-desk3.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <151871644696.27617.4390718895806529377.stgit-Cxk7aZI4ujnJARH06PadV2t3HXsI98Cx0E9HWUfgJXw@public.gmane.org>
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

In a situation where the rt_dev is DAX and data_dev is not DAX, if the user
requests to remove the realtime flag via ioctl we can no longer support DAX
for that file. Dynamic changing of S_DAX on the inode is not supported due
to various complications in the existing implementation. Therefore until we
address the dynamic S_DAX change issues, we must disallow realtime flag
being removed.

Signed-off-by: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 fs/xfs/xfs_ioctl.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a6a0efc35c76..a2728f803e26 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1030,6 +1030,21 @@ xfs_ioctl_setattr_xflags(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	uint64_t		di_flags2;
+	struct inode		*inode = VFS_I(ip);
+	struct super_block	*sb = inode->i_sb;
+
+	/*
+	 * In the case that the inode is realtime, and we are trying to remove
+	 * the realtime flag, and the rtdev supports DAX but the datadev does
+	 * not support DAX, we can't allow the realtime flag to be removed
+	 * since we do not support dynamic S_DAX flag removal yet.
+	 */
+	if ((XFS_IS_REALTIME_INODE(ip)) &&
+	    !(fa->fsx_xflags & FS_XFLAG_REALTIME) &&
+	    bdev_dax_supported(sb, mp->m_rtdev_targp->bt_bdev,
+		    sb->s_blocksize) &&
+	    !bdev_dax_supported(sb, mp->m_ddev_targp->bt_bdev, sb->s_blocksize))
+		return -ENOTSUPP;
 
 	/* Can't change realtime flag if any extents are allocated. */
 	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
