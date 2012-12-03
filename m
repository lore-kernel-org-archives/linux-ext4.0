From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [PATCH] ext4: remove some unused code lines
Date: Mon, 3 Dec 2012 10:11:20 +0800
Message-ID: <CAEH94Lj2DvVREkOJfbPN4eyismsjeZ+t0x=QfumDZ5p=bXk7LA@mail.gmail.com>
References: <1354183200-8628-1-git-send-email-zwu.kernel@gmail.com>
	<20121202122726.GA14852@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: zwu.kernel@gmail.com, linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59666 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2LCCLW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2012 21:11:22 -0500
In-Reply-To: <20121202122726.GA14852@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 2, 2012 at 8:27 PM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Thu, Nov 29, 2012 at 06:00:00PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> Please write a commit log to describe this patch, even though it is
> quite simple and straightfoward
Good suggestion, thanks.
>
> Otherwise, it looks good to me.
>
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
>
> Regards,
>                                                 - Zheng
>
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  fs/ext4/extents.c |    2 --
>>  1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 7011ac9..43ec639 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -2156,7 +2156,6 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
>>                 struct ext4_extent *ex)
>>  {
>>       struct ext4_ext_cache *cex;
>> -     struct ext4_sb_info *sbi;
>>       int ret = 0;
>>
>>       /*
>> @@ -2164,7 +2163,6 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
>>        */
>>       spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>>       cex = &EXT4_I(inode)->i_cached_extent;
>> -     sbi = EXT4_SB(inode->i_sb);
>>
>>       /* has cache valid data? */
>>       if (cex->ec_len == 0)
>> --
>> 1.7.6.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,

Zhi Yong Wu
