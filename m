From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] shared/272: fail quickly on mkfs errors and improve
 logging
Date: Wed, 8 Oct 2014 16:23:11 +1100
Message-ID: <20141008052311.GI12693@dastard>
References: <20140930195004.GB5803@wallace>
 <20141003043611.GK24490@dastard>
 <20141007210154.GA25094@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:57361 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbaJHFXP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Oct 2014 01:23:15 -0400
Content-Disposition: inline
In-Reply-To: <20141007210154.GA25094@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 07, 2014 at 05:01:54PM -0400, Eric Whitney wrote:
> * Dave Chinner <david@fromorbit.com>:
> > On Tue, Sep 30, 2014 at 03:50:04PM -0400, Eric Whitney wrote:
> > > 272 will log diagnostic information if it fails to make its scratch file
> > > system, but the test itself won't fail immediately.  If the scratch
> > > device had previously contained a valid filesystem, and the attempt to
> > > make a small scratch file system on it fails, 272 will mount and run on
> > > the pre-existing file system (as seen during ext4 inline data testing).
> > > Since 272 tests to ENOSPC, it can take a long time to learn mkfs failed.
> > > This behavior can also lead to invalid positive test results unless
> > > 272.full is examined separately.
> > > 
> > > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > > ---
> > >  tests/shared/272 | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/tests/shared/272 b/tests/shared/272
> > > index 4417535..9695e59 100755
> > > --- a/tests/shared/272
> > > +++ b/tests/shared/272
> > > @@ -87,8 +87,11 @@ _supported_os Linux
> > >  _need_to_be_root
> > >  _require_scratch
> > >  
> > > -_scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seqres.full 2>&1
> > > -_scratch_mount
> > > +rm -f $seqres.full
> > > +
> > > +_scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seqres.full 2>&1 \
> > > +	|| _fail "mkfs failed"
> > > +_scratch_mount >> $seqres.full 2>&1 || _fail "mount failed"
> > 
> > Let's not have an unending stream of patches to make this same
> > change to every test that calls _scratch_mkfs or scratch_mount.
> 
> That's not what I had in mind.
> 
> About a half dozen tests don't indicate failure on completion if their
> initial attempt to create a scratch file system fails.  This set of
> tests is further distinguished by their use of small scratch file systems
> less than 512 MB in size.

Right - your *general problem* is _scratch_mkfs_sized failing to
make a filesystem of the specified size. And so that sort of
failure should always cause _scratch_mkfs_sized to dump debug to
$seqres.full and fail the test. So, the generic infrastructure
should really do that, yes?

> There's an ext4 file system feature which is
> guaranteed to make that fail unless an option is set externally to xfstests,
> and it's easy to overlook that requirement (as it has been).  I'd hoped to
> make it easier to detect these failures without adding ext4-specific noise.

If there is a problem with mkfs.ext4 doing daft things and failing
randomly (seems to be a recurring theme recently), then
_scratch_mkfs_ext4 needs to detect and handle those failures
appropriately.

If we need to fix _scratch_mkfs_xfs then we'll do that too. And if
we need to check that _scratch_mkfs_sized actually resulted in the
correct sized filesystem then we should check that in
_scratch_mkfs_sized, not every test that calls
_scratch_mkfs_sized....

> I noticed that generic/077 and generic/083 both detected and reported these
> mkfs failures, and the six tests of interest did not.  I applied the mkfs
> error handling pattern used by those two (and numerous other) tests in the
> patches I posted in hopes that represented an acceptable approach.

Many old tests are not consistent in their behaviour and we correct
those as we fix infrastructure over time. So if we make
_scratch_mkfs and friends catch failures, dump debug and abort
tests, then that can be removed from all existing tests....

> > If you need more debug output from them if they fail, please put it
> > inside the low level _scratch_mkfs_$FSTYP functions themselves, as
> > they already capture errors and dump debug to $seqres.full.
> 
> I'm aware of that.  We already have what we need.  Unfortunately, generic/015
> redirects that information to /dev/null.

That's exactly the reason why the generic code should do the right
thing on failure.

> > And we've had the discussion in the past about failing if
> > scratch_mkfs fails. It came down on the side of "unless there's a
> > specific reason for failing the test, it should still run to give us
> > as much coverage as possible". e.g  a failed mkfs can result in the
> > test exercising error paths being exercised that wouldn't otherwise
> > be tested....
> 
> Was the conclusion that the test should also indicate successful execution
> in this case? 

Yes, because if the filesystem behaved correctly then the test
passed regardless of whether mkfs succeed or not.

> There is another cleaner way to address mkfs failures used in some xfstests -
> avoid redirecting the output from mkfs, capture it in the test output, and
> allow it to generate a miscompare with the golden output on error.

Actually, no, we can't, because the output of mkfs.ext4 is not the
same as the output of mkfs.xfs. And, indeed, the output of mkfs.xfs
from version 3.0.x is differen to that of 3.2.x, so all we do is
introduce the need to extensive, complex filtering of mkfs output.
Much easier to have _scratch_mkfs_$FSTYP handle this and have
tests redirect/filter the output in a way that is appropriate to the
scope of the test.

> > The case you have here (filling the fs can take ages) is a good
> > reason for terminating the test if _scratch_mkfs_sized fails, but in
> > general we really want the tests to run if at all possible...
> 
> Generic/027 is another one - would a mkfs fail fast patch have a chance of
> acceptance?

My advocacy of the "fix it in generic code" approach should answer
that question.  i.e. I'm suggesting that we should *always* fail
tests is _scratch_mkfs and friends fails rather than the current
"only fail is the test catches failure"...

Yes, there are a few special tests where we actually are testing for
mkfs failure (e.g xfs/049) but the are old enough that they are
calling things like "mkfs -t ext2" directly and not using any of the
generic infrastructure we've built in the years since those tests
were first written.

It comes down to the fact that I don't like band-aid fixes. Hacking
band-aids into individual tests to solve an immediate problem is an
easy, short-term fix. However, it does nothing to address the
underlying issue and results in having to patch different symptom
sof the same problem repeatedly.  This is just a waste of time and
effort. We know there's a general problem, we know how to fix it and
that it's going to take a little more effort to fix it right now,
but in the long run it will be less effort than appliying bandaids
and then having to do major surgery when the band-aids no longer
stem the bleeding.

Hence I think we should change the default behaviour *of the
infrastructure* and then fix the isolated fallout that will occur.
We did this recently with modifying the check harness to run
_check_scratch_fs after any test that uses the scratch device. We've
then added _require_scratch_nocheck for the few tests where that is
not a sane thing thing to do. That change of behaviour has found
several issues in XFS (both kernel and userspace tools), so it was
the *right thing to do* even though it has caused use a lot more
work in the short term...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
