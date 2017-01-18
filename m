From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs: Initialize tmp.b_page in generic_block_bmap()
Date: Wed, 18 Jan 2017 11:32:21 -0500
Message-ID: <20170118163220.vbdkcjmkkyjmfqxb@thunk.org>
References: <1482409815-89034-1-git-send-email-glider@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dvyukov@google.com, kcc@google.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
To: Alexander Potapenko <glider@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1482409815-89034-1-git-send-email-glider@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 22, 2016 at 01:30:15PM +0100, Alexander Potapenko wrote:
> KMSAN (KernelMemorySanitizer, a new error detection tool) reports use of
> uninitialized memory in ext4_update_bh_state():
> 
> ==================================================================
> BUG: KMSAN: use of unitialized memory
> CPU: 3 PID: 1 Comm: swapper/0 Tainted: G    B           4.8.0-rc6+ #597
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs
> 01/01/2011
>  0000000000000282 ffff88003cc96f68 ffffffff81f30856 0000003000000008
>  ffff88003cc96f78 0000000000000096 ffffffff8169742a ffff88003cc96ff8
>  ffffffff812fc1fc 0000000000000008 ffff88003a1980e8 0000000100000000
> Call Trace:
>  [<     inline     >] __dump_stack lib/dump_stack.c:15
>  [<ffffffff81f30856>] dump_stack+0xa6/0xc0 lib/dump_stack.c:51
>  [<ffffffff812fc1fc>] kmsan_report+0x1ec/0x300 mm/kmsan/kmsan.c:?
>  [<ffffffff812fc33b>] __msan_warning+0x2b/0x40 ??:?
>  [<     inline     >] ext4_update_bh_state fs/ext4/inode.c:727
>  [<ffffffff8169742a>] _ext4_get_block+0x6ca/0x8a0 fs/ext4/inode.c:759
>  [<ffffffff81696d4c>] ext4_get_block+0x8c/0xa0 fs/ext4/inode.c:769
>  [<ffffffff814a2d36>] generic_block_bmap+0x246/0x2b0 fs/buffer.c:2991
>  [<ffffffff816ca30e>] ext4_bmap+0x5ee/0x660 fs/ext4/inode.c:3177
> ...
> origin description: ----tmp@generic_block_bmap
> ==================================================================
> 
> (the line numbers are relative to 4.8-rc6, but the bug persists
> upstream)
> 
> The local |tmp| is created in generic_block_bmap() and then passed into
> ext4_bmap() => ext4_get_block() => _ext4_get_block() =>
> ext4_update_bh_state(). Along the way tmp.b_page is never initialized
> before ext4_update_bh_state() checks its value.
> 
> Signed-off-by: Alexander Potapenko <glider@google.com>

This is a one-line fix to fs/buffer.c; but I've investigated, and
since it only affects ext4, and no one else has responded, I'll take
the change through the ext4 git tree.

Thanks!!

						- Ted
