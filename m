From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [PATCH] ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
Date: Thu, 14 Feb 2008 13:48:21 +0100
Message-ID: <47B43895.7040709@bull.net>
References: <1202923172.3508.3.camel@ext1.frec.bull.fr> <20080213203305.GE3029@webber.adilger.int> <20080214041300.GA7835@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52737 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377AbYBNMrP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2008 07:47:15 -0500
In-Reply-To: <20080214041300.GA7835@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
>>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>>> index b0f84b4..0275150 100644
>>> --- a/fs/ext4/mballoc.c
>>> +++ b/fs/ext4/mballoc.c
>>> @@ -907,7 +907,7 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
>>>  	unsigned short chunk;
>>>  	unsigned short border;
>>>  
>>> -	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
>>> +	BUG_ON(len > EXT4_BLOCKS_PER_GROUP(sb));
>>>  
>>>  	border = 2 << sb->s_blocksize_bits;
>>>  
>>> @@ -3286,7 +3286,7 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>>>  	}
>>>  	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
>>>  			start > ac->ac_o_ex.fe_logical);
>>> -	BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
>>> +	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
> 
> I am not sure about this. Here size is the normalized request len. 
> Did we hit this BUG_ON ?
In fact, no. So, I'll not make the change now.
Thanks for your response and your explanations.
    Valerie
