From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Fri, 8 Jul 2016 10:51:27 +1000
Message-ID: <20160708005127.GK12670@dastard>
References: <1467786171-21127-1-git-send-email-wangshilong1991@gmail.com>
 <20160706233533.GK27480@dastard>
 <d0018d66-cb32-16df-b46e-5c418cc4bfae@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang Shilong <wangshilong1991@gmail.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org, tytso@mit.edu, sihara@ddn.com,
	lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d0018d66-cb32-16df-b46e-5c418cc4bfae@sandeen.net>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 06, 2016 at 09:47:28PM -0500, Eric Sandeen wrote:
> On 7/6/16 6:35 PM, Dave Chinner wrote:
> 
> ...
> 
> >> +_require_scratch
> >> +_require_chattr
> >> +_require_test_lsattr
> >> +_require_quota
> > 
> > needs  _require_prjquota, and that function needs to be modified to
> > detect for both XFS and ext4 support.
> 
> I think that if there is desire to test both xfs and non-xfs userspace
> with project quota, then we need to differentiate between "e2fsprogs
> and linux-quota and the kernel all support it" and "xfsprogs and
> the kernel both support it" don't we?

Well, it should be just "linux-quota and kernel". ext4 needs to
have the same mount option behaviour for project quota as it does
for all other types of quota, not be dependent on mkfs....

> IOWs if the test uses setquota/repquota, chattr, mkfs, and fsck to
> work with project quota, then that's a different set of requirements
> from a test using xfs_io, xfs_quota, etc.

_require_linux_prjquota
_require_xfs_prjquota

But that said, both ext4 and xfs need to work for both
configurations, and they should all be using the common xfstests
quota infrastructure....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
