From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/18] xfs: use generic posix ACL infrastructure
Date: Tue, 3 Dec 2013 10:34:44 +1100
Message-ID: <20131202233444.GH10988@dastard>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120656.194735588@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
	linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Joel Becker <jlbec@evilplan.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20131201120656.194735588@bombadil.infradead.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Sun, Dec 01, 2013 at 03:59:17AM -0800, Christoph Hellwig wrote:
> Also create inodes with the proper mode instead of fixing it up later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup work, Christoph.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
