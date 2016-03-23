From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2] generic: test I/O on dm error device
Date: Wed, 23 Mar 2016 12:14:42 +0800
Message-ID: <20160323041442.GO11419@eguan.usersys.redhat.com>
References: <1457710822-30532-2-git-send-email-eguan@redhat.com>
 <1458029534-17578-1-git-send-email-eguan@redhat.com>
 <20160323025327.GZ11812@dastard>
 <20160323032531.GN11419@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160323032531.GN11419@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 23, 2016 at 11:25:31AM +0800, Eryu Guan wrote:
> On Wed, Mar 23, 2016 at 01:53:27PM +1100, Dave Chinner wrote:
> > On Tue, Mar 15, 2016 at 04:12:14PM +0800, Eryu Guan wrote:
> > > This is a test that performs simple I/O on dm error device, which
> > > returns EIO on all I/O request.
> > > 
> > > This is motivated by an ext4 bug that crashes kernel on error path when
> > > trying to update atime. Following kernel patch should fix the issue
> > > 
> > >   ext4: fix NULL pointer dereference in ext4_mark_inode_dirty()
> > > 
> > > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > > ---
> > 
> > Fails with:
> > 
> > @@ -1,2 +1,6 @@
> >  QA output created by 338
> >   Silence is golden
> >   +specified blocksize 1024 is less than device physical sector size 4096
> >   +switching to logical sector size 512
> >   +mkfs.xfs: /dev/mapper/error-test appears to contain an existing filesystem (xfs).
> >   +mkfs.xfs: Use the -f option to force overwrite.
> > 
> > And then it failed to clean up properly and caused all sorts of
> > subsequent problems.
> 
> Test passed for me, seems it has something to do with the "physical
> sector size 4096" device. I'll look into it. Thanks for the review!

It fails because "_mkfs_dev $DMERROR_DEV" refuses to create new fs
without "-f" option, has nothing to do with the 4k sector device. It
passed for me is because I add "-f" mkfs option to my local.config for
xfs sections, so _mkfs_dev passed. I'll send v3 to fix this.

And the test fails to do cleanups on failure because "dmsetup remove
error-test" reports device is busy. Adding a "$UDEV_SETTLE_PROG" call 
before "dmsetup remove error-test" in common/dmerror fixes the issue for
me. I'll send another patch to fix it.

Thanks,
Eryu
