From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: ext2/3/4: punch support?
Date: Mon, 28 Feb 2011 19:19:14 -0700
Message-ID: <4D6C57A2.3040500@linux.vnet.ibm.com>
References: <AANLkTimyu6A=LgF8pit6So6JkPrScFLB42U3NwBJq7mv@mail.gmail.com> <20110228131118.GA18193@dhcp231-156.rdu.redhat.com> <OFF2910C77.5B46C8B2-ON87257846.000354EE-07257846.000414E9@us.ibm.com> <AANLkTikkDS38RhwP9LC47_Q-ZnUB_6q=EKRyQ8tswKW=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Allison C Henderson <achender@us.ibm.com>,
	Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	linux-ext4-owner@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Dave Young <hidave.darkstar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38513 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab1CACTR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 21:19:17 -0500
In-Reply-To: <AANLkTikkDS38RhwP9LC47_Q-ZnUB_6q=EKRyQ8tswKW=@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Alrighty then, I can send it out a little early since people are interested.  It should show up here soon.  Any feedback is appreciated! :)

Allison Henderson

On 2/28/2011 6:32 PM, Dave Young wrote:
> On Tue, Mar 1, 2011 at 8:44 AM, Allison C Henderson<achender@us.ibm.com>  wrote:
>>
>> Hi All,
>>
>> I've actually already started on a patch set for punch hole support in ext4.
>>   I've sent them out on the ltc-fsdev mailing list for review.  I had planned
>> to spend another week or two running it through some more debug cases before
>> sending it to the ext4 mailing list though.
> 
> Where can find your patch? should be sent to linux-ext4?
> 
>>
>> linux-ext4-owner@vger.kernel.org wrote on 02/28/2011 06:11:18 AM:
>>
>>> Josef Bacik<josef@redhat.com>
>>> Sent by: linux-ext4-owner@vger.kernel.org
>>>
>>> 02/28/2011 06:11 AM
>>>
>>> To
>>>
>>> Dave Young<hidave.darkstar@gmail.com>
>>>
>>> cc
>>>
>>> josef@redhat.com, Theodore Tso<tytso@mit.edu>, linux-
>>> ext4@vger.kernel.org, Linux Kernel Mailing List
>>> <linux-kernel@vger.kernel.org>
>>>
>>> Subject
>>>
>>> Re: ext2/3/4: punch support?
>>>
>>> On Mon, Feb 28, 2011 at 03:03:40PM +0800, Dave Young wrote:
>>>> Hi, josef and ext guys
>>>>
>>>> Do you have any plan with ext4 hole punching support? And the
>>>> fallocate for ext2/3?
>>>>
>>>> What's the obstacle to work on this? could someone tell the status of
>>>> this issue?
>>>
>>> There is no obstacle, just nobody has bothered to do it.  If you want to
>>> do it
>>> go for it.  Thanks,
>>>
>>> Josef
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> 


