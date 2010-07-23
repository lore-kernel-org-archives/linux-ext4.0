From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 240: test non-aligned AIO hole-filling
Date: Fri, 23 Jul 2010 20:12:22 +1000
Message-ID: <20100723101222.GH32635@dastard>
References: <4C489676.2000605@redhat.com>
 <20100723024938.GD32635@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:35601 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753718Ab0GWKMa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jul 2010 06:12:30 -0400
Content-Disposition: inline
In-Reply-To: <20100723024938.GD32635@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 23, 2010 at 12:49:38PM +1000, Dave Chinner wrote:
> On Thu, Jul 22, 2010 at 02:05:26PM -0500, Eric Sandeen wrote:
> > This replicates file corruption we've seen with qemu-kvm when
> > we use if=virtio,cache=none,aio=native for IO to a sparse
> > ext4- or xfs-hosted file, and the partitions/filesystems
> > within that file image are not block-aligned.  (think sector
> > 63 here...)  This results in AIO IOs not aligned to the
> > filesystem blocks.
> > 
> > This test modifies aiodio_sparse2.c to add an option to start
> > the file IO at an offset.
> > 
> > When we do 4k writes to a 16k file in 2 threads, starting
> > at offset 512, we get 0s interspersed in the file where they
> > should not be:
> > 
> > 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 00000200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
> > *
> > 00001000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > *
> > 00001200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
> > ....
> > 
> > Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> looks good - it needs to remove the $TEST_DIR/aiodio_sparse file
> before the test starts, though, so that repeated tests fail
> correctly. Otherwise:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Also, Eric, can you run this proof-of-concept test branch (on top of
> the current XFS for-2.6.36 branch) and see if QEMU is happy with it?
> It passes this test on my machine....
> 
> The following changes since commit d2ec2c790b3994bf0c4381cacc489b514705887c:
> 
>   xfs: clean up xfs_bmap_get_bp (2010-07-22 12:52:08 +1000)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev aio-unaligned

I just pushed another patch onto this series that will makes test
240 pass reliably here rather than hanging. It's all a bit messy,
but it does serve to illustrate the problem and a potential avenue
to prevent it....

Dave Chinner (5):
      Merge branch 'master' into working
      Merge branch 'for-2.6.36' into working
      fs: get_blocks needs an unaligned mapping flag
      xfs: serialise unaligned direct IO into unwritten extents
      xfs: wait on IO completion inside an IO context

 fs/buffer.c                 |   17 ++++----
 fs/direct-io.c              |   25 ++++++++++-
 fs/ioctl.c                  |    2 +-
 fs/mpage.c                  |    6 ++-
 fs/xfs/linux-2.6/xfs_aops.c |   95 ++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_inode.h          |   13 +++---
 include/linux/fs.h          |   10 ++++-
 7 files changed, 136 insertions(+), 32 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
