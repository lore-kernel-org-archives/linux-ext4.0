From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: xfsprogs: Fix for xfstest 252 hang on ext4
Date: Tue, 31 May 2011 08:25:53 -0700
Message-ID: <4DE50881.90401@linux.vnet.ibm.com>
References: <4DDAC4EF.1050702@linux.vnet.ibm.com> <BANLkTiks0NSDTSPN8n446JHWhKtM61_=Mw@mail.gmail.com> <4DDB1A0C.5030502@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>, Dave Chinner <david@fromorbit.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37922 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868Ab1EaP0L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 May 2011 11:26:11 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4VF4tTZ017403
	for <linux-ext4@vger.kernel.org>; Tue, 31 May 2011 11:04:55 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4VFQ5W4118214
	for <linux-ext4@vger.kernel.org>; Tue, 31 May 2011 11:26:05 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4VFQ44S015718
	for <linux-ext4@vger.kernel.org>; Tue, 31 May 2011 11:26:05 -0400
In-Reply-To: <4DDB1A0C.5030502@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/23/2011 7:38 PM, Allison Henderson wrote:
> On 5/23/2011 6:16 PM, Yongqiang Yang wrote:
>> On Tue, May 24, 2011 at 4:34 AM, Allison Henderson
>> <achender@linux.vnet.ibm.com> wrote:
>>> Hi all,
>>>
>>> While trying to add more punch hole tests to xfstest, I found that
>>> test 252 hangs on ext4 due to a loop in xfsprogs that does not exit.
>>> XFS gets out of this loop because there is logic in the loop that
>>> looks for the last extent flag and breaks out. But it looks like ext4
>>> does not return a last extent when the file has a hole at the end. I
>>> am not sure if this is the correct behavior or not, so I will copy
>>> the ext4 folks on this too. Below is a copy of the fix for xfsprogs:
>>
>> Hi there,
>>
>> What's blocksize of the tested ext4? For now, ext4 returns
>> LAST_EXTENT if the logical offset covered by the extent is greater
>> than file size, so if there is a hole at the end, no last extent is
>> returned. Thx!
>>
>> Yongqiang.
>
> Hi there,
>
> The block size I've been using is 4096. As long as that behavior is
> expected, I think the test will be ok with just the xfsprogs fix,
> though. Thx!
>
> Allison Henderson
>
>>
>>>
>>> diff --git a/io/fiemap.c b/io/fiemap.c
>>> index fa990cc..81fc92c 100644
>>> --- a/io/fiemap.c
>>> +++ b/io/fiemap.c
>>> @@ -246,7 +246,7 @@ fiemap_f(
>>> flg_w, _("FLAGS"));
>>> }
>>>
>>> - while (!last&& ((cur_extent + 1) != max_extents)) {
>>> + while (!last&& (cur_extent<= max_extents)) {
>>> if (max_extents)
>>> num_extents = min(num_extents,
>>> max_extents - (cur_extent + 1));
>>>
>>>
>>> It looks like the loop enters with last=0, cur_extents=0, and
>>> max_extents = 0, and on the first iteration cur_extents get set to 2,
>>> so we dont see ((cur_extent + 1) == max_extents for a very long time.
>>> I doubt the logic was meant to work that way, so this patch should
>>> fix it, but I wanted to make sure that the fiemap for ext4 is working
>>> as intended too. Feed back appreciated! Thx all!
>>>
>>> Allison Henderson
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>


 >> Hi all,
 >>
 >> I haven't heard much back on this patch, so Im just poking this
 >> thread to make sure it doesn't get forgotten. I have some patches
 >> out there for punch hole, and I'm currently looking at fixing up
 >> some older punch hole tests in the dmapi code, but they wont do much
 >> good for ext4 with out this fix.  If I could get a quick peek from
 >> some one on the xfs list for this patch, that would be much
 >> appreciated.  Thx all!
 >
 > If ext4 is not setting the last extent flag on the last extent then
 > that's an ext4 bug that the test has detected, right? And so you
 > should be fixing ext4 rather than modifying the test to hide the
 > different behaviour?
 >
 > Cheer
 >
 >-- Dave Chinner david@fromorbit.com

Hi All,

Sorry, I should have poked the thread with Yongqiang's response, so I 
will move the dialog into this thread.  At the moment, it sounds like 
the fiemap for ext4 is working as intended.  Yongqiang, do you agree 
that the fiemap for ext4 should be changed?  I think you are more 
familiar with this part of the code than I am, and I just want to make 
sure we find a solution that everyone is happy with.  Thx!

Allison Henderson





> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

