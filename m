From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [v4.14-rc3 bug] scheduling while atomic in generic/451 test on
 extN
Date: Fri, 13 Oct 2017 12:28:42 +0200
Message-ID: <20171013102842.7blegiipyftp3xcy@rh_laptop>
References: <20171005060700.GF8034@eguan.usersys.redhat.com>
 <20171012150740.GD31488@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eryu Guan <eguan@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757128AbdJMK2p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 13 Oct 2017 06:28:45 -0400
Content-Disposition: inline
In-Reply-To: <20171012150740.GD31488@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 12, 2017 at 05:07:40PM +0200, Jan Kara wrote:
> Hi Eryu!
> 
> On Thu 05-10-17 14:07:00, Eryu Guan wrote:
> > I hit "scheduling while atomic" bug by running fstests generic/451 on
> > extN filesystems in v4.14-rc3 testing, but it didn't reproduce for me on
> > every host I tried, but I've seen it multiple times on multiple hosts. A
> > test vm of mine with 4 vcpus and 8G memory reproduced the bug reliably,
> > while a bare metal host with 8 cpus and 8G mem couldn't.
> > 
> > This is due to commit 332391a9935d ("fs: Fix page cache inconsistency
> > when mixing buffered and AIO DIO"), which defers AIO DIO io completion
> > to a workqueue if the inode has mapped pages and does page cache
> > invalidation in process context. I think that the problem is that the
> > pages can be mapped after the dio->inode->i_mapping->nrpages check, so
> > we're doing page cache invalidation, which could sleep, in interrupt
> > context, thus "scheduling while atomic" bug happens.
> > 
> > Defering all AIO DIO completion to workqueue unconditionally (as what
> > the iomap based path does) fixed the problem for me. But there're
> > performance concerns to do so in the original discussions.
> > 
> > https://www.spinics.net/lists/linux-fsdevel/msg112669.html
> 
> Thanks for report and the detailed analysis. I think your analysis is
> correct and the nrpages check in dio_bio_end_aio() is racy. My solution to
> this would be to pass to dio_complete() as an argument whether invalidation
> is required or not (and set it to true for deferred completion and to false
> when we decide not to defer completion since nrpages is 0 at that moment).
> Lukas?

Oops, right I've missed that the nrpages check in dio_bio_end_aio() is
indeed racy. I'll prepare a patch. Thanks!

-Lukas

> 
> 								Honza
> 
> > [17087.868644] BUG: scheduling while atomic: swapper/0/0/0x00000100 
> > [17087.875363] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot dm_bufio loop dm_flakey dm_mod ses enclosure ext4 mbcache jbd2 intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul mpt3sas ghash_clmulni_intel raid_class sg scsi_transport_sas pcbc ipmi_ssif shpchp aesni_intel crypto_simd iTCO_wdt glue_helper ipmi_si cryptd iTCO_vendor_support cdc_ether ipmi_devintf ipmi_msghandler usbnet mii pcspkr acpi_pad wmi dcdbas joydev acpi_power_meter lpc_ich mei_me mei nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops sd_mod igb ttm ahci ptp libahci drm libata pps_core crc32c_intel dca megaraid_sas i2c_algo_bit i2c_co
 re [last unloaded: scsi_debug] 
> > [17087.955757] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.14.0-rc3 #1 
> > [17087.964110] Hardware name: Dell Inc. PowerEdge R620/01W23F, BIOS 2.5.4 01/22/2016 
> > [17087.972460] Call Trace: 
> > [17087.975189]  <IRQ> 
> > [17087.977441]  dump_stack+0x63/0x89 
> > [17087.981143]  __schedule_bug+0x62/0x70 
> > [17087.985232]  __schedule+0x7bb/0x890 
> > [17087.989125]  schedule+0x36/0x80 
> > [17087.992629]  io_schedule+0x16/0x40 
> > [17087.996429]  __lock_page+0x10a/0x150 
> > [17088.000420]  ? page_cache_tree_insert+0xb0/0xb0 
> > [17088.005470]  invalidate_inode_pages2_range+0x240/0x500 
> > [17088.011208]  ? kmem_cache_free+0x1ad/0x1c0 
> > [17088.015778]  ? mempool_free_slab+0x17/0x20 
> > [17088.020347]  ? mempool_free+0x2b/0x80 
> > [17088.024438]  dio_complete+0x14f/0x1d0 
> > [17088.028526]  dio_bio_end_aio+0xcb/0x120 
> > [17088.032800]  bio_endio+0xa1/0x120 
> > [17088.036501]  blk_update_request+0xb7/0x310 
> > [17088.041076]  scsi_end_request+0x34/0x200 
> > [17088.045454]  scsi_io_completion+0x133/0x5f0 
> > [17088.050123]  scsi_finish_command+0xd9/0x120 
> > [17088.054782]  scsi_softirq_done+0x145/0x170 
> > [17088.059355]  blk_done_softirq+0xa1/0xd0 
> > [17088.063627]  __do_softirq+0xc9/0x269 
> > [17088.067619]  irq_exit+0xd9/0xf0 
> > [17088.071123]  do_IRQ+0x51/0xd0 
> > [17088.074434]  common_interrupt+0x9d/0x9d 
> > [17088.078713]  </IRQ> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
