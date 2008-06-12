From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Thu, 12 Jun 2008 08:41:59 -0500
Message-ID: <485127A7.1000303@redhat.com>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker> <20080605032220.GC10488@mit.edu> <20080605084329.GB8942@skywalker> <1212677741.3645.44.camel@localhost.localdomain> <20080605182455.GV2961@webber.adilger.int> <484F45C9.3030804@cn.fujitsu.com> <20080612093431.GZ3726@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760193AbYFLNn3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 09:43:29 -0400
In-Reply-To: <20080612093431.GZ3726@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jun 11, 2008  11:26 +0800, Shen Feng wrote:
>> Andreas Dilger Wrote:
>>> On Jun 05, 2008  07:55 -0700, Mingming Cao wrote:
>>>>>  /**
>>>>> - * ext4_new_blocks_old() -- core block(s) allocation function
>>>>> + * ext4_orlov_new_blocks() -- core block(s) allocation function
>>>> what is orlov means? this is core function for non extent based without
>>>> mballoc block allocation, right? 
>>> Orlov is the name of the INODE allocator, not the block allocator.  I'm
>>> not sure there is a name for the block allocator except "old" or "bitmap".
>>> In the future I suspect we won't want to keep this version at all, using
>>> the mballoc allocator even for block-mapped files, but it is useful for
>>> now for performance comparisons.
>>>
>> Is that true?
>>
>> I got the following from the kernel ext4 documentation.
>> orlov		(*)	This enables the new Orlov block allocator. It is
>> 			enabled by default.
>>
>> oldalloc		This disables the Orlov block allocator and enables
>> 			the old block allocator.  Orlov should have better
>> 			performance - we'd like to get some feedback if it's
>> 			the contrary for you.
> 
> The documentation is incorrect then.  The Orlov allocator is for inodes:

Interestingly, though, the internets are full of references to "the
orlov block allocator for ext*" anyway.  :)  (it seems that the original
patches all referred to it this way):

http://lwn.net/Articles/14447/

Plus, some Orlov history for those interested ;)

http://web.archive.org/web/20070609035919/http://www.ptci.ru/gluk/dirpref/old/dirpref.html

-Eric

