From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [FOR STABLE 4.1] ext4 crypto: don't regenerate the per-inode
 encryption key unnecessarily
Date: Sun, 8 Oct 2017 16:34:50 -0400
Message-ID: <20171008203449.ys4sg5xztbzxx6ik@thunk.org>
References: <20171008180953.rpnxvpggqggc334m@thunk.org>
 <20171008191749.GA26458@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171008191749.GA26458@zzz.localdomain>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Oct 08, 2017 at 12:17:49PM -0700, Eric Biggers wrote:
g> 
> This is an improvement, but it's still broken because there is no locking.  If
> two processes ->open() the same inode at the same time, one can observe
> ext4_has_encryption_key() as true before the key has been fully initialized.  It
> may be a good idea to add a really simple
> DEFINE_MUTEX(ext4_key_generation_mutex), then do the ext4_has_encryption_key()
> check and key generation under the mutex...

Thanks for the review.  You're right, we need to add a mutex because
otherwise this patch would cause a regression.  Previously, a racing
open would "only" leak kernel memory.  Now, it could cause a kernel
crash.  I'll respin a patch with the mutex added.

At this point, looking at 4.1, I can't really recommend that _anyone_
try to use ext4 encryption with the 4.1 LTS kernel.  Fortunately, I
don't think there are that many users of 4.1, and those that do
probably aren't using ext4 encryption.  (The Android ecosystem seems
to have largely settled on 3.18 and 4.4, and there hasn't been much
use of ext4 encryption outside of Android yet.)  I just want to make
sure keep the latest upstream LTS kernels mostly clean with respect to
xfstests runs, so I more easily detect regressions.

Speaking of which, over the weekend I've sent a dozen or so stable
kernel backport/cherry pick requests to stable@vger.kernel.org.  Most
of them I didn't bother to cc linux-ext4 since they were minor changes
to allow the patches to apply and I decided not to spam the list with
the backports.  I cc'ed the patch in this thread because it was new
code, and I'm glad I did, since your review was very helpful.  If
folks are interested the backports, I can either send them all to the
list, or I can publish them on git.kernel.org.  Hopefully they will
all show up in the LTS stable review process and then into a LTS
kernel in the next month or so.

Also, there are a number of the backports which are needed if you want
to be able to run xfstests without tests causing older kernels
(especialy 3.18 and 4.1) to crash or hang in the middle of the test
run.  So if anyone else is interested in running xfstests against
older kernels before these patches land in the LTS kernels, let me
know.  (I still have one known problem which still needs to be fixed,
which is that generic/269 will cause 4.4 and earlier kernels to soft
lockup.)

Cheers,

					- Ted
