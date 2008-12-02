From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH v2] ext3, ext4: do_split() fix loop, with obvious	unsigned
 wrap
Date: Tue, 02 Dec 2008 18:17:45 -0500
Message-ID: <4935C219.3070006@tmr.com>
References: <49343AD9.4020606@gmail.com> <20081202132441.GC16172@mit.edu> <49356B96.7070900@tmr.com> <20081202215758.GE20858@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Bill Davidsen <davidsen@tmr.com>,
	roel kluin <roel.kluin@gmail.com>, adilger@sun.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:43946 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbYLBXSL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2008 18:18:11 -0500
In-Reply-To: <20081202215758.GE20858@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Tue, Dec 02, 2008 at 12:08:38PM -0500, Bill Davidsen wrote:
>   
>> Sorry, you are reading it wrong, the i values inside the loop are  
>> identical to those in the original. The value of i starts at count, and  
>> the test comes *before* the value is used inside the loop. The values of  
>> i inside the loop start at count-1 and go to zero, just as it did in the  
>> original. That's why the "i--" is there, the test is on the  
>> unincremented value range count to one, but the value inside the loop is  
>> correct (or at least is the same as the original patch).
>>     
>
> You're right; my bad.  But with something like this:
>
>   
>>>> +	for (i = count; i--; ) {
>>>>         
>
> ...where there is no third part of the for loop, and a decrement in
> the second part of the loop, just for clarity's sake, it's much better
> to write it as a while loop.
>   

I seriously disagree on that, writing it as a for makes it totally clear 
that the index initialization is part of the loop.
I know, looks funny, not the way we have always done it, not invented 
here...

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


