From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization
 endian-independent
Date: Fri, 7 Oct 2016 09:23:51 +1100
Message-ID: <20161006222351.GV27872@dastard>
References: <20161005170659.GA110549@google.com>
 <20161005182307.GA1164@google.com>
 <5c01fd8e-95e6-669c-9f9d-30ab5a7af9fd@nod.at>
 <ac10ada8-40fc-e946-7593-efa08eb875d1@nod.at>
 <20161006011714.GT27872@dastard>
 <20161006021625.pothakzxpbztwuwb@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32342 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752318AbcJFWX4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Oct 2016 18:23:56 -0400
Content-Disposition: inline
In-Reply-To: <20161006021625.pothakzxpbztwuwb@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 05, 2016 at 10:16:25PM -0400, Theodore Ts'o wrote:
> On Thu, Oct 06, 2016 at 12:17:15PM +1100, Dave Chinner wrote:
> > This is the sanest approach, because encrypting filesystem internal
> > metadata may have some unintended consequences. e.g being unable to
> > perform forensic analysis of corruption or data loss events, or an
> > inability for tools like fsck to work without also implementing all
> > the encryption code in userspace and being provided with all the
> > keys needed to decrypt the metadata.
> 
> Absolutely. 
> 
> > i.e. it's not just the kernel code we have to consider here when
> > discussing this level of encryption in filesystems - the impact
> > on the entire support ecosystem needs to be considered. A weakness
> > in a fsck tool will be just as serious as a weakness in the kernel
> > code, and there's a much larger amount of widely dispersed code that
> > would need to be encryption enabled by going down this path.
> 
> An approach that works fairly well, which doesn't require any
> userspace changes, is one where if you are using a hardware
> accelerated, in-line crypto engine, and where you are sending the key
> identifier to be used down through the block layer in the bio request,
> is to define a particular key as the "default" key to be used if a key
> is not specified in the bio request.
> 
> So if the file system doesn't send down an explicit key identifier for
> its metadata reads/write requests, the block device essentially acts
> like a dm-crypt device --- except the hardware is doing the encryption
> so it's nice and fast.

At which point, I have to ask, why not just use dm-crypt and
implement a simple "use device key on bio contents if none has been
specified by higher layer" mechanism to direct the encryption?  It's
simple, you can still offload the crypto to your hardware, requires
minimal extra plumbing, and no userspace tooling changes. This
allows the user data on a dm-crypt to be encrypted with a user
specified key so even is the device key is compromised their data is
not (and vice versa).

As for non-block device filesystems like UBIFS, I'd suggest that
their "storage layer" that the filesytem sits on top of could do the
same thing - any request that doesn't have a key supplied gets
encrypted using the device key. i.e. the filesystem layers use the
same implementation, but the underlying storage device implements
the encryption interface according to the requirements of the
subsystem.

i.e. I don't think we should be trying to implement a single layer
that supports both block and non-block filesystems here. However, we
can still architect a solution where the filesystem level code is
independent of the underlying storage encryption implementation.  In
this sort of architecture, the filesystem only does key management
and deals with unencrypted data and metadata, whilst the underlying
storage layer implements the (hardware accelerated) encryption as
the data passes through...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
