From: Mingming <cmm@us.ibm.com>
Subject: Re: circular locking dependency detected with lock inversion
Date: Wed, 18 Jun 2008 15:21:37 -0700
Message-ID: <1213827697.27507.95.camel@BVR-FS.beaverton.ibm.com>
References: <20080617170249.GB29335@skywalker>
	 <20080618094542.GD18994@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:60914 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbYFRWVH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jun 2008 18:21:07 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5IML5Rg005960
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 18:21:05 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5IML52p164408
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 16:21:05 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5IML5lb018427
	for <linux-ext4@vger.kernel.org>; Wed, 18 Jun 2008 16:21:05 -0600
In-Reply-To: <20080618094542.GD18994@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Wed, 2008-06-18 at 11:45 +0200, Jan Kara wrote:
> Hi,
> 
> On Tue 17-06-08 22:32:49, Aneesh Kumar K.V wrote:
> > 
> > =======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.26-rc6-autokern1 #1
> > -------------------------------------------------------
> > umount/28231 is trying to acquire lock:
> >  (&ei->i_data_sem){----}, at: [<ffffffff8030be45>] ext4_get_blocks_wrap+0x36/0x15c
> > 
> > but task is already holding lock:
> >  (&type->s_lock_key#7){--..}, at: [<ffffffff8028a856>] lock_super+0x22/0x24
> > 
> > which lock already depends on the new lock.
> > 
> > 
> > the existing dependency chain (in reverse order) is:
> > 
> > -> #1 (&type->s_lock_key#7){--..}:
> >        [<ffffffff8024dbcf>] __lock_acquire+0xc3c/0xe20
> >        [<ffffffff8024e052>] lock_acquire+0x53/0x6d
> >        [<ffffffff80503ae2>] mutex_lock_nested+0xd6/0x27d
> >        [<ffffffff8028a856>] lock_super+0x22/0x24
> >        [<ffffffff803105e1>] ext4_orphan_add+0x29/0x17d
> >        [<ffffffff8031a538>] ext4_ext_truncate+0x91/0x19c
> >        [<ffffffff8030c984>] ext4_truncate+0xbb/0x568
> >        [<ffffffff8026f07e>] vmtruncate+0xc2/0xe0
> >        [<ffffffff8029d586>] inode_setattr+0x28/0x123
> >        [<ffffffff8030ad2f>] ext4_setattr+0x226/0x284
> >        [<ffffffff8029d7ea>] notify_change+0x169/0x27b
> >        [<ffffffff80287886>] do_truncate+0x60/0x7e
> >        [<ffffffff80287a16>] sys_truncate+0x172/0x1a8
> >        [<ffffffff80222721>] sys32_truncate64+0x16/0x18
> >        [<ffffffff802223a2>] ia32_sysret+0x0/0xa
> >        [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > -> #0 (&ei->i_data_sem){----}:
> >        [<ffffffff8024dab7>] __lock_acquire+0xb24/0xe20
> >        [<ffffffff8024e052>] lock_acquire+0x53/0x6d
> >        [<ffffffff805045f7>] down_read+0x25/0x31
> >        [<ffffffff8030be45>] ext4_get_blocks_wrap+0x36/0x15c
> >        [<ffffffff8030c4cc>] ext4_get_block+0xb5/0xf3
> >        [<ffffffff802ab7ee>] generic_block_bmap+0x3a/0x40
> >        [<ffffffff803093bb>] ext4_bmap+0x70/0x79
> >        [<ffffffff8029c9aa>] bmap+0x1f/0x27
> >        [<ffffffff80335c8d>] jbd2_journal_bmap+0x2c/0x8a
> >        [<ffffffff80335fe5>] jbd2_journal_next_log_block+0x76/0x7e
> >        [<ffffffff803362cd>] jbd2_journal_get_descriptor_buffer+0x17/0x80
> >        [<ffffffff80331b15>] jbd2_journal_commit_transaction+0x56e/0x1045
> >        [<ffffffff803356c4>] jbd2_journal_destroy+0xfc/0x250
> >        [<ffffffff80312acf>] ext4_put_super+0x3e/0x213
> >        [<ffffffff8028a96a>] generic_shutdown_super+0x63/0xf8
> >        [<ffffffff8028b6d6>] kill_block_super+0x12/0x27
> >        [<ffffffff8028a81f>] deactivate_super+0x4c/0x61
> >        [<ffffffff8029f28b>] mntput_no_expire+0xed/0x120
> >        [<ffffffff802a0d30>] sys_umount+0x312/0x327
> >        [<ffffffff802223a2>] ia32_sysret+0x0/0xa
> >        [<ffffffffffffffff>] 0xffffffffffffffff
>   The problem is we call ext4_orphan_add() in ext4_ext_truncate() under
> i_data_sem. I wonder why we didn't hit it earlier... In principle, there's
> no reason why ext4_orphan_add() could not be called earlier. So the patch
> below should help.
> 

I added this patch to patch queue to see if it helps.

Thanks,
Mingming
> 								Honza

