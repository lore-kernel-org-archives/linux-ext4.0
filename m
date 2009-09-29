From: Theodore Tso <tytso@mit.edu>
Subject: Re: hard lockup, followed by ext4_lookup: deleted inode
	referenced: 524788
Date: Mon, 28 Sep 2009 23:13:08 -0400
Message-ID: <20090929031308.GB24383@mit.edu>
References: <20090928191644.GR12922@hexapodia.org> <20090928202507.GB22733@mit.edu> <20090928212838.GS12922@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andy Isaacson <adi@hexapodia.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:40279 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbZI2DNJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2009 23:13:09 -0400
Content-Disposition: inline
In-Reply-To: <20090928212838.GS12922@hexapodia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 28, 2009 at 02:28:38PM -0700, Andy Isaacson wrote:
> 
> I've attached the complete output from "fsck -n /dev/sda1" and "stat
> <%d>" on each inode reported to be deleted.
> 

So the large numbers of multiply-claimed blocks message is definitely
a clue:

> Multiply-claimed block(s) in inode 919422: 3704637
> Multiply-claimed block(s) in inode 928410: 3704637

> Multiply-claimed block(s) in inode 928622: 3703283
> Multiply-claimed block(s) in inode 943927: 3703283

> Multiply-claimed block(s) in inode 933307: 3702930
> Multiply-claimed block(s) in inode 943902: 3702930

What this indicates to me is that an inode table block was written to
the wrong location on disk.  In fact, given large numbers of inode
numbers involved, it looks like large numbers of inode table blocks
were written to the wrong location on disk.

So what happend with the file "/etc/rcS.d/S90mountdebugfs" is probably
_not_ that it was deleted on September 22nd, but rather sometime
recently the inode table block containing to inode #524788 was
overwritten by another inode table block, containing a deleted inode
at that relative position in the inode table block.

This must have happened since the last successful boot, since with
/etc/rcS.d/S90mountdebugfs pointing at a deleted inode, any attempt to
boot the system after the corruption had taken place would have
resulted in catastrophe.

I'm surprised by how many inode tables blocks apparently had gotten
mis-directed.  Almost certainly there must have been some kind of
hardware failure that must have triggered this.  I'm not sure what
caused it, but it does seem like your filesystem has been toasted
fairly badly.

At this point my advice to you would be to try to recover as much data
from the disk as you can, and to *not* try to run fsck or mount the
filesystem read/write until you are confident you have recovered all
of the critical files you care about, or have made a image copy of the
disk using dd to a backup hard drive first.  If you're really curious
we could try to look at the dumpe2fs output and see if we can find the
pattern of what might have caused so many misdirected writes, but
there's no guarantee that we would be able to find the definitive root
cause, and from a recovery perspective, it's probably faster and less
risk to reinstall your system disk from scratch.

Good luck, and I'm sorry your file system had gotten so badly
disrupted.

						- Ted
