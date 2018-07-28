From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: Remounting filesystem read-only
Date: Fri, 27 Jul 2018 20:18:23 -0400
Message-ID: <20180728001823.GA28432@thunk.org>
References: <366cf3ac534bbadaaa61714a43006ac7@codeaurora.org>
 <e9869d6cd358e9de395d730ab7b3aa60@codeaurora.org>
 <20180727195213.GE13922@thunk.org>
 <c121825198eba667c09fc53fa9b4fd3a@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, wen.xu@gatech.edu,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Sodagudi Prasad <psodagud@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c121825198eba667c09fc53fa9b4fd3a@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 27, 2018 at 01:34:31PM -0700, Sodagudi Prasad wrote:
> > The error should be pretty clear: "Inode table for bg 0 marked as
> > needing zeroing".  That should never happen.
> 
> Can you provide any debug patch to detect when this corruption is happening?
> Source of this corruption and how this is partition getting corrupted?
> Or which file system operation lead to this corruption?

Do you have a reliable repro?  If it's a one-off, it can be caused by
*anything*.  Crappy hardware, a bug in some proprietary, binary-only
GPU driver dereferencing some wild pointer that corrupts kernel
memory, etc.

Asking for a debug patch is like asking for "can you create technology
that can detect when a cockroach enter my house?"

So if you have a reliable repro, then we know what operations might be
triggering the corruption, and then you work on creating a minimal
repro, and only *then* when we have a restricted set of possibilities
that might be the cause (for example, if removing a GPU call makes the
problem go away, then the patch would need to be in the proprietary
GPU driver....)

> I am digging code a bit around this warning to understand more.

The warning means that a flag in block group descriptor #0 is set
that should never be set.  How did the flag get set?  There is any
number of things that could cause that.

You might want to look at the block group descriptor via dumpe2fs or
debugfs, to see if it's just a single bit getting flipped, or if the
entire block group descriptor is garbage.  Note that under normal code
paths, the flag *never* gets set by ext4 kernel code.  The flag will
get set on non-block group 0 block group descriptors by ext4, and the
ext4 kernel code will only clear the flag.

Of course, if there is a bug in some driver that dereferences a
pointer widely, all bets are off.

					- Ted
