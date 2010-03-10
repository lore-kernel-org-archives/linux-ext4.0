From: Enrik Berkhan <Enrik.Berkhan@ge.com>
Subject: Re: possible ext4 related deadlock
Date: Wed, 10 Mar 2010 17:23:38 +0100
Message-ID: <4B97C78A.10301@ge.com>
References: <4B754E5E.603@ge.com> <4B910D8C.30301@ge.com> <20100305154552.GA6000@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:38821 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab0CJQX7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Mar 2010 11:23:59 -0500
In-Reply-To: <20100305154552.GA6000@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Fri, Mar 05, 2010 at 02:56:28PM +0100, Enrik Berkhan wrote:
>> Meanwhile, I have found out that thread 2 actually isn't completely
>> blocked but loops in __alloc_pages_internal:
>>
>> get_page_from_freelist() doesn't return a page;
>> try_to_free_pages() returns did_some_progress == 0;
>> later, do_retry == 1 and the loop restarts with goto rebalance;
>>
>>
>> Can anybody explain this behaviour and maybe direct me to the root cause?

I think, I have isolated it further: the Blackfin/NOMMU changes are
simply to call drop_pagecache() in __alloc_pages_internal() before
trying harder to get pages, which generally is a good thing on NOMMU. We 
have far less OOMs since that has been introduced into the Blackfin patches.

So, the call sequence may reduce to

...
/* got no free page on first try */
drop_pagecache();
rebalance:
did_some_progress = try_to_free_pages();
/* returns 0, most probably because drop_pagecache() has already cleaned 
up everything possible, thus no call to get_page_from_freelist() */
drop_pagecache();
goto rebalance;
...

>> Of course, this now looks more like a page allocation problem than
>> an ext4 one.
> 
> Yep, I'd have to agree with you.  We're only trying to allocate a
> single page here, and you have plenty of pages available.  Just
> checking....  you don't have CONFIG_NUMA enabled and doing something
> crazy with NUMA nodes, are you?

no NUMA, of course :)

The ext4 contribution to the problem is setting AOP_FLAG_NOFS, which is
correct, of course. And because most probably no one else in the world 
uses ext4 on Blackfin/NOMMU, the endless loop only triggers here.

So it's definitely a page allocation problem and a better workaround is 
to call get_page_from_freelist() after each call to drop_pagecache().

I will continue this discussion on the Blackfin list.

Thanks for your patience.

Enrik

