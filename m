From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Mon, 31 Mar 2008 17:46:47 +0900
Message-ID: <200803310846.AA00351@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	a-fujita@rs.jp.nec.com
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:42275 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbYCaIsx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Mar 2008 04:48:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming Cao wrote:
> On Thu, 2008-03-27 at 19:15 +0900, Akira Fujita wrote:
>> Aneesh Kumar K.V wrote:
>>> On Mon, Mar 24, 2008 at 09:31:03PM +0900, Akira Fujita wrote:
>>>   
>>>> Hi Aneesh,
>>>>     
>>>>> On Mon, Mar 24, 2008 at 08:00:54PM +0900, Akira Fujita wrote:
>>>>>       
>>>>>>>   
>>>>>>>           
>>>>>> Is EXT4_IOC_FIEMAP going to be added to the ext4 patch queue?
>>>>>> I will try to use EXT4_IOC_FIEMAP instead of EXT4_IOC_EXTENTS_INFO
>>>>>> in ext4 online defrag when kernel supports it.
>>>>>>         
>>>>> Can you also look at the sparse warnings with the patches ?
>>>>>
>>>>>       
>>>> I have already released the fixed patch before, but it is not in the ext4 patch queue yet.
>>>> Mingming, could you replace new ext4-online-defrag-free-space-fragmentation.patch
>>>> with old one in the ext4 patch queue? 
>>>>
>>>>     
>>>   CHECK   fs/ext4/defrag.c
>>>   fs/ext4/defrag.c:181:7: warning: cast to restricted type
>>>   fs/ext4/defrag.c:181:7: warning: cast from restricted type
>>>   fs/ext4/defrag.c:613:21: warning: incorrect type in argument 1
>>>   (different address spaces)
>>>   fs/ext4/defrag.c:613:21:    expected void [noderef] <asn:1>*to
>>>   fs/ext4/defrag.c:613:21:    got struct ext4_group_data_info *<noident>
>>>   fs/ext4/defrag.c:629:24: warning: incorrect type in argument 1
>>>   (different address spaces)
>>>   fs/ext4/defrag.c:629:24:    expected void [noderef] <asn:1>*to
>>>   fs/ext4/defrag.c:629:24:    got struct ext4_extents_info *<noident>
>>>   fs/ext4/defrag.c:849:29: warning: potentially expensive pointer
>>>   subtraction
>>>   fs/ext4/defrag.c:912:22: warning: potentially expensive pointer
>>>   subtraction
>>>
>>> you would need http://www.kernel.org/pub/software/devel/sparse/
>>> to find and fix these warnings.
>>>
>>>   
>> Oops, there are a lot of warnings. =-O
>> Thank you for letting me know.
>> I will release fixed defrag patches in a few days.
>
> As part of transition to move ext4 related header files out of
> include/linux, and move to fs/ext4, I also updated the defrag patches to
> adapt this change. You might want to checkout the defrag patches in
> patch queue and merge the updates before release the new version.
>
I see.
I'll use the latest patches in the ext4 patch queue to fix warnings.

BTW, I have a slight question about this warning fix.
The compiler with sparse outputs the warning for the following line.

	slots_range = o_end - o_start + 1;

<warning>
fs/ext4/defrag.c:912:22: warning: potentially expensive pointer subtraction

Then I tried to fix this line as follows.

	slots_range = ((unsigned long)o_end - (unsigned long)o_start + 1)
					/ sizeof(struct ext4_extent);

There is no warning but it seems hard to read a bit.
I have no idea whether I should fix this line or not in this case.  :-\ 

Regards,
Akira
