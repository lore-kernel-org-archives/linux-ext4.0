From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/32] ext4: lock inode before calling ext4_orphan_add()
Date: Wed, 21 Jun 2017 21:20:50 -0400
Message-ID: <20170622012050.j7zrfiflipc67dpk@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-3-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-3-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:13PM -0700, Tahsin Erdogan wrote:
> ext4_orphan_add() requires caller to be holding the inode lock.
> Add missing lock statements.
> 
>  WARNING: CPU: 3 PID: 1806 at fs/ext4/namei.c:2731 ext4_orphan_add+0x4e/0x240
>  CPU: 3 PID: 1806 Comm: python Not tainted 4.12.0-rc1+ #746
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>  task: ffff880135d466c0 task.stack: ffffc900014b0000
>  RIP: 0010:ext4_orphan_add+0x4e/0x240
>  RSP: 0018:ffffc900014b3d50 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff8801348fe1f0 RCX: ffffc900014b3c64
>  RDX: 0000000000000000 RSI: ffff8801348fe1f0 RDI: ffff8801348fe1f0
>  RBP: ffffc900014b3da0 R08: 0000000000000000 R09: ffffffff80e82025
>  R10: 0000000000004692 R11: 000000000000468d R12: ffff880137598000
>  R13: ffff880137217000 R14: ffff880134ac58d0 R15: 0000000000000000
>  FS:  00007fc50f09e740(0000) GS:ffff88013fd80000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00000000008bc2e0 CR3: 00000001375ac000 CR4: 00000000000006e0
>  Call Trace:
>   ext4_xattr_inode_orphan_add.constprop.19+0x9d/0xf0
>   ext4_xattr_delete_inode+0x1c4/0x2f0
>   ext4_evict_inode+0x15a/0x7f0
>   evict+0xc0/0x1a0
>   iput+0x16a/0x270
>   do_unlinkat+0x172/0x290
>   SyS_unlink+0x11/0x20
>   entry_SYSCALL_64_fastpath+0x18/0xad
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, added to the ext4 patch queue.

						- Ted
