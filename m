From: Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH] fs: Initialize tmp.b_page in generic_block_bmap()
Date: Mon, 26 Jun 2017 12:06:02 +0200
Message-ID: <CAG_fn=X51VhM=e=eSX0piw3PUQnsqrx3tVT6=w-HvBNJAA29=g@mail.gmail.com>
References: <1482409815-89034-1-git-send-email-glider@google.com> <20170118163220.vbdkcjmkkyjmfqxb@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Theodore Ts'o" <tytso@mit.edu>,
        Alexander Potapenko <glider@google.com>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170118163220.vbdkcjmkkyjmfqxb@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Theodore,

Looks like the patch hasn't been landed yet, could you please revisit it?

Thanks,
Alex


On Wed, Jan 18, 2017 at 5:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Dec 22, 2016 at 01:30:15PM +0100, Alexander Potapenko wrote:
>> KMSAN (KernelMemorySanitizer, a new error detection tool) reports use of
>> uninitialized memory in ext4_update_bh_state():
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KMSAN: use of unitialized memory
>> CPU: 3 PID: 1 Comm: swapper/0 Tainted: G    B           4.8.0-rc6+ #597
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs
>> 01/01/2011
>>  0000000000000282 ffff88003cc96f68 ffffffff81f30856 0000003000000008
>>  ffff88003cc96f78 0000000000000096 ffffffff8169742a ffff88003cc96ff8
>>  ffffffff812fc1fc 0000000000000008 ffff88003a1980e8 0000000100000000
>> Call Trace:
>>  [<     inline     >] __dump_stack lib/dump_stack.c:15
>>  [<ffffffff81f30856>] dump_stack+0xa6/0xc0 lib/dump_stack.c:51
>>  [<ffffffff812fc1fc>] kmsan_report+0x1ec/0x300 mm/kmsan/kmsan.c:?
>>  [<ffffffff812fc33b>] __msan_warning+0x2b/0x40 ??:?
>>  [<     inline     >] ext4_update_bh_state fs/ext4/inode.c:727
>>  [<ffffffff8169742a>] _ext4_get_block+0x6ca/0x8a0 fs/ext4/inode.c:759
>>  [<ffffffff81696d4c>] ext4_get_block+0x8c/0xa0 fs/ext4/inode.c:769
>>  [<ffffffff814a2d36>] generic_block_bmap+0x246/0x2b0 fs/buffer.c:2991
>>  [<ffffffff816ca30e>] ext4_bmap+0x5ee/0x660 fs/ext4/inode.c:3177
>> ...
>> origin description: ----tmp@generic_block_bmap
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> (the line numbers are relative to 4.8-rc6, but the bug persists
>> upstream)
>>
>> The local |tmp| is created in generic_block_bmap() and then passed into
>> ext4_bmap() =3D> ext4_get_block() =3D> _ext4_get_block() =3D>
>> ext4_update_bh_state(). Along the way tmp.b_page is never initialized
>> before ext4_update_bh_state() checks its value.
>>
>> Signed-off-by: Alexander Potapenko <glider@google.com>
>
> This is a one-line fix to fs/buffer.c; but I've investigated, and
> since it only affects ext4, and no one else has responded, I'll take
> the change through the ext4 git tree.
>
> Thanks!!
>
>                                                 - Ted



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Matthew Scott Sucherman, Paul Terence Manicle
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
