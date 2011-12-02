From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ext4: let mpage_submit_io works well when blocksize
 < pagesize
Date: Thu, 01 Dec 2011 23:46:54 -0700
Message-ID: <4ED8745E.5040009@linux.vnet.ibm.com>
References: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com> <4ED7DFD0.8020503@linux.vnet.ibm.com> <CAGBYx2Zubgp+ed297BebAjV_WYiiYnu_-Fjrz1EVkaemUCmzmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58256 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab1LBGrJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Dec 2011 01:47:09 -0500
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 2 Dec 2011 01:47:08 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pB26l5eL287592
	for <linux-ext4@vger.kernel.org>; Fri, 2 Dec 2011 01:47:05 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pB26l4Us026952
	for <linux-ext4@vger.kernel.org>; Fri, 2 Dec 2011 01:47:05 -0500
In-Reply-To: <CAGBYx2Zubgp+ed297BebAjV_WYiiYnu_-Fjrz1EVkaemUCmzmg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/01/2011 06:15 PM, Yongqiang Yang wrote:
> On Fri, Dec 2, 2011 at 4:13 AM, Allison Henderson
> <achender@linux.vnet.ibm.com>  wrote:
>> On 11/23/2011 02:15 AM, Yongqiang Yang wrote:
>>>
>>> If there is a unwritten but clean buffer in a page and there is a dirty
>>> buffer
>>> after the buffer, then mpage_submit_io does not write the dirty buffer
>>> out.
>>> As a result, da_writepages loops forever.
>>>
>>> This patch fixes the problem by checking dirty flag.
>>>
>>> Signed-off-by: Yongqiang Yang<xiaoqiangnk@gmail.com>
>>> ---
>>>   fs/ext4/inode.c |    7 +++++--
>>>   1 files changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>> index 755f6c7..20a1d17 100644
>>> --- a/fs/ext4/inode.c
>>> +++ b/fs/ext4/inode.c
>>> @@ -1339,8 +1339,11 @@ static int mpage_da_submit_io(struct mpage_da_data
>>> *mpd,
>>>                                         clear_buffer_unwritten(bh);
>>>                                 }
>>>
>>> -                               /* skip page if block allocation undone */
>>> -                               if (buffer_delay(bh) ||
>>> buffer_unwritten(bh))
>>> +                               /*
>>> +                                * skip page if block allocation undone
>>> and
>>> +                                * block is dirty
>>> +                                */
>>> +                               if (ext4_bh_delay_or_unwritten(NULL, bh))
>>>                                         skip_page = 1;
>>>                                 bh = bh->b_this_page;
>>>                                 block_start += bh->b_size;
>>
>> Hi Yongqiang,
>>
>> Thank you for looking into the punch hole code, I know there's been some
>> recent bugs reported, so I am looking at it too.  I've applied your patch
>> and ran it through an fsx stress test, and I notice there are some failures,
>> but it appears to run longer with the patch then with out it, so it may not
>> be the cause of the errors I'm seeing. I think maybe something else may have
>> happened between now and the last time it made it through 24hr of fsx (at
>> least for me :) ), so I'm continuing to look through the recent code
> On the other hand, xfstests have a lot of changes since your last
> test.   I am not sure if original xfstests did not discover some
> errors.
>> changes.  I will keep folks posted on my findings.  Thx!
> Did you test it by multi-thread tests or single thread tests?  If
> multi-thread, I suggest that we hold the i_mutex in punching hole.

Alrighty, well the test Im using is just the fsx test (in xfstests under 
the ltp folder).  I will check and see if there's been any updates to it 
since then.  The command I usually use is just "./fsx -d -S 1 
/mnt/ext4MntPt/test" from the ltp folder.  I dont think it's 
multi-threaded, but the i_mutex lock is another work item on my plate 
that I haven't gotten to yet.  The reason we dont want to just lock 
i_mutex is because folks are trying to reduce the use of i_mutex in 
ext4.  So the plan is to implement extent locks to replace i_mutex all 
together.  That's another project, but I will do a trial run with 
i_mutex locked just to rule it out.

Allison Henderson

>
>
> Yongqiang.
>>
>> Allison Henderson
>>
>>
>
>
>

