From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block
 allocation
Date: Tue, 6 Mar 2012 09:27:16 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203060912170.5085@dhcp-27-109.brq.redhat.com>
References: <20120305125029.GA5121@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120305125029.GA5121@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 5 Mar 2012, Zheng Liu wrote:

> Hi list,
> 
> Block allocation is a key component of file system.  Every file systems try to
> improve the performance with optimizing the block allocation of a file.  But no
> matter what file system does, it just guesses what the user expects.  Thus, it
> is not very accurate.  fadvise(2) provides a method to let the user to give a
> hint to file system.  However, until now, only few flags are provided.  So we
> can provide more flags to tell file system how to allocate the blocks for a
> file.
> 
> For example:
> we can add these flags into fadvise(2):
> FADV_ALLOC_READ_SEQ
> FADV_ALLOC_READ_RANDOM
> FADV_ALLOC_WRITE_ONCE
> FADV_ALLOC_WRITE_APPEND
> 
> FADV_ALLOC_READ_* are not similar with FADV_SEQUENTIAL and FADV_RANDOM.
> FADV_ALLOC_READ_SEQ tells file system that this file need to allocate some
> sequential blocks, and FADV_ALLOC_READ_RADOM tells file system that this file
> can endure the fragmentation.
> 
> FADV_ALLOC_WRITE_ONCE indicates that this file just is written once.  So file
> system can allocate some sequential blocks for it to improve the read
> performance.  FADV_ALLOC_WRITE_APPEND flag is set to point out that data will be
> appended to the end of this file, and file system can reserve some blocks for it
> to guarantee the sequence as much as possible.

Hi Zheng,

those two flags does not make sense to me. The FADV_ALLOC_WRITE_ONCE is
actually the same as fallocate, and we certainly do not need more ways
to do fallocate, one is more than enough.

FADV_ALLOC_WRITE_APPEND seems weird. File systems already do some
preallocations for the files, so we do not fragment them as much. So
what might be more interesting is to be able to set how much space we
want to keep preallocated for the particular file, however strictly
speaking it is not something we would not achieve with fallocate, but it
would certainly be more convenient.

-Lukas

> 
> File systems can support a subset of these flags according to its design.  These
> flags provide a rich interface that lets the user to control block allocation of
> files.  The user could precisely control the allocation of their files to
> improve the performance of appliatons.
> 
> Any comments or suggestions are appreciated.  Thank you.
> 
> Regards,
> Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
