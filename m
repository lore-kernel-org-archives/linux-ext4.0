From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypto: move ioctl processing more fully into common
 code
Date: Sun, 27 Nov 2016 12:39:34 -0500
Message-ID: <20161127173934.uz5cyjxuisainys4@thunk.org>
References: <1476723246-47420-1-git-send-email-ebiggers@google.com>
 <20161127000901.wuyl6t6wp6qhmkrs@thunk.org>
 <20161127042048.GA34163@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161127042048.GA34163@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Nov 26, 2016 at 08:20:48PM -0800, Eric Biggers wrote:
> 
> I guess I'm okay with that, since struct fscrypt_policy won't have any padding
> bytes because its members are all bytes.  Plus it's marked __packed, though I
> think that was a mistake given that the struct isn't stored on disk directly.
>

It wouldn't have mattered if wasn't marked __packed, since the first
four fields are __u8, and the master_key_descriptor is a 4 byte
aligned __u8 array of size 8.

The use of __packed in the fscrypt code came from Michael, and I
suspect it's more of a Microsoft thing, since his previous experience
was as the architect for Bitlocker.  It's actually pretty rare that we
use __packed in Linux kernel sources in general, and in ext4
specifically.

Personally, I tend to depend on __uNN declaration and various
assumptions that we make about "sane" packing rules which are assumed
by the kernel.  See how the on-disk ext4 superblock is defined; that's
not the only place where we make assumptions about sane structure
packing, and anyone who tried porting Linux to a 18-bit or 36-bit
architecture would have lots of other problems, even if a modern Linux
kernel could be made small enough to fit in the memory available to a
PDP-10 or a PDP-15. :-)

We probably could remove a few of them, but I haven't bothered, since
in general they aren't doing any harm.

Cheers,

					- Ted


