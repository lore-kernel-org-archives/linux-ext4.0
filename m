From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [patch]check NULL pointer
Date: Thu, 09 Jun 2011 09:51:46 -0500
Message-ID: <4DF0DE02.1090008@redhat.com>
References: <1307590292.15392.71.camel@sli10-conroe> <alpine.LFD.2.00.1106091112560.4138@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Shaohua Li <shaohua.li@intel.com>, linux-ext4@vger.kernel.org,
	"Ted Ts'o" <tytso@mit.edu>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab1FIOvu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Jun 2011 10:51:50 -0400
In-Reply-To: <alpine.LFD.2.00.1106091112560.4138@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/9/11 4:24 AM, Lukas Czerner wrote:
> On Thu, 9 Jun 2011, Shaohua Li wrote:
> 
>> orig_data could be NULL.
> 
> Now, that is the commit description :). Could you please be more
> descriptive in the "descritpion" ? Also the subject is not right either,
> please see Documentation/SubmittingPatches

Yes; if possible please use the commit message to describe how/why orig_data
can be NULL; a testcase if one exists; the resulting flaw (null pointer deref?)
etc.

something like:

Subject: [PATCH] ext4: check for NULL orig_data pointer in mount paths

The orig_data pointer in ext4_fill_super()  and ext4_remount()
can be null if < ??? >, which can lead to < ??? > in the mount
and remount paths.  This can be demonstrated by < ??? >.  
To avoid this, we can simply test for the null pointer
and return an error in ext4_fill_super() and ext4_remount().


> Thanks!
> -Lukas
> 
>>
>> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index cc5c157..45fc255 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -3057,6 +3057,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>>  	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
>>  	ext4_group_t first_not_zeroed;
>>  
>> +	if (!orig_data)
>> +		return ret;
> 
> Again no data, no reason for backing off.

orig_data could be NULL if *data is NULL, or if kstrdup got ENOMEM.

Anyway, please describe how the bug can arise, and then we can better evaluate the change.

Thanks!

-Eric

>>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>>  	if (!sbi)
>>  		goto out_free_orig;
>> @@ -4285,6 +4287,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>>  #endif
>>  	char *orig_data = kstrdup(data, GFP_KERNEL);
>>  
>> +	if (!orig_data)
>> +		return -ENOMEM;
> 
> 
> This does not seem right, it there is no data we will end with ENOMEM
> for no reason.
> 
>>  	/* Store the original options */
>>  	lock_super(sb);
>>  	old_sb_flags = sb->s_flags;
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

