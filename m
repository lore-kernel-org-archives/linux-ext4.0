From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block
 allocation
Date: Tue, 6 Mar 2012 15:29:43 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203061504230.5085@dhcp-27-109.brq.redhat.com>
References: <20120305125029.GA5121@gmail.com> <alpine.LFD.2.00.1203060912170.5085@dhcp-27-109.brq.redhat.com> <20120306135656.GB24695@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965183Ab2CFO3t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 09:29:49 -0500
In-Reply-To: <20120306135656.GB24695@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 Mar 2012, Zheng Liu wrote:

> On Tue, Mar 06, 2012 at 09:27:16AM +0100, Lukas Czerner wrote:
> > On Mon, 5 Mar 2012, Zheng Liu wrote:
> > 
> > > Hi list,
> > > 
> > > Block allocation is a key component of file system.  Every file systems try to
> > > improve the performance with optimizing the block allocation of a file.  But no
> > > matter what file system does, it just guesses what the user expects.  Thus, it
> > > is not very accurate.  fadvise(2) provides a method to let the user to give a
> > > hint to file system.  However, until now, only few flags are provided.  So we
> > > can provide more flags to tell file system how to allocate the blocks for a
> > > file.
> > > 
> > > For example:
> > > we can add these flags into fadvise(2):
> > > FADV_ALLOC_READ_SEQ
> > > FADV_ALLOC_READ_RANDOM
> > > FADV_ALLOC_WRITE_ONCE
> > > FADV_ALLOC_WRITE_APPEND
> > > 
> > > FADV_ALLOC_READ_* are not similar with FADV_SEQUENTIAL and FADV_RANDOM.
> > > FADV_ALLOC_READ_SEQ tells file system that this file need to allocate some
> > > sequential blocks, and FADV_ALLOC_READ_RADOM tells file system that this file
> > > can endure the fragmentation.
> > > 
> > > FADV_ALLOC_WRITE_ONCE indicates that this file just is written once.  So file
> > > system can allocate some sequential blocks for it to improve the read
> > > performance.  FADV_ALLOC_WRITE_APPEND flag is set to point out that data will be
> > > appended to the end of this file, and file system can reserve some blocks for it
> > > to guarantee the sequence as much as possible.
> > 
> > Hi Zheng,
> > 
> > those two flags does not make sense to me. The FADV_ALLOC_WRITE_ONCE is
> > actually the same as fallocate, and we certainly do not need more ways
> > to do fallocate, one is more than enough.
> > 
> > FADV_ALLOC_WRITE_APPEND seems weird. File systems already do some
> > preallocations for the files, so we do not fragment them as much. So
> > what might be more interesting is to be able to set how much space we
> > want to keep preallocated for the particular file, however strictly
> > speaking it is not something we would not achieve with fallocate, but it
> > would certainly be more convenient.
> > 
> > -Lukas
> > 
> 
> Hi Lukas,
> 
> I have realized that these two flags seem redundant, and we don't need
> them.
> 
> As we discussed previously and Sunil's suggestions.  The key issue is
> that user provides a hint to file system, and file system can know
> whether or not this file can be stored in a corner or be allocated in
> non-sequential blocks.  Then the sequential blocks are reserved for the
> particular file that has a *_HOT* flag.  Although fallocate(2) can
> preallocate some blocks for a file, it cannot put a file at the
> beginning of the disk to obtain a better performance.  So maybe file
> system can use these flags to optimize the layout of a file.

However the file system do not have the information which part of the
device it resides on is faster. It might be the beginning of the file
system, but it might not be the case at all.

Moreover the flag which is stating that the file does not have to be
allocated sequentially is not particularly helpful, I can not imagine
people using it. Why would someone want to lower their performance ?
Well, they might think that it will increase performance of the other
files, but that is highly disputable and there are better solutions like
using faster storage for the files that actually needs it.

Additionally *_HOT* flag does not say anything about the allocation
policy. It might be accessed often ,but no in sequential manner, or it
can be written to a lot, it can be appended a lot, or it the content
might be changed without changing its size etc... *Hot* might mean so
many thing that this is just not useful for the file system. It would
certainly be better to come up with something less esoteric which would
actually address concrete user issues and help file system to deal with
them better, like, I do not know, do not fsync/force allocation on
rename maybe...(or whatever we are doing right now).

Thanks!
-Lukas

> 
> Regards,
> Zheng
> 
> > > 
> > > File systems can support a subset of these flags according to its design.  These
> > > flags provide a rich interface that lets the user to control block allocation of
> > > files.  The user could precisely control the allocation of their files to
> > > improve the performance of appliatons.
> > > 
> > > Any comments or suggestions are appreciated.  Thank you.
> > > 
> > > Regards,
> > > Zheng
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > -- 
> 

-- 
