From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Mon, 06 Jun 2011 11:42:03 -0500
Message-ID: <4DED035B.9090107@redhat.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net> <alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com> <BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com> <4DECF2D5.7050408@redhat.com> <77863E67-6DAF-491D-836D-09FCD379B81F@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Amir G." <amir73il@users.sourceforge.net>,
	Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1FFRHg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 13:07:36 -0400
In-Reply-To: <77863E67-6DAF-491D-836D-09FCD379B81F@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/6/11 11:33 AM, Andreas Dilger wrote:
> On 2011-06-06, at 9:31 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 6/6/11 9:32 AM, Amir G. wrote:
>>>
>>> For one reason, a snapshot file format is currently an indirect file
>>> and big_alloc
>>> doesn't support indirect mapped files.
>>> I am not saying it cannot be done, but if it does, there would be
>>> several obstacles
>>> to cross.
>>
>> I know I'm kind of just throwing a bomb out here, but I am very concerned
>> about the ever-growing feature (in)compatibility matrix in ext4.
> 
> I tend to agree. A new feature like this for ext4 that does not work
> the default features of ext4 (extents) means that it will not be
> usable for the majority of users, but will make the code complex for
> all of the developers.

It's my understanding that the limitation is only on the snapshot file
itself, right?  But that bigalloc can't work in the presence of any
non-extent-mapped files?

I guess this is indicative of problems with The Matrix if we are
already confusing ourselves.  ;)

> Has any thought gone into how this feature could be implemented for
> extent-mapped files? It seems that part of the problem is because the
> snapshot "file" needs to be able to map the whole filesystem, which
> neither indirect-mapped nor extent-mapped files can do without
> changes.
> 
> The current change is to allow indirect-mapped files to have an extra
> triple-indirect block, which works up to 2^32 blocks (the same limit
> as extent-mapped files) but this is not useful for filesystems over
> 2^32 blocks, which is another reason that ext4 was introduced.
> 
> So, it seems the reason the 64bit feature is unsupported is really
> for filesystems larger than the maximum file size, and not for any
> other reason. Is that correct? Would that mean Ted's bigalloc patches
> will avoid this problem, or do they not actually increase the maximum
> file size?
> 
>> Take for example dioread_nolock caveats:
>>
>>          "However this does not work with nobh
>>           option and the mount will fail.
> 
> Does anyone actually use nobh? I recall it was a performance tweak
> fir ext3, but i think it was eclipsed by other improvements in ext4.
> If nobody is using it anymore, we might consider removing it
> entirely, since it was only a mount-time option and did not affect
> the on-disk format.

As Lukas said, removing old cruft would help a fair bit, and this would
seem reasonable to remove.

> Does smolt return the filesystem mount options?

not currently, no.

>> Nor does it work with
>>           data journaling and dioread_nolock option will be
>>           ignored with kernel warning. Note that dioread_nolock
>>           code path is only used for extent-based files."
> 
> Does this mean that dioread_nolock isn't needed for indirect-mapped
> files, or that it will work incorrectly on indirect-mapped files, or
> only that they will use some less efficient code path? I don't recall
> the details if this option, but it seems that it was related to
> unwritten extents, in which case it is irrelevant to indirect-mapped
> files.

It uses unwritten extents, which cannot exist on indirect-mapped files.
So, you must fall back to the old locking in that case.

>> If ext4 matches the lifespan of ext3, in 10 years I fear that it will look
>> more like a collection of various individuals' pet projects, rather than
>> any kind of well-designed, cohesive project.
>>
>> How long can we really keep adding features which are semi- or wholly-
>> incompatible with other features?
>>
>> Consider this a cry in the wilderness for less rushed feature introduction,
>> and a more holistic approach to ext4 design...
> 
> I agree. I am far less concerned with new features that are only
> available to users of newly-formatted ext4 filesystems. What worries
> me is a feature that in NOT usable on new filesystems and may be dead
> code in a couple of years.
> 
> I'd be a lot more confident in its acceptance if there was at least a
> design for how to move forward with this feature for filesystems with
> extents and 64bit support. I'd be happy with some co-requirement that
> bigalloc is needed for filesystems larger than 2^32 blocks (for
> example), so that there is never a need to have a snapshot with more
> than 2^32 blocks.

Yes, mutually exclusive (and well-planned) design points would be more
reasonable, I think.

> Doing this design work may point out some other solution which does
> not require the 4*triple-indirect block hack in the first place, and
> will improve the code in the long run.
> 
> Cheers, Andreas--
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

