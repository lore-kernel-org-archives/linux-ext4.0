From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix null pointer deref on mount
Date: Tue, 6 Jan 2009 08:25:09 -0500
Message-ID: <20090106132509.GA12407@mit.edu>
References: <4961603B.5020505@ph.tum.de> <20090105170259.GB8939@mit.edu> <49627285.8060407@ph.tum.de> <20090105213938.GG8939@mit.edu> <49628EBF.2040805@ph.tum.de> <20090105234411.GD14500@mit.edu> <4963529F.4040703@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54066 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbZAFNZL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Jan 2009 08:25:11 -0500
Content-Disposition: inline
In-Reply-To: <4963529F.4040703@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 06, 2009 at 01:46:23PM +0100, Thiemo Nagel wrote:
>>> @@ -2160,6 +2162,15 @@
>>>  			EXT4_BLOCKS_PER_GROUP(sb) - 1);
>>>  	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
>>>  	sbi->s_groups_count = blocks_count;
>>> +	if (sbi->s_groups_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
>>
>> This can't possibly work, given that s_groups_count is an unsigned
>> int.
>
> I'm casting to uint64_t, so in my opinion it should work on all  
> architectures.

... which doesn't help given that sbi->s_groups_count is 32 bits on
x86_32 machines if it is unsigned long, and always 32 bits once
ext4_group_t was changed to be an unsigned int.

						- Ted

