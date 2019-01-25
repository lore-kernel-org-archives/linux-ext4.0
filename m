Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E093C282C3
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 02:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02F45218D2
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 02:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfAYCC0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 21:02:26 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:40683 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727983AbfAYCC0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Jan 2019 21:02:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07487;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TIxfOHb_1548381742;
Received: from 30.5.112.244(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TIxfOHb_1548381742)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 25 Jan 2019 10:02:23 +0800
Subject: Re: [PATCH v2 2/2] ext4: fix slow writeback under dioread_nolock and
 nodelalloc
To:     Jan Kara <jack@suse.cz>, "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org, Liu Bo <bo.liu@linux.alibaba.com>
References: <20181215054840.5960-1-xiaoguang.wang@linux.alibaba.com>
 <20181215054840.5960-2-xiaoguang.wang@linux.alibaba.com>
 <20190123062737.GC7597@mit.edu> <20190123124823.GE20927@quack2.suse.cz>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <57434a9c-888b-1aea-9c44-1d20650959cd@linux.alibaba.com>
Date:   Fri, 25 Jan 2019 10:02:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190123124823.GE20927@quack2.suse.cz>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

hi,


> On Wed 23-01-19 01:27:38, Theodore Y. Ts'o wrote:
>> On Sat, Dec 15, 2018 at 01:48:40PM +0800, Xiaoguang Wang wrote:
>>> With "nodelalloc", blocks are allocated at the time of writing, and with
>>> "dioread_nolock", these allocated blocks are marked as unwritten as well,
>>> so bh(s) attached to the blocks have BH_Unwritten and BH_Mapped.
>>
>> I've been looking at your patches, and it seems that a simpler way,
>> perhaps more maintainable approach in the long term is to change how
>> we write to newly allocated blocks.  Today, we have two ways of doing
>> this:
>>
>> 1) In the dioread_nolock case, we allocate blocks, insert an entry in
>> the extent tree with the blocks marked uninitialized, write the
>> blocks, and then mark the blocks initialized.
>>
>> 2) In the !dioread_nolock case, we allocate blocks, insert an entry to
>> the extent tree, write the blocks --- and if we start a commit, we
>> write out all dirty pages associated with that inode (in the default
>> data=writeback case) to avoid stale writes.
>>
>> So what if we change the dioread_nolock case to do write the blocks
>> first, and *then* insert the entry into the extent tree?  This avoids
>> stale data getting exposed, either by a direct I/O read, or after a
>> crash (which means we avoid needing to do the force write-out).
>>
>> So what we would need to do is to pass a flag to ext4_map_blocks()
>> which causes it to *not* make any on-disk changes.  Instead, it would
>> track the fact that blocks have be reserved in the buddy bitmap (this
>> is how we prevent blocks from being preallocated after they are
>> deleted, but before the transaction has been committed), and the
>> location of the assigned blocks in the extent_status tree.  Since no
>> on-disk changes are being made, we wouldn't need to hold the
>> transaction open.
>>
>> Then in the callback after the blocks are written, using the starting
>> logical block number stored in the io_end structure, we either convert
>> the unwritten extents or actually insert the newly allocated blocks in
>> the extent tree and update the on-disk bitmap allocation bitmaps.
>>
>> Once we get this working, it should be easy to make dioread_nolock for
>> 1k block sizes; it keeps the time that the handle open very short; and
>> it completely obviates the need for data=writeback.
>>
>> What do folks think?
> 
> Hum, so there is the problem that adding extent to the extent tree may need
> some block allocations for metadata. So we'd have to carry over delalloc
> reservations upto the io-end time. But that should be doable, just needs
> some work. Also in the dioread_nolock case we don't have problems with
> page lock & page writeback vs transaction start deadlocks as I've described
> in my another email regarding ext4_writepages(). So I don't see any hole in
> this and the performance should be good. I like this!
First sorry for late response, I was busy with some internal work.
I really like your ideas, thanks both of you. Writing dirty pages while holding
open jbd2 handle will result in some issues, for example, system load will be high,
many tasks in the D state, some of them is stuck in wait_transaction_locked().

Currently I have tried some methods to fix this issue, for example, change
MAX_WRITEPAGES_EXTENT_LEN to 256, then we can make sure that one bio will
be generated at most, and this bio will be submitted after journal stop:
		if (!ext4_handle_valid(handle) || handle->h_sync == 0) {
			ext4_journal_stop(handle);
			handle = NULL;
			mpd.do_map = 0;
		}
		/* Submit prepared bio */
		ext4_io_submit(&mpd.io_submit);
After this change, the number of tasks in D state will decrease much,
Of course, my method is not good, I just say writing diry pages while holding
open jbd2 handle is not good :) and I believe that your ideas can fix this kind
of problems, thanks again.

Regards,
Xiaoguang Wang



Regards,
Xiaoguang Wang

> 
> 								Honza
> 
