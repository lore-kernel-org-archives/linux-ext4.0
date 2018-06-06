From: Christoph Hellwig <hch@lst.de>
Subject: iomap preparations for GFS2
Date: Wed,  6 Jun 2018 12:40:27 +0200
Message-ID: <20180606104033.4947-1-hch@lst.de>
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
using the iomap code.  I'd like to start with an immutable branch for
iomap patches in either the XFS tree or a tree of mine own with something
like this so that we can have a nice common base for both the major
iomap changes for XFS and the GFS2 work.
