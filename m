From: Frank Mayhar <fmayhar@google.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Tue, 21 Jul 2009 14:29:31 -0700
Message-ID: <1248211771.20743.2.camel@bobble.smo.corp.google.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
	 <4A64F37D.7020803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Curt Wohlgemuth <curtw@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:24670 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZGUV3w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jul 2009 17:29:52 -0400
In-Reply-To: <4A64F37D.7020803@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2009-07-20 at 17:45 -0500, Eric Sandeen wrote: 
> Curt Wohlgemuth wrote:
> > We've recently seen some interesting behavior with ftruncate()
> > following a fallocate() call on ext4, and would like to know if this
> > is intended or not.
> > 
> > The sequence used from user space:
> > 
> > fd = open()
> > fallocate(fd, FALLOC_FL_KEEP_SIZE, 8MB)
> > write(fd, buf, 64KB)
> > ftruncate(fd, 64KB)
> > close(fd)
> > 
> > Since inode_setattr() only does something if the input size is not the
> > same as inode->i_size, the ftruncate() call above does nothing; no
> > blocks from the fallocate() are freed up.
> > 
> > Yes, removing the KEEP_SIZE flag gets the behavior I'm expecting, but
> > KEEP_SIZE is quite convenient in recovering from errors.
> > 
> > I would have thought that ftruncate() would alter i_disksize even if
> > this value is different from i_size.
> > 
> > Any comments?  I looked at other Linux file systems, and none that I
> > saw that support fallocate() have this issue.
> > 
> > Thanks,
> > Curt
> 
> Yep, I think you've found a bug, I will look into this soon unless
> someone beats me to it :)

I've spent a little while today digging into this.  My guess (only a
guess at this point until I have a chance to prove it) is that
i_disksize should be updated by fallocate() even when KEEP_SIZE is
specified.  It's currently not updated in that case.  It's my
understanding that i_disksize should be the real allocation, right?
While i_size is the size that has actually been used?  If so, then
setting i_disksize is probably what's missing.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

