From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] xfs: don't use ioends for direct write completions
Date: Mon, 8 Feb 2016 08:31:21 +0100
Message-ID: <20160208073121.GA30092@lst.de>
References: <1454524816-11392-1-git-send-email-hch@lst.de> <1454524816-11392-3-git-send-email-hch@lst.de> <20160208010026.GL31407@dastard> <20160208061731.GC27429@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160208061731.GC27429@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Feb 08, 2016 at 05:17:31PM +1100, Dave Chinner wrote:
> Right now this series is in a stable branch in the XFS tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-dio-fix-4.6
> 
> If you want to push it through some other tree, please let me know
> when/where it is committed so I can rebuild the XFS for-next branch
> appropriately from a stable commit/branch...

That's how I think it should be handled.  This would also allow the
ext4 and ocfs2 maintainers to depend on the stable branch to clean
up their direct I/O completion handling in this merge window if they
want to.
