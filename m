From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: PATCH ext4: fix to call_filldir
Date: Mon, 24 Nov 2008 16:51:47 -0500
Message-ID: <20081124215146.GC20928@mit.edu>
References: <20081124182105.184338C977@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51606 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954AbYKXVzH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Nov 2008 16:55:07 -0500
Content-Disposition: inline
In-Reply-To: <20081124182105.184338C977@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 24, 2008 at 10:21:05AM -0800, Curt Wohlgemuth wrote:
> 
> [ Sorry: I mistakenly sent just the patch, with no explanation... ]
> 
> I happened to find a bug running bonnie++-1.03a on an ext4 filesystem, when
> it complained about not being able to remove a file.
> 
> Further investigation showed a problem with call_filldir(), which is not
> quite correct with respect to the same function in fs/ext3/dir.c.  The patch
> below fixes this problem.

Um, how much testing have you done with this patch in place?  The
change to call_filldir() was part of other changes in how
call_filldir() was called, and at least in the common case where
filldir() returns -EINVAL because there's not enough room in the
user's readdir buffer and the entry needs to be saved for the next
getdents() systemcall, the code is correct.   

In fact, I haven't tried your patch, but I'm pretty certain that if
applied, it will cause directory entries to be dropped such that rm
-rf for large hierarchies will *always* fail because some files won't
get deleted becuase they won't be returned by readdir().

What kernel version were you running when you were testing ext4 using
bonnie?  If you are using a kernel older than 2.6.28-rc2 (and newer
than 2.6.27-rc4), I would guess what you ran into was a known bug that
was fixed by commit 3c37fc86.

						- Ted
