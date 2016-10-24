From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFD] Common userspace tool for fscypto
Date: Mon, 24 Oct 2016 09:28:39 -0400
Message-ID: <20161024132839.qbw6u6hkzbbf5jcy@thunk.org>
References: <0bef3877-060e-b722-0354-3a5508219e23@nod.at>
 <20161024124937.bxohuapjqns3m2dy@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Weinberger <richard@nod.at>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161024124937.bxohuapjqns3m2dy@ws.net.home>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 24, 2016 at 02:49:37PM +0200, Karel Zak wrote:
> > That said, what about implementing such a tool as part of util-linux to control
> > fscrypto? We (David and I) would volunteer.
> 
> I have nothing against this plan (add to util-linux) if ext4, f2fs and
> ubifs guys agree too.

Our current plan is to implement it in e2fsprogs since we can more
quickly iterate over code reviews and code improvements.  At some
future point I'm happy to transfer it over to util-linux much like
we've done with blkid and uuid libraries and associated utilities.
We'll probably also keep a version in e2fsprogs for the long term just
because upstream e2fsprogs is now integrated into the Android's AOSP
build infrastructure, and it's probably simpler keep the tool there
than to try to add Android.mk files and add the necessary helper
scripts to deal with the fact (a) in the AOSP build system, you have
to be able to cross-compile packages using Linux, MacOS, and Windows
as the host OS and (b) Android using the Bionic C library instead of
glibc.


In answer to Richard's other questions, of course it would be released
under the GPL, and our goals for creating a new fscrypto are (a) make
it be more user-friendly, (b) support the new file-system level
encryption features and new algorithms which Michael's team will be
implementing, including a stronger string-to-key (password hashing)
algorithm, new encryption modes, data integrity, etc), and (c) not
have to be tied to backwards compatibility concerns with the e4crypt
command.  (Since we are just starting a new e2fsprogs 1.44 development
cycle, we'll have plenty of time to experiment with the UI and make
incompatible changes before 1.44 gets released and at that point I
would want to lock down the any option names, etc., for long-term
backwards compatibility.)

I suspect we'll keep e4crypt around for a while, just because it's a
handy debugging tool, and in general it's faster to add quick wrapper
around ioctls for testing purposes than it is to be very thoughtful
about creating a UI which is both friendly and able to support new
features in a backwards compatible way.

I also suspect we'll want to put most of the bits that could be
usefully called from other C programs (e.g., Android's userspace
stack, and libpam modules) and put it in a new libfscrypto library.

Cheers,

						- Ted

P.S.  If anyone is ever interested in trying to make util-linux build
using AOSP (which would be cool since every once in a while I wish I
had some of the util-linux tools purely for debugging purposes, but
it's a bunch of work and I've never had the time, plus I wasn't at all
convinced Karel would be willing to accept such changes upstream for
util-linux), see e2fsprogs's Android.mk files plus the script in
util/gen-android-files.
