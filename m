From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] shared/272: fail quickly on mkfs errors and improve
 logging
Date: Tue, 7 Oct 2014 17:01:54 -0400
Message-ID: <20141007210154.GA25094@wallace>
References: <20140930195004.GB5803@wallace>
 <20141003043611.GK24490@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:40883 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaJGVCD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2014 17:02:03 -0400
Content-Disposition: inline
In-Reply-To: <20141003043611.GK24490@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Dave Chinner <david@fromorbit.com>:
> On Tue, Sep 30, 2014 at 03:50:04PM -0400, Eric Whitney wrote:
> > 272 will log diagnostic information if it fails to make its scratch file
> > system, but the test itself won't fail immediately.  If the scratch
> > device had previously contained a valid filesystem, and the attempt to
> > make a small scratch file system on it fails, 272 will mount and run on
> > the pre-existing file system (as seen during ext4 inline data testing).
> > Since 272 tests to ENOSPC, it can take a long time to learn mkfs failed.
> > This behavior can also lead to invalid positive test results unless
> > 272.full is examined separately.
> > 
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > ---
> >  tests/shared/272 | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tests/shared/272 b/tests/shared/272
> > index 4417535..9695e59 100755
> > --- a/tests/shared/272
> > +++ b/tests/shared/272
> > @@ -87,8 +87,11 @@ _supported_os Linux
> >  _need_to_be_root
> >  _require_scratch
> >  
> > -_scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seqres.full 2>&1
> > -_scratch_mount
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs_sized $((64 * 1024 * 1024)) >> $seqres.full 2>&1 \
> > +	|| _fail "mkfs failed"
> > +_scratch_mount >> $seqres.full 2>&1 || _fail "mount failed"
> 
> Let's not have an unending stream of patches to make this same
> change to every test that calls _scratch_mkfs or scratch_mount.

That's not what I had in mind.

About a half dozen tests don't indicate failure on completion if their
initial attempt to create a scratch file system fails.  This set of
tests is further distinguished by their use of small scratch file systems
less than 512 MB in size.  There's an ext4 file system feature which is
guaranteed to make that fail unless an option is set externally to xfstests,
and it's easy to overlook that requirement (as it has been).  I'd hoped to
make it easier to detect these failures without adding ext4-specific noise.

I noticed that generic/077 and generic/083 both detected and reported these
mkfs failures, and the six tests of interest did not.  I applied the mkfs
error handling pattern used by those two (and numerous other) tests in the
patches I posted in hopes that represented an acceptable approach.

> 
> If you need more debug output from them if they fail, please put it
> inside the low level _scratch_mkfs_$FSTYP functions themselves, as
> they already capture errors and dump debug to $seqres.full.

I'm aware of that.  We already have what we need.  Unfortunately, generic/015
redirects that information to /dev/null.

> 
> And we've had the discussion in the past about failing if
> scratch_mkfs fails. It came down on the side of "unless there's a
> specific reason for failing the test, it should still run to give us
> as much coverage as possible". e.g  a failed mkfs can result in the
> test exercising error paths being exercised that wouldn't otherwise
> be tested....

Was the conclusion that the test should also indicate successful execution
in this case?  The tests I'm patching return a zero exit status after
mkfs fails.  Detecting failures then requires a manual review of the
$seqres.full files, assuming that they log failures there - not very
convenient in an automated test environment. 

There is another cleaner way to address mkfs failures used in some xfstests -
avoid redirecting the output from mkfs, capture it in the test output, and
allow it to generate a miscompare with the golden output on error.  I didn't
choose to go that way on concern that some filesystems' mkfs programs might
generate output on success for some tests that would spoil the output (the
simple existence of the pattern I followed was reason for that).

> 
> The case you have here (filling the fs can take ages) is a good
> reason for terminating the test if _scratch_mkfs_sized fails, but in
> general we really want the tests to run if at all possible...

Generic/027 is another one - would a mkfs fail fast patch have a chance of
acceptance?

I'm not interested in adding unwanted clutter to tests, but I would like to
think a test has actually passed and tested what it claims to when it reports
success.  Running on a pre-existing scratch file system built with 
undetermined features and options after a mkfs failure without obvious warning
isn't consistent with that.

Eric


> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
