From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: 2.6.32.4 - still getting ext4 related crashes
Date: Wed, 27 Jan 2010 15:40:06 -0500
Message-ID: <4B60A4A6.3070001@redhat.com>
References: <20100122085035.GA5020@nik-nb2.linuxbox.cz> <20100122213827.GH21263@thunk.org> <20100124071943.GA4407@nik-comp.linuxbox.cz> <20100124094853.GA4382@thunk.org> <20100126204754.GA4637@nik-comp.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	ext4 maillist <linux-ext4@vger.kernel.org>,
	IDE/ATA development list <linux-ide@vger.kernel.org>
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100126204754.GA4637@nik-comp.linuxbox.cz>
Sender: linux-ide-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/26/2010 03:47 PM, Nikola Ciprich wrote:
> Hello Theo,
> Actually it's ME who appreciates YOUR efforts ;)
> I'm sorry for late reply, I did a lot of testing and I've been a bit
> busy lately.
> It's getting quite weird. I  can 100% reproduce it.
> BUT - the thing is, I can reproduce it only on external eSATA box with
> long eSATA cable. I've tried it on two different machines, and with
> two different disk boxes. Using shorter cabling seems to fix the problem.
> I'd just close the problem stating that it's caused byt crappy cable,
> but what worries me is why it was working with older kernels?
> Does it mean our backups were just silently being damaged and new
> kernel somehow detects the problem? (and if it's the hw problem,
> kernel could maybe show it the better way then just crashing).
> I'm going to repeat tests with older kernels which were working
> OK, and I can also test newer ones. I'll also try to get new
> cable of same length to check it again.
> Do You have any other ideas what else I should check?
> with best regards
> nik
>
>    

Hi Nik,

If you only see this with an external S-ATA box and a long cable, we 
might have issues with S-ATA (and knock on issues with error handling up 
the stack).

Can you summarize/repost the log of the panic with the linux-ide people 
cc'ed (added above)?

Thanks!

Ric

>
> On Sun, Jan 24, 2010 at 04:48:53AM -0500, tytso@mit.edu wrote:
>    
>> On Sun, Jan 24, 2010 at 08:19:43AM +0100, Nikola Ciprich wrote:
>>      
>>> Hi,
>>> yes, I can reproduce it reliably, I'll give it a try tomorrow and
>>> report.
>>> have a nice day.
>>>        
>> Thanks, I appreciate it.  If it does reproduce on 2.6.33-rc3+, could
>> you send me the output of "dumpe2fs -h /dev/XXX"?
>>
>> Best regards,
>>
>> 					- Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>      
>    

