From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 14 Apr 2011 11:49:19 -0500
Message-ID: <4DA7258F.1080302@sandeen.net>
References: <20110414120635.GB1678@x4.trippels.de> <20110414140222.GB1679@x4.trippels.de> <4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net> <4DA7182B.8050409@draigBrady.com> <4DA71920.9@sandeen.net> <20110414160343.GA12787@x4.trippels.de> <BANLkTimRxvBMp9M7zwiUY_UmmFOY5N58+A@mail.gmail.com> <20110414162856.GA21658@x4.trippels.de> <4DA7214C.4070602@sandeen.net> <20110414164811.GB21658@x4.trippels.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	=?ISO-8859-1?Q?P=E1draig_Br?= =?ISO-8859-1?Q?ady?=
	<P@draigbrady.com>, xfs-oss <xfs@oss.sgi.com>,
	linux-ext4@vger.kernel.org, coreutils@gnu.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49784 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1DNQtU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 12:49:20 -0400
In-Reply-To: <20110414164811.GB21658@x4.trippels.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/14/11 11:48 AM, Markus Trippelsdorf wrote:
> On 2011.04.14 at 11:31 -0500, Eric Sandeen wrote:
>> On 4/14/11 11:28 AM, Markus Trippelsdorf wrote:
>>
>> <snip>
>>
>>> Yes, but we're still trying to find out what caused the zeros in the
>>> binaries that coreutils installed on my system.
>>>
>>> Now the failure only happens when I use "gold" as my linker. With GNU ld
>>> everything is OK. But I thought this must be a timing issue, because
>>> gold is faster and the binaries in coreutils-8.11/src are all fine.
>>
>> maybe xfs_bmap (or filefrag) of the binaries with both linkers would be instructive; are they laid out significantly differently?
>>
>> does gold preallocate?
> 
> Just checked and yes it does. That should explain the issue I was
> seeing.

Well, mystery solved there, at least!

Now for the fixing part :)

Thanks for checking, at least my view of the world is still intact ;)

-Eric

> bool
> Output_file::map_no_anonymous()
> {
>   const int o = this->o_;
> 
>   // If the output file is not a regular file, don't try to mmap it;
>   // instead, we'll mmap a block of memory (an anonymous buffer), and
>   // then later write the buffer to the file.
>   void* base;
>   struct stat statbuf;
>   if (o == STDOUT_FILENO || o == STDERR_FILENO
>       || ::fstat(o, &statbuf) != 0
>       || !S_ISREG(statbuf.st_mode)
>       || this->is_temporary_)
>     return false;
> 
>   // Ensure that we have disk space available for the file.  If we
>   // don't do this, it is possible that we will call munmap, close,
>   // and exit with dirty buffers still in the cache with no assigned
>   // disk blocks.  If the disk is out of space at that point, the
>   // output file will wind up incomplete, but we will have already
>   // exited.  The alternative to fallocate would be to use fdatasync,
>   // but that would be a more significant performance hit.
>   if (::posix_fallocate(o, 0, this->file_size_) < 0)
>     gold_fatal(_("%s: %s"), this->name_, strerror(errno));
> 
>   // Map the file into memory.
>   base = ::mmap(NULL, this->file_size_, PROT_READ | PROT_WRITE,
> 		MAP_SHARED, o, 0);
> 
>   // The mmap call might fail because of file system issues: the file
>   // system might not support mmap at all, or it might not support
>   // mmap with PROT_WRITE.
>   if (base == MAP_FAILED)
>     return false;
> 
>   this->map_is_anonymous_ = false;
>   this->base_ = static_cast<unsigned char*>(base);
>   return true;
> }
> 
> 

