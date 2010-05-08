From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Introducing Next3 - built-in snapshots support for Ext3
Date: Sat, 08 May 2010 08:51:21 -0400
Message-ID: <4BE55E49.5000006@redhat.com>
References: <g2j18730dc51004180841obb1171bbwa1822d6fe0856429@mail.gmail.com>	 <s2s18730dc51005030247u5ef2fddfz269b57d97714db8f@mail.gmail.com>	 <20100504224226.GE6344@thunk.org>	 <p2h18730dc51005041905ma9e3733uc944bdb58af9f10@mail.gmail.com>	 <87vdaz21b0.fsf@basil.nowhere.org>	 <q2i18730dc51005071222q7d97ab67p968072fa6fdceb28@mail.gmail.com>	 <4BE4855E.40808@redhat.com> <AANLkTinbzARSNHOvMbRq7iKSZENKhnKYdKSq5IHvX_xs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, Andi Kleen <andi@halobates.de>,
	tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab0EHMvd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 May 2010 08:51:33 -0400
In-Reply-To: <AANLkTinbzARSNHOvMbRq7iKSZENKhnKYdKSq5IHvX_xs@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/08/2010 01:43 AM, Amir G. wrote:
> On Fri, May 7, 2010 at 11:25 PM, Ric Wheeler wrote:
>    
>> On 05/07/2010 03:22 PM, Amir G. wrote:
>>      
>>> In theory, it is possible to have 2 modes for Ext4 (extents or snapshots)
>>> and some would argue that it makes sense to do that.
>>> But I think that making that decision can be deferred to a later time,
>>> after people have experienced with Next3 and have decided if they
>>> would like to have
>>> the snapshot feature merged into Ext4 or not.
>>>
>>> Besides, it would take me a considerable amount of time to merge the
>>> snapshot feature into Ext4,
>>> and Next3 is ready to be used now.
>>>
>>> Amir.
>>> --
>>>
>>>        
>> I think that the counter argument would be that moving features into ext3 is
>> probably the wrong thing to do.
>>
>> I don't think that anyone is in a huge hurry given that we have LVM based
>> snapshots with ext3 and btrfs snapshots around the corner.  Probably this is
>> most interesting when done to the latest version of the ext family.
>>
>>      
> This is a valid argument, but it is important for me to clarify a few
> issues regarding the statements above:
>
> 1. No features are added to Ext3, so there is no concern for the
> stability of Ext3.
> The feature is added as a new f/s, with the slight overhead of
> duplicate code in the
> kernel tree and an extra loadable module in the system.
>
> 2. From the user's point of view, there is not much difference between
> "mount -t next3"
> and "mount -t ext4 -o snapshots", because in both cases it would not
> be possible to
> mount ext4 with extents support on that volume before discarding snapshots and
> it will be possible to mount ext4 with extents support after
> discarding snapshots.
>
> 3. Next3 snapshots are much more scalable durable and efficient than
> LVM snapshots.
> These are some of the benefits of built-in snapshots support.
>
> 4. I do not want to restart the discussion about when btrfs will be
> production ready.
> As for Next3 stability, I think that with the help of the community,
> Next3 can be production ready within a matter of months,
> because the Next3 code religiously attempts to retain the stability of
> its ancestor Ext3.
>
> I dare you to prove me wrong ;-)
>
> Amir.
>    

As Ted mentioned in his reply, the big concern is that you are forking 
ext3 instead of adding a new feature to the end of the ext* family of 
file systems.

Since we have multiple snapshot mechanisms in place already (not just 
btrfs & lvm, but don't forget all of the builtin array snapshots), I 
think that we are not in a hurry to get this done quickly. I would 
strongly prefer we get this rebased onto the latest ext4 and resubmitted.

As far as proof goes, I think that the unfortunate burden of proof is on 
your shoulders to prove to us that we should take and maintain those new 
features given the often conflicting priorities :-)

Thanks!

Ric



