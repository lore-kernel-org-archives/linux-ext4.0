From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypto: make XTS tweak initialization
 endian-independent
Date: Wed, 5 Oct 2016 22:16:25 -0400
Message-ID: <20161006021625.pothakzxpbztwuwb@thunk.org>
References: <20161005170659.GA110549@google.com>
 <20161005182307.GA1164@google.com>
 <5c01fd8e-95e6-669c-9f9d-30ab5a7af9fd@nod.at>
 <ac10ada8-40fc-e946-7593-efa08eb875d1@nod.at>
 <20161006011714.GT27872@dastard>
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
In-Reply-To: <20161006011714.GT27872@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 06, 2016 at 12:17:15PM +1100, Dave Chinner wrote:
> This is the sanest approach, because encrypting filesystem internal
> metadata may have some unintended consequences. e.g being unable to
> perform forensic analysis of corruption or data loss events, or an
> inability for tools like fsck to work without also implementing all
> the encryption code in userspace and being provided with all the
> keys needed to decrypt the metadata.

Absolutely. 

> i.e. it's not just the kernel code we have to consider here when
> discussing this level of encryption in filesystems - the impact
> on the entire support ecosystem needs to be considered. A weakness
> in a fsck tool will be just as serious as a weakness in the kernel
> code, and there's a much larger amount of widely dispersed code that
> would need to be encryption enabled by going down this path.

An approach that works fairly well, which doesn't require any
userspace changes, is one where if you are using a hardware
accelerated, in-line crypto engine, and where you are sending the key
identifier to be used down through the block layer in the bio request,
is to define a particular key as the "default" key to be used if a key
is not specified in the bio request.

So if the file system doesn't send down an explicit key identifier for
its metadata reads/write requests, the block device essentially acts
like a dm-crypt device --- except the hardware is doing the encryption
so it's nice and fast.

This approach means that no changes are needed in the file system for
encrypting and decrypting the metadata blocks, and it also means that
no changes are needed in any of the e2fsprogs userspace utiliies
(which except for debugfs and fuse2fs, only read metadata blocks).
Well, resize2fs wouldn't work since it would try to move data blocks
around, but eMMC memory is generally not resizeable, so it all works
out at least for mobile devices, and if we really want to support this
for resizeable devices, we could teach resize2fs a way to signal to
the block device which blocks are data blocks and so the ICE layer
should be passed during a file system shrink operation.

So if we move to a model where we move the actual block
encryption/decryption into a dm-crypt like layer (instead of doing it
in fs/ext4/page_io.c as we currently do for ext4's fs crypto support),
we minimize the changes needed in the file systems --- since all we
need to do is to pass the key identifier into the bio layer, and key
identifier management can be done in the fs/crypto layer, and so on
top of the other benefits, we get the ability to support generalized
hardware ICE acceleration and metadata encryption for a relatively
tiny investment of effort.

Yes, this won't work for ubifs, but ubifs is a bit of an outlier, and
unless we think we want to support any other MTD file systems, we may
just simply need make things flexible enough so that ubifs can do its
own thing as far as hardware acceleration is concerned.

Cheers,

					- Ted
