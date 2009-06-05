From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
Date: Fri, 05 Jun 2009 22:32:37 +0100
Message-ID: <4A298EF5.9000504@tuffmail.co.uk>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com> <4A293084.5010400@tuffmail.co.uk> <4A2937CC.7070503@redhat.com> <4A294B15.9070209@tuffmail.co.uk> <4A29601F.3070802@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Aioanei Rares <krnl.list@gmail.com>, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:28471 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZFEVbV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Jun 2009 17:31:21 -0400
In-Reply-To: <4A29601F.3070802@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Alan Jenkins wrote:
>   
>> Eric Sandeen wrote:
>>     
>
>   
>>> Maybe you could try some things in your shutdown script, such as
>>> explicitly fsyncing the file, or bmapping it with filefrag, or dropping
>>> caches and rereading it... see what the state is just before the
>>> shutdown compared to after the reboot.
>>>
>>> -Eric
>>>   
>>>       
>> Dropping caches (and running sync first) had no effect on the result of 
>> md5sum.  Hopefully that narrows it down a bit.
>>     
>
> And did the reread after dropping caches have the right data?
>   

Yes.

> Did the block numbers reported by filefrag -v change post-boot?
>   

Oh, I didn't understand that's what you were asking for.

The bug report Ted linked to says it's (most likely) a writeback issue.  
In which case I think the block numbers won't change.  I'll check 
tomorrow, and follow-up if it turns up any unexpected result.

There's also speculation that it's a core kernel issue, something that 
changed since 2.6.26.  Perhaps that explains how remount-ro + sync + 
drop_caches can leave the correct data sitting in the pagecache, without 
either writing it to disk or dropping it.

Thanks
Alan
