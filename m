From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v1 00/30] Ext4 snapshots
Date: Wed, 08 Jun 2011 10:22:51 -0500
Message-ID: <4DEF93CB.60507@redhat.com>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>	<alpine.LFD.2.00.1106071735100.11385@dhcp-27-109.brq.redhat.com>	<BANLkTikAB-RDDS8PMMrFK-OuY6PuavBixA@mail.gmail.com>	<alpine.LFD.2.00.1106081114240.5026@dhcp-27-109.brq.redhat.com>	<BANLkTi=T1OtyRSWNTA6xhkTy5uaHWqA_XA@mail.gmail.com>	<4DEF8A1D.2080707@redhat.com> <BANLkTi=CUs=bwcQa2YFgCfS3qYaY+T+S9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab1FHPXA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jun 2011 11:23:00 -0400
In-Reply-To: <BANLkTi=CUs=bwcQa2YFgCfS3qYaY+T+S9w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/8/11 10:01 AM, Amir G. wrote:
> On Wed, Jun 8, 2011 at 5:41 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 6/8/11 9:04 AM, Amir G. wrote:
>>>> And one last note, I also think that the snapshot format change in the
>>>>> future, when we'll have snpashots with 64bit feature compatible seems
>>>>> just wrong to me. Adding some features or changing the implementation a
>>>>> bit is ok, but format change is different. When the code is upstream and
>>>>> stable it is just wrong.
>>> What can I say, I understand why it looks bad, but is 64bit code
>>> upstream and stable? Hell no! e2fsprogs 64bit is not out yet!
>>> There is no reason to call it 'format change'.
>>> It's going to be a new format used only for 64bit fs, which are not
>>> even out there yet. And when they are finally out there, they won't
>>> have
>>> snapshots until the new format is implemented.
>>
>> Well, the on-disk format for 64-bit (48-bit?) ext4 is there & fixed; it's
>> just that there is no released userspace which can properly handle it, right?
> 
> I don't know, you tell me.
> Are there many users out there using 64bit feature, without the proper
> user space tools?

No, but that doesn't mean the disk format has to change when the tools
come out... I just don't want to confuse "there are no tools" with
"the disk format is unstable" - Andreas et. al. have been using
that format for years.

>>
>> I don't anticipate ext4 format changes for >16T, or am I missing something?
>>
>> -Eric
>>
> 
> Argh! I wish I hadn't missed the Monday call (it's
> not in a good time for me).
> This whole 'format change' has gone out of control
> and I find it hard to present my case properly on scattered emails.

Sorry; I may have just misunderstood...

> The message I am trying to get through is:
> There is 32bit snapshot file format, which is implemented and well tested.
> There is 64bit snapshot file format, which is not implemented yet, so
> 64bit and snapshot feature are mutually exclusive.
> If and when 64bit snapshot file format will be implemented, it will be
> a new type of extent mapped file (v2) with 48bit logical addresses.
> Is this a 'format change'? Call it what you will, but it shouldn't
> affect anything on existing structures. It should only affect the
> non-existing structure of 64bit snapshot file.
> 
> Does this answer your question?

Yes, I guess I had misunderstood your point; I thought you were
implying that ext4's format had to change to support 64-bit, so why
not change snapshots along with it....

But you're just saying that you wish to push 32-bit snapshots which only
work with certain sizes of ext4 filesystems now, and later you will
release a new snapshot format which works with the larger filesystems.
Right?

(I don't actually know if we'll ever have 64-bit ext4, though, there
are still so many scaling issues beyond just being able to mkfs,
mount, growfs etc ... it's a serious game of catch-up with xfs
in that space, IMHO, which has been doing it well for years now...)

Still, pushing snapshots upstream which will have an on-disk format
more limited than the rest of the filesystem's on-disk format 
does strike me as suboptimal from a pure technical design POV.

What if we proposed, say, xattr code that could only apply xattrs
to files located in the first 16T?  I don't think it'd be accepted.

I understand that you have a history and a format and a business case,
but that really should not change whether we do it right the first time,
upstream, IMHO...  But I'm just the peanut gallery, here....  ;)

-Eric

> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

