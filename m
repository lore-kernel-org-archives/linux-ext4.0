From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Crash after umount'ing a disconnected disk and JBD: recovery
 failed (Re: extfs reliability)
Date: Mon, 09 Aug 2010 22:45:52 +0400
Message-ID: <4C604CE0.9040808@vlnb.net>
References: <20100804180325.GL9453@thunk.org> <4C5B1137.1070001@vlnb.net> <20100805211758.GA12358@thunk.org> <4C5C0CE2.7030009@vlnb.net> <20100806181042.GB24583@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49153 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab0HISpt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Aug 2010 14:45:49 -0400
In-Reply-To: <20100806181042.GB24583@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o, on 08/06/2010 10:10 PM wrote:
> On Fri, Aug 06, 2010 at 05:23:46PM +0400, Vladislav Bolkhovitin wrote:
>>>>
>>>> 1. A bunch of detected hung tasks with call traces.
>>>>
>>>
>>> Do you eventually get file
>>> system I/O errors that abort the journal transaction?  You should...
>>
>> Yes, as you can see in the previously attached log.
>
> OK, so what are you complaining about?  This is *normal*.  You can
> change how long the kernel will wait before printing the warnings, by
> adjusting /proc/sys/kernel/hung_task_timeout_secs, but the fact that
> you're getting the detected hung tasks is the system performing as
> designed.

Well, I'm not complaining, I'm reporting.

I can't say where is the problem. And I really would *not* say that 
activation of the hung tasks detector is normal. A correct timeout 
should be set by default, not after manual user intervention.

>>>> 2. "JBD: recovery failed" I reported before.
>>>
>>> I've searched my mail archives, and I'm not sure what you're talking
>>> about here.  Maybe this was in an e-mail that you sent that perhaps
>>> got lost?
>>
>> It's next to the message on which you originally replied. It was
>> about ext3, but this time I saw it with ext4.
>
> Can you resend, and with a new and specific subject line that is
> helpful for finding it, and just that one message?

See http://lkml.org/lkml/2010/7/29/222 and 
http://lkml.org/lkml/2010/7/29/325.

Vlad
