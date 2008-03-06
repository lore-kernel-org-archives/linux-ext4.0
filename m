From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 2/3] ext4 online defrag (ver 0.7)
Date: Thu, 06 Mar 2008 15:20:09 +0900
Message-ID: <47CF8D19.8080703@rs.jp.nec.com>
References: <200803060001.AA00324@TNESG9526.rs.jp.nec.com> <20080306052552.GL3616@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:48690 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbYCFGZR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2008 01:25:17 -0500
In-Reply-To: <20080306052552.GL3616@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,
> On Mar 06, 2008  09:01 +0900, Akira Fujita wrote:
>   
>> Change the name of functions (ext4_ext_xxx -> ext4_defrag_xxx)
>> and some cleanups.
>>
>> -int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>> -			ext4_lblk_t num, ext_prepare_callback func,
>> -			void *cbdata)
>> -{
>>     
>
> We were just going to be using this function for the FIEMAP support.
> I think there are several other functions which are not specific
> to defrag, so they shouldn't be renamed to be defrag specific.
>   

ext4_ext_walk_space is no longer used by ext4 online defrag.
So I just removed from defrag.c not renamed.

Shouldn't I remove ext4_ext_walk_space from defrag
for support FIEMAP?
I think it should be moved to extents.c

Regards, Akira

-- 
Akira Fujita <a-fujita@rs.jp.nec.com>

