From: Jan Kara <jack@suse.cz>
Subject: Re: ext2 on latest -git: BUG: unable to handle kernel paging request at f0f0fffc
Date: Mon, 18 Aug 2008 16:05:42 +0200
Message-ID: <20080818140542.GB10621@atrey.karlin.mff.cuni.cz>
References: <19f34abd0807180419x37d4eb79y5fcecfc1066e0f9c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Josef Bacik <jbacik@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753807AbYHROkK@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19f34abd0807180419x37d4eb79y5fcecfc1066e0f9c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

> I got this with an intentionally corrupted filesystem image. Before
> mounting, I explicitly disabled continue-on-error, like this:
> 
>         tune2fs -f disk -e remount-ro
>         mount -o loop disk mnt
> 
> loop0: rw=0, want=4201400, limit=24576
> Buffer I/O error on device loop0, logical block 2100699
> attempt to access beyond end of device
> loop0: rw=0, want=4201400, limit=24576
> Buffer I/O error on device loop0, logical block 2100699
> EXT2-fs error (device loop0): ext2_free_blocks: Freeing blocks not in
> datazone - block = 131072, count = 1
> Remounting filesystem read-only
> BUG: unable to handle kernel paging request at f0f0fffc

  Hmm, did anybody have a look at this? If not, please file it into the
bugzilla so that it doesn't get lost. You can also assign it to me or
give me CC. I can have a look at it but I'm not sure when I'll have some
time...

> IP: [<c026ee46>] read_block_bitmap+0xc6/0x180
> *pde = 343bf163 *pte = 30f0f160
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 11241, comm: rm Not tainted (2.6.26-03415-gdf3030b #45)
> EIP: 0060:[<c026ee46>] EFLAGS: 00210297 CPU: 1
> EIP is at read_block_bitmap+0xc6/0x180
> EAX: ffffffff EBX: f0f10000 ECX: f4349030 EDX: 00000001
> ESI: f3facbc8 EDI: f0f10800 EBP: f20a3d40 ESP: f20a3d10
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process rm (pid: 11241, ti=f20a2000 task=f207cfb0 task.ti=f20a2000)
> Stack: 00000400 c1fb0520 f20a3d24 c01831f5 00000008 00000000 f424ee10 00000000
>        f0f10000 f0f10400 05c711f5 00000003 f20a3da8 c026f01c f3f35478 f3f35d00
>        f3f351a0 f3f9ee38 00200246 f3f35000 f3eea208 00000031 00000000 00000032
> Call Trace:
>  [<c01831f5>] ? mark_page_accessed+0x45/0x60
>  [<c026f01c>] ? ext2_free_blocks+0x11c/0x320
>  [<c026efad>] ? ext2_free_blocks+0xad/0x320
>  [<c0272f52>] ? ext2_free_branches+0xc2/0x1a0
>  [<c0272fd3>] ? ext2_free_branches+0x143/0x1a0
>  [<c014b360>] ? wake_bit_function+0x0/0x60
>  [<c01c90d6>] ? __wait_on_buffer+0x26/0x30
>  [<c0272fd3>] ? ext2_free_branches+0x143/0x1a0
>  [<c0273552>] ? ext2_truncate+0x522/0x5b0
>  [<c01c89a4>] ? mark_buffer_dirty+0x44/0x80
>  [<c02726db>] ? ext2_update_inode+0x1ab/0x350
>  [<c0273f07>] ? ext2_delete_inode+0x87/0x90
>  [<c0273e80>] ? ext2_delete_inode+0x0/0x90
>  [<c01b9ba1>] ? generic_delete_inode+0x81/0x120
>  [<c01b9d67>] ? generic_drop_inode+0x127/0x180
>  [<c01b8be7>] ? iput+0x47/0x50
>  [<c01af1bc>] ? do_unlinkat+0xec/0x170
>  [<c01b185b>] ? vfs_readdir+0x6b/0xa0
>  [<c01b1540>] ? filldir64+0x0/0xf0
>  [<c0430948>] ? trace_hardirqs_on_thunk+0xc/0x10
>  [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
>  [<c01af383>] ? sys_unlinkat+0x23/0x50
>  [<c010407f>] ? sysenter_past_esp+0x78/0xc5
>  =======================
> Code: 00 00 00 8b 45 e8 8b 1f 8b 55 e4 8b 88 ac 02 00 00 8b 41 34 0f
> af 51 10 03 50 14 89 5d ec 8b 46 18 89 45 f0 89 d8 8b 5d f0 29 d0 <0f>
> a3 03 19 c0 85 c0 74 11 8b 47 04 89 45 ec 29 d0 0f a3 03 19
> EIP: [<c026ee46>] read_block_bitmap+0xc6/0x180 SS:ESP 0068:f20a3d10
> Kernel panic - not syncing: Fatal exception
> 
> $ addr2line -e vmlinux -i c026ee46
> include/asm/bitops.h:305
> fs/ext2/balloc.c:87
> fs/ext2/balloc.c:153
> 
> Is this one:
> 
>         if (!ext2_test_bit(offset, bh->b_data))


									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
