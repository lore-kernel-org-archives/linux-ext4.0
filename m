From: Dmitri Monakhov <dmonakhov@openvz.org>
Subject: delayed allocation result in BUG at fs/buffer.c:2880!
Date: Thu, 20 Mar 2008 17:04:47 +0300
Message-ID: <20080320140447.GB19995@dmon-lap.sw.ru>
References: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr> <47E1CE7F.6050706@redhat.com> <20080320081619.GB13928@dmon-lap.sw.ru> <20080320120957.GB11891@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Solofo.Ramangalahy@bull.net,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:30074 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbYCTOdM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Mar 2008 10:33:12 -0400
Content-Disposition: inline
In-Reply-To: <20080320120957.GB11891@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 17:39 Thu 20 Mar     , Aneesh Kumar K.V wrote:
> On Thu, Mar 20, 2008 at 11:16:19AM +0300, Dmitri Monakhov wrote:
> > On 21:39 Wed 19 Mar     , Eric Sandeen wrote:
> > > Solofo.Ramangalahy@bull.net wrote:
> > > > Hello,
> > > > 
> > > > During stress testing (workload: racer from ltp + fio/iometer), here
> > > > is an error I am encountering:
> > > > 8<------------------------------------------------------------------------------
> > > > kernel: WARNING: at fs/buffer.c:1680 __block_write_full_page+0xd4/0x2af()
> > > 
> > > So this is WARN_ON(bh->b_size != blocksize);
> > > 
> > > What is b_size in this case?
> > FS block size, because this page pinned bh (it comes from page_buffers(page)), but
> > not dummy bh which may comes from {write,read}pages or direct_IO. 
> > Page's bh i_size must always be equal to fs blocksize.
> > This bh always constructed via following construction
> > if (!page_has_buffers(page))
> > 	create_empty_buffers(page, 1<<inode->i_blkbits, flags)
> > So page's bh->b_size was inited with right value from very beginning, but
> > apparently somewhere this size was changed 
> > I guess i've localized buggy place, at least it's looks strange.
> > ext4_da_get_block_prep ()
> > {
> > ...
> > 	BUG_ON(create == 0);
> >         BUG_ON(bh_result->b_size != inode->i_sb->s_blocksize);
> > 	ret =  ext4_get_blocks_wrap(NULL,  inode, iblock, 1,  bh_result, 0, 0);
> > #Here ext4_get_block_write called with max_blocks == 1  ^^^^^
> > 	...
> > 	if (ret > 0) {
> >                         bh_result->b_size = (ret << inode->i_blkbits);
> > 	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > ## I don't understand this place. I hoped what (ret <= max_blocks) must always
> > ##be true true. But after I've add debug info printing I've got following result.
> >                 ret = 0;
> >         }
> > ...
> > }
> > Some times I've seen following ,message 
> >  bh= {state=0,size=114688, blknr=18446744073709551615 dev=0000000000000000,count=0}, ret=28
> > And because it was page-cache's bh later this result in WARNING.
> 
> Is that a fallocate space ?. For falloc space we can return values
> greater than max_blocks. ext4_ext_get_blocks was made to return  >0
> for a read on prealloc space to ensure delalloc doesn't reserve space
> for the same. I guess we need to make sure we don't return more than
> max_blocks. Can you try the patch below
Ok Warning has gone, but resulted bh still incorrectly filled.
I've found what function ext4_da_get_block_prep() return bh witch 
is !mapped and !delayed, which is prohibited because it is always called with
create != 0. BH debug info at the end of this function result in following msg

BH={state=0, size=4096, blknr=18446744073709551615,dev=0000000000000000,
  count=0} block =288 ret=1

Later this incorrectly filled bh result in BUG_ON triggering
------------[ cut here ]------------
 kernel BUG at fs/buffer.c:2880!
 invalid opcode: 0000 [1] SMP
 CPU 1
 Modules linked in: ext4dev jbd2 crc16 ipv6 autofs4 hidp hid rfcomm l2cap
