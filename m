From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] UPDATED: types fixup for mballoc
Date: Thu, 03 Jan 2008 13:24:40 -0600
Message-ID: <477D3678.7020203@redhat.com>
References: <473CCEB8.5060201@redhat.com> <473D2147.9030504@redhat.com> <477BEDAC.1030802@redhat.com> <20080103191733.GJ3351@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbYACTYn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2008 14:24:43 -0500
In-Reply-To: <20080103191733.GJ3351@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Jan 02, 2008  14:01 -0600, Eric Sandeen wrote:
>> This patch:
>>
>> changes fe_len to an int, I don't think we need it to be a long,
>> looking at how it's used (should it be a grpblk_t?)  Also change
>> anything assigned to return value of mb_find_extent, since it returns
>> fe_len.
>>
>> changes anything that does groupno * EXT4_BLOCKS_PER_GROUP
>> or pa->pa_pstart + <whatever> to an ext4_fsblk_t
>>
>> fixes up any related formats
>>
>> The change to ext4_mb_scan_aligned to avoid a 64-bit modulo
>> could use an extra look I think.
>>
>> @@ -1732,17 +1735,18 @@ static void ext4_mb_scan_aligned(struct 
>>  	BUG_ON(sbi->s_stripe == 0);
>>  
>> -	/* find first stripe-aligned block */
>> -	i = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb)
>> -		+ le32_to_cpu(sbi->s_es->s_first_data_block);
>> -	i = ((i + sbi->s_stripe - 1) / sbi->s_stripe) * sbi->s_stripe;
>> -	i = (i - le32_to_cpu(sbi->s_es->s_first_data_block))
>> -			% EXT4_BLOCKS_PER_GROUP(sb);
> 
>> +	/* find first stripe-aligned block in group */
>> +	a = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb)
>> +		+ le32_to_cpu(sbi->s_es->s_first_data_block);
>> +	a = (a + sbi->s_stripe - 1) & ~((ext4_fsblk_t)sbi->s_stripe - 1);
>> +	a = a - le32_to_cpu(sbi->s_es->s_first_data_block);
>> +	i = do_div(a, EXT4_BLOCKS_PER_GROUP(sb));
> 
> I don't think this is correct...  This code should only be used if s_stripe
> is NOT a power-of-two value, otherwise we can just use the buddy maps to
> find aligned chunks.  As a result I don't think that "& (s_stripe - 1)"
> change is equivalent to "/ s_stripe * s_stripe".

Hmmm ok let me re-check that then.

(...curses 64-bit math trickiness...)

>>  	while (i < sb->s_blocksize * 8) {
>>  		if (!mb_test_bit(i, bitmap)) {
> 
> Hrmmm, I thought this should be "while (i < EXT4_BLOCKS_PER_GROUP(sb))"
> and not "sb->s_blocksize * 8"?  Did that fix get lost somewhere?

I did wonder about that.... wondered about the magic 8 number but forgot
to comment.

Thanks,
-Eric
