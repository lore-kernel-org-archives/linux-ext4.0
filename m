From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization
 endian-independent
Date: Fri, 7 Oct 2016 12:05:02 -0400
Message-ID: <20161007160502.sdv2rl36e5mjpxct@thunk.org>
References: <20161005170659.GA110549@google.com>
 <20161005182307.GA1164@google.com>
 <5c01fd8e-95e6-669c-9f9d-30ab5a7af9fd@nod.at>
 <ac10ada8-40fc-e946-7593-efa08eb875d1@nod.at>
 <20161006011714.GT27872@dastard>
 <20161006021625.pothakzxpbztwuwb@thunk.org>
 <20161006222351.GV27872@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Weinberger <richard@nod.at>,
        Michael Halcrow <mhalcrow@google.com>,
        David Gstir <david@sigma-star.at>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        jaegeuk@kernel.org, Eric Biggers <ebiggers@google.com>,
        Anand Jain <anand.jain@oracle.com>,
        Tyler Hicks <tyhicks@canonical.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161006222351.GV27872@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 07, 2016 at 09:23:51AM +1100, Dave Chinner wrote:
> At which point, I have to ask, why not just use dm-crypt and
> implement a simple "use device key on bio contents if none has been
> specified by higher layer" mechanism to direct the encryption?  It's
> simple, you can still offload the crypto to your hardware, requires
> minimal extra plumbing, and no userspace tooling changes. This
> allows the user data on a dm-crypt to be encrypted with a user
> specified key so even is the device key is compromised their data is
> not (and vice versa).

That's what I was suggesting.  There would still have to be a
userspace tool which specifies which key should be used for which
file, but the actual userspace changes beyond that are minimal.  We
have some changes in e2fsck to complain if the "this file encrypted"
when the encryption feature flag is not set, and so on.

Once Pixel and Pixel XL ship in a few weeks, and the kernel
repositories are published through AOSP, there will be some prototype
code for folks to look at --- although I'll be the first to admit it
is a bit ugly.  We were under a bit of time pressure, and so we took a
bunch of shortcuts that we knew we would have to clean up (and maybe
even reimplement) before the technology was ready to go upstream.

But, yes, that's the direction in which I want to evolve the fs/crypto
code.

> As for non-block device filesystems like UBIFS, I'd suggest that
> their "storage layer" that the filesytem sits on top of could do the
> same thing - any request that doesn't have a key supplied gets
> encrypted using the device key. i.e. the filesystem layers use the
> same implementation, but the underlying storage device implements
> the encryption interface according to the requirements of the
> subsystem.

Yes, the right place for this would be in the MTD layer.  I'm not sure
hardware designers will ever be interested in adding hardware
accelerated crypto in front of the "raw flash" interface (if they are
going to do that, why not just throw in the whole FTL and eMMC layers
as well?), but if it does happen, the MTD layer could handle that as
well.

> i.e. I don't think we should be trying to implement a single layer
> that supports both block and non-block filesystems here. However, we
> can still architect a solution where the filesystem level code is
> independent of the underlying storage encryption implementation.  In
> this sort of architecture, the filesystem only does key management
> and deals with unencrypted data and metadata, whilst the underlying
> storage layer implements the (hardware accelerated) encryption as
> the data passes through...

Yep, that's the idea --- with the added twist that the architecture
should be flexible enough that in some cases, the pieces of the key
management, currently in fs/crypto, might get moved into to secure
enclaves, such that even if the attacker completely compromises kernel
memory, none of cryptographic bits would be available.

Both ARM Trustzone and Intel's SGX are examples of trusted execution
environments which could be used for this purpose, so this is
something we'll eventually be able to use and test on x86 developer
workstations.

Cheers,

						- Ted
