From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic/250: ignore xfs_io IO errors when writing to
 dmerror device
Date: Wed, 25 May 2016 12:43:07 +0800
Message-ID: <20160525044307.GV5140@eguan.usersys.redhat.com>
References: <1464096276-28407-1-git-send-email-eguan@redhat.com>
 <20160524182136.GA4592@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160524182136.GA4592@birch.djwong.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 24, 2016 at 11:21:36AM -0700, Darrick J. Wong wrote:
> On Tue, May 24, 2016 at 09:24:36PM +0800, Eryu Guan wrote:
> > When testing with data=journal ext4, direct write to dmerror device
> > doesn't return EIO, because ext4 turns direct write to buffered write in
> > data=journal mode and all data is written to journal buffer. The write
> > only fails later when commiting journal and error messages can be seen
> > in dmesg.
> > 
> > As the test is checking on the md5 checksum of the test file, it's ok to
> > ignore the IO error returned by xfs_io, as long as the checksums match
> > the golden image.
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> > 
> > Not returning errors to userspace properly is kind of an ext4 bug in journal
> > mode, but ext4 always behaves this way. So I think instead of fixing ext4, this
> > is the easiest way to make generic/250 work with journal mode ext4.
> 
> /me wonders why _require_odirect doesn't _notrun in situations where we
> *know* ahead of time that we're not going to get O_DIRECT semantics, but
> whatever.  It's no big deal if we shuffle the -EIO message to seqres.full.

I think that's because direct write falls back to buffered write
silently on journal mode ext4, so the _require_odirect check returns
pass.

> 
> >  tests/generic/250     | 3 ++-
> >  tests/generic/250.out | 1 -
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tests/generic/250 b/tests/generic/250
> > index 6d15de2..891b8b0 100755
> > --- a/tests/generic/250
> > +++ b/tests/generic/250
> > @@ -83,7 +83,8 @@ echo "CoW and unmount"
> 
> Er... that should be 'echo "Write and unmount"', oops, sorry about that.
> There's no COW going on here.

I can fix that in v2 :)

Thanks,
Eryu
> 
> --D
> 
> >  $XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
> >  sync
> >  _dmerror_load_error_table
> > -$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 >> $seqres.full
> > +$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $testdir/file2 \
> > +	>> $seqres.full 2>&1
> >  _dmerror_load_working_table
> >  _dmerror_unmount
> >  _dmerror_mount
> > diff --git a/tests/generic/250.out b/tests/generic/250.out
> > index 710c80e..0ff87d0 100644
> > --- a/tests/generic/250.out
> > +++ b/tests/generic/250.out
> > @@ -4,7 +4,6 @@ Create the original files
> >  Compare files
> >  ec8bb3b24d5b0f1b5bdf8c8f0f541ee6  SCRATCH_MNT/test-250/file2
> >  CoW and unmount
> > -pwrite64: Input/output error
> >  Compare files
> >  3ed86318f4ff8da26c1c2a6e3041f9be  SCRATCH_MNT/test-250/file2
> >  Check for damage
> > -- 
> > 2.5.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
