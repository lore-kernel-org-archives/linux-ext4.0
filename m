From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] UPDATED2: types fixup for mballoc
Date: Thu, 03 Jan 2008 15:07:48 -0600
Message-ID: <477D4EA4.6040402@redhat.com>
References: <473CCEB8.5060201@redhat.com> <473D2147.9030504@redhat.com> <477BEDAC.1030802@redhat.com> <20080103191733.GJ3351@webber.adilger.int> <477D3678.7020203@redhat.com> <477D4152.4020901@redhat.com> <20080103203546.GM3351@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Alex Tomas <Alex.Tomas@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbYACVHu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2008 16:07:50 -0500
In-Reply-To: <20080103203546.GM3351@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jan 03, 2008  14:10 -0600, Eric Sandeen wrote:
>> @@ -1732,17 +1735,19 @@ static void ext4_mb_scan_aligned(struct 
>> +	/* find first stripe-aligned block in group */
>> +	a = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb)
>>  		+ le32_to_cpu(sbi->s_es->s_first_data_block);
>> +	a += sbi->s_stripe - 1;
> 
> Why not just have "+ sbi->s_stipe - 1" on the previous line, instead of "+="?

hmm good point.

> Also minor coding style nit: the "+" is normally at the end of the previous
> line instead of at the start of the next line, so:
> 
> 	/* find first stripe-aligned block in group */
> 	a = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb) +
> 		le32_to_cpu(sbi->s_es->s_first_data_block) + sbi->s_stripe - 1;

Ok, that was inherited :)

>> +	a = (a * sbi->s_stripe) - le32_to_cpu(sbi->s_es->s_first_data_block);
>> +	i = do_div(a, EXT4_BLOCKS_PER_GROUP(sb));
> 
> I guess this doesn't stricly need to be a modulus either, because we know
> which group this will be in and can just subtract the start.  You can just do:
>  
> 	/* find first stripe-aligned block in this group */
> 	group_start = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb) +;
> 		le32_to_cpu(sbi->s_es->s_first_data_block);
> 
> 	a = group_start + sbi->s_stripe - 1;
> 	do_div(a, sbi->s_stripe);
> 	a = (a * sbi->s_stripe) - group_start;

Ok, I knew I had stared at this for too long :)

4th try coming soon.

-Eric
