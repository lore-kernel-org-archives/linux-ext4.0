From: Anton Blanchard <anton@ozlabs.org>
Subject: Re: [PATCH 1/2] ext4: fix warning about stack corruption
Date: Tue, 22 Aug 2017 21:08:49 +1000
Message-ID: <20170822210849.0edb91cc@kryten>
References: <20170726185219.GA57833@beast>
        <20170801120438.1582336-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:36147 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932350AbdHVLIx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Aug 2017 07:08:53 -0400
In-Reply-To: <20170801120438.1582336-1-arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Arnd,

> After commit 62d1034f53e3 ("fortify: use WARN instead of BUG for
> now"), we get a warning about possible stack overflow from a memcpy
> that was not strictly bounded to the size of the local variable:
> 
>     inlined from 'ext4_mb_seq_groups_show' at
> fs/ext4/mballoc.c:2322:2: include/linux/string.h:309:9: error:
> '__builtin_memcpy': writing between 161 and 1116 bytes into a region
> of size 160 overflows the destination [-Werror=stringop-overflow=]
> 
> We actually had a bug here that would have been found by the warning,
> but it was already fixed last year in commit 30a9d7afe70e ("ext4: fix
> stack memory corruption with 64k block size").
> 
> This replaces the fixed-length structure on the stack with a
> variable-length structure, using the correct upper bound that tells
> the compiler that everything is really fine here. I also change the
> loop count to check for the same upper bound for consistency, but the
> existing code is already correct here.
> 
> Note that while clang won't allow certain kinds of variable-length
> arrays in structures, this particular instance is fine, as the array
> is at the end of the structure, and the size is strictly bounded.

Unfortunately it doesn't appear to work, at least with ppc64le clang:

fs/ext4/mballoc.c:2303:17: error: fields must have a constant size: 'variable length array in structure' extension will never be supported
	ext4_grpblk_t counters[blocksize_bits + 2];

Anton
