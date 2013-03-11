From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG][data=journal] general protection fault is hitted when we
 run xfstests #074
Date: Mon, 11 Mar 2013 17:33:38 +0100
Message-ID: <20130311163338.GM29799@quack.suse.cz>
References: <20130307122019.GC2800@gmail.com>
 <20130307122638.GD6723@quack.suse.cz>
 <20130308125545.GA18986@gmail.com>
 <20130311132717.GD29799@quack.suse.cz>
 <20130311140646.GA5266@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab3CKQdk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 12:33:40 -0400
Content-Disposition: inline
In-Reply-To: <20130311140646.GA5266@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 11-03-13 22:06:46, Zheng Liu wrote:
> On Mon, Mar 11, 2013 at 02:27:17PM +0100, Jan Kara wrote:
> > On Fri 08-03-13 20:55:45, Zheng Liu wrote:
> > > On Thu, Mar 07, 2013 at 01:26:38PM +0100, Jan Kara wrote:
> > > > On Thu 07-03-13 20:20:19, Zheng Liu wrote:
> > > > > Hi all,
> > > > > 
> > > > > This bug can be hitted in 3.8 kernel, and it doesn't be fixed in dev
> > > > > branch.  When #074 runs in a ext4 file system with '-o data=journal', I
> > > > > will get a general protection fault in my sand box.  I need to run
> > > > > several times to hit this bug.
> > > > > 
> > > > > My sand box is a Dell Desktop with a Intel(R) Core(TM)2 Duo CPU E8400
> > > > > @ 3.00GHz, 4G memory, a 160G HDD and a Intel SSD.  The test runs against
> > > > > SSD.
> > > > > 
> > > > > The messages from dmesg:
> > > > > 
> > > > > wenqing: run xfstest 074
> > > > > kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> > > > > Opts: acl,user_xattr,data=journal
> > > > > kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> > > > > Opts: acl,user_xattr,data=journal
> > > > > kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> > > > > Opts: acl,user_xattr,data=journal
> > > > > kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> > > > > Opts: acl,user_xattr,data=journal
> > > > > kernel: general protection fault: 0000 [#1] SMP 
> > > > > kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6
> > > > > dm_mirror dm_region_hash dm_log dm_mod parport_pc parport dcdbas
> > > > > acpi_cpufreq mperf sg button pcspkr serio_raw i2c_i801 i2c_core ehci_pci
> > > > > ehci_hcd e1000e ext3 jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
> > > > > kernel: CPU 1 
> > > > > kernel: Pid: 2786, comm: flush-8:0 Not tainted 3.8.0 #1 Dell Inc.
> > > > > OptiPlex 780                 /0V4W66
> > > > > kernel: RIP: 0010:[<ffffffffa01da0a0>]  [<ffffffffa01da0a0>]
> > > > > jbd2_journal_dirty_metadata+0x147/0x211 [jbd2]
> > > > > kernel: RSP: 0000:ffff880107a93868  EFLAGS: 00010206
> > > > > kernel: RAX: 0000000000000000 RBX: ffff88010a674540 RCX: 5c5c5c5c5c5c5c5c
> > > > > kernel: RDX: 000000000034402d RSI: ffff88010a674540 RDI: ffff880105bd6ca0
> > > > > kernel: RBP: ffff880107a938b8 R08: 0000000000000000 R09: 0000000000000000
> > > > > kernel: R10: ffff880105bd6ca0 R11: 000000000000000c R12: ffff88008e4ee518
> > > > > kernel: R13: ffff8801114fb800 R14: ffff880105bd6ca0 R15: ffff88010a658c80
> > > > > kernel: FS:  0000000000000000(0000) GS:ffff880117c40000(0000)
> > > > > knlGS:0000000000000000
> > > > > kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > > > kernel: CR2: 00007f60256a5000 CR3: 0000000117834000 CR4: 00000000000407e0
> > > > > kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > > kernel: Process flush-8:0 (pid: 2786, threadinfo ffff880107a92000, task
> > > > > ffff880112cde6b0)
> > > > > kernel: Stack:
> > > > > kernel: ffff880105bd6ca0 0000000000001000 ffff880107a938a8 ffffffffa01da6de
> > > > > kernel: ffff8801114fb868 0000000000000000 00000000000003bf ffffffffa023f0e0
> > > > > kernel: ffff88010a674540 0000000000001000 ffff880107a938f8 ffffffffa022bb07
> > > > > kernel: Call Trace:
> > > > > kernel: [<ffffffffa01da6de>] ? jbd2_journal_get_write_access+0x36/0x40 [jbd2]
> > > > > kernel: [<ffffffffa022bb07>] __ext4_handle_dirty_metadata+0xd7/0xe6 [ext4]
> > > > > kernel: [<ffffffffa01ff4a5>] write_end_fn+0x37/0x3d [ext4]
> > > > > kernel: [<ffffffffa01ff167>] ext4_walk_page_buffers+0x65/0x9b [ext4]
> > > > > kernel: [<ffffffffa01ff46e>] ? ext4_nonda_switch+0xbd/0xbd [ext4]
> > > > > kernel: [<ffffffffa0203367>] __ext4_journalled_writepage+0x156/0x1ee [ext4]
> > > > > kernel: [<ffffffffa0203c10>] ext4_writepage+0x1b8/0x20d [ext4]
> > > > > kernel: [<ffffffff820b7ab4>] __writepage+0x17/0x30
> > > > > kernel: [<ffffffff820b8554>] write_cache_pages+0x276/0x37f
> > > > > kernel: [<ffffffff820b7a9d>] ? set_page_dirty+0x64/0x64
> > > > > kernel: [<ffffffff820b86a2>] generic_writepages+0x45/0x5c
> > > > > kernel: [<ffffffff820b86e0>] do_writepages+0x27/0x29
> > > > > kernel: [<ffffffff8210fc93>] __writeback_single_inode+0x48/0x119
> > > > > kernel: [<ffffffff82110e7c>] writeback_sb_inodes+0x1ec/0x2fd
> > > > > kernel: [<ffffffff82110fff>] __writeback_inodes_wb+0x72/0xb0
> > > > > kernel: [<ffffffff821111ee>] wb_writeback+0x13e/0x230
> > > > > kernel: [<ffffffff820b8dae>] ? global_dirty_limits+0x36/0x134
> > > > > kernel: [<ffffffff821114aa>] wb_do_writeback+0x1ca/0x1ea
> > > > > kernel: [<ffffffff8211158c>] bdi_writeback_thread+0xc2/0x1e2
> > > > > kernel: [<ffffffff821114ca>] ? wb_do_writeback+0x1ea/0x1ea
> > > > > kernel: [<ffffffff821114ca>] ? wb_do_writeback+0x1ea/0x1ea
> > > > > kernel: [<ffffffff8204eadf>] kthread+0xb5/0xbd
> > > > > kernel: [<ffffffff8204ea2a>] ? kthread_freezable_should_stop+0x65/0x65
> > > > > kernel: [<ffffffff8238689c>] ret_from_fork+0x7c/0xb0
> > > > > kernel: [<ffffffff8204ea2a>] ? kthread_freezable_should_stop+0x65/0x65
> > > > > kernel: Code: 08 49 8b 4c 24 28 4c 39 f9 0f 84 81 00 00 00 4d 8b 4d 58 31 c0
> > > > > 4c 39 c9 74 36 4d 85 c9 74 04 41 8b 41 08 45 31 c0 48 85 c9 74 04 <44> 8b 41
> > > > > 08 48 8b 53 18 49 8d b5 58 03 00 00 89 04 24 48 c7 c7 
> > > > > kernel: RIP  [<ffffffffa01da0a0>] jbd2_journal_dirty_metadata+0x147/0x211 [jbd2]
> > > > > kernel: RSP <ffff880107a93868>
> > > > > kernel: ---[ end trace d8e02cf12f9b2b79 ]---
> > > >   Hum, clearly we hit some poison value (RCX which was dereferenced was
> > > > 0x5c5c5c5c5c5c5c5c). Can you post full disassembly of
> > > > jbd2_journal_dirty_metadata()? I was trying to match decoded 'Code' section
> > > > with the C code but I failed...
> > > 
> > > Sorry for the delay.  Here is the result that I use 'objdump -r -S -l
> > > --disassemble fs/jbd2/jbd2.ko' to generate.  Hope it's useful for you.
> > > 
> > > Sorry I don't have time to look at it carefully.  Please let me know if
> > > you need some details.
> >   Thanks for the debug data. So we oops on dereferencing jh->b_transaction
> > because it is 0x5c5c5c5c5c5c5c5c which is JBD2_POISON_FREE. So clearly the
> > journal head we have has been freed. Not sure yet how that can happen
> > though.
> 
> Yup, but I don't think it is a very urgent bug because I need to run a
> stress test case a lot of times to hit it, and in practice we don't
> receive any report yet.  Certainly we need to keep it in mind.
  Actually, it wasn't that hard. Attached patch should fix the issue.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--k1lZvvs/B4yU6o8G
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-jbd2-Fix-use-after-free-in-jbd2_journal_dirty_metada.patch"

>From f32ca41396f1d71a689f86ba3e7372a1ad1fdba2 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 11 Mar 2013 16:49:16 +0100
Subject: [PATCH] jbd2: Fix use after free in jbd2_journal_dirty_metadata()

jbd2_journal_dirty_metadata() didn't get a reference to journal_head it
was working with. This is OK in most of the cases since the journal head
should be attached to a transaction but in rare occasions when we are
journalling data, __ext4_journalled_writepage() can race with
jbd2_journal_invalidatepage() stripping buffers from a page and thus
journal head can be freed under hands of jbd2_journal_dirty_metadata().

Fix the problem by getting own journal head reference in
jbd2_journal_dirty_metadata() (and also in jbd2_journal_set_triggers()
which can possibly have the same issue).

Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index d6ee5ae..325bc01 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1065,9 +1065,12 @@ out:
 void jbd2_journal_set_triggers(struct buffer_head *bh,
 			       struct jbd2_buffer_trigger_type *type)
 {
-	struct journal_head *jh = bh2jh(bh);
+	struct journal_head *jh = jbd2_journal_grab_journal_head(bh);
 
+	if (WARN_ON(!jh))
+		return;
 	jh->b_triggers = type;
+	jbd2_journal_put_journal_head(jh);
 }
 
 void jbd2_buffer_frozen_trigger(struct journal_head *jh, void *mapped_data,
@@ -1119,17 +1122,18 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
-	struct journal_head *jh = bh2jh(bh);
+	struct journal_head *jh;
 	int ret = 0;
 
-	jbd_debug(5, "journal_head %p\n", jh);
-	JBUFFER_TRACE(jh, "entry");
 	if (is_handle_aborted(handle))
 		goto out;
-	if (!buffer_jbd(bh)) {
+	jh = jbd2_journal_grab_journal_head(bh);
+	if (!jh) {
 		ret = -EUCLEAN;
 		goto out;
 	}
+	jbd_debug(5, "journal_head %p\n", jh);
+	JBUFFER_TRACE(jh, "entry");
 
 	jbd_lock_bh_state(bh);
 
@@ -1220,6 +1224,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	spin_unlock(&journal->j_list_lock);
 out_unlock_bh:
 	jbd_unlock_bh_state(bh);
+	jbd2_journal_put_journal_head(jh);
 out:
 	JBUFFER_TRACE(jh, "exit");
 	WARN_ON(ret);	/* All errors are bugs, so dump the stack */
-- 
1.7.1


--k1lZvvs/B4yU6o8G--
