From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH] ext4: fix null pointer deref on mount
Date: Tue, 06 Jan 2009 13:46:23 +0100
Message-ID: <4963529F.4040703@ph.tum.de>
References: <4961603B.5020505@ph.tum.de> <20090105170259.GB8939@mit.edu> <49627285.8060407@ph.tum.de> <20090105213938.GG8939@mit.edu> <49628EBF.2040805@ph.tum.de> <20090105234411.GD14500@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:48301 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbZAFMoI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 07:44:08 -0500
In-Reply-To: <20090105234411.GD14500@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> I'd rewrite the test as:
> 	/*
> 	 * It makes no sense for the first data block to be beyond the end
> 	 * of the filesystem.
> 	 */
> 	if (le32_to_cpu(es->s_first_data_block) >= ext4_blocks_count(es)) {
>   		printk(KERN_WARNING "EXT4-fs: bad geometry: first data"
> 			"block %u is beyond end of filesystem(%llu)\n",
> 			le32_to_cpu(es->s_first_data_block),
> 			ext4_blocks_count(es));

Much better.

>> @@ -2160,6 +2162,15 @@
>>  			EXT4_BLOCKS_PER_GROUP(sb) - 1);
>>  	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
>>  	sbi->s_groups_count = blocks_count;
>> +	if (sbi->s_groups_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
> 
> This can't possibly work, given that s_groups_count is an unsigned
> int.

I'm casting to uint64_t, so in my opinion it should work on all 
architectures.

Kind regards,
Thiemo
