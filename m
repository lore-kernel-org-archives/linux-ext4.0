From: Jan Kara <jack@suse.cz>
Subject: Re: v4.16-rc2: virtio-block + ext4 lockdep splats / sleeping from
	invalid context
Date: Mon, 26 Feb 2018 11:52:56 +0100
Message-ID: <20180226105256.jagidoki6vsrvzb4@quack2.suse.cz>
References: <20180223154735.x4ezmpjbjm6o6duw@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pm2vxkhhandoykr2"
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
	"Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-block@vger.kernel.org, Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20180223154735.x4ezmpjbjm6o6duw@lakrids.cambridge.arm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-ext4.vger.kernel.org


--pm2vxkhhandoykr2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 23-02-18 15:47:36, Mark Rutland wrote:
> Hi all,
>=20
> While fuzzing arm64/v4.16-rc2 with syzkaller, I simultaneously hit a
> number of splats in the block layer:
>=20
> * inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-R} usage in
>   jbd2_trans_will_send_data_barrier
>=20
> * BUG: sleeping function called from invalid context at mm/mempool.c:320
>=20
> * WARNING: CPU: 0 PID: 0 at block/blk.h:297 generic_make_request_checks+0=
x670/0x750
>=20
> ... I've included the full splats at the end of the mail.
>=20
> These all happen in the context of the virtio block IRQ handler, so I
> wonder if this calls something that doesn't expect to be called from IRQ
> context. Is it valid to call blk_mq_complete_request() or
> blk_mq_end_request() from an IRQ handler?

No, it's likely a bug in detection whether IO completion should be deferred
to a workqueue or not. Does attached patch fix the problem? I don't see
exactly this being triggered by the syzkaller but it's close enough :)

								Honza


> Syzkaller came up with a minimized reproducer, but it's a bit wacky (the
> fcntl and bpf calls should have no practical effect), and I haven't
> managed to come up with a C reproducer.
>=20
> Any ideas?
>=20
> Thanks,
> Mark.
>=20
>=20
> Syzkaller reproducer:
> # {Threaded:true Collide:true Repeat:false Procs:1 Sandbox:setuid Fault:f=
alse FaultCall:-1 FaultNth:0 EnableTun:true UseTmpDir:true HandleSegv:true =
WaitRepeat:false Debug:false Repro:false}
> mmap(&(0x7f0000000000/0x24000)=3Dnil, 0x24000, 0x3, 0x32, 0xfffffffffffff=
fff, 0x0)
> r0 =3D openat(0xffffffffffffff9c, &(0x7f0000019000-0x8)=3D'./file0\x00', =
0x42, 0x0)
> fcntl$setstatus(r0, 0x4, 0x10000)
> ftruncate(r0, 0x400)
> io_setup(0x1f, &(0x7f0000018000)=3D<r1=3D>0x0)
> io_submit(r1, 0x1, &(0x7f000001d000-0x28)=3D[&(0x7f000001b000)=3D{0x0, 0x=
0, 0x0, 0x1, 0x0, r0, &(0x7f0000022000-0x1000)=3D"0000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000000000000000000=
0000000000000000000000000000000
>  000000000000000000000000000000000000000000000000000000000000000000000000=
00000000000000000000000000000000000000000000000000000000000000000000000", 0=
x200, 0x0, 0x0, 0x0, 0x0}])
> bpf$BPF_PROG_ATTACH(0xffffffff, &(0x7f000001b000)=3D{0x0, 0x0, 0x3, 0x2},=
 0x40000000)
