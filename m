From: Rishikesh K Rajak <risrajak@in.ibm.com>
Subject: Re: Oops with ext4 from 2.6.27-rc3
Date: Thu, 14 Aug 2008 11:09:25 +0530
Message-ID: <OF8D47BF2B.8827A7D7-ON652574A5.001EE687-652574A5.001EC03B@in.ibm.com>
References: <47983.10.5.1.205.1218652098.squirrel@webmail.lugor.de>	 <200808132255.10194.mail@eworm.de> <20080813210408.GC6142@mit.edu>
	 <200808132307.07437.mail@eworm.de> <20080813220100.GE6142@mit.edu>	 <1218672653.6456.14.camel@mingming-laptop> <216e58580808132159y53fc5403xb52839e1be2186a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Iranna D Ankad <iranna.ankad@in.ibm.com>,
	linux-ext4@vger.kernel.org, "Christian Hesse" <mail@eworm.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Mingming Cao" <cmm@us.ibm.com>, "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:41243 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750840AbYHNGBV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 02:01:21 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7E5eIcG022926
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 11:10:18 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7E5dVVT1527946
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 11:10:18 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7E5dRHo030537
	for <linux-ext4@vger.kernel.org>; Thu, 14 Aug 2008 11:09:27 +0530
In-Reply-To: <216e58580808132159y53fc5403xb52839e1be2186a6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Mingming & Ted, Thanks for your patch. Now it is working fine for me.


<TESTED-By: Rishikesh K Rajak risrajak@in.ibm.com >

> Ext4: Fix delalloc release block reservation for truncate
>
> From: Mingming Cao <cmm@us.ibm.com>
>
> Ext4 will release the reserved blocks for delalloc
> when inode is truncated/unlinked.  If there is no reserved block at all,
> we  shouldn't  need to do so.  But current code still tries to release
the
> reserved blocks regardless whether the counters's value is 0.
> Continue doing that causes the later calculation went wrong and a
> kernel BUG_ON()
> catched that. This doesn't happen for originally extent format file,
> as the calculation
> for 0 reserved blocks was right for  extent based file.
>
> This patch fixed the kernel BUG() due to above reason. It adds checks for
0 to
> avoid unnecessary release and fix calculation for non extent files.
>
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>

<TESTED-By: Rishikesh K Rajak risrajak@in.ibm.com >

> Index: linux-2.6.27-rc1/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.27-rc1.orig/fs/ext4/inode.c       2008-08-13 15:29:35.
> 000000000 -0700
> +++ linux-2.6.27-rc1/fs/ext4/inode.c    2008-08-13 16:22:14.000000000
-0700
> @@ -1007,6 +1007,9 @@ static int ext4_indirect_calc_metadata_a
>  */
>  static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
>  {
> +       if (!blocks)
> +               return 0;
> +
>        if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
>                return ext4_ext_calc_metadata_amount(inode, blocks);
>
> @@ -1553,8 +1556,27 @@ static void ext4_da_release_space(struct
>        struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>        int total, mdb, mdb_free, release;
>
> +       if (!to_free){
> +               /* Nothing to release, exit */
> +               return;
> +       }
> +
>        spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>
> +       if (!EXT4_I(inode)->i_reserved_data_blocks){
> +               /*
> +                * if there is no reserved blocks, but we try to free
some
> +                * then the counter is messed up somewhere.
> +                * but since this function is called from invalidate
> +                * page, it's harmless to return without any action
> +                */
> +               printk(KERN_INFO "ext4 delalloc try to release %d
reserved"
> +                           "blocks for inode %lu, but there is no
reserved"
> +                           "data blocks\n", inode->i_ino, to_free);
> +               spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +               return;
> +       }
> +
>        /* recalculate the number of metablocks still need to be reserved
*/
>        total = EXT4_I(inode)->i_reserved_data_blocks - to_free;
>        mdb = ext4_calc_metadata_amount(inode, total);
> @@ -3592,7 +3614,7 @@ void ext4_truncate(struct inode *inode)
>         * ext4 *really* writes onto the disk inode.
>         */
>        ei->i_disksize = inode->i_size;
> -
> +
>        if (n == 1) {           /* direct blocks */
>                ext4_free_data(handle, inode, NULL, i_data+offsets[0],
>                               i_data + EXT4_NDIR_BLOCKS);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

