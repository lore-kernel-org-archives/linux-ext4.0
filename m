From: "Alex Tomas" <alex@clusterfs.com>
Subject: Re: new mballoc patches.
Date: Sun, 30 Sep 2007 07:51:41 +0400
Message-ID: <cac28cb80709292051r7a09d5few3bf25a535e4222fb@mail.gmail.com>
References: <46E651E6.3070107@linux.vnet.ibm.com>
	 <46E8A5A9.6040105@linux.vnet.ibm.com>
	 <46EA7A36.8050002@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Andreas Dilger" <adilger@clusterfs.com>,
	"Mingming Cao" <cmm@us.ibm.com>,
	"Avantika Mathur" <mathur@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48607 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbXI3Dvo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 29 Sep 2007 23:51:44 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mail.clusterfs.com (Postfix) with ESMTP id 971264E456B
	for <linux-ext4@vger.kernel.org>; Sat, 29 Sep 2007 21:51:43 -0600 (MDT)
Received: by ug-out-1314.google.com with SMTP id o2so1971442uge
        for <linux-ext4@vger.kernel.org>; Sat, 29 Sep 2007 20:51:42 -0700 (PDT)
In-Reply-To: <46EA7A36.8050002@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

yes, it's absolutely safe to remove. I just wanted to see how many
collisions happen in "real life".

On 9/14/07, Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> wrote:
> Hi Alex,
>
> Aneesh Kumar K.V wrote:
> >
> > I checked the logs today for the fsstress run i found this in my dmesg
> > log. The
> > same stack trace is repeated for many times
> >
> >
> > uh! busy PA
> > Call Trace:
> > [c0000000efa72fc0] [c00000000000fe30] .show_stack+0x6c/0x1a0 (unreliable)
> > [c0000000efa73060] [c0000000001954a0]
> > .ext4_mb_discard_group_preallocations+0x208/0x4fc
> > [c0000000efa73180] [c0000000001957c8]
> > .ext4_mb_discard_preallocations+0x34/0x94
> > [c0000000efa73220] [c000000000197fc8] .ext4_mb_new_blocks+0x1fc/0x2c0
> > [c0000000efa733a0] [c00000000018dfb4] .ext4_ext_get_blocks+0x540/0x6f8
> > [c0000000efa734d0] [c00000000017bfe8] .ext4_get_block+0x12c/0x1b4
> > [c0000000efa73580] [c000000000109104] .__blockdev_direct_IO+0x554/0xb94
> > [c0000000efa736b0] [c000000000179b28] .ext4_direct_IO+0x138/0x208
> > [c0000000efa73790] [c00000000009a314] .generic_file_direct_IO+0x134/0x1a0
> > [c0000000efa73840] [c00000000009a404] .generic_file_direct_write+0x84/0x150
> > [c0000000efa73900] [c00000000009bf54]
> > .__generic_file_aio_write_nolock+0x2c4/0x3d4
> > [c0000000efa73a00] [c00000000009c0e4] .generic_file_aio_write+0x80/0x114
> > [c0000000efa73ac0] [c000000000175c90] .ext4_file_write+0x2c/0xd4
> > [c0000000efa73b50] [c0000000000d0cf4] .do_sync_write+0xc4/0x124
> > [c0000000efa73cf0] [c0000000000d16bc] .vfs_write+0x120/0x1f4
> > [c0000000efa73d90] [c0000000000d21a8] .sys_write+0x4c/0x8c
> > [c0000000efa73e30] [c00000000000852c] syscall_exit+0x0/0x40
> > uh! busy PA
>
>
> I think we can remove from the code this dump_stack.
>
>
> list_for_each_entry_safe(pa, tmp,
>                                 &grp->bb_prealloc_list, pa_group_list) {
>                 spin_lock(&pa->pa_lock);
>                 if (atomic_read(&pa->pa_count)) {
>                         spin_unlock(&pa->pa_lock);
>                         printk(KERN_ERR "uh! busy PA\n");
>                         dump_stack();
>                         busy = 1;
>                         continue;
>                 }
>
> This happens during ext4_mb_discard_group_prealloction. It is quiet possible that
> during the discard operation some other CPUs can use the preallocated space right ?
> Infact down the code we see if we have skipped some of the PA (busy == 1 )and the
> free space retrieved is not enough they we loop again
>
> Can you let me know why we marked the dump_stack there ?
>
>
> -aneesh
>
>
>


-- 
thanks, Alex
