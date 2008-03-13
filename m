From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: e2fsck not fixing all corruptions on the first run?
Date: Thu, 13 Mar 2008 18:16:57 -0400
Message-ID: <20080313221657.GJ28728@mit.edu>
References: <alpine.DEB.1.00.0803131923420.7433@sheep.housecafe.de> <20080313205426.GD28728@mit.edu> <alpine.DEB.1.00.0803132219590.7433@sheep.housecafe.de> <20080313214731.GE28728@mit.edu> <alpine.DEB.1.00.0803132255230.7433@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57641 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641AbYCMWRY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 18:17:24 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0803132255230.7433@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2008 at 10:59:55PM +0100, Christian Kujau wrote:
> On Thu, 13 Mar 2008, Theodore Tso wrote:
>> Oh, right.  Sorry, I missed that.  I think I know what's going on.
>> The problem is we're not supporting long symlinks which are in extents
>> format.  That's something which we changed, but we're going to change
>> back (since we need it to support filesystems with > 2**32 blocks).
>
> When you say "changed", you mean the on-disk format changed? If so, I could 
> (should?) just mkfs again, since ext4 is in flux anyway and nobody said the 
> on-disk format was frozen. IOW, I don't know if it's wise to put in quirks 
> just because of some old test-environment. When ext4 is (offically) 
> released, everybody will have the "right" format and e2fsck will work as 
> expected, no?

Technically, I guess you could say the on-disk format changed, but as
I mentioned, it's going to change back to the original format.  It's
not a big deal.  The question is for long symlinks, where the symlink
can't fit in the 60 bytes in the i_block[] array, whether the block
number should be encoded as a single integer as i_block[0], as it is
under ext3, or whether it should be encoded as an extents structure.

Right now, the kernel you are using is encoding it as an extents
structure.  E2fsprogs doesn't think that's legal for symlink, so it
cleared them.  The kernel I am running encodes symlinks the same way
as ext3; but we're planning on changing it back to the way your kernel
is currently doing things, as it turns out you need to use the extents
format if the block number is larger than 32 bits.

So it's simply a matter of teaching e2fsprogs how to understand a long
symlink if the block number was encoded as an extent structure.

So no, there's no need to reformat your filesystem.  It's just that
right now, if you create a symlink where the target is larger than 60
bytes, e2fsck will think it is an invalid symlink and delete it.  The
fix for that will be coming shortly, becuase this is clearly very
annoying.

						- Ted
