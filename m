From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 1/2] ext4: Include forgotten start block on fallocate
 insert range
Date: Sat, 7 Jan 2017 16:22:10 -0500
Message-ID: <20170107212210.2repgu7cm6mtimek@thunk.org>
References: <20170106202601.32722-1-roman.penyaev@profitbricks.com>
 <20170106202601.32722-2-roman.penyaev@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <namjae.jeon@samsung.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Roman Pen <roman.penyaev@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170106202601.32722-2-roman.penyaev@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 06, 2017 at 09:26:00PM +0100, Roman Pen wrote:
> While doing 'insert range' start block should be also shifted right.
> The bug can be easily reproduced by the following test:
> 
>     ptr = malloc(4096);
>     assert(ptr);
> 
>     fd = open("./ext4.file", O_CREAT | O_TRUNC | O_RDWR, 0600);
>     assert(fd >= 0);
> 
>     rc = fallocate(fd, 0, 0, 8192);
>     assert(rc == 0);
>     for (i = 0; i < 2048; i++)
>             *((unsigned short *)ptr + i) = 0xbeef;
>     rc = pwrite(fd, ptr, 4096, 0);
>     assert(rc == 4096);
>     rc = pwrite(fd, ptr, 4096, 4096);
>     assert(rc == 4096);
> 
>     for (block = 2; block < 1000; block++) {
>             rc = fallocate(fd, FALLOC_FL_INSERT_RANGE, 4096, 4096);
>             assert(rc == 0);
> 
>             for (i = 0; i < 2048; i++)
>                     *((unsigned short *)ptr + i) = block;
> 
>             rc = pwrite(fd, ptr, 4096, 4096);
>             assert(rc == 4096);
>     }
> 
> Because start block is not included in the range the hole appears at
> the wrong offset (just after the desired offset) and the following
> pwrite() overwrites already existent block, keeping hole untouched.
> 
> Simple way to verify wrong behaviour is to check zeroed blocks after
> the test:
> 
>    $ hexdump ./ext4.file | grep '0000 0000'
> 
> The root cause of the bug is a wrong range (start, stop], where start
> should be inclusive, i.e. [start, stop].
> 
> This patch fixes the problem by including start into the range.  But
> not to break left shift (range collapse) stop points to the beginning
> of the a block, not to the end.
> 
> The other not obvious change is an iterator check on validness in a
> main loop.  Because iterator is unsigned the following corner case
> should be considered with care: insert a block at 0 offset, when stop
> variables overflows and never becomes less than start, which is 0.
> To handle this special case iterator is set to NULL to indicate that
> end of the loop is reached.
> 
> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>

Thanks, applied.

					- Ted
