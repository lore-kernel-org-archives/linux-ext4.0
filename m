From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 0/8] ext4 online defrag (ver 0.8)
Date: Mon, 14 Apr 2008 13:14:05 +0900
Message-ID: <4802DA0D.4060502@rs.jp.nec.com>
References: <47F60EA7.1050604@rs.jp.nec.com> <1207945113.3639.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36868 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYDNEQE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Apr 2008 00:16:04 -0400
In-Reply-To: <1207945113.3639.5.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Mingming Cao wrote:
>> Summary of patches:
>> * These patches are replaced with ext4 online defrag patches
>>   which are already in the ext4 git tree (linux-2.6.26-rc8).
>>
>> [PATCH 1/8]  Exchange the blocks between two inodes
>> - Exchange the data blocks between the temporary inode and
>>   the original inode.
>>
>> [PATCH 2/8] Read and write file data with memory page
>> - Read the file data from the old blocks to the page and
>>   write the file data on the page into the new blocks.
>>
>> [PATCH 3/8] Allocate new contiguous blocks with mballoc
>> - Search contiguous free blocks with mutil-block allocation
>>   and allocate them for the temporary inode.
>>
>> [PATCH 4/8] Main function of ext4 online defrag and ioctl implementation
>> - Create the temporary inode and do defrag per
>>   defrag_size (defalut 64MB).
>>
> 
> I am curious about the ordering here. It seems reverse the order of the
> first 4 patches make the logic more clear to me, start from patch 4,
> then 3, then 2 and last 1?  At lease when I read the describtion of the
> first patch I was puzzled by a minute what is this coming from
> 
> Just share my thoughts.
> 

Ah, as you said, the ordering the patches is confusing.
I'll reconstruct my patches order(4-3-2-1-5-6-7-8) to be clear
in the future release.

Thanks,
Akira
