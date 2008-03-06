From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH 2/3] ext4 online defrag (ver 0.7)
Date: Thu, 06 Mar 2008 10:36:28 -0600
Message-ID: <47D01D8C.1000806@redhat.com>
References: <200803060001.AA00324@TNESG9526.rs.jp.nec.com> <20080306052552.GL3616@webber.adilger.int> <47CF8D19.8080703@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, tytso@mit.edu, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762705AbYCFQlb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2008 11:41:31 -0500
In-Reply-To: <47CF8D19.8080703@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Akira Fujita wrote:
> Hi Andreas,
>> On Mar 06, 2008  09:01 +0900, Akira Fujita wrote:
>>   
>>> Change the name of functions (ext4_ext_xxx -> ext4_defrag_xxx)
>>> and some cleanups.
>>>
>>> -int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>>> -			ext4_lblk_t num, ext_prepare_callback func,
>>> -			void *cbdata)
>>> -{
>>>     
>> We were just going to be using this function for the FIEMAP support.
>> I think there are several other functions which are not specific
>> to defrag, so they shouldn't be renamed to be defrag specific.
>>   
> 
> ext4_ext_walk_space is no longer used by ext4 online defrag.
> So I just removed from defrag.c not renamed.
> 
> Shouldn't I remove ext4_ext_walk_space from defrag
> for support FIEMAP?
> I think it should be moved to extents.c

I agree.  I'm working on FIEMAP, and I'll put it back into extents.c
along with the FIEMAP patch, if you don't need it for defrag.

-Eric
