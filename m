From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: fix warning about stack corruption
Date: Sat, 5 Aug 2017 21:53:24 -0400
Message-ID: <20170806015324.yg7gc45c77zemtlh@thunk.org>
References: <20170726185219.GA57833@beast>
 <20170801120438.1582336-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170801120438.1582336-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 01, 2017 at 02:04:03PM +0200, Arnd Bergmann wrote:
> There is one remaining issue with the function that I'm not addressing
> here: With s_blocksize_bits==16, we don't actually print the last two
> members of the array, as we loop though just the first 14 members.
> This could be easily addressed by adding two extra columns in the output,
> but that could in theory break parsers in user space, and should be
> a separate patch if we decide to modify it.

Actually, the counters array is blocksize_bits+2 in length.  So for
all block sizes greater than 4k (blocksize_bits == 12), we're not
iterating over all of the free space counters maintained by mballoc.
However, since most Linux systems run architectures where the page
size is 4k, and the Linux VM really doesn't easily support file system
block sizes greater than the page size, this really isn't an issue
except on Itanics and Power systems.

I very much doubt there are userspace parsers who depend on this,
since far too many programmers subscribe to the "All the world's an
x86" theory, in direct contravention of Henry Spencer's Tenth
commandment:

	https://www.lysator.liu.se/c/ten-commandments.html

But indeed, it's a separate patch for another day.

Thanks, I'll apply this patch.

						- Ted
