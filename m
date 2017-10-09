From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [FOR STABLE 4.1] ext4 crypto: don't regenerate the per-inode
 encryption key unnecessarily
Date: Sun, 8 Oct 2017 20:02:22 -0400
Message-ID: <20171009000222.opub5o74zl5beqqg@thunk.org>
References: <20171008180953.rpnxvpggqggc334m@thunk.org>
 <20171008191749.GA26458@zzz.localdomain>
 <20171008203449.ys4sg5xztbzxx6ik@thunk.org>
 <20171008215216.GA1602@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50042 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752060AbdJIACY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 8 Oct 2017 20:02:24 -0400
Content-Disposition: inline
In-Reply-To: <20171008215216.GA1602@zzz.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 08, 2017 at 02:52:16PM -0700, Eric Biggers wrote:
> But yes, it's
> nice at least making it so that xfstests doesn't crash the kernel.  We should
> probably also backport 9a200d075e5d ("ext4: require encryption feature for
> EXT4_IOC_SET_ENCRYPTION_POLICY") so that if someone happens to have
> CONFIG_EXT4_FS_ENCRYPTION turned on in their kernel, random unprivileged users
> can't reach all the buggy code on any ext4 filesystem.

Yeah, that's a good idea.  I'll send a request to
stable@vger.kernel.org.  Commit 9a200d075e5d applies cleanly to 4.1,
so that should be straightforward.

> By the way, just looking at ext4_generate_encryption_key() in 4.1, there are
> three different bugs in how it's accessing the keyring, and all allow an
> unprivileged user to cause a kernel oops.  The first two were fixed upstream by
> 687c3c36e754 ("ext4 crypto: replace some BUG_ON()'s with error checks") and
> db7730e3091a ("ext4 crypto: add missing locking for keyring_key access").  The
> last will be fixed by "fscrypt: fix dereference of NULL user_key_payload" which
> still needs to be applied.  (It's part of a series which fixes the same bug in 5
> different places; I'll probably need to resend the patches individually to the
> different maintainers unless the keyrings maintainer wants to take the whole
> series.)

Well, I'm not particulary motivated to backport those fixes to 4.1,
but if you or someone else wants to do the backport, I certainly won't
complain.

Personally, though, if I have more time to work on the LTS kernels,
cleaning up the 3.18.x test failures is higher on my priority list,
since it might actually help some Android devices still stuck on 3.18.
(See below for the current state of the LTS kernels with my backports
and fixups to xfstests to fix some false positives due to the older
kernels not supporting ea_inode and project quotas.)

Of the failures in 4.9 and 4.4, generic/082 and generic/338 are
relatively minor quota bugs that aren't going to affect Android's use
of quota.  generic/441 tests the new error handling code, and we're
not likely to backport that to LTS kernels.  generic/451 is a buffered
vs. AIO/DIO race test, which I suspect won't be worth fixing except by
changing the Direct I/O paths to uses the new iomap infrastructure.
generic/456 will be fixed in the next merge window and backported to
the LTS kernels.  And generic/459 is a dm-thin problem.

So the only real problem children is 3.18 and 4.1, and my motivation
to clean up 4.1 is minimal.

      	    	       	      - Ted

KERNEL:    kernel 4.9.52-xfstests-00005-gc9dacd33bdcf #4 SMP Sun Oct 8 15:47:09 EDT 2017 x86_64
CMDLINE:   --kernel /build/ext4-4.9-64 -c 4k -g auto
CPUS:      2
MEM:       7680

ext4/4k: 339 tests, 5 failures, 38 skipped, 3024 seconds
  Failures: generic/082 generic/441 generic/451 generic/456
    generic/459
Totals: 339 tests, 38 skipped, 5 failures, 0 errors, 2932s


KERNEL:    kernel 4.4.89-xfstests-00004-g85c293dc2ed8 #5 SMP Sun Oct 8 15:55:01 EDT 2017 x86_64
CMDLINE:   --kernel /build/ext4-4.4-64 -c 4k -g auto -X generic/269

ext4/4k: 338 tests, 5 failures, 49 skipped, 3361 seconds
  Failures: generic/382 generic/441 generic/451 generic/456
    generic/459
Totals: 338 tests, 49 skipped, 5 failures, 0 errors, 3261s


KERNEL:    kernel 4.1.44-xfstests-00009-gd899706494c1 #6 SMP Sun Oct 8 16:38:13 EDT 2017 x86_64
CMDLINE:   --kernel /build/ext4-4.1-64 -c 4k -g auto -X generic/269

ext4/4k: 338 tests, 14 failures, 55 skipped, 3353 seconds
  Failures: ext4/022 ext4/025 generic/313 generic/382 generic/395
    generic/397 generic/398 generic/429 generic/435 generic/440
    generic/441 generic/451 generic/456 generic/459
Totals: 338 tests, 55 skipped, 14 failures, 0 errors, 3270s


KERNEL:    kernel 3.18.73-xfstests-00006-gc80a32d5a966 #2 SMP Sun Oct 8 16:35:31 EDT 2017 x86_64
CMDLINE:   --kernel /build/ext4-3.18-64 -c 4k -g auto -X generic/269 -X ext4/022

ext4/4k: 337 tests, 9 failures, 67 skipped, 3254 seconds
  Failures: ext4/001 ext4/025 generic/313 generic/382 generic/441
    generic/450 generic/451 generic/456 generic/459
Totals: 337 tests, 67 skipped, 9 failures, 0 errors, 3178s
