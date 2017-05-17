From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: RE: Re: [PATCH] ext4: hand over jobs handling discard commands on
 commit complete phase to kworkers
Date: Wed, 17 May 2017 01:24:06 +0000
Message-ID: <20170517012406epcms1p8d4e5c4e54bf7e97c5856b1d62af6cd83@epcms1p8>
References: <20170516151153.GB7316@quack2.suse.cz>
        <1494920262-10128-1-git-send-email-daeho.jeong@samsung.com>
        <CGME20170516073738epcas1p42daa31d04ae9d07eae07d9fcee6708a2@epcms1p8>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "jack@suse.com" <jack@suse.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>, Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:27665 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbdEQBYL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 16 May 2017 21:24:11 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20170517012409epoutp022f44c0063bc03a3b7581f4f2b4450c40~-QEENjaSd0068600686epoutp02P
        for <linux-ext4@vger.kernel.org>; Wed, 17 May 2017 01:24:09 +0000 (GMT)
In-Reply-To: <20170516151153.GB7316@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> So I see several problems with this. Firstly, it breaks the ENOSPC handling

> logic which relies on the fact that after forcing a transaction commit all

> blocks held by the transaction are released - now they will be released

> only after the work is completed and thus we can prematurely report ENOSPC.





Hi, Jan.



We already freed all the blocks in the block bitmap and increased

sbi->s_freeclusters_counter in ext4_free_blocks() in advance of

ext4_free_data_callback() which is handling discard commands and releasing

blocks in the buddy cache. So, I think that it's ok about ENOSPC, because

we are ckecking whether we can allocate the blocks or not using

ext4_claim_free_clusters(), which is just seeing sbi->s_freeclusters_counter,

and the blocks were already freed from on-disk block bitmap.





> Secondly, offloading the discard work doesn't change the fundamental fact

> that discard is slow (for some devices) and this change just hides this

> fact at the possible cost of for example higher file fragmentation as a

> result of delayed block freeing. Also the outstanding queue of discard

> requests isn't limited in any way again leading to possible strange

> allocation / ENOSPC issues.





Yes, I agree with you about that the discard handling will be still slow.

However, by hiding this, we can get a better responsiveness of fsync() from

30s to 0.255s in the worst case and this is very important to mobile environments

where fsync() delay means the users have to wait to do the next action in a while.

For the higher file fragmentation, even now, we cannot free the blocks fastly

in the buddy cache because we have to handle all the discard commands before

freeing blocks in the buddy. So, we already have the same problem now. :-)



Thank you.







 
