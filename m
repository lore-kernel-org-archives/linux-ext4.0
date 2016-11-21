From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 1/4] generic: add utilities for testing filesystem
 encryption
Date: Mon, 21 Nov 2016 10:40:50 -0800
Message-ID: <20161121184050.GB30672@google.com>
References: <1479412027-34416-1-git-send-email-ebiggers@google.com>
 <1479412027-34416-2-git-send-email-ebiggers@google.com>
 <20161120213313.GI28177@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs@vger.kernel.org, "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        David Gstir <david@sigma-star.at>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34233 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753260AbcKUSky (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2016 13:40:54 -0500
Received: by mail-pf0-f172.google.com with SMTP id c4so53567640pfb.1
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2016 10:40:54 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20161120213313.GI28177@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Dave, thanks for reviewing.

On Mon, Nov 21, 2016 at 08:33:13AM +1100, Dave Chinner wrote:
> > +
> > +. ./common/rc
> 
> Tests will already have included common/rc before this file, so we
> do not source it here.
...
> These go in the tests, not here.
...
> _requires_real_encryption()
> 
> In each test.
...
> And this should all be in a _requires_encryption() function.
> 

I'll do all of these.  Of course the intent was to avoid duplicating code in
each test, but I will use the more verbose style if that's preferred.  I assume
you'd also prefer explicitly formatting and mounting the scratch device in each
test even though _require_encryption would already have to do that?

> > +}
> > +
> > +_scratch_mkfs_encrypted() {
> > +	case $FSTYP in
> > +	ext4)
> > +		# ext4 encryption requires block size = PAGE_SIZE.
> > +		MKFS_OPTIONS="-O encrypt -b $(getconf PAGE_SIZE)" _scratch_mkfs
> > +		;;
> > +	*)
> > +		MKFS_OPTIONS="-O encrypt" _scratch_mkfs
> > +		;;
> > +	esac
> > +}
> 
> THis completely overrides any user supplied mkfs options, which we
> try to avoid doing. Instead, this should simply be
> 
> 	_scratch_mkfs -O encrypt
> 
> so that _scratch_mkfs_encrypted() fails if there are conflicting
> mkfs options specified. This means _requires_encryption() will
> not_run the test when this occurrs...
> 

It wouldn't work exactly like that because mkfs.ext4 currently allows creating a
filesystem with -O encrypt and a block size incompatible with encryption.  The
kernel then refuses to mount the filesystem.  But your suggestion would
basically still work, since we have to try mounting the filesystem anyway to
check for kernel support for encryption.

> > diff --git a/src/fscrypt_util.c b/src/fscrypt_util.c
> > new file mode 100644
> > index 0000000..de63667
> > --- /dev/null
> > +++ b/src/fscrypt_util.c
> 
> ....
> 
> Ok, can we get this added to xfs_io rather than a stand-alone
> fstests helper? There are three clear commands here:
> 
> 	{"gen_key", gen_key},
> 	{"rm_key", rm_key},
> 	{"set_policy", set_policy},
> 
> So it should plug straight into the xfs_io command parsing
> infrastructure without much change at all.

I see that xfs_io is part of xfsprogs, not xfstests.  Does it make sense to add
filesystem encryption commands to xfs_io even though XFS doesn't support them
yet?  Currently only ext4 and f2fs support filesystem encryption via this common
API.  (ubifs support has been proposed too.)

If we do go that route then it should be considered only adding "set_policy" and
"get_policy" commands, and for "gen_key" and "rm_key" instead using shell
wrappers around 'keyctl' instead.  gen_key and rm_key don't touch the filesystem
at all; they only work with the keyring.  It's possible to use 'keyctl padd' to
add a fscrypt key, though it's not completely trivial because you'd have to use
'echo -e' to generate the C structure 'struct fscrypt_key' with mode = 0, raw =
actual key in binary, size = 64.

Eric
