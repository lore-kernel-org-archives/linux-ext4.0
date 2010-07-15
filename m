From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.35-r5 ext3 corruptions
Date: Thu, 15 Jul 2010 21:26:36 +1000
Message-ID: <20100715112636.GJ30737@dastard>
References: <20100715105745.GI30737@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100715105745.GI30737@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 15, 2010 at 08:57:45PM +1000, Dave Chinner wrote:
> Upgrading my test vms from 2.6.35-rc3 to 2.6.35-rc5 is resulting in
> repeated errors on the root drive of a test VM:
>=20
> { 1532.368808] EXT3-fs error (device sda1): ext3_lookup: deleted inod=
e referenced: 211043
> [ 1532.370859] Aborting journal on device sda1.
> [ 1532.376957] EXT3-fs (sda1):=20
> [ 1532.376976] EXT3-fs (sda1): error: ext3_journal_start_sb: Detected=
 aborted journal
> [ 1532.376980] EXT3-fs (sda1): error: remounting filesystem read-only
> [ 1532.420361] error: remounting filesystem read-only
> [ 1532.621209] EXT3-fs error (device sda1): ext3_lookup: deleted inod=
e referenced: 211043
>=20
> The filesysetm is a mess when checked on reboot - lots of illegal
> references to blocks, multiply linked blocks, etc, but repairs.
> Files are lots, truncated, etc, so there is visible filesystem
> damage.
>=20
> I did lots of testing on 2.6.35-rc3 and came across no problems;
> problems only seemed to start with 2.6.35-rc5, and I've rep=E3=82=8Do=
duced
> the problem on a vanilla 2.6.35-rc4.
>=20
> The problem seems to occur randomly - sometimes during boot or when
> idle after boot, sometimes a while after boot. I haven't done any
> digging at all for the cause - all I've done so far is confirm that
> it is reproducable and it's not my code causing the problem.

=46WIW, a warning is trigging a few seconds after an error occurs:

[ 1025.201140] EXT3-fs error (device sda1): ext3_lookup: deleted inode =
referenced: 211043
[ 1025.203062] Aborting journal on device sda1.
[ 1025.217894] EXT3-fs (sda1): error: remounting filesystem read-only
[ 1025.271198] EXT3-fs error (device sda1): ext3_lookup: deleted inode =
referenced: 211043
[ 1039.116558] ------------[ cut here ]------------
[ 1039.117192] WARNING: at fs/ext3/inode.c:1534 ext3_ordered_writepage+=
0x213/0x230()
[ 1039.120544] Hardware name: Bochs
[ 1039.121036] Modules linked in: [last unloaded: scsi_wait_scan]
[ 1039.122103] Pid: 1838, comm: flush-8:0 Not tainted 2.6.35-rc5-dgc+ #=
34
[ 1039.122837] Call Trace:
[ 1039.123320]  [<ffffffff8107de0f>] warn_slowpath_common+0x7f/0xc0
[ 1039.123892]  [<ffffffff8107de6a>] warn_slowpath_null+0x1a/0x20
[ 1039.124461]  [<ffffffff811dc4d3>] ext3_ordered_writepage+0x213/0x230
[ 1039.125088]  [<ffffffff81114c6a>] __writepage+0x1a/0x50
[ 1039.125652]  [<ffffffff81115a47>] write_cache_pages+0x1f7/0x410
[ 1039.126233]  [<ffffffff81114c50>] ? __writepage+0x0/0x50
[ 1039.126796]  [<ffffffff8107303b>] ? cpuacct_charge+0x9b/0xb0
[ 1039.127371]  [<ffffffff81072fc2>] ? cpuacct_charge+0x22/0xb0
[ 1039.127947]  [<ffffffff8105ed38>] ? pvclock_clocksource_read+0x58/0x=
d0
[ 1039.128574]  [<ffffffff81115c87>] generic_writepages+0x27/0x30
[ 1039.129146]  [<ffffffff81115cc5>] do_writepages+0x35/0x40
[ 1039.129709]  [<ffffffff81171704>] writeback_single_inode+0xe4/0x3e0
[ 1039.130290]  [<ffffffff81171f29>] writeback_sb_inodes+0x199/0x2a0
[ 1039.130869]  [<ffffffff81172756>] writeback_inodes_wb+0x76/0x1a0
[ 1039.131444]  [<ffffffff81172acb>] wb_writeback+0x24b/0x2b0
[ 1039.132001]  [<ffffffff81172cad>] wb_do_writeback+0x17d/0x190
[ 1039.132597]  [<ffffffff81172d17>] bdi_writeback_task+0x57/0x160
[ 1039.133200]  [<ffffffff8109d1a7>] ? bit_waitqueue+0x17/0xc0
[ 1039.133771]  [<ffffffff81125200>] ? bdi_start_fn+0x0/0x100
[ 1039.134327]  [<ffffffff81125286>] bdi_start_fn+0x86/0x100
[ 1039.134876]  [<ffffffff81125200>] ? bdi_start_fn+0x0/0x100
[ 1039.135435]  [<ffffffff8109cdb6>] kthread+0x96/0xa0
[ 1039.135970]  [<ffffffff81035de4>] kernel_thread_helper+0x4/0x10
[ 1039.136575]  [<ffffffff817a5a90>] ? restore_args+0x0/0x30
[ 1039.137128]  [<ffffffff8109cd20>] ? kthread+0x0/0xa0
[ 1039.137701]  [<ffffffff81035de0>] ? kernel_thread_helper+0x0/0x10
[ 1039.138272] ---[ end trace 689f32ae8f9a7104 ]---

Of interest is that it is the same inode number that it tripped over.
It's always been inode numbers in the ~211000 range that have been
reported.

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
