From: Solofo.Ramangalahy@bull.net
Subject: Re: [RFC 0/2] ext4: zero uninitialized inode tables
Date: Tue, 25 Nov 2008 13:28:47 +0100
Message-ID: <18731.61311.620237.554814@frecb006361.adech.frec.bull.fr>
References: <20081121102309.182113793@bull.net>
	<20081125053226.GE20928@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Solofo.Ramangalahy@bull.net, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39008 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYKYM2w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 07:28:52 -0500
In-Reply-To: <20081125053226.GE20928@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso writes:
 > Does that make sense?

Yes, thanks for the guidance!

 > doing it as a module allows you to shorten your
 > compile-edit-debug cycle, I suppose, so maybe it's a justification for
 > doing it that way,

Yes it is.

 > but if that's the main reason, I'd choose using
 > user mode linux or KVM as my main development vehicle to speed up the
 > development cycle....

I did both kvm and module :-)
Other reasons were:
. this resize comment:
  * This could probably be made into a module, because it is not often in use.
  and this sentence from the OLS'02 paper
  "Since the online resizing code is only used very rarely, it would
  be possible to put the bulk of this code into a separate module that
  is only loaded when a resize operation is done."
  Inode zeroing is done only once in a filesystem lifetime (and each
  time it is resized).
. the fact that did not have a clear idea of when to fire the thread.
. some consideration for memory usage (you mentionned NAS boxes in
  another thread).

 > I'm not sure why you are treating the non-empty group case any
 > different from the empty-group case.

Because of simplicity. I wanted to have "something" to start the
discussion.

I was also thinking that there may be other places to do it. For
example, zeroing the inode table where the inode bitmap is initialized
(ext4_init_inode_bitmap() called only once in
ext4_read_inode_bitmap()).

The reasoning would have been to zero as soon as it is known to be
needed:
. without deferring it to the threads,
. decreasing the probability of zeroing competing with other code
. decreasing the "window of vulnerability" (the time between formating
  and end of zeroing where it is known that fsck is not safe).

I don't know if it would have been sufficient to guarantee that all
the groups are eventually itable zeroed.

 > > . fix the resize inode case
 > 
 > Not sure what problem you were having here?

With resize inode, the obtained filesystem is corrupted, fsck says
"Resize inode not valid.  Recreate?"
as well as: 
"Free blocks count wrong for group #0 (6788, counted=6789)."


Appart from the data structures change you mentionned, these changes
were discussed:
. a mount option to disable the threads when doing testing/performance
  benchmarking
. a flag in s_flags field of struct ext4_super_block to indicate that
  the zeroing has been done on all the groups. Possibly reset with
  resize.
Do they sound reasonable?

-- 
solofo
