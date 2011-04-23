From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Quick EXT4 discard question
Date: Sat, 23 Apr 2011 09:23:34 -0500
Message-ID: <4DB2E0E6.8030302@redhat.com>
References: <1303433101.1389.132.camel@keith-laptop>	 <4DB0E7AA.6070007@tao.ma> <1303440294.1389.136.camel@keith-laptop>	 <4DB0EDB1.2070506@tao.ma>	 <alpine.LFD.2.00.1104220940540.4415@dhcp-27-109.brq.redhat.com> <1303488500.1389.139.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, Tao Ma <tm@tao.ma>,
	linux-ext4@vger.kernel.org
To: Keith Mannthey <kmannth@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373Ab1DWOXt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Apr 2011 10:23:49 -0400
In-Reply-To: <1303488500.1389.139.camel@keith-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/22/11 11:08 AM, Keith Mannthey wrote:
> On Fri, 2011-04-22 at 09:44 +0200, Lukas Czerner wrote:

...

>> Actually you can query that with hdparm -I /path/to/the/device and you
>> should see something like
>>
>> *   Data Set Management TRIM supported
>>
>> in the output.
> 
> I see 
> 
> *	Data Set Management TRIM supported
> ...
> *	Deterministic read after TRIM
> 
> set on my devices. 
> 
> Thanks,
>   Keith 

So the way you get your message is:

                        ret = ext4_issue_discard(sb, entry->group,
                                        entry->start_blk, entry->count);
                        if (unlikely(ret == -EOPNOTSUPP)) {
                                ext4_warning(sb, "discard not supported, "
                                                 "disabling");
                                clear_opt(sb, DISCARD);
                        }

which returns the error message from the calls below it:

ext4_issue_discard
	sb_issue_discard
		blkdev_issue_discard

and EOPNOTSUPP is pretty clear... I wonder if it could be that a discard request
on a particular boundary is causing it to be rejected?

-Eric
		
