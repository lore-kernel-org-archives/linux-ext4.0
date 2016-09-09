From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: XFS reflink and getfsmap/scrub development git trees updated again
Date: Thu, 8 Sep 2016 22:24:13 -0700
Message-ID: <20160909052413.GD9314@birch.djwong.org>
References: <20160905053317.GA15302@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-xfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
	Brian Foster <bfoster@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20160905053317.GA15302@birch.djwong.org>
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

Hi everyone,

I've just rebased the reflink patches against kernel 4.8-rc5 and the xfsprogs
dev branch:

https://github.com/djwong/linux/tree/for-dave-for-4.9-2
https://github.com/djwong/xfsprogs/tree/for-dave-for-4.9-2

These branches should contain /only/ the patches needed to get reflink working:
no fsmap ioctl, no online scrub, and no realtime rmapbt.  I'm publishing these
branches in the hopes of getting wider testing prior to the merge window.  I
haven't heard any complaints for several weeks now.  The only changes since
4.9-1 are to take care of all the comments that Christoph has sent up to
this point.

-----------

For the latest development branch, check out the djwong-wtf branches on github:
https://github.com/djwong/linux/tree/djwong-wtf
https://github.com/djwong/xfsprogs/tree/djwong-wtf

This contains all the latest reflink patches, the reworked GETFSMAP ioctl,
and the latest online scrubbing code.  The scraggly deadlock avoidance fixes
I mentioned in the last posting are now integrated properly into the patch
series.  Also, btree left/right sibling pointer checks have been implemented.

(Adding Ted and the ext4 list because Ted expressed interest in GETFSMAP.)

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
