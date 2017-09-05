From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 0/9] add ext4 per-inode DAX flag
Date: Tue,  5 Sep 2017 16:35:32 -0600
Message-ID: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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

The original intent of this series was to add a per-inode DAX flag to ext4
so that it would be consistent with XFS.  In my travels I found and fixed
several related issues in both ext4 and XFS.

I'm not fully happy with the ways that ext4 DAX interacts with conflicting
features (journaling, inline data and encryption).  My goal with this
series was to make all these interactions as consistent as possilble, and
of course to make them safe.  If anyone has ideas for improvements, I'm
very open.

Ross Zwisler (9):
  ext4: remove duplicate extended attributes defs
  xfs: always use DAX if mount option is used
  xfs: validate bdev support for DAX inode flag
  ext4: add ext4_should_use_dax()
  ext4: ext4_change_inode_journal_flag error handling
  ext4: safely transition S_DAX on journaling changes
  ext4: prevent data corruption with inline data + DAX
  ext4: add sanity check for encryption + DAX
  ext4: add per-inode DAX flag

 fs/ext4/ext4.h      | 47 ++++++---------------------------------------
 fs/ext4/ext4_jbd2.h | 16 ++++++++++++++++
 fs/ext4/inline.c    | 10 ----------
 fs/ext4/inode.c     | 45 ++++++++++++++++++++++++-------------------
 fs/ext4/ioctl.c     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/super.c     |  8 ++++++++
 fs/xfs/xfs_ioctl.c  | 14 +++++++++++---
 7 files changed, 119 insertions(+), 76 deletions(-)

-- 
2.9.5
