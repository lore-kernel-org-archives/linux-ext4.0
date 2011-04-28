From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC v1 0/5]Factor common code from convert and split unwritten.
Date: Thu, 28 Apr 2011 12:51:19 -0700
Message-ID: <4DB9C537.9060100@linux.vnet.ibm.com>
References: <1303548259-28311-1-git-send-email-xiaoqiangnk@gmail.com> <4DB71844.5030103@linux.vnet.ibm.com> <BANLkTi=7VsvPGztFtAOFh5trGZ0dHH7rWQ@mail.gmail.com> <4DB7B8F7.9020306@linux.vnet.ibm.com> <BANLkTikWzUgmiRQ6_g+UKjbB5QNSBDnRog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:35849 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab1D1Tvd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Apr 2011 15:51:33 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3SJdD1L023453
	for <linux-ext4@vger.kernel.org>; Thu, 28 Apr 2011 13:39:13 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id p3SJpQwV156014
	for <linux-ext4@vger.kernel.org>; Thu, 28 Apr 2011 13:51:27 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3SJpNQ8001284
	for <linux-ext4@vger.kernel.org>; Thu, 28 Apr 2011 13:51:25 -0600
In-Reply-To: <BANLkTikWzUgmiRQ6_g+UKjbB5QNSBDnRog@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/27/2011 11:05 PM, Yongqiang Yang wrote:
> Hi Allison,
>
> Could you send punch hole patch and fsx(if you modified it) to me?  I
> can not reproduce the bug on my system without punch hole.
>
> Thank you,
> Yongqiang.
>

Sure, I have a patch for fsx to enable fallocate, and another patch that 
adds punch hole to the test suite.  Right now I'm just working on
  getting our patches through the fsx that only has fallocate enabled. 
I thought it might be best if we work out all the bugs with that first 
before we deal with the more complex tests.

Also, I have a debug patch that fits on top of the punch hole patch. 
Initially I hadn't planned to send it out, but maybe it might help you 
so I will include it too.

Allison Henderson

> On Wed, Apr 27, 2011 at 2:34 PM, Allison Henderson
> <achender@linux.vnet.ibm.com>  wrote:
>> On 4/26/2011 9:48 PM, Yongqiang Yang wrote:
>>>
>>> On Wed, Apr 27, 2011 at 3:08 AM, Allison Henderson
>>> <achender@linux.vnet.ibm.com>    wrote:
>>>>
>>>> On 4/23/2011 1:44 AM, Yongqiang Yang wrote:
>>>>>
>>>>> v0->v1:
>>>>>     fix a bug in ext4_ext_convert_to_initialized() reported by
>>>>>     Allison<achender@linux.vnet.ibm.com>.
>>>>>
>>>>>     optimize ext4_ext_convert_to_initialized().
>>>>>
>>>>> -- factor common code
>>>>>     These patches factor common code from
>>>>> ext4_ext_convert_to_initialized()
>>>>> and
>>>>>     ext4_split_unwritten_extents() so that extent-move-on-write in
>>>>> snapshot
>>>>> and
>>>>>     punch hole can be built on the common code.
>>>>>
>>>>> -- optimization
>>>>>     the 4th and the 5th patch optimize ext4_ext_convert_to_initialized()
>>>>> by
>>>>>     zeroing out in memory.
>>>>>
>>>>>
>>>>> [PATCH RFC v1 1/5] ext4:Add a function merging extent right and left.
>>>>> [PATCH RFC v1 2/5] ext4:Add two functions splitting an extent.
>>>>> [PATCH RFC v1 3/5] ext4:Reimplement convert and split_unwritten.
>>>>> [PATCH RFC v1 4/5] ext4: Add a function ext4_ext_zeroout_mem().
>>>>> [PATCH RFC v1 5/5] ext4: optimize ext4_ext_convert_to_initialized().
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>> Hi there,
>>>>
>>>> Just an update on your patch set.  Im am working on getting the punch
>>>> hole
>>>> patch to work with this new set, but I'm am having trouble getting it
>>>> through the stress test.  It gets up to around 48265 file operations, and
>>>> then hangs. So I am currently trying to narrow down the problem.  It
>>>> looks
>>>> like it does it with or with out the extra punch hole patches, but you
>>>> may
>>>> need to enable fallocate in the fsx Makefile to recreate the problem.  I
>>>> will keep you posted if I find any more clues.
>>>
>>> Hi,
>>>
>>> Could you tell me how to get fsx?  I can not find that.
>>
>> Hi there,
>>
>> I believe you can find it in both xfstests and ltp.  The one I am using I
>> got from xfstests here:
>>
>> http://xfs.org/index.php/Getting_the_latest_source_code
>>
>> Once you have it configured and built, there is a sub folder called ltp.
>>   Execute this command from that folder:
>>
>> ./fsx -d -b 1 -N 100000 -S 1 /mnt/ext4MntPt/holePunch/testFile
>>
>> Where "/mnt/ext4MntPt/holePunch/testFile" is a file on an ext4 file system.
>>   It should then try to run through 100000 random file operations, but get
>> stuck on number 48256.
>>
>> If you do not see any fallocate operations running, you may have to go
>> enable it in the ltp/Makefile.  I had to change "ifeq ($(HAVE_FALLOCATE),
>> true)" to "ifeq ($(HAVE_FALLOCATE), yes)" to allow the extra fallocate code
>> to compile in.  Let me know if you have any trouble recreating the bug.
>>
>>>
>>> Thank you,
>>> Yongqiang.
>>>>
>>>> Allison Henderson
>>>>
>>>
>>>
>>>
>>
>>
>
>
>

