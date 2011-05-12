From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: ext4_ext_convert_to_initialized bug found in extended FSX testing
Date: Thu, 12 May 2011 14:00:08 -0700
Message-ID: <4DCC4A58.7060608@linux.vnet.ibm.com>
References: <4DC97C32.2020203@linux.vnet.ibm.com> <BANLkTi=jjVcy9WQvNfYwPVNw-+t4M5WbFw@mail.gmail.com> <1305162935.4102.13.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:35511 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab1ELVBI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 17:01:08 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e38.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4CKr2rI016635
	for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 14:53:02 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4CL0nbT118620
	for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 15:00:52 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4CL0FLr021650
	for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 15:00:19 -0600
In-Reply-To: <1305162935.4102.13.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/11/2011 6:15 PM, Mingming Cao wrote:
> On Wed, 2011-05-11 at 09:47 +0800, Yongqiang Yang wrote:
>> On Wed, May 11, 2011 at 1:56 AM, Allison Henderson
>> <achender@linux.vnet.ibm.com>  wrote:
>>> Hi All,
>>>
>>> We've been trying to get punch hole through some extended fsx tests, and I ran across some other tests that were failing because the test file contained zeros where it shouldn't.  I made this fix to the ext4_ext_convert_to_initialized
>>
>> What do you mean zeros here?
>> Some useful data is zeroed?
>>
>> and the test has been running smooth for about an hour now.
>> Yongqiang, this one looks like it may have been associated with the
>> split extents clean up patch.  Would you mind taking a look at this
>> fix and giving it your ok if it looks good?  Thx!
>>>
>>> Signed-off-by: Allison Henderson<achender@us.ibm.com>
>>> ---
>>> :100644 100644 e363f21... ce69450... M  fs/ext4/extents.c
>>>   fs/ext4/extents.c |    3 ++-
>>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>> index e363f21..ce69450 100644
>>> --- a/fs/ext4/extents.c
>>> +++ b/fs/ext4/extents.c
>>> @@ -2819,7 +2819,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>>>                         /* case 3 */
>>>                         zero_ex.ee_block =
>>>                                          cpu_to_le32(map->m_lblk + map->m_len);
>>> -                       zero_ex.ee_len = cpu_to_le16(allocated - map->m_len);
>>> +                       zero_ex.ee_len = cpu_to_le16(ee_len -
>>> +                                               allocated - map->m_len);
>> The logic is that we splits [ee_block, ee_block + ee_len) into
>> [ee_block, map->m_blk) that is uninitialized and [map->m_blk, ee_block
>> + ee_len) that is initialized.   We need to zero [map->m_lblk +
>> map->m_len, ee_block + ee_len).
>> and [map->m_lblk, map->m_lblk + map->m_len) is zeroed by upper layer
>> because of MAP_NEW flag.
>>
>> Right logic?
>>
>
> Hmm, the logic in case 3 is-- if ex2[map->m_blk, map->m_blk+m_len] and
> ex3 together[map->mblk+m_len+1, map->m_blk+allocated] total length
> (allocated)is<  than 7 blocks, then we zero out the entire ex2 and ext3,
> there is no need to do split.
>
> I think zero_ex.ee_len should be "allocated". Look at the original code
> (before the extents splits cleanup patches), it will zero out entire
> [map->mblk, map->m_blk+allocated] and don't do split anymore.
>
>
> something like this, not a patch, but show what I think the right fix.
>
>
>         if (allocated>  map->m_len) {
>                 if (allocated<= EXT4_EXT_ZERO_LEN&&
>                     (EXT4_EXT_MAY_ZEROOUT&  split_flag)) {
>                         /* case 3 */
>                         zero_ex.ee_block =
>                                          cpu_to_le32(map->m_lblk + map->m_len);
> -                       zero_ex.ee_len = cpu_to_le16(allocated - map->m_len);
>                         zero_ex.ee_len = cpu_to_le16(allocated);
>                         ext4_ext_store_pblock(&zero_ex,
>                                 ext4_ext_pblock(ex) + map->m_lblk - ee_block);
>                         err = ext4_ext_zeroout(inode,&zero_ex);
>                          if (err)
>                                  goto out;
> -                       split_map.m_lblk = map->m_lblk;
> -                       split_map.m_len = allocated;
> +             		ext4_ext_mark_initialized(ex);
> +              		ext4_ext_try_to_merge(inode, path, ex);
> +	              err = ext4_ext_dirty(handle, inode, path + depth);
> +            		   goto out;
>    }
>
>
>
> Mingming
>
>
>>
>> I can not see the error and the meaning of ee_len - allocated - map->m_len.

Hi Yongqiang,

Sorry I didnt see your extra question down here.  Initially I had read 
"allocated" to be the length of ex1, but now I see that it is the length 
of ex2+ex3. So  ee_len - allocated - map->m_len was supposed to be ex3, 
but I think Mingming has the right idea now with zeroing out all of 
"allocated".

Allison Henderson


>>
>> Thanks,
>> Yongqiang.
>>
>>
>>>                         ext4_ext_store_pblock(&zero_ex,
>>>                                 ext4_ext_pblock(ex) + map->m_lblk - ee_block);
>>>                         err = ext4_ext_zeroout(inode,&zero_ex);
>>> --
>>> 1.7.1
>>>
>>>
>>
>>
>>
>
>

