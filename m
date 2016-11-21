From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] generic: add utilities for testing filesystem
 encryption
Date: Tue, 22 Nov 2016 08:08:49 +1100
Message-ID: <20161121210849.GI31101@dastard>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
 <1479412027-34416-2-git-send-email-ebiggers@google.com>
 <20161120213313.GI28177@dastard>
 <20161121184050.GB30672@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>
To: Eric Biggers <ebiggers@google.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161121184050.GB30672@google.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 21, 2016 at 10:40:50AM -0800, Eric Biggers wrote:
> Hi Dave, thanks for reviewing.
> 
> On Mon, Nov 21, 2016 at 08:33:13AM +1100, Dave Chinner wrote:
> > > +
> > > +. ./common/rc
> > 
> > Tests will already have included common/rc before this file, so we
> > do not source it here.
> ...
> > These go in the tests, not here.
> ...
> > _requires_real_encryption()
> > 
> > In each test.
> ...
> > And this should all be in a _requires_encryption() function.
> > 
> 
> I'll do all of these.  Of course the intent was to avoid duplicating code in
> each test, but I will use the more verbose style if that's preferred.  I assume
> you'd also prefer explicitly formatting and mounting the scratch device in each
> test even though _require_encryption would already have to do that?

Yes, because in future _require_encryption may change to no require
touching the scratch device. Also, checking for encryption may
create a filesystem with different configuration than the one we
want to test. So it's better to be consistent across all tests and
require the scratch_mkfs call in each test so we know the exact
state of the filesystem before the test starts....

> > Ok, can we get this added to xfs_io rather than a stand-alone
> > fstests helper? There are three clear commands here:
> > 
> > 	{"gen_key", gen_key},
> > 	{"rm_key", rm_key},
> > 	{"set_policy", set_policy},
> > 
> > So it should plug straight into the xfs_io command parsing
> > infrastructure without much change at all.
> 
> I see that xfs_io is part of xfsprogs, not xfstests.  Does it make sense to add
> filesystem encryption commands to xfs_io even though XFS doesn't support them
> yet?  Currently only ext4 and f2fs support filesystem encryption via this common
> API.  (ubifs support has been proposed too.)

Yes, because it is in the plan to support the generic encryption in
XFS, too. It'll just take us a little while to get to it, but it
won't hurt to support these operations ahead of that time...

> If we do go that route then it should be considered only adding
> "set_policy" and "get_policy" commands, and for "gen_key" and
> "rm_key" instead using shell wrappers around 'keyctl' instead.
> gen_key and rm_key don't touch the filesystem at all; they only
> work with the keyring.  It's possible to use 'keyctl padd' to add
> a fscrypt key, though it's not completely trivial because you'd
> have to use 'echo -e' to generate the C structure 'struct
> fscrypt_key' with mode = 0, raw = actual key in binary, size = 64.

Sounds fine to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
