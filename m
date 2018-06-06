From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/6] fs: factor out a
	__generic_write_end helper
Date: Wed, 6 Jun 2018 12:59:06 +0200
Message-ID: <20180606105906.GA11821@lst.de>
References: <20180606104033.4947-1-hch@lst.de>
	<20180606104033.4947-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
	Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Return-path: <cluster-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180606104033.4947-2-hch@lst.de>
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

On Wed, Jun 06, 2018 at 12:40:28PM +0200, Christoph Hellwig wrote:
> Bits of the buffer.c based write_end implementations that don't know
> about buffer_heads and can be reused by other implementations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This actually already had two reviews:

Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

That got lost through the detour via gfs2.
