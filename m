From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: When reading from fallocated blocks make sure we
	return zero.
Date: Mon, 18 Feb 2008 13:15:12 +0530
Message-ID: <20080218074512.GA16067@skywalker>
References: <1203099414-8815-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1203104584.3598.4.camel@localhost.localdomain> <20080216032334.GA6501@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:52016 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYBRHpb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 02:45:31 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1I7iq9e005869
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 18:44:52 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1I7jPSo2756690
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 18:45:25 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1I7jP0s031537
	for <linux-ext4@vger.kernel.org>; Mon, 18 Feb 2008 18:45:25 +1100
Content-Disposition: inline
In-Reply-To: <20080216032334.GA6501@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 16, 2008 at 08:53:34AM +0530, Aneesh Kumar K.V wrote:
> On Fri, Feb 15, 2008 at 11:43:04AM -0800, Mingming Cao wrote:
> > On Fri, 2008-02-15 at 23:46 +0530, Aneesh Kumar K.V wrote:
> > > fallocate blocks are considered as sparse area and read from them should
> > > return zero. ext4_ext_get_blocks should return zero for read request.
> > > 
> > 
> > The patch itself looks harmless, but I still don't see how this could
> > fix the problem you described at irc: a write hit a BUG_ON() in
> > fs/buffer.c saying the buffer is not mapped. Could you add more details
> > here?
> 
> Write will take the below call chain
> 
> ext4_write_begin
>   block_write_begin
>     __block_prepare_write
>        ext4_getblock
>          ext4_get_blocks_wrap
> (1)	   ext4_ext_get_blocks with create = 0 return allocated
>        ll_rw_block  if buffer not uptodate.
>          submit_bh
> 	   BUG_ON(!buffer_mapped(bh))
> 
> 
> ext4_ext_get_blocks at (1) should have returned 0. That would cause
> ext4_get_blocks_wrap to again call ext4_ext_get_blocks with create = 1
> and that would have returned us the buffer head which is mapped. This
> would also result in splitting the extent to initialized and
> uninitialized one.
> 

The change is also needed to get mmap on fallocate space to work.

------------[ cut here ]------------
WARNING: at fs/buffer.c:1680 __block_write_full_page+0x101/0x2f1()
 Modules linked in:
 Pid: 2478, comm: mmaptest Not tainted 2.6.25-rc1 #12
  [<c0120e84>] warn_on_slowpath+0x41/0x51
  [<c0108c00>] ?  native_sched_clock+0x2d/0x9f
  [<c013b44e>] ?  __lock_acquire+0xacb/0xb13
  [<c013b44e>] ?  __lock_acquire+0xacb/0xb13
  [<c0180f97>] __block_write_full_page+0x101/0x2f1
  [<c01d053f>] ?  ext4_get_block+0x0/0xc0
  [<c018124f>] block_write_full_page+0xc8/0xd1
  [<c01d053f>] ?  ext4_get_block+0x0/0xc0
  [<c01d1a36>] ext4_ordered_writepage+0xad/0x146
  [<c01cec12>] ? bget_one+0x0/0xb
  [<c014c5dd>] __writepage+0xb/0x25
  [<c014cab2>] write_cache_pages+0x180/0x287
  [<c014c5d2>] ? __writepage+0x0/0x25
  [<c01527d5>] ?  __do_fault+0x2e2/0x324
  [<c0147889>] ? unlock_page+0x25/0x28 
  [<c014cbd6>] generic_writepages+0x1d/0x27
  [<c014cc0c>] do_writepages+0x2c/0x34
  [<c0147fe1>] __filemap_fdatawrite_range+0x5b/0x67
  [<c01481ba>] filemap_fdatawrite+0x15/0x17
  [<c017ea3d>] do_fsync+0x2c/0x9a
  [<c017eacb>] __do_fsync+0x20/0x2f
  [<c017eaf9>] sys_fsync+0xd/0xf
  [<c0104992>] sysenter_past_esp+0x5f/0xa5
  =======================
 ---[ end trace 5ba60b430e0af601 ]---


-aneesh
