From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/12] block: test fallocate for block devices
Date: Tue, 15 Mar 2016 01:34:37 -0700
Message-ID: <20160315083437.GB8802@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
	<20160305003837.28738.49794.stgit@birch.djwong.org>
	<20160305182508.GA25528@infradead.org>
	<20160315034148.GF30721@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org,
	xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20160315034148.GF30721@dastard>
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

On Tue, Mar 15, 2016 at 02:41:48PM +1100, Dave Chinner wrote:
> I think it's the right place to test it - we have all the
> infrastructure available to do it (i.e. xfs_io and various block
> devices) and we really need to make sure this stuff works,
> especially if we start to write filesystem code that depends on
> correct behaviour...

Ok.  But let's keep it outside of the auto group so we don't run purely
block device specific tests every time we do an xfstests run.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
