From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Question on fallocate/ftruncate sequence
Date: Mon, 20 Jul 2009 17:45:17 -0500
Message-ID: <4A64F37D.7020803@redhat.com>
References: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49239 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbZGTWpX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2009 18:45:23 -0400
In-Reply-To: <6601abe90907200936w61ebda92reae368a2b9efac66@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Curt Wohlgemuth wrote:
> We've recently seen some interesting behavior with ftruncate()
> following a fallocate() call on ext4, and would like to know if this
> is intended or not.
> 
> The sequence used from user space:
> 
> fd = open()
> fallocate(fd, FALLOC_FL_KEEP_SIZE, 8MB)
> write(fd, buf, 64KB)
> ftruncate(fd, 64KB)
> close(fd)
> 
> Since inode_setattr() only does something if the input size is not the
> same as inode->i_size, the ftruncate() call above does nothing; no
> blocks from the fallocate() are freed up.
> 
> Yes, removing the KEEP_SIZE flag gets the behavior I'm expecting, but
> KEEP_SIZE is quite convenient in recovering from errors.
> 
> I would have thought that ftruncate() would alter i_disksize even if
> this value is different from i_size.
> 
> Any comments?  I looked at other Linux file systems, and none that I
> saw that support fallocate() have this issue.
> 
> Thanks,
> Curt

Yep, I think you've found a bug, I will look into this soon unless
someone beats me to it :)

-Eric
