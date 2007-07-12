From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Ext3 onlie resize failure due to small journal size
Date: Thu, 12 Jul 2007 10:40:00 +0530
Message-ID: <4695B7A8.1030008@linux.vnet.ibm.com>
References: <4694E279.1060107@linux.vnet.ibm.com> <20070711173821.GA5495@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Suzuki <suzuki@linux.vnet.ibm.com>, linux-ext4@vger.kernel.org,
	Amit K Arora <amitarora@in.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:61805 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbXGLFKd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2007 01:10:33 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6C5BDKw2199748
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jul 2007 15:11:14 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6C5DfXC157134
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jul 2007 15:13:47 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6C5A56Q002283
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jul 2007 15:10:06 +1000
In-Reply-To: <20070711173821.GA5495@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Jul 11, 2007  19:30 +0530, Suzuki wrote:
>> Trying to resize a mounted ext3 filesystem fails due to small journal size.
>>
>> Background :
>>
>> The filesystem was created with default values, except blocksize = 4K on 
>> a LV partition. Later we tried extended the partition to +16M and tried 
>> to resize the fs using resize2fs, while it was mounted.
>>
>> While adding the new blockgroup, inside setup_new_group_blocks() we hit 
>> the limit because we are requesting for a a credit value of 2 + 
>> sbi->s_itb_per_group which in the case of the file system below is 1026 
>> while the max_transaction credits possible is 1024 for the fs.
>>
>> journal->j_maxlen = inode->i_size / blocksize = 16M/4K = 4K
>>
>> journal->j_max_transaction_buffers = journal->j_maxlen / 4 = 1K
>>
>> journal->j_max_transaction_buffers = 1024.
>>
>> Is this a supported operation ? If yes, what could be the best way to 
>> fix it ?
>>
>> Resizing the journal is not supported at the moment :(.
> 
> You can't do a journal resize online, but you can wait until your next
> outage and resize the journal at that time.  Even a few extra blocks
> would be enough.  I guess this is a corner case that hasn't been hit
> before.  It might make sense to have the ext2fs_figure_journal_size()
> take this into account when making the filesystem?
> 
>

That't true. I was looking at it. I guess we should make sure we can
ask for a credit same as inode tables block per group + some extra.

Will try to see i can cook a patch.

-aneesh
