From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH][RESEND]  xfstests: only run generic/300 on filesystems
 supporting
Date: Sat, 21 Sep 2013 17:59:27 -0400
Message-ID: <20130921215927.GD7855@wallace>
References: <20130906194243.GA19286@wallace>
 <522A3254.3090704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52834 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab3IUV7c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Sep 2013 17:59:32 -0400
Received: by mail-qa0-f49.google.com with SMTP id k15so583844qaq.8
        for <linux-ext4@vger.kernel.org>; Sat, 21 Sep 2013 14:59:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <522A3254.3090704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Eric Sandeen <sandeen@redhat.com>:
> On 9/6/13 2:42 PM, Eric Whitney wrote:
> > Generic/300 fails when run on a test filesystem that does not support
> > fallocate(), as in the case of an ext4 filesystem created without the
> > extent feature.  It uses fio's falloc ioengine to generate part of its
> > I/O load.
> > 
> > Verify that the test filesystem supports fallocate() before proceeding
> > with the test.  Also, delete any pre-existing test output to avoid
> > confusion with old results.
> 
> Hey Eric - sorry this got missed for review.
> 
> Since the test doesn't actually use xfs_io it seems like slightly the
> wrong check, maybe we need a new _require_fio_falloc()?
> 
> But xfs_io will almost always be installed for someone running
> xfstests, and the check as you have it will indeed test that the fs
> can do fallocate; it's just not the most targeted test.
> 
> It's probably ok, though - a comment about why you _require_xfs_io
> when xfs_io isn't used might be good.
> 
> What do you think?
> 

Hi Eric:

Sorry for my late reply.

I agree that the scope of _require_xfs_io_falloc is larger than what we
really need here.  However, after looking for other possible users of a
_require_fio_falloc and not finding others, I think adding the comment you
suggest sounds like the way to go for now.  I'm willing to add a function
tailored to fio (implemented and tested same), but that looks like it would
add some fairly redundant code that would only be used by one caller.  And,
you're quite right that you really need xfsprogs in place to use xfstest 
anyway - there are more than 20 tests that require xfs_io to run generic
xfstests on ext4.

More work revealed that I also need to add a call to
_require_xfs_io_falloc_punch.  Ext4 filesystems created with the bigalloc
feature don't support hole punching but do support allocation with fallocate().

I've got a tested V2 patch I'll post shortly.

Also, I discovered that generic/299 needs some similar treatment.  It's
using the fallocate command to generate a background load, but is failing
silently while reporting success when run against an ext4 filesystem created
without the extent feature (ext3 emulation).  This tends to point out the
problem with implementing a _require_<command>_falloc function for each
new command that test scripts want to use to generate I/O - they could
multiply quickly.

At any rate, I'm planning to get out a patch for generic/299 as well.

Thanks,
Eric

> 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > ---
> >  tests/generic/300 |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/tests/generic/300 b/tests/generic/300
> > index 7c60728..1ac763b 100755
> > --- a/tests/generic/300
> > +++ b/tests/generic/300
> > @@ -43,6 +43,9 @@ _supported_fs generic
> >  _supported_os Linux
> >  _need_to_be_root
> >  _require_scratch
> > +_require_xfs_io_falloc
> > +
> > +rm -f $seqres.full
> >  
> >  NUM_JOBS=$((4*LOAD_FACTOR))
> >  BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> > 
> 