>=20
>=20
> Full splat:
> [  162.337073] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [  162.338055] WARNING: inconsistent lock state
> [  162.339017] 4.16.0-rc2 #1 Not tainted
> [  162.339797] --------------------------------
> [  162.340725] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-R} usage.
> [  162.342030] swapper/0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [  162.343061]  (&journal->j_state_lock){+?++}, at: [<000000003b9c3e4b>] =
jbd2_trans_will_send_data_barrier+0x44/0xc8
> [  162.353187] {HARDIRQ-ON-W} state was registered at:
> [  162.354433]   lock_acquire+0x48/0x68
> [  162.358640]   _raw_write_lock+0x3c/0x50
> [  162.360716]   ext4_init_journal_params.isra.6+0x40/0xa0
> [  162.363445]   ext4_fill_super+0x25cc/0x2e88
> [  162.364481]   mount_bdev+0x19c/0x1d8
> [  162.365345]   ext4_mount+0x14/0x20
> [  162.366130]   mount_fs+0x34/0x160
> [  162.366790]   vfs_kern_mount.part.8+0x54/0x160
> [  162.367874]   do_mount+0x540/0xd40
> [  162.373776]   SyS_mount+0x68/0x100
> [  162.374467]   mount_block_root+0x11c/0x28c
> [  162.376558]   mount_root+0x130/0x164
> [  162.380753]   prepare_namespace+0x138/0x180
> [  162.381729]   kernel_init_freeable+0x25c/0x280
> [  162.382625]   kernel_init+0x10/0x100
> [  162.383337]   ret_from_fork+0x10/0x18
> [  162.384072] irq event stamp: 3670810
> [  162.384787] hardirqs last  enabled at (3670805): [<00000000fa98454e>] =
arch_cpu_idle+0x14/0x28
> [  162.386505] hardirqs last disabled at (3670806): [<00000000341112e2>] =
el1_irq+0x74/0x130
> [  162.388107] softirqs last  enabled at (3670810): [<00000000d00bd211>] =
_local_bh_enable+0x20/0x40
> [  162.389880] softirqs last disabled at (3670809): [<00000000e929005c>] =
irq_enter+0x54/0x70
> [  162.391443]
> [  162.391443] other info that might help us debug this:
> [  162.392680]  Possible unsafe locking scenario:
> [  162.392680]
> [  162.405967]        CPU0
> [  162.406513]        ----
> [  162.407055]   lock(&journal->j_state_lock);
> [  162.407880]   <Interrupt>
> [  162.408400]     lock(&journal->j_state_lock);
> [  162.409287]
> [  162.409287]  *** DEADLOCK ***
> [  162.409287]
> [  162.410447] 2 locks held by swapper/0/0:
> [  162.411248]  #0:  (&(&vblk->vqs[i].lock)->rlock){-.-.}, at: [<00000000=
b75553ae>] virtblk_done+0x50/0xf8
> [  162.413101]  #1:  (rcu_read_lock){....}, at: [<000000002bf2a216>] hctx=
_lock+0x1c/0xe8
> [  162.414630]
> [  162.414630] stack backtrace:
> [  162.415492] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.16.0-rc2 #1
> [  162.429624] Hardware name: linux,dummy-virt (DT)
> [  162.430631] Call trace:
> [  162.431196]  dump_backtrace+0x0/0x1c8
> [  162.432005]  show_stack+0x14/0x20
> [  162.432747]  dump_stack+0xac/0xe4
> [  162.433507]  print_usage_bug.part.28+0x258/0x270
> [  162.434510]  mark_lock+0x744/0x750
> [  162.435208]  __lock_acquire+0xab8/0x18c0
> [  162.435982]  lock_acquire+0x48/0x68
> [  162.436678]  _raw_read_lock+0x3c/0x50
> [  162.449520]  jbd2_trans_will_send_data_barrier+0x44/0xc8
> [  162.450681]  ext4_sync_file+0x1e0/0x330
> [  162.451535]  vfs_fsync_range+0x48/0xc0
> [  162.452323]  dio_complete+0x1fc/0x220
> [  162.453094]  dio_bio_end_aio+0xf0/0x130
> [  162.453935]  bio_endio+0xe8/0xf8
> [  162.454625]  blk_update_request+0x80/0x2e8
> [  162.455450]  blk_mq_end_request+0x20/0x70
> [  162.456240]  virtblk_request_done+0x24/0x30
> [  162.457080]  __blk_mq_complete_request+0x100/0x1b0
> [  162.458047]  blk_mq_complete_request+0x60/0x98
> [  162.458918]  virtblk_done+0x70/0xf8
> [  162.459608]  vring_interrupt+0x38/0x50
> [  162.460367]  __handle_irq_event_percpu+0x5c/0x148
> [  162.472443]  handle_irq_event_percpu+0x34/0x88
> [  162.477991]  handle_irq_event+0x48/0x78
> [  162.480661]  handle_fasteoi_irq+0xc0/0x198
> [  162.485417]  generic_handle_irq+0x24/0x38
> [  162.490334]  __handle_domain_irq+0x84/0xf0
> [  162.493834]  gic_handle_irq+0x58/0xa8
> [  162.498464]  el1_irq+0xb4/0x130
> [  162.500621]  arch_cpu_idle+0x18/0x28
> [  162.504729]  default_idle_call+0x1c/0x34
> [  162.508005]  do_idle+0x17c/0x1f0
> [  162.510184]  cpu_startup_entry+0x20/0x28
> [  162.515050]  rest_init+0x250/0x260
> [  162.518228]  start_kernel+0x3f0/0x41c
> [  162.522987] BUG: sleeping function called from invalid context at mm/m=
empool.c:320
> [  162.533762] in_atomic(): 1, irqs_disabled(): 128, pid: 0, name: swappe=
r/0
> [  162.540375] INFO: lockdep is turned off.
> [  162.542696] irq event stamp: 3670810
> [  162.544963] hardirqs last  enabled at (3670805): [<00000000fa98454e>] =
arch_cpu_idle+0x14/0x28
> [  162.551514] hardirqs last disabled at (3670806): [<00000000341112e2>] =
el1_irq+0x74/0x130
> [  162.557422] softirqs last  enabled at (3670810): [<00000000d00bd211>] =
_local_bh_enable+0x20/0x40
> [  162.562596] softirqs last disabled at (3670809): [<00000000e929005c>] =
irq_enter+0x54/0x70
> [  162.568863] Preemption disabled at:
> [  162.568877] [<ffff000008b59ca4>] schedule_preempt_disabled+0x1c/0x28
> [  162.574673] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.16.0-rc2 #1
> [  162.580013] Hardware name: linux,dummy-virt (DT)
> [  162.583234] Call trace:
> [  162.585279]  dump_backtrace+0x0/0x1c8
> [  162.587583]  show_stack+0x14/0x20
> [  162.589047]  dump_stack+0xac/0xe4
> [  162.592035]  ___might_sleep+0x164/0x238
> [  162.594830]  __might_sleep+0x50/0x88
> [  162.597012]  mempool_alloc+0xc0/0x198
> [  162.600633]  bio_alloc_bioset+0x144/0x250
> [  162.602983]  blkdev_issue_flush+0x48/0xc8
> [  162.606134]  ext4_sync_file+0x220/0x330
> [  162.607870]  vfs_fsync_range+0x48/0xc0
> [  162.611694]  dio_complete+0x1fc/0x220
> [  162.613369]  dio_bio_end_aio+0xf0/0x130
> [  162.617040]  bio_endio+0xe8/0xf8
> [  162.618583]  blk_update_request+0x80/0x2e8
> [  162.619841]  blk_mq_end_request+0x20/0x70
> [  162.621082]  virtblk_request_done+0x24/0x30
> [  162.627389]  __blk_mq_complete_request+0x100/0x1b0
> [  162.630482]  blk_mq_complete_request+0x60/0x98
> [  162.633003]  virtblk_done+0x70/0xf8
> [  162.635456]  vring_interrupt+0x38/0x50
> [  162.638588]  __handle_irq_event_percpu+0x5c/0x148
> [  162.640582]  handle_irq_event_percpu+0x34/0x88
> [  162.642829]  handle_irq_event+0x48/0x78
> [  162.644062]  handle_fasteoi_irq+0xc0/0x198
> [  162.646182]  generic_handle_irq+0x24/0x38
> [  162.648024]  __handle_domain_irq+0x84/0xf0
> [  162.650304]  gic_handle_irq+0x58/0xa8
> [  162.652917]  el1_irq+0xb4/0x130
> [  162.656972]  arch_cpu_idle+0x18/0x28
> [  162.658445]  default_idle_call+0x1c/0x34
> [  162.660723]  do_idle+0x17c/0x1f0
> [  162.664958]  cpu_startup_entry+0x20/0x28
> [  162.670009]  rest_init+0x250/0x260
> [  162.672763]  start_kernel+0x3f0/0x41c
> [  162.677064] WARNING: CPU: 0 PID: 0 at block/blk.h:297 generic_make_req=
uest_checks+0x670/0x750
> [  162.682622] Kernel panic - not syncing: panic_on_warn set ...
> [  162.682622]
> [  162.695097] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W        4=
=2E16.0-rc2 #1
> [  162.700355] Hardware name: linux,dummy-virt (DT)
> [  162.713462] Call trace:
> [  162.714859]  dump_backtrace+0x0/0x1c8
> [  162.722935]  show_stack+0x14/0x20
> [  162.725392]  dump_stack+0xac/0xe4
> [  162.727719]  panic+0x13c/0x2b8
> [  162.732313]  panic+0x0/0x2b8
> [  162.735233]  report_bug+0xb4/0x158
> [  162.738377]  bug_handler+0x30/0x88
> [  162.740810]  brk_handler+0xd8/0x198
> [  162.747677]  do_debug_exception+0x9c/0x190
> [  162.752011]  el1_dbg+0x18/0x78
> [  162.755197]  generic_make_request_checks+0x670/0x750
> [  162.761260]  generic_make_request+0x2c/0x278
> [  162.764366]  submit_bio+0x54/0x208
> [  162.771402]  submit_bio_wait+0x68/0xa0
> [  162.775053]  blkdev_issue_flush+0x8c/0xc8
> [  162.780520]  ext4_sync_file+0x220/0x330
> [  162.784815]  vfs_fsync_range+0x48/0xc0
> [  162.788243]  dio_complete+0x1fc/0x220
> [  162.792071]  dio_bio_end_aio+0xf0/0x130
> [  162.794820]  bio_endio+0xe8/0xf8
> [  162.796203]  blk_update_request+0x80/0x2e8
> [  162.800883]  blk_mq_end_request+0x20/0x70
> [  162.803072]  virtblk_request_done+0x24/0x30
> [  162.806877]  __blk_mq_complete_request+0x100/0x1b0
> [  162.809298]  blk_mq_complete_request+0x60/0x98
> [  162.811408]  virtblk_done+0x70/0xf8
> [  162.812461]  vring_interrupt+0x38/0x50
> [  162.813467]  __handle_irq_event_percpu+0x5c/0x148
> [  162.814657]  handle_irq_event_percpu+0x34/0x88
> [  162.815730]  handle_irq_event+0x48/0x78
> [  162.816856]  handle_fasteoi_irq+0xc0/0x198
> [  162.817946]  generic_handle_irq+0x24/0x38
> [  162.818948]  __handle_domain_irq+0x84/0xf0
> [  162.820056]  gic_handle_irq+0x58/0xa8
> [  162.821013]  el1_irq+0xb4/0x130
> [  162.826572]  arch_cpu_idle+0x18/0x28
> [  162.827304]  default_idle_call+0x1c/0x34
> [  162.828315]  do_idle+0x17c/0x1f0
> [  162.829174]  cpu_startup_entry+0x20/0x28
> [  162.830072]  rest_init+0x250/0x260
> [  162.830872]  start_kernel+0x3f0/0x41c
> [  162.831627] SMP: stopping secondary CPUs
> [  165.929235] SMP: failed to stop secondary CPUs 0,2
> [  165.949001] Kernel Offset: disabled
> [  165.963649] CPU features: 0x1802082
> [  165.969405] Memory Limit: none
> [  165.974480] Rebooting in 86400 seconds..
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR

