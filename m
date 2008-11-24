From: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap and
 mark_diskspace_used
Date: Mon, 24 Nov 2008 21:17:53 +0300
Message-ID: <492AEFD1.4060701@sun.com>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20081123140038.GC26473@mit.edu> <492A5453.9030801@sun.com>
 <20081124113323.GC8462@skywalker> <492AD821.9030506@sun.com>
 <20081124164300.GD8462@skywalker> <492AEC69.40202@sun.com>
 <20081124181252.GE8462@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@MIT.EDU>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:44665 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYKXSSJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 13:18:09 -0500
Received: from fe-emea-10.sun.com (gmp-eb-lb-2-fe3.eu.sun.com [192.18.6.12])
	by gmp-eb-inf-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAOII7BJ009118
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 18:18:07 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAU00F01NXBGC00@fe-emea-10.sun.com>
 (original mail from Alex.Zhuravlev@Sun.COM) for linux-ext4@vger.kernel.org;
 Mon, 24 Nov 2008 18:18:07 +0000 (GMT)
In-reply-to: <20081124181252.GE8462@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> With commit c806e68f we do a init_bitmap every time we do a
> read_block_bitmap.

can you explain why do we need to init it every time?

thanks, Alex

> 
> To quote the update commit message that i have
> 
>     ext4: Fix race between read_block_bitmap() and mark_diskspace_used()
>     
>     We need to make sure we update the block bitmap and clear
>     EXT4_BG_BLOCK_UNINIT flag with sb_bgl_lock held.  We look at
>     EXT4_BG_BLOCK_UNINIT and reinit the block bitmap each time in
>     ext4_read_block_bitmap (introduced by commit c806e68f), and this can
>     race with block allocations in ext4_mb_mark_diskspace_used().
>     
>     ext4_read_block_bitmap does:
>     
>     spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
>     if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
>     	ext4_init_block_bitmap(sb, bh, block_group, desc);
>     
>     Now on the block allocation side we do
>     
>     mb_set_bits(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group), bitmap_bh->b_data,
>     			ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
>     ....
>     spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
>     if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
>     	gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
>     
>     ie on allocation we update the bitmap then we take the sb_bgl_lock
>     and clear the EXT4_BG_BLOCK_UNINIT flag. What can happen is a
>     parallel ext4_read_block_bitmap can zero out the bitmap in between
>     the above mb_set_bits and spin_lock(sb_bg_lock..)
>     
>     The race results in below user visible errors
>     EXT4-fs error (device sdb1): ext4_mb_release_inode_pa: free 100, pa_free 105
>     EXT4-fs error (device sdb1): mb_free_blocks: double-free of inode 0's block 50(bit 100 in group 0)
> 
> -aneesh

