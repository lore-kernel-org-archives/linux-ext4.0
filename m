From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: Please apply these two patches to the 3.18 stable branch
Date: Mon, 28 Sep 2015 14:39:11 +0100
Message-ID: <20150928133911.GE2548@ares>
References: <20150922180607.GA1948@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: stable@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150922180607.GA1948@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 22, 2015 at 02:06:07PM -0400, Theodore Ts'o wrote:
> The upstream commits are:
>=20
> 0f2af21aae1197 ext4: allocate entire range in zero range
> 94426f4b964815 ext4: fix loss of delalloc extent info in ext4_zero_ra=
nge()
>

The first patch is already in the 3.16 kernel; I'm queuing the second o=
ne
as well for this kernel.

Cheers,
--
Lu=EDs

> The first patch in particular is needed to address the following fail=
ure:
>=20
>     kernel BUG at /usr/projects/linux/ext4-3.18/fs/ext4/inode.c:1242!
>     invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
>     CPU: 0 PID: 17896 Comm: xfs_io Not tainted 3.18.21-ext4 #2
>     Hardware name: Google Google, BIOS Google 01/01/2011
>     task: ffff8802104ec7d0 ti: ffff8801f95bc000 task.ti: ffff8801f95b=
c000
>     RIP: 0010:[<ffffffff81216978>]  [<ffffffff81216978>] ext4_da_inva=
lidatepage+0x61/0x293
>     RSP: 0018:ffff8801f95bfcf8  EFLAGS: 00010286
>     RAX: 0000000000000400 RBX: ffffea0002bec500 RCX: 0100000000000825
>     RDX: 00000000fffffc00 RSI: 0000000000000400 RDI: ffffea0002bec500
>     RBP: ffff8800b9ffed78 R08: 0000000000000000 R09: 0000000000000000
>     R10: ffff8801f95bfce8 R11: ffff8800b9ee8de0 R12: 0000000000000001
>     R13: 00000000fffffc00 R14: 0000000000000400 R15: 0000000000000000
>     FS:  00000000009a0880(0063) GS:ffff88021de00000(0000) knlGS:00000=
00000000000
>     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     CR2: 00007fa6ba80d000 CR3: 0000000210633000 CR4: 00000000001406f0
>     Stack:
>     0000040000000000 0000000000000002 0000000000000002 ffffffff8114e9=
f2
>     0000000000000000 0000000000000002 ffff8800b9ffed78 00000000000000=
01
>     ffffea0002bec500 0000000000000400 0000000000000000 ffffffff81159a=
98
>     Call Trace:
>     [<ffffffff8114e9f2>] ? pagecache_get_page+0x27/0x14e
>     [<ffffffff81159a98>] ? truncate_inode_pages_range+0x226/0x427
>     [<ffffffff81159572>] ? __pagevec_release+0x23/0x2c
>     [<ffffffff8114e21e>] ? filemap_fdatawait_range+0xec/0x105
>     [<ffffffff8123bf19>] ? ext4_fallocate+0x27e/0x6d2
>     [<ffffffff8118d478>] ? do_fallocate+0x137/0x161
>     [<ffffffff8118d4eb>] ? SyS_fallocate+0x49/0x65
>     [<ffffffff81661889>] ? system_call_fastpath+0x12/0x17
>     Code: 44 89 ea 48 89 df 5b 5d 41 5c 41 5d 41 5e 41 5f e9 3c ec ff=
 ff 8b 44 24 04 44 8d 0c 10 41 81 f9 00 10 00 00 77 05 44 39 ca 76 02 <=
0f> 0b 48 8b 07 f6 c4 08 75 02 0f 0b 48 8b 47 08 31 d2 31 ed 4c=20
>     RIP  [<ffffffff81216978>] ext4_da_invalidatepage+0x61/0x293
>     RSP <ffff8801f95bfcf8>
>=20
> .... which can be triggered by calling fallocate with
> FALLOC_FL_ZERO_RANGE on a file with in a file system using a 1k
> blocksize with an offset of 4300 and a length of 512 bytes.
>=20
> Many thanks!
>=20
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
