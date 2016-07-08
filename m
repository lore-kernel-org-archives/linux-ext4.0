From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Fri, 8 Jul 2016 14:57:20 +1000
Message-ID: <20160708045720.GM12670@dastard>
References: <1467786171-21127-1-git-send-email-wangshilong1991@gmail.com>
 <20160706233533.GK27480@dastard>
 <d0018d66-cb32-16df-b46e-5c418cc4bfae@sandeen.net>
 <20160708005127.GK12670@dastard>
 <20160708024654.GE19871@thunk.org>
 <77863b4a-95e6-4100-79c2-5cbcaf0872e7@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Wang Shilong <wangshilong1991@gmail.com>,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	sihara@ddn.com, lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:13523 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbcGHE50 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jul 2016 00:57:26 -0400
Content-Disposition: inline
In-Reply-To: <77863b4a-95e6-4100-79c2-5cbcaf0872e7@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 07, 2016 at 10:19:27PM -0500, Eric Sandeen wrote:
> 
> 
> On 7/7/16 9:46 PM, Theodore Ts'o wrote:
> > On Fri, Jul 08, 2016 at 10:51:27AM +1000, Dave Chinner wrote:
> >> On Wed, Jul 06, 2016 at 09:47:28PM -0500, Eric Sandeen wrote:
> >>> On 7/6/16 6:35 PM, Dave Chinner wrote:
> >>>
> >>> ...
> >>>
> >>>>> +_require_scratch
> >>>>> +_require_chattr
> >>>>> +_require_test_lsattr
> >>>>> +_require_quota
> >>>>
> >>>> needs  _require_prjquota, and that function needs to be modified to
> >>>> detect for both XFS and ext4 support.
> >>>
> >>> I think that if there is desire to test both xfs and non-xfs userspace
> >>> with project quota, then we need to differentiate between "e2fsprogs
> >>> and linux-quota and the kernel all support it" and "xfsprogs and
> >>> the kernel both support it" don't we?
> >>
> >> Well, it should be just "linux-quota and kernel". ext4 needs to
> >> have the same mount option behaviour for project quota as it does
> >> for all other types of quota, not be dependent on mkfs....
> > 
> > Project quota for ext4 is an optional thing, and if nothing else, we
> > need to have a separate feature flag for legacy file systems that were
> > created before we started supporting project quota.

No shit, Sherlock.

But we don't need the feature bit set by mkfs to support project
quota - it only needs to be set when the project quota file is
created by quotacheck. Or by the first mount -o pquota operation
after quotacheck has created the quotafile.

Either way, project quota can be dynamically turned on and be
protected against legacy filesystems, and it still can't be turned
on without a userspace or kernel that understands project quotas
being installed.

> > So if you want to
> > support project quota you *will* need to have a version of e2fsck that
> > understands project quota, and a version of mke2fs that knows how to
> > request that project quota be enabled, etc., etc.
> > So while it might be *nice* if ext4 could support project quota
> > without being dependent on having a specific version of mke2fs and
> > e2fsck installed, it's just simply not possible....

We can test for that in _requires_linux_prjquota() and _notrun the
test is it isn't present. We do this to test for all optional
features in different filesystems - how is doing this for
ext4 project quota support in any way difficult or so special it's
not possible to implement such checks?

> >>> IOWs if the test uses setquota/repquota, chattr, mkfs, and fsck to
> >>> work with project quota, then that's a different set of requirements
> >>> from a test using xfs_io, xfs_quota, etc.
> >>
> >> _require_linux_prjquota
> >> _require_xfs_prjquota
> >>
> >> But that said, both ext4 and xfs need to work for both
> >> configurations, and they should all be using the common xfstests
> >> quota infrastructure....
> > 
> > Agreed, but we want xfstests to be able to support systems where
> > linux-quota (aka quotatools) and/or e2fsprogs and/or the kernel
> > haven't been upgraded to support project quota, don't we?  If for no
> > other reason than to be kind to the poor souls who have to support
> > RHEL 6.  :-)
> 
> It's unlikely that ext4 project quota will find its way to RHEL6. ;)
> 
> But the point I keep trying to make - and failing, apparently - 
> is that we will / should have two sets of tests for userspace
> functionality at least; one using standard quota tools, and one
> using xfs_quota.  Both should test the same kernel paths, but
> if we want to know that userspace is working we need to test both.

That's what I've been trying to say.

i.e.  the only difference between two project quota tests should be
the binaries run to set project quota flags, limits and get reports.
Otherwise the tests should be the same, similar to how we already
abstract quota setup and mounting, or like we abstract the fallocate
vs XFS preallocation/punch/zero commands in xfs_io in
_test_generic_punch().

i.e. test code is common between two tests, only the setup is
different. And, most importantly, they should give identical
accounting results.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
