From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] fs: Initialize tmp.b_page in generic_block_bmap()
Date: Mon, 22 May 2017 10:58:45 -0700
Message-ID: <CAGXu5j+XON=8U7BfS2W_YJZh8=0zfeuAPkds9Q+oXZPzvgvkqw@mail.gmail.com>
References: <1482409815-89034-1-git-send-email-glider@google.com>
 <20170118163220.vbdkcjmkkyjmfqxb@thunk.org> <CAG_fn=UEtkQmN3gjn_-1dAf=fRLX0PG7f8GDEHq_7y4B0o3aNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Kostya Serebryany <kcc@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Alexander Potapenko <glider@google.com>,
        Dmitriy Vyukov <dvyukov@google.com>, "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG_fn=UEtkQmN3gjn_-1dAf=fRLX0PG7f8GDEHq_7y4B0o3aNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 28, 2017 at 9:28 AM, Alexander Potapenko <glider@google.com> wrote:
> On Wed, Jan 18, 2017 at 5:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Thu, Dec 22, 2016 at 01:30:15PM +0100, Alexander Potapenko wrote:
>>> KMSAN (KernelMemorySanitizer, a new error detection tool) reports use of
>>> uninitialized memory in ext4_update_bh_state():
>>>
>>> ==================================================================
>>> BUG: KMSAN: use of unitialized memory
>>> CPU: 3 PID: 1 Comm: swapper/0 Tainted: G    B           4.8.0-rc6+ #597
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs
>>> 01/01/2011
>>>  0000000000000282 ffff88003cc96f68 ffffffff81f30856 0000003000000008
>>>  ffff88003cc96f78 0000000000000096 ffffffff8169742a ffff88003cc96ff8
>>>  ffffffff812fc1fc 0000000000000008 ffff88003a1980e8 0000000100000000
>>> Call Trace:
>>>  [<     inline     >] __dump_stack lib/dump_stack.c:15
>>>  [<ffffffff81f30856>] dump_stack+0xa6/0xc0 lib/dump_stack.c:51
>>>  [<ffffffff812fc1fc>] kmsan_report+0x1ec/0x300 mm/kmsan/kmsan.c:?
>>>  [<ffffffff812fc33b>] __msan_warning+0x2b/0x40 ??:?
>>>  [<     inline     >] ext4_update_bh_state fs/ext4/inode.c:727
>>>  [<ffffffff8169742a>] _ext4_get_block+0x6ca/0x8a0 fs/ext4/inode.c:759
>>>  [<ffffffff81696d4c>] ext4_get_block+0x8c/0xa0 fs/ext4/inode.c:769
>>>  [<ffffffff814a2d36>] generic_block_bmap+0x246/0x2b0 fs/buffer.c:2991
>>>  [<ffffffff816ca30e>] ext4_bmap+0x5ee/0x660 fs/ext4/inode.c:3177
>>> ...
>>> origin description: ----tmp@generic_block_bmap
>>> ==================================================================
>>>
>>> (the line numbers are relative to 4.8-rc6, but the bug persists
>>> upstream)
>>>
>>> The local |tmp| is created in generic_block_bmap() and then passed into
>>> ext4_bmap() => ext4_get_block() => _ext4_get_block() =>
>>> ext4_update_bh_state(). Along the way tmp.b_page is never initialized
>>> before ext4_update_bh_state() checks its value.
>>>
>>> Signed-off-by: Alexander Potapenko <glider@google.com>
>>
>> This is a one-line fix to fs/buffer.c; but I've investigated, and
>> since it only affects ext4, and no one else has responded, I'll take
>> the change through the ext4 git tree.
>>
>> Thanks!!
>>
>>                                                 - Ted
>
> Hi Ted,
>
> any updates on this patch?
> Looks like it hasn't been landed yet.

I think the following would be better (pardon any whitespace damage
via gmail...):

diff --git a/fs/buffer.c b/fs/buffer.c
index 161be58c5cb0..20292b858b61 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3021,11 +3021,11 @@ EXPORT_SYMBOL(block_write_full_page);
 sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
                            get_block_t *get_block)
 {
-       struct buffer_head tmp;
        struct inode *inode = mapping->host;
-       tmp.b_state = 0;
-       tmp.b_blocknr = 0;
-       tmp.b_size = i_blocksize(inode);
+       struct buffer_head tmp = {
+               .b_size = i_blocksize(inode);
+       };
+
        get_block(inode, block, &tmp, 0);
        return tmp.b_blocknr;
 }

This will keep all unspecified fields zero-initialized. (i.e. a more
robust fix than just a single zero-initialization being added)

-Kees

-- 
Kees Cook
Pixel Security
