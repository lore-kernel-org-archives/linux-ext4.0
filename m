From: Ted Ts'o <tytso@mit.edu>
Subject: Re: EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741:
 group 1904, 32254 clusters in bitmap, 32258 in gd
Date: Mon, 4 Jun 2012 19:04:04 -0400
Message-ID: <20120604230404.GB6525@thunk.org>
References: <17610219749.20120604192048@eikelenboom.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Sander Eikelenboom <linux@eikelenboom.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47665 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757546Ab2FDXEK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jun 2012 19:04:10 -0400
Content-Disposition: inline
In-Reply-To: <17610219749.20120604192048@eikelenboom.it>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 04, 2012 at 07:20:48PM +0200, Sander Eikelenboom wrote:
> Hello Ted,
> 
> I have a problem back that occured , but didn't receive much respons in debugging:
> 
> [ 4688.270789] EXT4-fs error (device dm-42): ext4_mb_generate_buddy:741: group 1904, 32254 clusters in bitmap, 32258 in gd
> [ 4688.279172] Aborting journal on device dm-42-8.
> [ 4688.288634] EXT4-fs (dm-42): Remounting filesystem read-only
> [ 4688.299011] EXT4-fs (dm-42): ext4_da_writepages: jbd2_start: 6144 pages, ino 15597569; err -30

Ah, sorry, I didn't see this message when I responded to your earlier
message (you didn't mail thread it).  I also didn't recall your
earlier complaint until I did an search of my mail archives.

The main problem is that we don't have an easy reproduction case.
It's not a problem which has been showing up on any of my testing.
Earlier you had said that this happened after a read-only snapshot, so
I had assumed it was an DM issue.

But you say this time it's not happening without a snapshot.  OK, how
frequently does this happen?  How easily can you reproduce it?  Can
you do it pretty much on demand?  And are the numbers *always* the same?

> 
> Running: Fsck -D -f -v -p, results in:
> 

Can you run this command instead? e2fsck -f /dev/XXXX

And send me the output?  The -p overrides the -f option, so it wasn't
doing a full fsck check.  It should have done a full check if the file
system was marked as containing an error, regardless of the -p, but
there was a bug that was fixed in 3.5-rc1 which prevented that.  I'm
at a loss to explain why you were still seeing problem in 3.5-rc1 ---
was the fsck log from after running a kernel running 3.5-rc1?  In any
case, please do a full fsck using "e2fsck -f /dev/XXX" and send me the
output from that command.

Regards,

						- Ted
