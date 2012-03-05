From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block allocation
Date: Mon, 05 Mar 2012 11:48:43 -0800
Message-ID: <4F55189B.4080507@oracle.com>
References: <20120305125029.GA5121@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120305125029.GA5121@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/05/2012 04:50 AM, Zheng Liu wrote:
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


File systems typically allocate the best layout they can for a file
at the time of write. Does _RANDOM mean do not do that. Find single
bits scattered around the disk. If so, why will people use it. I mean, 
random IOs are slow. What you are proposing it is a further slowdown.
Hardly a feature that will be attractive to users.


> FADV_ALLOC_WRITE_ONCE indicates that this file just is written once.  So file
> system can allocate some sequential blocks for it to improve the read
> performance.  FADV_ALLOC_WRITE_APPEND flag is set to point out that data will be
> appended to the end of this file, and file system can reserve some blocks for it
> to guarantee the sequence as much as possible.


Define ONCE. Is it one write(2)? I guess not. You probably mean
that once the file descriptor is closed, it will not be written
to. But we have no way of knowing how many writes there will be.
So it will be treated the same as APPEND. And file systems already
provide allocation reservation and/or delayed allocation to handle
APPEND write loads. So this flag does not offer much to the user
or the fs.
