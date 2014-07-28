From: Vlad Dobrotescu <vlad@dobrotescu.ca>
Subject: Re: Question: errors=continue behaviour for failed external journal
 device
Date: Mon, 28 Jul 2014 09:31:05 -0400
Message-ID: <53D65099.6010901@dobrotescu.ca>
References: <loom.20140727T010632-633@post.gmane.org> <20140727000733.GV6725@thunk.org> <alpine.LFD.2.00.1407281107530.2077@localhost.localdomain> <20140728131742.GP6725@thunk.org> <alpine.LFD.2.00.1407281522110.2077@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46468 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaG1NbH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 09:31:07 -0400
Received: by mail-ie0-f178.google.com with SMTP id rd18so6633580iec.37
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2014 06:31:07 -0700 (PDT)
In-Reply-To: <alpine.LFD.2.00.1407281522110.2077@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If you are talking about changes, wouldn't "read-only" be a better=20
fall-back
alternative for a failed or missing external journal?

Vlad

On 28/07/2014 09:25, Luk=C3=A1=C5=A1 Czerner wrote:
> On Mon, 28 Jul 2014, Theodore Ts'o wrote:
>
>> Date: Mon, 28 Jul 2014 09:17:42 -0400
>> From: Theodore Ts'o<tytso@mit.edu>
>> To: Luk=C3=A1=C5=A1 Czerner<lczerner@redhat.com>
>> Cc: Vlad Dobrotescu<vlad@dobrotescu.ca>, linux-ext4@vger.kernel.org
>> Subject: Re: Question: errors=3Dcontinue behaviour for failed extern=
al journal
>>      device
>>
>> On Mon, Jul 28, 2014 at 11:11:45AM +0200, Luk=C3=A1=C5=A1 Czerner wr=
ote:
>>> I very much agree with that, that's why I was quite surprised that =
I
>>> found out recently that this is the default. I was living in the
>>> delusion that the default was ERRORS_RO for as long as I can rememb=
er.
>>> So my question is, should we change it ? This really does not seem
>>> like a sane default.
>> Yeah, I've been thinking that this would be a good thing to change f=
or
>> 1.43.
>>
>> The only reason that errors=3Dcontinue was the default was for
>> historical reasons.  I could imagine some system administrators bein=
g
>> surprised when all of a sudden their production systems start gettin=
g
>> lots of EROFS errors getting reported by applications.  So I could
>> potentially imagine some Help Desks / Support folks at distributions
>> not being enthusiastic about such a change.
>>
>> Hmm.... we are starting to have some errors where we can allow the
>> system to stagger on, even if we need to disallow new allocations in
>> some block groups.  I wonder if it is worthwhile to have a "continue
>> for correctable errors".  The danger, of course, is that some errors=
,
>> even if they are correctable, (such as freeing a block which is
>> already freed), could be a hint that there are other fs corruptions,
>> not yet detected, that might lead to data loss if we reboot and fsck=
,
>> or remount readonly right away.  So the question is while there is
>> some value, is it worth the added complexity to add an
>> "errors=3Dcontinue-correctable" option?
> Right,
>
> I like the idea of the new errors option, even though the name is a
> bit long (maybe "auto") which will try the best to continue, but is
> allowed to remount read only if we can not recover from that error.
>
> This would however need some work to make it work reliably and most
> importantly a fair amount of testing. Though I think it's worth the
> work.
>
> -Lukas
>
>> 							- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
