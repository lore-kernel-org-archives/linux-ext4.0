From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Thu, 27 Mar 2008 19:15:58 +0900
Message-ID: <47EB73DE.7050702@rs.jp.nec.com>
References: <200803241231.AA00344@TNESG9526.rs.jp.nec.com> <20080325174827.GA7190@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, cmm@us.ibm.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37091 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYC0KU1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Mar 2008 06:20:27 -0400
In-Reply-To: <20080325174827.GA7190@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, Mar 24, 2008 at 09:31:03PM +0900, Akira Fujita wrote:
>   
>> Hi Aneesh,
>>     
>>> On Mon, Mar 24, 2008 at 08:00:54PM +0900, Akira Fujita wrote:
>>>       
>>>>>   
>>>>>           
>>>> Is EXT4_IOC_FIEMAP going to be added to the ext4 patch queue?
>>>> I will try to use EXT4_IOC_FIEMAP instead of EXT4_IOC_EXTENTS_INFO
>>>> in ext4 online defrag when kernel supports it.
>>>>         
>>> Can you also look at the sparse warnings with the patches ?
>>>
>>>       
>> I have already released the fixed patch before, but it is not in the ext4 patch queue yet.
>> Mingming, could you replace new ext4-online-defrag-free-space-fragmentation.patch
>> with old one in the ext4 patch queue? 
>>
>>     
>
>   CHECK   fs/ext4/defrag.c
>   fs/ext4/defrag.c:181:7: warning: cast to restricted type
>   fs/ext4/defrag.c:181:7: warning: cast from restricted type
>   fs/ext4/defrag.c:613:21: warning: incorrect type in argument 1
>   (different address spaces)
>   fs/ext4/defrag.c:613:21:    expected void [noderef] <asn:1>*to
>   fs/ext4/defrag.c:613:21:    got struct ext4_group_data_info *<noident>
>   fs/ext4/defrag.c:629:24: warning: incorrect type in argument 1
>   (different address spaces)
>   fs/ext4/defrag.c:629:24:    expected void [noderef] <asn:1>*to
>   fs/ext4/defrag.c:629:24:    got struct ext4_extents_info *<noident>
>   fs/ext4/defrag.c:849:29: warning: potentially expensive pointer
>   subtraction
>   fs/ext4/defrag.c:912:22: warning: potentially expensive pointer
>   subtraction
>
> you would need http://www.kernel.org/pub/software/devel/sparse/
> to find and fix these warnings.
>
>   
Oops, there are a lot of warnings. =-O
Thank you for letting me know.
I will release fixed defrag patches in a few days.

Regards, Akira
