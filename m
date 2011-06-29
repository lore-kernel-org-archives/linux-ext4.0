From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Remove some deprecated mount options
Date: Wed, 29 Jun 2011 10:01:14 -0500
Message-ID: <4E0B3E3A.5030509@redhat.com>
References: <1309276394-11536-1-git-send-email-lczerner@redhat.com> <B9B585C1-330D-487B-9E1A-B55255377451@dilger.ca> <4E0AE886.6060005@gmail.com> <alpine.LFD.2.00.1106291249550.6151@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <ricwheeler@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1F2PBU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jun 2011 11:01:20 -0400
In-Reply-To: <alpine.LFD.2.00.1106291249550.6151@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/29/11 6:03 AM, Lukas Czerner wrote:
> On Wed, 29 Jun 2011, Ric Wheeler wrote:
> 
>> On 06/28/2011 05:35 PM, Andreas Dilger wrote:
>>> On 2011-06-28, at 9:53 AM, Lukas Czerner wrote:
>>>> Remove deprecated mount options bsddf, nogrpid, sysvgroups which has
>>>> been marked as deprecated since 2.6.23 and should be removed in 2.6.28.
>>>> However it is not a big deal because those are defaults anyway and the
>>>> options for setting their opposites still remains in kernel (however are
>>>> still deprecated). Also push the kernel version to remove those leftover
>>>> options further in time.
>>>>
>>>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>>>> index 9ea71aa..a75320e 100644
>>>> --- a/fs/ext4/super.c
>>>> +++ b/fs/ext4/super.c
>>>> @@ -1486,24 +1483,13 @@ static int parse_options(char *options, struct
>>>> super_block *sb,
>>>> 		args[0].to = args[0].from = NULL;
>>>> 		token = match_token(p, tokens, args);
>>>> 		switch (token) {
>>>> -		case Opt_bsd_df:
>>>> -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p,
>>>> "2.6.38");
>>>> -			clear_opt(sb, MINIX_DF);
>>>> -			break;
>>>> 		case Opt_minix_df:
>>>> -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p,
>>>> "2.6.38");
>>>> +			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "3.5");
>>>> 			set_opt(sb, MINIX_DF);
>>>> -
>>>> 			break;
>>>> 		case Opt_grpid:
>>>> -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p,
>>>> "2.6.38");
>>>> +			ext4_msg(sb, KERN_WARNING, deprecated_msg, p, "3.5");
>>>> 			set_opt(sb, GRPID);
>>>> -
>>>> -			break;
>>>> -		case Opt_nogrpid:
>>>> -			ext4_msg(sb, KERN_WARNING, deprecated_msg, p,
>>>> "2.6.38");
>>>> -			clear_opt(sb, GRPID);
>>> One problem is that these options haven't been deprecated in major vendor
>>> releases (e.g. 2.6.32 for RHEL6 and SLES11), which is what most people are
>>> using.  I think that they should be deprecated for at least one major
>>> vendor release before being removed, otherwise it is nearly the same as just
>>> deleting them on some random kernel version without telling anyone.
>>>
>>> I'm not sure where you got "2.6.23" and "2.6.28" from, maybe you meant
>>> "2.6.33",
> 
> Oh, sure it should be 2.6.33 and 2.6.38, sorry!
> 
>>> which is unfortunately just after the cutoff for both RHEL6 and SLES11SP1.
>>>
>>>
>>> Cheers, Andreas
>>>
>>
>> I am not sure that I follow the concern - people who use upstream follow that,
>> people who use vendor kernels get some branched version of something old.
>>
>> In fact, we try hard *not* to do things in RHEL kernels that are not upstream
>> first. I would be perfectly happy to drop it upstream first and then deprecate
>> it in a future RHEL release.
> 
> Ric has a valid point, it does not matter that the deprecation change
> did not appear in RHEL, SLES or others because it is really a distributor
> decision what code from what kernel version to use and communicate
> changes with their customers.
> 
> That said, I do not think there is a point in upstream waiting for
> distributors to adopt some change. Especially when it is not a question
> feature test coverage.

*nod* I don't mean to turn this into an RH me-too fest, but we usually
go the other way; make changes we want to see upstream first, and then
they find their way into a distro.

We try to be pretty conservative on which of the filesystem configurations
we support (you all know of my love for mount option matrices by now)
so I'll shed no tear over losing these ...

-Eric

> Thanks!
> -Lukas
> 
>>
>> Thanks!
>>
>> Ric
>>
>> (and Lukas is *very* familiar with which kernel the ext4 code was lifted from
>> :))
>>
>>
> 

