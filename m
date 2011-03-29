From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: breaking ext4 to test recovery
Date: Tue, 29 Mar 2011 08:50:18 -0500
Message-ID: <4D91E39A.3000800@redhat.com>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1C2NuU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Mar 2011 09:50:20 -0400
In-Reply-To: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/28/11 9:45 PM, Daniel Taylor wrote:
> I would like to be able to break our ext4 file system
> (specifically corrupt the journal) to be sure that we
> can automatically notice the problem and attempt an
> autonomous fix.
> 
> dumpe2fs tells me the inode, but not, that I can see, the
> blocks where the journal exists (for "dd"ing junk to it).
> 
> Is there any debug tool that would let me deliberately
> break the file system (at least, trash the journal)?
> 
> If not, is there a hint for figuring out the block(s) of
> the journal so I can stomp it?
> 
> The kernel is in an embedded machine, so it's a little old
> 2.6.32.11 and e2fsprogs/libs 1.41.12-2 (Lenny)

As Tao Ma said, you can stat <8> in debugfs to see the journal
blocks.

Another tool which can be useful for this sort of thing is
fsfuzzer.  It writes garbage; using dd to write zeros actually
might be "nice" corruption.

But are you trying to test in-kernel recovery, or e2fsck, after
you corrupt the journal?  Or both?

I assume you'd start with a filesystem with a dirty log,
corrupt that log, and then what, fsck it, or try to mount it?

How are you generating your fs w/ dirty log?

(xfs has an ioctl to abruptly "stop" the fs as if it had crashed,
that would be very useful in extN as well).

Another thing which could use lots more testing in the wild is
simple journal recovery; nothing is corrupted, but the drive got
unplugged or the system lost power while the fs was under load;
see if a mount; umount; fsck and/or if a fsck; mount; umount; fsck finds
errors.

(the former will test in-kernel log recovery, the latter will test
log recovery in e2fsck).

-Eric

> Dan Taylor
> Sr. Staff Engineer
> WD Branded Products
> 949.672.7761 

