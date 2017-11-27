From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Mon, 27 Nov 2017 11:11:38 -0500
Message-ID: <20171127161137.4ghjcxfklpurk2eo@thunk.org>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
 <20171122180317.nvymp7eedhswga7l@thunk.org>
 <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: Ashlie Martinez <ashmrtn@utexas.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59264 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752788AbdK0QLl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 27 Nov 2017 11:11:41 -0500
Content-Disposition: inline
In-Reply-To: <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 27, 2017 at 08:31:07AM -0600, Ashlie Martinez wrote:
> Ted,
> 
> Thank you very much for taking the time to lay all of this out for me
> (and throwing some humor and youtube links to boot), despite how busy
> you were (I hope everything is alright!). I see now why the fix works
> and what was going wrong. It appears I was confused about the order of
> operations being performed in the test based on what I read in another
> email. I believe in another email somewhere I read that the fallocate
> was before a delayed write so I was thinking something like fallocate
> then write. I see now that it is write with delayed allocation
> (resolved after fallocate) and then fallocate. With that piece of
> information everything else about the test, delayed allocation, and
> the fix make sense.

Sorry, "before" was misleading.  When I used the word "before", I was
speaking of the order that the operations hit the disk.  The confusion
comes from the fact that the delayed allocation write was *issued*
before the fallocate, but in terms of when they are committed to disk,
the fallocate commits *first*, and then 25-30 seconds later, the
delayed allocation write is resolved and then committed to disk.

It's the difference between the order that the operations are issued
and when they are committed to disk which is what caused the bug; and
the problem reproduction relies on crashing/aborting the file system
between the time that the two operations would have been committed.

Hopefully this will be helpful in terms of finding a way to create
automated file system testing systems that can detect bugs similar to
this one.  I can imagine that if you ever want to extend this to
database testing, a similar technique might be used to detect
transactions which close in a different order than how they were
issued, or dealing transactions which end up getting rolled back.

						- Ted

P.S.  I see you have some Google internships under your belt, so I'm
sure you know the drill, but I hope you'll consider us for another
future internship experience.   :-)
