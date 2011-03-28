From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mke2fs reserved_ratio default value is nonsensical
Date: Mon, 28 Mar 2011 13:30:53 -0500
Message-ID: <4D90D3DD.9000709@redhat.com>
References: <AANLkTi=7jMS=yq4-72_CvcyGHuWWV6ixEKtk501wnxUz@mail.gmail.com> <4D90CE41.4030209@redhat.com> <AANLkTinZWJpV1tXvbrmUr740cSf5iyOOo7f=UCRb6ykK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Oren Elrad <elrad@brandeis.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab1C1Sa7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Mar 2011 14:30:59 -0400
In-Reply-To: <AANLkTinZWJpV1tXvbrmUr740cSf5iyOOo7f=UCRb6ykK@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/28/11 1:27 PM, Oren Elrad wrote:
> On Mon, Mar 28, 2011 at 2:06 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 3/28/11 1:02 PM, Oren Elrad wrote:
>>> Undesired behavior; mke2fs defaults to reserving 5% of the volume for
>>> the root user. 5% of a 2TB volume is 100GB. The rationale for root
>>> reservation (syslogd, etc...) does not require 100GB. As volumes get
>>> larger, this default makes less and less sense.
>>>
>>> Proposal; If the user does not specify their preferred reserve_ratio
>>> on the command-line (-m), use the less of 5% or MAX_RSRV_SIZE. I
>>> propose 10GiB as a sensible maximum default reservation for root.
>>>
>>> Patch: Follows and http://capsid.brandeis.edu/~elrad/e2fsprog.gitdiff
>>>
>>> Tested on the latest git+patch, RHEL5 (2.6.18-194.17.1.el5) with a
>>> 12TB volume (which would reserve 600GB under the default!):
>>
>> There's been a bit of debate about this; is the space really saved
>> for root, or is it to stop the allocator from going off the rails
>> when the fs nears capacity?  Both, really.
>>
>> I don't really have a horse in the race, but the complaint has certainly
>> come up before... it's just important to realize that the space isn't
>> only there for root's eventual use.
>>
>> No other fs that I know of enforces this "don't fill the fs to capacity"
>> common sense programatically, though.
>>
>> -Eric
>>
> 
> [SNIP]
> 
> Well, in my version you still get some reservation to prevent whatever
> woes (fragmentation, allocator slow-down) that accompany a nearly-full
> disk. If you think 25 or 50GiB is a more appropriate maximum default,
> I have no objections.

the question is, how much is enough?  (isn't that always the question?) :)
What constitutes "nearly full?"

> Whatever the reason for reservation, more than 100GB is totally
> nonsensical IMHO.

That depends; 1% sounds small, until the total is a Petabyte.

For overall performance, it may well be the % that matters, not the 
absolute number.  It really could probably use more real investigation,
and less hand-waving (of which I am also guilty).  :)

-Eric

> Oren Elrad
> Dept. of Physics
> Brandeis University

