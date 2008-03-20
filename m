From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [2.6.25-rc5-ext4-36c86] attempt to access beyond end of device
Date: Wed, 19 Mar 2008 21:19:19 -0500
Message-ID: <47E1C9A7.6000200@redhat.com>
References: <18399.36935.640758.796880@frecb006361.adech.frec.bull.fr> <20080318162301.GA8432@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Solofo.Ramangalahy@bull.net, linux-ext4@vger.kernel.org
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbYCTCTz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2008 22:19:55 -0400
In-Reply-To: <20080318162301.GA8432@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitri Monakhov wrote:
> On 10:49 Tue 18 Mar     , Solofo.Ramangalahy@bull.net wrote:
> Content-Description: message body and .signature
>> Hello,
>>
>> During stress testing (workload: racer from ltp + fio/iometer), here
>> is an error I am encountering:
> Confirm this issue happens after ~30secs of ltp fsstress.
> 
> This happens because of error in ext4_get_block()
> ext4_get_block()
> { 
> ...
> 	ret = ext4_get_blocks_wrap(handle, inode, iblock,
>                                         max_blocks, bh_result, create, 0);
>         if (ret > 0) {
>                 r2 = ret;
>                 bh_result->b_size = (ret << inode->i_blkbits);
> # Setting b_size, if ret > 1 then bh_result is broken because
> #  b_size must always be equal to FS logical block size(1<<inode->i_blkbits)

I don't think that's quite right.

this bh is a dummy bh, right, which just gives us info on the mapping.

static int ext4_get_block(struct inode *inode, sector_t iblock,
                        struct buffer_head *bh_result, int create)
{
        handle_t *handle = ext4_journal_current_handle();
        int ret = 0, started = 0;
        unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;

for starters, ext3 does exactly the same thing.

Also look for example at get_more_blocks():

                map_bh->b_state = 0;
                map_bh->b_size = fs_count << dio->inode->i_blkbits;
...
                ret = (*dio->get_block)(dio->inode, fs_startblk,
                                                map_bh, create);

or do_mpage_readpage():

        nblocks = map_bh->b_size >> blkbits;

....

                if (block_in_file < last_block) {
                        map_bh->b_size = (last_block-block_in_file) <<
blkbits;
                        if (get_block(inode, block_in_file, map_bh, 0))
                                goto confused;
                        *first_logical_block = block_in_file;
                }

the bh->b_size can be more than a block; in this case it's not a problem.

maybe some buffer tracing would be in order?

-Eric
