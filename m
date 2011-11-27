From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 1/2] ext4: let mpage_submit_io works well when blocksize
 < pagesize
Date: Sun, 27 Nov 2011 16:59:14 +0800
Message-ID: <4ED1FBE2.8020001@tao.ma>
References: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com> <4ED100E8.109@tao.ma> <CAGBYx2a_Xm5e3ESuh2YpBpcrEM4j5_TPegQC3WO1yQVtmqJ2Pw@mail.gmail.com> <4ED10448.1040204@tao.ma> <CAGBYx2apFEheGGtJWeLeKKGBWeq849AW6+wwqvEopM0PeJQd=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"achender@linux.vnet.ibm.com" <achender@linux.vnet.ibm.com>,
	"tytso@mit.edu" <tytso@mit.edu>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35409 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750987Ab1K0I7k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2011 03:59:40 -0500
In-Reply-To: <CAGBYx2apFEheGGtJWeLeKKGBWeq849AW6+wwqvEopM0PeJQd=w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/27/2011 09:29 AM, Yongqiang Yang wrote:
> 
> 
> On Saturday, November 26, 2011, Tao Ma <tm@tao.ma <mailto:tm@tao.ma>> wrote:
>> On 11/26/2011 11:13 PM, Yongqiang Yang wrote:
>>> Hi,
>>>
>>> It can be tested by xfstests 61 or 91, I did not remember which one.
>> ok, I will try it later. But I still wonder how it happens. See my
>> comments below.
>>>
>>> It can be reproduced by reading on a fallocted block and write the block
>>> after the fallocted block.  Then the written block can not be written
>>> out by da_writepages.
>> Why? in read no bh will be created, and in write only the written bh
>> will be mapped and set unwritten. How could that happen? Sorry, but this
>> explanation doesn't convince me.
> Ok!  The bug was found with punch hole enabled, and punch hole creates
> empty buffers sometimes.
> Actually, punching hole can read the whole page like read operation
> does, but it do not.  May be this is the source of the  problem.
> The problemastic  function is discard_partial_buffers.   I post a patch
> fixing another bug in it in this series.  If we read whole page in this
> function, the problem can also be solved.
Got it and thanks for the explanation. So we introduced a bug and then
fix it in another way. ;)

Thanks
Tao
> 
> Yongqiang.
>>>
>>> Yongqiang.
>>>
>>> On Saturday, November 26, 2011, Tao Ma <tm@tao.ma <mailto:tm@tao.ma>
> <mailto:tm@tao.ma <mailto:tm@tao.ma>>> wrote:
>>>> Hi Yongqiang,
>>>> On 11/23/2011 05:15 PM, Yongqiang Yang wrote:
>>>>> If there is a unwritten but clean buffer in a page and there is a
>>> dirty buffer
>>>>> after the buffer, then mpage_submit_io does not write the dirty
>>> buffer out.
>>>>> As a result, da_writepages loops forever.
>>>> Did you ever meet with this bug or just find it to be a possible bug by
>>>> skimming the code? Actually, I can't find a proper way to get a buffer
>>>> which can satisfy the check.
>>>>
>>>> Thanks
>>>> Tao
>>>>>
>>>>> This patch fixes the problem by checking dirty flag.
>>>>>
>>>>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com
> <mailto:xiaoqiangnk@gmail.com>
>>> <mailto:xiaoqiangnk@gmail.com <mailto:xiaoqiangnk@gmail.com>>>
>>>>> ---
>>>>>  fs/ext4/inode.c |    7 +++++--
>>>>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>>> index 755f6c7..20a1d17 100644
>>>>> --- a/fs/ext4/inode.c
>>>>> +++ b/fs/ext4/inode.c
>>>>> @@ -1339,8 +1339,11 @@ static int mpage_da_submit_io(struct
>>> mpage_da_data *mpd,
>>>>>                                       clear_buffer_unwritten(bh);
>>>>>                               }
>>>>>
>>>>> -                             /* skip page if block allocation
> undone */
>>>>> -                             if (buffer_delay(bh) ||
>>> buffer_unwritten(bh))
>>>>> +                             /*
>>>>> +                              * skip page if block allocation
> undone and
>>>>> +                              * block is dirty
>>>>> +                              */
>>>>> +                             if (ext4_bh_delay_or_unwritten(NULL, bh))
>>>>>                                       skip_page = 1;
>>>>>                               bh = bh->b_this_page;
>>>>>                               block_start += bh->b_size;
>>>>
>>>>
>>>>
>>>
>>> --
>>> Best Wishes
>>> Yongqiang Yang
>>>
>>
>>
> 
> -- 
> Best Wishes
> Yongqiang Yang
> 

