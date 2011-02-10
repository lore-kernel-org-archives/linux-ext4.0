From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 4/4] ext4: Speed up FITRIM by recording flags in ext4_group_info.
Date: Thu, 10 Feb 2011 09:39:02 +0800
Message-ID: <4D5341B6.4050709@tao.ma>
References: <4D522B9B.5070707@tao.ma> <1297231048-3458-4-git-send-email-tm@tao.ma> <alpine.LFD.2.00.1102091445580.5596@dhcp-27-109.brq.redhat.com> <8576F204-586C-4046-974B-A691C8C36E34@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:48713 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752501Ab1BJBjU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Feb 2011 20:39:20 -0500
In-Reply-To: <8576F204-586C-4046-974B-A691C8C36E34@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/10/2011 03:25 AM, Andreas Dilger wrote:
> On 2011-02-09, at 06:01, Lukas Czerner wrote:
>    
>>> @@ -1200,6 +1200,9 @@ struct ext4_sb_info {
>>> 	struct ext4_li_request *s_li_request;
>>> 	/* Wait multiplier for lazy initialization thread */
>>> 	unsigned int s_li_wait_mult;
>>> +
>>> +	/* record the last minlen when FITRIM is called. */
>>> +	u64 trim_minlen;
>>>        
>> Maybe this is a bit nitpicking, but it is not very clear what is the
>> "trim_minlen" for. I would rather use something like
>> "last_trim_minblks", or similar.
>>      
> And for good measure, this should use the "s_" prefix to indicate it is in the superblock.
>    
ok.
>    
>>> +#define EXT4_GROUP_INFO_NEED_INIT_BIT		0
>>> +#define EXT4_GROUP_INFO_HAS_BEEN_TRIMMED	1
>>>        
> It would also be good if the names of these fields were consistent, like
>
> +#define EXT4_GROUP_INFO_NEED_INIT_BIT		0
> +#define EXT4_GROUP_INFO_WAS_TRIMMED_BIT	1
>    
thanks for the advice.
>    
>>> @@ -1563,6 +1563,9 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
>>> 	mb_set_bits(EXT4_MB_BITMAP(e4b), ex->fe_start, len0);
>>> 	mb_check_buddy(e4b);
>>>
>>> +	if (!ret)
>>> +		EXT4_SB(sb)->trim_minlen = minlen;
>>> +
>>>        
>> Did you even tried to compile it ? "minlen" is not defined in
>> mb_mark_used(), also it does make sense to set trim_minlen there. Did
>> not you meant it to be in ext4_trim_fs ?
>>      
> I was wondering exactly the same thing, but I haven't had time to look at the code.
>    
Sorry, it seems to be caused by my rebase. The right place should be in 
the end of ext4_trim_fs.

Regards,
Tao
> Cheers, Andreas
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

