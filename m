From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Which kernel do I need to use ext4 64-bit.
Date: Tue, 18 Jul 2017 19:23:33 -0500
Message-ID: <380f9d57-f49c-bc35-f0f9-f0956fd558cf@gmail.com>
References: <789629f3-d70f-5588-65ec-a45d5c3259a9@gmail.com>
 <469EA06D-C08B-463E-9511-4C340BED86C8@dilger.ca>
 <57c41e8d-8d81-e43b-e57b-e91daa7bba83@gmail.com>
 <D80D3FA1-26DF-4C34-BDC6-A2A3BAEE2215@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35671 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdGSAXf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Jul 2017 20:23:35 -0400
Received: by mail-oi0-f51.google.com with SMTP id 191so31144206oii.2
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 17:23:34 -0700 (PDT)
In-Reply-To: <D80D3FA1-26DF-4C34-BDC6-A2A3BAEE2215@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/18/2017 05:57 PM, Andreas Dilger wrote:
> On Jul 18, 2017, at 4:49 PM, Ram Ramesh <rramesh2400@gmail.com> wrote:
>> On 07/18/2017 02:17 PM, Andreas Dilger wrote:
>>> On Jul 16, 2017, at 10:26 AM, Ram Ramesh <rramesh2400@gmail.com> wrote:
>>>> I asked this question on linux-ext3 and apparently I cannot post it there as moderator has to approve it, and he is neither approving or disapproving my message. May be the list is dormant now and everything happens here. Any way here is my question.
>>> The linux-ext3 list is obsolete, linux-ext4 is the right list for such questions.
>>>
>>>>> Is there a kernel version restriction for 64bit ext4 FS creation/use? Google does not seem to find any info on this. I have mythbuntu  14.04 distro that has
>>>>>
>>>>>> zym [rramesh] 473 > uname -a
>>>>>> Linux zym 3.13.0-119-generic #166-Ubuntu SMP Wed May 3 12:18:55 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>>>>> Can I create a 64bit ext4 under this kernel and mount/use?
>>> The 64bit feature flag was only set for large filesystems (> 16TB) in the past,
>>> but I believe that this is the default for all filesystems since e2fsprogs-1.43.
>>>
>>>>> BTW, my resize2fs cannot grow the file system beyond 16TB. I assume this is due to current FS being 32bit. I need to make it 64bit. What is the best way to go about doing this *on my distro*?
>>>>>
>>>>>> zym [rramesh] 474 > resize2fs
>>>>>> resize2fs 1.42.9 (4-Feb-2014)
>>>>>> Usage: resize2fs [-d debug_flags] [-f] [-F] [-M] [-P] [-p] device [new_size]
>>> This is fairly old.  1.42.13 is probably the better version for you to use.
>>> I believe that 1.43 also has support for enabling the 64bit feature on an
>>> existing filesystem.
>>>
>> Thanks. I can't update e2fsprogs to 1.43 without knowing that the file system it creates can be mounted on my kernel. I am with ubuntu 14.04 which only has these. I could manually download and build from source or install from another repository only if I know my kernel will support it. So, I really need to know if linux 3.13 support ext4-64bit.
> This is hard to know for sure with vendor kernels, as they may have applied patches that added features.  It is possible for you to either check the source for your kernel, or just try formatting a test filesystem with "-O 64bit" and mounting it.
>
> Cheers, Andreas
>
>
I am too dumb. I should have thought of the above method. You live and 
learn. Thanks for not ignoring me over silly questions.

Ramesh
