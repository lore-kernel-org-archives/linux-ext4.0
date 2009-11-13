From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Mount -o sync regression in 2.6.31
Date: Fri, 13 Nov 2009 15:28:21 -0800
Message-ID: <20091113152821.2d712997@nehalam>
References: <20091111123340.703f5c86@nehalam>
	<200911112234.24180.elendil@planet.nl>
	<20091113144727.575cf038@nehalam>
	<20091113150719.9d31dde2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Frans Pop <elendil@planet.nl>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Nick Piggin <npiggin@suse.de>, jens.axboe@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20091113150719.9d31dde2.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 13 Nov 2009 15:07:19 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 13 Nov 2009 14:47:27 -0800
> Stephen Hemminger <shemminger@vyatta.com> wrote:
> 
> > Okay the scenario is:
> > 1. Mount floppy with ext2 filesystem in sync mode
> > 2. Write to floppy
> > 3. Prematurely eject floppy
> > 4. Unmount floppy
> 
> I assume that by "prematurely eject", you mean that you waited until
> the activity LED had turned off, then hit the button without typing
> umount?

yes. no activity, but not unmounted

> 
> Really, I think ext2 is just wrong here.  At unmount time it runs
> ext2_sync_super(), which updates a few fields in the superblock and
> tries to write them back.
> 
> But if the fs was mounted with `-osync' then the driver should be
> operating synchronously, dammit!  That means that any time any syscall
> alters the filesystem's s_free_blocks_count, s_free_inodes_count or
> s_wtime, the driver should write those fields back to the superblock
> prior to returning from the syscall.

Agreed, but it looks like it has always done that.

> However that might be unreasonaly anal of us, because those fields
> aren't terribly important.  A fsck will whine and fix them up.
> 
> > This triggers this warning in 2.6.31 which did not occur in 2.6.30
> 
> hm, I wonder why that changed.  The warning's been there for a while.
> 
> >  [  580.325447] floppy0: disk absent or changed during operation
> >  [  580.325454] lost page write due to I/O error on fd0
> >  [  580.958434] ------------[ cut here ]------------
> >  [  580.958437] WARNING: at fs/buffer.c:1152 mark_buffer_dirty+0x23/0x7d()
> >  [  580.958440] Hardware name: System Product Name
> >  [  580.958442] Modules linked in: hid_belkin binfmt_misc bridge stp llc kvm_intel kvm ipv6 video output pci_slot acpi_cpufreq cpufreq_powersave cpufreq_ondemand cpufreq_conservative cpufreq_userspace psmouse pcspkr serio_raw rtc_cmos wmi evdev sg sr_mod cdrom usbhid mvsas pata_acpi pata_marvell ata_piix libsas ahci igb sky2 scsi_transport_sas dca e1000e floppy dm_mirror dm_region_hash dm_log dm_snapshot dm_mod fuse
> >  [  580.958475] Pid: 8340, comm: umount Not tainted 2.6.30-rc6-bisect #12
> >  [  580.958477] Call Trace:
> >  [  580.958483]  [<ffffffff80232ebb>] ? warn_slowpath_fmt+0xd9/0x10b
> >  [  580.958489]  [<ffffffff80270031>] ? find_get_pages_tag+0x41/0xdd
> >  [  580.958494]  [<ffffffff802782f0>] ? pagevec_lookup+0x17/0x1e
> >  [  580.958498]  [<ffffffff80279377>] ? truncate_inode_pages_range+0x21d/0x31d
> >  [  580.958502]  [<ffffffff80270db5>] ? wait_on_page_writeback_range+0xce/0x11b
> >  [  580.958507]  [<ffffffff80245037>] ? bit_waitqueue+0x10/0xa0
> >  [  580.958510]  [<ffffffff802be80d>] ? mark_buffer_dirty+0x23/0x7d
> >  [  580.958515]  [<ffffffff803003eb>] ? ext2_sync_super+0x39/0x55
> >  [  580.958519]  [<ffffffff8030079c>] ? ext2_put_super+0x34/0xc7
> >  [  580.958524]  [<ffffffff802a3174>] ? generic_shutdown_super+0x70/0xfd
> >  [  580.958533]  [<ffffffff802a3223>] ? kill_block_super+0x22/0x3a
> >  [  580.958537]  [<ffffffff802a3831>] ? deactivate_super+0x43/0x5a
> >  [  580.958541]  [<ffffffff802b56f9>] ? sys_umount+0x2d8/0x307
> >  [  580.958546]  [<ffffffff8020aeeb>] ? system_call_fastpath+0x16/0x1b
> >  [  580.958549] ---[ end trace ccbde6411acd243f ]---
> >  [  580.958580] floppy0: disk absent or changed during operation
> >  [  580.958587] lost page write due to I/O error on fd0
> 
> 	void mark_buffer_dirty(struct buffer_head *bh)
> 	{
> 		WARN_ON_ONCE(!buffer_uptodate(bh));
> 
> that's expected, I expect.  And it's just a WARN_ON_ONCE() so it
> won't be flooding logs.  We could just delete it I suppose.
> 
> > Bisecting between 2.6.30 and 2.6.31-rc1 reduced it down to:
> > 
> > 8f184f27300f66f6dcc8296c2dae7a1fbe8429c9 is first bad commit
> > commit 8f184f27300f66f6dcc8296c2dae7a1fbe8429c9
> > Author: Frederic Weisbecker <fweisbec@gmail.com>
> > Date:   Sat May 16 06:24:36 2009 +0200
> > 
> >     tracing/stat: replace linked list by an rbtree for sorting
> 
> Current score:
> 
> git: 			4,559
> kernel developers:	0


-- 
