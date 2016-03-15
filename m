From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/2] generic: test I/O on dm error device
Date: Tue, 15 Mar 2016 16:02:14 +0800
Message-ID: <20160315080214.GQ11419@eguan.usersys.redhat.com>
References: <1457710822-30532-1-git-send-email-eguan@redhat.com>
 <1457710822-30532-2-git-send-email-eguan@redhat.com>
 <20160315024616.GC30721@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160315024616.GC30721@dastard>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 15, 2016 at 01:46:16PM +1100, Dave Chinner wrote:
> On Fri, Mar 11, 2016 at 11:40:22PM +0800, Eryu Guan wrote:
> > This is a test that performs simple I/O on dm error device, which
> > returns EIO on all I/O request.
> > 
> > This is motivated by an ext4 bug that crashes kernel on error path when
> > trying to update atime. Following kernel patch should fix the issue
> > 
> >   ext4: fix NULL pointer dereference in ext4_mark_inode_dirty()
> 
> Why does this test require the loop device? Why can't you just
> unmount the filesystem, run 'blkdev --flushbufs <dev>' to ensure
> there are no cached buffers/pages on the block device, then mount
> it again?

Yes, 'blockdev --flushbufs <dev>' works, and I found that I only need to
add a blockdev call before dropping caches. This makes the code much
cleaner and easier to read, perhaps the first patch can be dropped as
well. I'll send out v2 shortly. Thanks for the review!

Eryu
