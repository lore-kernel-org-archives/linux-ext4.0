From: Andreas Dilger <adilger@sun.com>
Subject: Re: Question on block group allocation
Date: Mon, 27 Apr 2009 17:12:40 -0600
Message-ID: <20090427231240.GA8821@webber.adilger.int>
References: <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com>
 <20090423190817.GN3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58645 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758171AbZD0XNN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Apr 2009 19:13:13 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3RNDDgn007481
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2009 16:13:13 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KIS00C007WT7Q00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 27 Apr 2009 16:13:13 -0700 (PDT)
In-reply-to: <20090423190817.GN3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 23, 2009  13:08 -0600, Andreas Dilger wrote:
> This is likely the "uninit_bg" feature that is causing the allocations
> to skip groups which are marked BLOCK_UNINIT.  In some sense the benefit
> of skipping the block bitmap read during e2fsck is probably not at all
> beneficial compared to the cost of the extra seeking during IO.  As the
> filesystem gets more full, the BLOCK_UNIIT flags would be cleared anyways,
> so we might as well just keep the early allocations contiguous.
> 
> A simple change to verify this would be something like the following,
> but it hasn't actually been tested.
> 
> --- ./fs/ext4/mballoc.c.uninit    2009-04-08 19:13:13.000000000 -0600
> +++ ./fs/ext4/mballoc.c 2009-04-23 13:02:22.000000000 -0600
> @@ -1742,10 +1723,6 @@ static int ext4_mb_good_group(struct ext
>  	switch (cr) {
>  	case 0:
>  		BUG_ON(ac->ac_2order == 0);
> -		/* If this group is uninitialized, skip it initially */
> -		desc = ext4_get_group_desc(ac->ac_sb, group, NULL);
> -		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))
> -			return 0;
>  
>  		bits = ac->ac_sb->s_blocksize_bits + 1;
>  		for (i = ac->ac_2order; i <= bits; i++)
> @@ -2039,9 +2035,7 @@ repeat:
>  			ac->ac_groups_scanned++;
>  			desc = ext4_get_group_desc(sb, group, NULL);
> -			if (cr == 0 || (desc->bg_flags &
> -				cpu_to_le16(EXT4_BG_BLOCK_UNINIT) &&
> -				ac->ac_2order != 0))
> +			if (cr == 0)
>  				ext4_mb_simple_scan_group(ac, &e4b);
>  			else if (cr == 1 &&
>  					ac->ac_g_ex.fe_len == sbi->s_stripe)

Because this is actually proving to be useful:

Signed-off-by: Andreas Dilger <adilger@sun.com>

As we discussed in the call, I suspect BLOCK_UNINIT was more useful in the
past when directories were spread over all groups evenly (pre-Orlov), and
before flex_bg where seeking to read all of the bitmaps was a slow and
painful process.  For flex_bg it could be WORSE to skip bitmap reads because
instead of doing contiguous 64kB reads it may now doing read 4kB, seek,
read 4kB, seek, etc.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

