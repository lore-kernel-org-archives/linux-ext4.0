From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC PATCH 10/17] signed int -> blk64_t to fix bugs at 2^31 -
 2^32 blocks
Date: Thu, 13 Nov 2008 21:42:52 -0600
Message-ID: <491CF3BC.80305@redhat.com>
References: <1226461390-5502-3-git-send-email-vaurora@redhat.com> <1226461390-5502-4-git-send-email-vaurora@redhat.com> <1226461390-5502-5-git-send-email-vaurora@redhat.com> <1226461390-5502-6-git-send-email-vaurora@redhat.com> <1226461390-5502-7-git-send-email-vaurora@redhat.com> <1226461390-5502-8-git-send-email-vaurora@redhat.com> <1226461390-5502-9-git-send-email-vaurora@redhat.com> <1226461390-5502-10-git-send-email-vaurora@redhat.com> <1226461390-5502-11-git-send-email-vaurora@redhat.com> <20081113195742.GV16005@webber.adilger.int> <20081114023812.GD20637@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56777 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYKNDnS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2008 22:43:18 -0500
In-Reply-To: <20081114023812.GD20637@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Aurora Henson wrote:
> On Thu, Nov 13, 2008 at 12:57:42PM -0700, Andreas Dilger wrote:
>> On Nov 11, 2008  19:43 -0800, Valerie Aurora Henson wrote:
>>> diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
>>> index 7235f7d..71ad445 100644
>>> --- a/lib/ext2fs/alloc_tables.c
>>> +++ b/lib/ext2fs/alloc_tables.c
>>> @@ -147,7 +147,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
>>> -		int prev_block = 0;
>>> +		blk64_t prev_block = 0;
>>> @@ -178,7 +178,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
>>>  	if (flexbg_size) {
>>> -		int prev_block = 0;
>>> +		blk64_t prev_block = 0;
>> These appear to be defects in the base code and should be landed ASAP
>> (as int -> blk_t) independently of this patch series.
> 
> Agreed.  Ted, is this a good format for you or do you want me to
> regenerate against something?

Is it?

        if (flexbg_size) {
                int prev_block = 0;
                if (group && fs->group_desc[group-1].bg_block_bitmap)
                        prev_block =
fs->group_desc[group-1].bg_block_bitmap;
                start_blk = flexbg_offset(fs, group, prev_block, bmap,
                                                 0, rem_grps, 1);
                last_blk = ext2fs_group_last_block(fs, last_grp);
        }

bg_block_bitmap is only a __u32, and that's what we assign to prev_block.

Just a quick scan, but isn't this just a relative block in the group?

-Eric

> -VAL
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

