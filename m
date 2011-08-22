From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/6 v5] ext4: Correct large hole offset calcuation
Date: Mon, 22 Aug 2011 10:19:42 -0700
Message-ID: <4E528FAE.1000904@linux.vnet.ibm.com>
References: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com> <1313893787-25460-5-git-send-email-achender@linux.vnet.ibm.com> <4E527AC6.30905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49114 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab1HVRTp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Aug 2011 13:19:45 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7MGnnOm017505
	for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 12:49:49 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7MHJiH7251108
	for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 13:19:44 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7MDJVBU027605
	for <linux-ext4@vger.kernel.org>; Mon, 22 Aug 2011 10:19:31 -0300
In-Reply-To: <4E527AC6.30905@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/22/2011 08:50 AM, Eric Sandeen wrote:
> On 8/20/11 9:29 PM, Allison Henderson wrote:
>> This bug was reported by Lukas Czerner while working on a
>> new patch to add discard support for loop devices using
>> punch hole.
>>
>> The bug is happens because the data type for logical blocks is
>
> s/is //
>
>> not large enough to calculate the block offset for holes that are
>
> Should that be "the _byte_ offset for holes ...?"
>
>> very large.  This bug is resolved by casting the ext4_lblk_t
>> to an loff_t before calculating the byte offset of the block.
>>
>> Reviewed-and-Tested-by: Lukas Czerner<lczerner@redhat.com>
>>
>> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
>
>
> I wonder if it'd be more straightforward to just use a mask
> to compute these rather than the right shift / left shift, but
> no big deal I guess esp. since we need the intermediate value
> anyway?

Ah!  Now that you point it out, I realized that patch 2 removed the need 
for the intermediate values since things are now calculated from the 
byte offsets of pages rather than byte offsets of blocks.  At the time I 
was looking at the bug Lukas had reported, I hadn't finished this set 
yet, so this is the patch that resolved the problem when things were 
still using block offsets.  I added the patch to this set, but it's 
probably not really makeing any sort of differnce now.  Maybe I can get 
rid this patch and just remove these values in patch 2.  I will try that 
and retest for the bug that Lukas reported.

Also, maybe when the patch for the loop discard support is done, we 
could use the steps that Lukas outlined to recreate this bug as a good 
punch hole test for xfstests.  (Re:[PATCH] loop: add discard support for 
loop devices, 8/11/2011) It would probably be a good way to quickly pick 
up any punch hole oddness.

Allison Henderson

>
> Aside from the question about the commit message,
>
> Reviewed-by: Eric Sandeen<sandeen@redhat.com>
>
>> ---
>> :100644 100644 0d7617d... b417e47... M	fs/ext4/extents.c
>>   fs/ext4/extents.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 0d7617d..b417e47 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -4179,8 +4179,8 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
>>   		EXT4_BLOCK_SIZE_BITS(sb);
>>   	last_block = (offset + length)>>  EXT4_BLOCK_SIZE_BITS(sb);
>>
>> -	first_block_offset = first_block<<  EXT4_BLOCK_SIZE_BITS(sb);
>> -	last_block_offset = last_block<<  EXT4_BLOCK_SIZE_BITS(sb);
>> +	first_block_offset = ((loff_t)first_block)<<  EXT4_BLOCK_SIZE_BITS(sb);
>> +	last_block_offset = ((loff_t)last_block)<<  EXT4_BLOCK_SIZE_BITS(sb);
>>
>>   	first_page = (offset + PAGE_CACHE_SIZE - 1)>>  PAGE_CACHE_SHIFT;
>>   	last_page = (offset + length)>>  PAGE_CACHE_SHIFT;
>

