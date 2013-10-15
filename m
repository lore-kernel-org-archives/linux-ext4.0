From: Jan Kara <jack@suse.cz>
Subject: Re: new kernel warning when running xfstest ext4/271 on 3.12
Date: Tue, 15 Oct 2013 15:26:05 +0200
Message-ID: <20131015132605.GE12428@quack.suse.cz>
References: <20131014021606.GA31336@wallace>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Sr1nOIr3CvdE5hEN"
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759171Ab3JON0H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Oct 2013 09:26:07 -0400
Content-Disposition: inline
In-Reply-To: <20131014021606.GA31336@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun 13-10-13 22:16:06, Eric Whitney wrote:
> Since 3.12-rc1, I've noticed a new warning message in my kernel logs when
> running ext4 regression tests with xfstests on both my x86-64 (KVM guest) and
> ARM (Pandaboard ES) SUTs.  (I'm using xfstests-bld to run xfstests.)  It
> remains visible in 3.12-rc4.
> 
> The warning appears when running ext4/271 after mounting the test file system
> with the dioread_nolock option.
> 
> After running ext4/271, the kernel log contains the following trace repeated
> 21 times, apparently once for each write performed by dd in the test:
  Attached patch should fix this.

								Honza

> 
> EXT4-fs (vdc): mounted filesystem without journal. Opts: dioread_nolock,noload
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 1366 at fs/ext4/page-io.c:205 ext4_put_io_end_defer+0xf5/0x100()
> Modules linked in: snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer psmouse serio_raw snd soundcore virtio_balloon snd_page_alloc i2c_piix4 mac_hid lp parport floppy
> CPU: 1 PID: 1366 Comm: dd Not tainted 3.12.0-rc4-ext4testing+ #1
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>  0000000000000009 ffff88003fd03d10 ffffffff816e3b66 0000000000000000
>  ffff88003fd03d48 ffffffff8104eb4c ffff88003d1a1168 ffff88003d209c10
>  0000000000000000 0000000000001000 ffff88003bb57490 ffff88003fd03d58
> Call Trace:
>  <IRQ>  [<ffffffff816e3b66>] dump_stack+0x45/0x56
>  [<ffffffff8104eb4c>] warn_slowpath_common+0x8c/0xc0
>  [<ffffffff8104eb9a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff81245df5>] ext4_put_io_end_defer+0xf5/0x100
>  [<ffffffff81245ec6>] ext4_end_bio+0xc6/0xe0
>  [<ffffffff811d206d>] bio_endio+0x1d/0x30
>  [<ffffffff8133313a>] blk_update_request+0xba/0x450
>  [<ffffffff813333e0>] ? blk_update_request+0x360/0x450
>  [<ffffffff813334f7>] blk_update_bidi_request+0x27/0xa0
>  [<ffffffff81336720>] __blk_end_bidi_request+0x20/0x50
>  [<ffffffff8133676f>] __blk_end_request_all+0x1f/0x30
>  [<ffffffff81480a20>] virtblk_done+0x100/0x260
>  [<ffffffff81412b11>] vring_interrupt+0x31/0x50
>  [<ffffffff810a6394>] handle_irq_event_percpu+0x54/0x1f0
>  [<ffffffff810a6578>] handle_irq_event+0x48/0x70
>  [<ffffffff810a8de7>] handle_edge_irq+0x77/0x110
>  [<ffffffff810044de>] handle_irq+0x1e/0x30
>  [<ffffffff816f70ba>] do_IRQ+0x5a/0xe0
>  [<ffffffff816ecdaf>] common_interrupt+0x6f/0x6f
>  <EOI>  [<ffffffff810be18e>] ? lock_acquire+0x9e/0x100
>  [<ffffffff811a76ad>] ? path_init+0x26d/0x4c0
>  [<ffffffff8107ca94>] lg_local_lock+0x34/0x70
>  [<ffffffff811a76ad>] ? path_init+0x26d/0x4c0
>  [<ffffffff811a76ad>] path_init+0x26d/0x4c0
>  [<ffffffff81370898>] ? __raw_spin_lock_init+0x38/0x70
>  [<ffffffff811abbb1>] path_openat+0x81/0x660
>  [<ffffffff81165031>] ? handle_mm_fault+0x2d1/0xaf0
>  [<ffffffff816f0638>] ? __do_page_fault+0x148/0x570
>  [<ffffffff811ac4b3>] do_filp_open+0x43/0xa0
>  [<ffffffff816ec897>] ? _raw_spin_unlock+0x27/0x30
>  [<ffffffff811b9876>] ? __alloc_fd+0xd6/0x130
>  [<ffffffff8119a62c>] do_sys_open+0x13c/0x230
>  [<ffffffff8119a742>] SyS_open+0x22/0x30
>  [<ffffffff816f5192>] system_call_fastpath+0x16/0x1b
> ---[ end trace bd3f4c22c85fc732 ]---
> 
> The test itself concludes successfully as written, though it's worth noting
> the test does not check the integrity of the data written.
> 
> The same warning can be triggered by the following simple sequence of
> commands, extracted from ext4/271:
> 
> mkfs.ext4 /dev/vdc
> mount -o dioread_nolock,noload /dev/vdc /vdc
> touch /vdc/file
> chattr +S /vdc/file
> dd if=/dev/zero of=/vdc/file bs=4k count=1
> 
> (FWIW, if you omit the touch and chattr commands, the warning won't be
> triggered unless a second instance of the dd command is issued.)
> 
> The warning bisects cleanly to this patch:
> 7b7a8665ed direct-io: Implement generic deferred AIO completions
> 
> Apparently, !io_end->handle is unexpectedly true in this test case.  A
> WARN_ON for that condition was newly added in the patch.
> 
> It's not yet clear to me how serious this warning is, but the new message is
> at least a minor regression.
> 
> Thanks,
> Eric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--Sr1nOIr3CvdE5hEN
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-assertion-in-ext4_add_complete_io.patch"

>From 3575f7ab985e3f8ddbddf88e72b93ece20a113e6 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 15 Oct 2013 15:17:48 +0200
Subject: [PATCH] ext4: Fix assertion in ext4_add_complete_io()

It doesn't make sense to require io_end->handle when we are in nojournal
mode. So update the assertion accordingly to avoid false warnings from
ext4_add_complete_io().

Reported-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/page-io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index d7d0c7b46ed4..d488f80ee32d 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -197,14 +197,15 @@ static void dump_completed_IO(struct inode *inode, struct list_head *head)
 static void ext4_add_complete_io(ext4_io_end_t *io_end)
 {
 	struct ext4_inode_info *ei = EXT4_I(io_end->inode);
+	struct ext4_sb_info *sbi = EXT4_SB(io_end->inode->i_sb);
 	struct workqueue_struct *wq;
 	unsigned long flags;
 
 	/* Only reserved conversions from writeback should enter here */
 	WARN_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
-	WARN_ON(!io_end->handle);
+	WARN_ON(!io_end->handle && sbi->s_journal);
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	wq = EXT4_SB(io_end->inode->i_sb)->rsv_conversion_wq;
+	wq = sbi->rsv_conversion_wq;
 	if (list_empty(&ei->i_rsv_conversion_list))
 		queue_work(wq, &ei->i_rsv_conversion_work);
 	list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
-- 
1.8.1.4


--Sr1nOIr3CvdE5hEN--
