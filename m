From: Andreas Dilger <adilger@sun.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Mon, 24 Aug 2009 16:46:16 -0600
Message-ID: <20090824224616.GR5931@webber.adilger.int>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com>
 <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int>
 <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com>
 <20090824220738.GG17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60596 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbZHXWqQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Aug 2009 18:46:16 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7OMkC0f014578
	for <linux-ext4@vger.kernel.org>; Mon, 24 Aug 2009 15:46:14 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KOW00J00KJBKQ00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 24 Aug 2009 15:46:12 -0700 (PDT)
In-reply-to: <20090824220738.GG17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 24, 2009  18:07 -0400, Theodore Ts'o wrote:
> What ext3 and ext4 does by default is this:
> 
> 1)  Write data blocks required by data=ordered mode (if any)
> 
> 2)  Write the journal blocks
> 
> 3)  Wait for the journal blocks to be sent to disk.  (We don't actually
>     do a barrier operation), so this just means the blocks have been
>     sent to the disk, not necessarily that they are forced to a platter.

Hmm, I think you are missing a step here.  In both jbd and jbd2 there is
a wait for these buffers to hit the disk.  In the jbd case it is at
"commit phase 2", and in jbd2 it is at "wait_for_iobuf".

> 4)  Write the commit block, with the barrier flag set.
>
> 5)  Wait for the commit block.
> 
> -----
> 
> What the current async commit code does is this:
> 
> 1)  Write data blocks required by data=ordered mode (if any)
> 
> 2)  Write the journal blocks
> 
> 3)  Write the commit block, without a barrier.
> 
> 4)  Wait for the journal blocks to be sent to disk.
> 
> 5)  Wait for the commit block (since a barrier is requested, this is
> just when it was sent to the disk, not when it is actually committed
> to stable store).

Similarly, in the async case, all of the data blocks and the commit
block are waited on, AFAICS.  It's just that with async_commit the
commit block is submitted with the data blocks, and in case of a
crash the transaction checksum is needed to determine if the commit
block is valid or not.

> What I think we can do safely in ext4 is this:
> 
> 1)  Write data blocks required by data=ordered mode (if any)
> 
> 2)  Write the journal blocks
> 
> 3)  Write the commit block, WITH a barrier requested.
> 
> 4)  Wait for the commit block to be completed.
> 
> 5)  Wait for the journal blocks to be sent to disk.  #4 implies that
> all of the journal block I/O will have been completed, so this is just
> to collect the commit completion status; we should actually block
> during step #5, assuming the block layer's barrier operation was
> implemented correctly.

Since a barrier is a painful operation, it is better to just wait
explicitly on the completion of the various blocks as needed (i.e.
journal data + commit block).  That avoids the huge wait on many
other blocks that may have been sent to disk unrelated to the journal
itself, if the journal is on the same device as the filesystem.

> This should save us a little bit, since it implies the commit record
> will be sent to disk in the same I/O request to the storage device as
> the the other journal blocks, which is _not_ currently the case today.

Are you _really_ sure that isn't what is done today?  My reading of the
code is different, but it's of course possible that I'm seeing what I
want to see (which is how it was originally designed) and not what is
really there.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

