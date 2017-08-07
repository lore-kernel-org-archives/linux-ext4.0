From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ext4: fix warning about stack corruption
Date: Mon, 07 Aug 2017 12:12:33 +0530
Message-ID: <1591040.QxnHWsmrMC@localhost.localdomain>
References: <20170726185219.GA57833@beast> <20170801120438.1582336-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170801120438.1582336-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday, August 1, 2017 5:34:03 PM IST Arnd Bergmann wrote:
> After commit 62d1034f53e3 ("fortify: use WARN instead of BUG for now"),
> we get a warning about possible stack overflow from a memcpy that
> was not strictly bounded to the size of the local variable:
> 
>     inlined from 'ext4_mb_seq_groups_show' at fs/ext4/mballoc.c:2322:2:
> include/linux/string.h:309:9: error: '__builtin_memcpy': writing between 161 and 1116 bytes into a region of size 160 overflows the destination [-Werror=stringop-overflow=]
> 
> We actually had a bug here that would have been found by the warning,
> but it was already fixed last year in commit 30a9d7afe70e ("ext4: fix
> stack memory corruption with 64k block size").
> 
> This replaces the fixed-length structure on the stack with a variable-length
> structure, using the correct upper bound that tells the compiler that
> everything is really fine here. I also change the loop count to check
> for the same upper bound for consistency, but the existing code is
> already correct here.
> 
> Note that while clang won't allow certain kinds of variable-length arrays
> in structures, this particular instance is fine, as the array is at the
> end of the structure, and the size is strictly bounded.
> 
> There is one remaining issue with the function that I'm not addressing
> here: With s_blocksize_bits==16, we don't actually print the last two
> members of the array, as we loop though just the first 14 members.
> This could be easily addressed by adding two extra columns in the output,
> but that could in theory break parsers in user space, and should be
> a separate patch if we decide to modify it.
> 

I executed xfstests on a ppc64 machine with both 4k and 64k block size 
combination.

Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

-- 
chandan
