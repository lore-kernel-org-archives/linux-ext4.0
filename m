From: Christoph Hellwig <hch@lst.de>
Subject: iomap preparations for GFS2 v2
Date: Thu, 14 Jun 2018 14:04:51 +0200
Message-ID: <20180614120457.28285-1-hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
	Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Return-path: <cluster-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

Hi all,

this is a slight rework of the patches from Andreas to prepare for gfs2
using the iomap code.

Note: I'd like to start with an immutable branch for iomap patches in either
the XFS tree or a tree of mine at the beginning of the merge window so that
we have a common base for the GFS2 and XFS iomap work.

Changes since v1:
 - move code to a different spot in iomap.c to prefer for readpages
   inline data support
 - add a forward declaration for struct page to iomap.h
 - fix a typo in the dax_dev/bdev unioning
 - fix a comment typo
