From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH] ext4: handle errors during orphan cleanup
Date: Mon, 14 Dec 2015 19:50:26 +0100
Message-ID: <566F0F72.4040804@oracle.com>
References: <1450115955-11537-1-git-send-email-vegard.nossum@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450115955-11537-1-git-send-email-vegard.nossum@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 12/14/2015 06:59 PM, Vegard Nossum wrote:
> If a filesystem is mounted with errors=remount-ro, then orphan cleanup
> can enter an infinite loop since the iput() inside the linked list
> traversal doesn't actually always cause es->s_last_orphan to advance to
> the next orphan inode (i.e. in case of errors).
>
> The bug manifests in two different ways. It's an endless spew of either:
>
>    EXT4-fs (loop0): Inode 5 (ffff8800153ed720): orphan list check failed!
>    [...]
>    CPU: 1 PID: 957 Comm: mount Not tainted 4.4.0-rc3+ #244
>     ffffffff820ac0c0 ffff88001562f868 ffffffff81610cc9 ffff8800153ed7e0
>     ffff88001562f8a0 ffffffff8133097a 00000000000003e8 ffffffff00000001
>     ffff8800153ed7e0 ffffffff820ac0c0 ffff8800153ed880 ffff88001562f8c0
>    Call Trace:
>     [<ffffffff81610cc9>] dump_stack+0x44/0x5b
>     [<ffffffff8133097a>] ext4_destroy_inode+0xba/0xc0
>     [<ffffffff8125440f>] destroy_inode+0x5f/0x80
>     [<ffffffff81254d75>] evict+0x1e5/0x270
>     [<ffffffff81256217>] iput+0x297/0x350
>     [<ffffffff813393c5>] ext4_fill_super+0x4fa5/0x53b0
>    [...]
>
> or:
>
>    WARNING: CPU: 0 PID: 924 at lib/list_debug.c:36 __list_add+0xf9/0x100()
>    list_add double add: new=00000000dfba0070, prev=00000000dffba970, next=00000000dfba0070.
>    CPU: 0 PID: 924 Comm: mount.exe Tainted: G        W       4.4.0-rc3 #1
>    Stack:
>     df7f59b0 60075642 6071c3ae 00000009
>     df7f5a30 600bc4fe df7f59c0 603f1e5f
>     df7f5a20 600412cd df7f59e0 6040d859
>    Call Trace:
>     [<60029f9b>] show_stack+0xdb/0x1a0
>     [<603f1e5f>] dump_stack+0x2a/0x3b
>     [<600412cd>] warn_slowpath_common+0x9d/0xf0
>     [<600413f4>] warn_slowpath_fmt+0x94/0xa0
>     [<6040d859>] __list_add+0xf9/0x100
>     [<601b28d4>] ext4_fill_super+0x3e04/0x4040
>    [...]
>
> This was the smallest change I could find that still covers all the
> cases I ran into. It probably also makes sense intuitively to not
> continue orphan cleanup if there was an error in the meantime.

Oh, nevermind, I just hit another case that apparently isn't covered :-(


Vegard
