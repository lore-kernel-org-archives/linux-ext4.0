From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] ext4: fix warning about stack corruption
Date: Sun, 6 Aug 2017 22:34:14 +0200
Message-ID: <CAK8P3a0UWU_0dccmnZmP7zPaPbzo_c7X5YkYk=g07cHbmoRY_A@mail.gmail.com>
References: <20170726185219.GA57833@beast> <20170801120438.1582336-1-arnd@arndb.de>
 <20170806015324.yg7gc45c77zemtlh@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Ts'o" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806015324.yg7gc45c77zemtlh@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Aug 6, 2017 at 3:53 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Aug 01, 2017 at 02:04:03PM +0200, Arnd Bergmann wrote:
>> There is one remaining issue with the function that I'm not addressing
>> here: With s_blocksize_bits==16, we don't actually print the last two
>> members of the array, as we loop though just the first 14 members.
>> This could be easily addressed by adding two extra columns in the output,
>> but that could in theory break parsers in user space, and should be
>> a separate patch if we decide to modify it.
>
> Actually, the counters array is blocksize_bits+2 in length.  So for
> all block sizes greater than 4k (blocksize_bits == 12), we're not
> iterating over all of the free space counters maintained by mballoc.

Ah, makes sense.

> However, since most Linux systems run architectures where the page
> size is 4k, and the Linux VM really doesn't easily support file system
> block sizes greater than the page size, this really isn't an issue
> except on Itanics and Power systems.

Red Hat also build their arm64 kernels with 64k pages for some odd
reason I could never quite understand.

> Thanks, I'll apply this patch.

Thanks!

     Arnd
