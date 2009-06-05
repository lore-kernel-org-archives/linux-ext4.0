From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
Date: Fri, 05 Jun 2009 17:43:01 +0100
Message-ID: <4A294B15.9070209@tuffmail.co.uk>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com> <4A293084.5010400@tuffmail.co.uk> <4A2937CC.7070503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Aioanei Rares <krnl.list@gmail.com>, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:44385 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZFEQlp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 12:41:45 -0400
In-Reply-To: <4A2937CC.7070503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Alan Jenkins wrote:
>   
>> Aioanei Rares wrote:
>>     
>
>   
>>> I suspect, although I might be wrong, that this is not a kernel-related
>>> problem.
>>>       
>> "To try and rule out a faulty userspace program, I marked the file as 
>> read-only (chmod a-w) and immutable (chattr +i).  After a reboot, the 
>> file was still read-only and immutable, yet it still became corrupted."
>>
>> Since the immutable bit is not respected, I tend to think it is a kernel 
>> problem.  Unless the filesystem isn't getting unmounted/flushed properly 
>> for some reason... but I thought the modern kernel had that covered.
>>
>> I agree it is very suspicious this happens only after upgrading libc.  
>> I'll see if I can find an individual change in libc locale-handling that 
>> might trigger this.
>>     
>
> Maybe you could try some things in your shutdown script, such as
> explicitly fsyncing the file, or bmapping it with filefrag, or dropping
> caches and rereading it... see what the state is just before the
> shutdown compared to after the reboot.
>
> -Eric
>   

Dropping caches (and running sync first) had no effect on the result of 
md5sum.  Hopefully that narrows it down a bit.

Thanks to your prodding though, I have another interesting finding:

If I remove the corrupted file and copy a "known good" copy into it's 
place, then the corruption doesn't happen.  I've verified this a couple 
of times.  The corruption only occurs if the file was created by 
"locale-gen".

I'll continue to try work out why :-).

Thanks
Alan