--pm2vxkhhandoykr2
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-direct-io-Fix-sleep-in-atomic-due-to-sync-AIO.patch"

>From 501d97ed88f5020a55a0de4d546df5ad11461cea Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 26 Feb 2018 11:36:52 +0100
Subject: [PATCH] direct-io: Fix sleep in atomic due to sync AIO

Commit e864f39569f4 "fs: add RWF_DSYNC aand RWF_SYNC" added additional
way for direct IO to become synchronous and thus trigger fsync from the
IO completion handler. Then commit 9830f4be159b "fs: Use RWF_* flags for
AIO operations" allowed these flags to be set for AIO as well. However
that commit forgot to update the condition checking whether the IO
completion handling should be defered to a workqueue and thus AIO DIO
with RWF_[D]SYNC set will call fsync() from IRQ context resulting in
sleep in atomic.

Fix the problem by checking directly iocb flags (the same way as it is
done in dio_complete()) instead of checking all conditions that could
lead to IO being synchronous.

CC: Christoph Hellwig <hch@lst.de>
CC: Goldwyn Rodrigues <rgoldwyn@suse.com>
CC: stable@vger.kernel.org
Reported-by: Mark Rutland <mark.rutland@arm.com>
Fixes: 9830f4be159b29399d107bffb99e0132bc5aedd4
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/direct-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index a0ca9e48e993..1357ef563893 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1274,8 +1274,7 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	 */
 	if (dio->is_async && iov_iter_rw(iter) == WRITE) {
 		retval = 0;
-		if ((iocb->ki_filp->f_flags & O_DSYNC) ||
-		    IS_SYNC(iocb->ki_filp->f_mapping->host))
+		if (iocb->ki_flags & IOCB_DSYNC)
 			retval = dio_set_defer_completion(dio);
 		else if (!dio->inode->i_sb->s_dio_done_wq) {
 			/*
-- 
2.13.6


--pm2vxkhhandoykr2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Virtualization mailing list
Virtualization@lists.linux-foundation.org
https://lists.linuxfoundation.org/mailman/listinfo/virtualization
--pm2vxkhhandoykr2--
