From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] mballoc: remove unncessary mb_find_buddy()
Date: Thu, 24 Feb 2011 14:07:08 -0500
Message-ID: <20110224190708.GV2924@thunk.org>
References: <4D4E2961.6020007@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Alex Tomas <alex@clusterfs.com>,
	Theodore Tso <tytso@google.com>
To: Coly Li <i@coly.li>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33061 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab1BXTHL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 14:07:11 -0500
Content-Disposition: inline
In-Reply-To: <4D4E2961.6020007@coly.li>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Added to the ext4 patch queue, thanks!!

      	     	  	       - Ted

On Sun, Feb 06, 2011 at 12:53:53PM +0800, Coly Li wrote:
> In __mb_check_buddy(), look at the bellowed code,
> 
>  591         fstart = -1;
>  592         buddy = mb_find_buddy(e4b, 0, &max);
>  593         for (i = 0; i < max; i++) {
>  594                 if (!mb_test_bit(i, buddy)) {
>  595                         MB_CHECK_ASSERT(i >= e4b->bd_info->bb_first_free);
>  596                         if (fstart == -1) {
>  597                                 fragments++;
>  598                                 fstart = i;
>  599                         }
>  600                         continue;
>  601                 }
>  602                 fstart = -1;
>  603                 /* check used bits only */
>  604                 for (j = 0; j < e4b->bd_blkbits + 1; j++) {
>  605                         buddy2 = mb_find_buddy(e4b, j, &max2);
>  606                         k = i >> j;
>  607                         MB_CHECK_ASSERT(k < max2);
>  608                         MB_CHECK_ASSERT(mb_test_bit(k, buddy2));
>  609                 }
>  610         }
>  611         MB_CHECK_ASSERT(!EXT4_MB_GRP_NEED_INIT(e4b->bd_info));
>  612         MB_CHECK_ASSERT(e4b->bd_info->bb_fragments == fragments);
>  613
>  614         grp = ext4_get_group_info(sb, e4b->bd_group);
>  615         buddy = mb_find_buddy(e4b, 0, &max);
> 
> On line 592, buddy is fetched by mb_find_buddy() with order 0, between
> line 593 to line 615, buddy is not changed, therefore there is
> no need to fetch buddy again from mb_find_buddy() with order 0 again.
> 
> We can safely remove the second mb_find_buddy() on line 615.
> 
> Signed-off-by: Coly Li <bosong.ly@taobao.com>
> Cc: Alex Tomas <alex@clusterfs.com>
> Cc: Theodore Tso <tytso@google.com>
