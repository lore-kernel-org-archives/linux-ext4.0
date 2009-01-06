From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH] ext4: fix null pointer deref on mount
Date: Tue, 06 Jan 2009 17:32:07 +0100
Message-ID: <49638787.3020707@ph.tum.de>
References: <4961603B.5020505@ph.tum.de> <20090105170259.GB8939@mit.edu> <49627285.8060407@ph.tum.de> <20090105213938.GG8939@mit.edu> <49628EBF.2040805@ph.tum.de> <20090105234411.GD14500@mit.edu> <4963529F.4040703@ph.tum.de> <20090106132509.GA12407@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:48059 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249AbZAFQ3v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 11:29:51 -0500
In-Reply-To: <20090106132509.GA12407@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Jan 06, 2009 at 01:46:23PM +0100, Thiemo Nagel wrote:
>>>> @@ -2160,6 +2162,15 @@
>>>>  			EXT4_BLOCKS_PER_GROUP(sb) - 1);
>>>>  	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
>>>>  	sbi->s_groups_count = blocks_count;
>>>> +	if (sbi->s_groups_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
>>> This can't possibly work, given that s_groups_count is an unsigned
>>> int.
>> I'm casting to uint64_t, so in my opinion it should work on all  
>> architectures.
> ... which doesn't help given that sbi->s_groups_count is 32 bits on
> x86_32 machines if it is unsigned long, and always 32 bits once
> ext4_group_t was changed to be an unsigned int.

You're right.

Thiemo
