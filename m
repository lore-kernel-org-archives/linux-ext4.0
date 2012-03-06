From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block
 allocation
Date: Tue, 6 Mar 2012 10:35:05 +0800
Message-ID: <20120306023505.GA7728@gmail.com>
References: <20120305125029.GA5121@gmail.com>
 <4F55189B.4080507@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52151 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab2CFC35 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Mar 2012 21:29:57 -0500
Content-Disposition: inline
In-Reply-To: <4F55189B.4080507@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 05, 2012 at 11:48:43AM -0800, Sunil Mushran wrote:
> On 03/05/2012 04:50 AM, Zheng Liu wrote:
> >Hi list,
> >
> >Block allocation is a key component of file system.  Every file systems try to
> >improve the performance with optimizing the block allocation of a file.  But no
> >matter what file system does, it just guesses what the user expects.  Thus, it
> >is not very accurate.  fadvise(2) provides a method to let the user to give a
> >hint to file system.  However, until now, only few flags are provided.  So we
> >can provide more flags to tell file system how to allocate the blocks for a
> >file.
> >
> >For example:
> >we can add these flags into fadvise(2):
> >FADV_ALLOC_READ_SEQ
> >FADV_ALLOC_READ_RANDOM
> >FADV_ALLOC_WRITE_ONCE
> >FADV_ALLOC_WRITE_APPEND
> >
> >FADV_ALLOC_READ_* are not similar with FADV_SEQUENTIAL and FADV_RANDOM.
> >FADV_ALLOC_READ_SEQ tells file system that this file need to allocate some
> >sequential blocks, and FADV_ALLOC_READ_RADOM tells file system that this file
> >can endure the fragmentation.

Hi Sunil,

Thank you for your feedback.

> 
> 
> File systems typically allocate the best layout they can for a file
> at the time of write. Does _RANDOM mean do not do that. Find single
> bits scattered around the disk. If so, why will people use it. I
> mean, random IOs are slow. What you are proposing it is a further
> slowdown.
> Hardly a feature that will be attractive to users.

No, _RANDOM means that file system doesn't need to try its best to find
a proper position to allocate some blocks for this file.  Furthermore,
currently random IOs seem that they are not obviously slower than
sequential IOs in Flash/SSD device.  For example, when users know a file
that is accessed infrequently, they can put this file in a corner, such
as in some discontinuously blocks.  Then sequential blocks are reserved
for the file that needs to be accessed frequently and users can obtain
the better performance.

> 
> 
> >FADV_ALLOC_WRITE_ONCE indicates that this file just is written once.  So file
> >system can allocate some sequential blocks for it to improve the read
> >performance.  FADV_ALLOC_WRITE_APPEND flag is set to point out that data will be
> >appended to the end of this file, and file system can reserve some blocks for it
> >to guarantee the sequence as much as possible.
> 
> 
> Define ONCE. Is it one write(2)? I guess not. You probably mean
> that once the file descriptor is closed, it will not be written
> to. But we have no way of knowing how many writes there will be.
> So it will be treated the same as APPEND. And file systems already
> provide allocation reservation and/or delayed allocation to handle
> APPEND write loads. So this flag does not offer much to the user
> or the fs.

Sorry, I don't express clearly. _ONCE means that the size of a file
doesn't be chagned after it has been created. Certainly, you are right.
We can use fallocate(2) to obtain the same result. ;-)

Regards,
Zheng

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