bluetooth sunrpc dm_multipath video output sbs sbshc battery ac parport_pc lp
parport floppy sg e1000 button ata_generic i6300esb i2c_i801 iTCO_wdt pcspkr
i2c_core e752x_edac iTCO_vendor_support edac_core dm_snapshot dm_zero dm_mirror
dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd mbcache ehci_hcd ohci_hcd
uhci_hcd [last unloaded: microcode]
 Pid: 3291, comm: fsstress-x86_64 Not tainted 2.6.25-rc4 #28
 RIP: 0010:[<ffffffff804a318b>]  [<ffffffff804a318b>] submit_bh+0x18/0xfc
 RSP: 0018:ffff81006cd5ba08  EFLAGS: 00010246
 RAX: 0000000000000004 RBX: ffff810067ce6380 RCX: ffffffff8076a728
 RDX: ffff81006cd5bae0 RSI: ffff810067ce6380 RDI: 0000000000000000
 RBP: 0000000000000000 R08: ffffffff8076a710 R09: ffff810001029060
 R10: 0000000000000000 R11: ffffffff8041e877 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000427
 FS:  0000000000691850(0063) GS:ffff81007f80e480(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 00007fca7c019000 CR3: 0000000076d56000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process fsstress-x86_64 (pid: 3291, threadinfo ffff81006cd5a000, task
ffff810076d49220)
 Stack:  ffff810067ce6380 ffff81006cd5bae0 0000000000000000 ffffffff804a434f
  0000000000001000 0000000000000000 ffffe2000169bac8 0000000000000000
  0000000000000000 ffffffff804a4905 0000000000000000 0000004400000000
 Call Trace:
  [<ffffffff804a434f>] ll_rw_block+0x9c/0xbf
  [<ffffffff804a4905>] __block_prepare_write+0x358/0x434
  [<ffffffff88238d82>] :ext4dev:ext4_da_get_block_prep+0x0/0xd9
  [<ffffffff804a4a7e>] block_write_begin+0x78/0xc9
  [<ffffffff88237160>] :ext4dev:ext4_da_write_begin+0x65/0x78
  [<ffffffff88238d82>] :ext4dev:ext4_da_get_block_prep+0x0/0xd9
  [<ffffffff80463667>] generic_file_buffered_write+0x14a/0x642
  [<ffffffff8049514f>] __d_lookup+0xa8/0x104
  [<ffffffff80432143>] current_fs_time+0x1e/0x24
  [<ffffffff80463e9b>] __generic_file_aio_write_nolock+0x33c/0x3a6
  [<ffffffff80463f66>] generic_file_aio_write+0x61/0xc1
  [<ffffffff882349eb>] :ext4dev:ext4_file_write+0xa0/0x125
  [<ffffffff8048532f>] do_sync_write+0xc9/0x10c
  [<ffffffff8043f5c3>] autoremove_wake_function+0x0/0x2e
  [<ffffffff80485ad9>] vfs_write+0xad/0x156
  [<ffffffff8048607b>] sys_write+0x45/0x6e
  [<ffffffff8040be79>] tracesys+0xdc/0xe1
 Code: 3b 5c 24 08 48 89 df eb eb 5b 5d 5b 5d 44 89 e0 41 5c c3 41 54 55 89 fd
53 48 8b 06 48 89 f3 a8 04 75 04 0f 0b eb fe a8 20 75 04 <0f> 0b eb fe 48 83 7e
38 00 75 04 0f 0b eb fe f6 c4 10 74 0b 83
 RIP  [<ffffffff804a318b>] submit_bh+0x18/0xfc
  RSP <ffff81006cd5ba08>
 ---[ end trace 1b684ef9ec78f248 ]---


> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index d6ae40a..4985fd5 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2600,8 +2600,18 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>  			}
>  			if (create == EXT4_CREATE_UNINITIALIZED_EXT)
>  				goto out;
> -			if (!create)
> +			if (!create) {
> +				/*
> +				 * We have blocks reserved already. We
> +				 * return allocated blocks so that delalloc
> +				 * won't do block reservation for us. But
> +				 * the buffer head will be unmapped so that
> +				 * a read from the block return 0
> +				 */
> +				if (allocated > max_blocks)
> +					allocated = max_blocks;
>  				goto out2;
> +			}
>  
>  			ret = ext4_ext_convert_to_initialized(handle, inode,
>  								path, iblock,
