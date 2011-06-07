From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH RFC 00/30] Ext4 snapshots - core patches
Date: Tue, 7 Jun 2011 09:40:33 +0300
Message-ID: <BANLkTimor-kJ8cjnLt4JYPhW2GW09N1YtQ@mail.gmail.com>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
	<alpine.LFD.2.00.1106061501460.3934@dhcp-27-109.brq.redhat.com>
	<BANLkTimjxkOnX6hvLvU+Xth20ie5FaXq1A@mail.gmail.com>
	<4DECF2D5.7050408@redhat.com>
	<20110606205512.GE20818@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46557 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1FGGkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 02:40:35 -0400
Received: by wya21 with SMTP id 21so3311305wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 06 Jun 2011 23:40:33 -0700 (PDT)
In-Reply-To: <20110606205512.GE20818@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 6, 2011 at 11:55 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 06, 2011 at 10:31:33AM -0500, Eric Sandeen wrote:
>> > For one reason, a snapshot file format is currently an indirect fi=
le
>> > and big_alloc
>> > doesn't support indirect mapped files.
>> > I am not saying it cannot be done, but if it does, there would be
>> > several obstacles
>> > to cross.
>>
>> I know I'm kind of just throwing a bomb out here, but I am very conc=
erned
>> about the ever-growing feature (in)compatibility matrix in ext4.
>
> bigalloc doesn't support indirect blocks mainly because it was faster
> to get things working if I didn't have to worry about indirect blocks=
=2E
> It wouldn't be _that_ hard to make bigalloc work on indirect blocks.
> I'll get around to it at some point.
>
> dioread_nolock is something that I had hoped to clean up by now, by
> making this the default way we do all buffered writebacks, for all
> block sizes.
>
>> Take for example dioread_nolock caveats:
>>
>> =A0 =A0 =A0 =A0 =A0 "However this does not work with nobh
>> =A0 =A0 =A0 =A0 =A0 =A0option and the mount will fail. Nor does it w=
ork with
>> =A0 =A0 =A0 =A0 =A0 =A0data journaling and dioread_nolock option wil=
l be
>> =A0 =A0 =A0 =A0 =A0 =A0ignored with kernel warning. Note that diorea=
d_nolock
>> =A0 =A0 =A0 =A0 =A0 =A0code path is only used for extent-based files=
=2E"
>
> Hey, at least we got rid of nobh! =A0:-)
>
>> If ext4 matches the lifespan of ext3, in 10 years I fear that it wil=
l look
>> more like a collection of various individuals' pet projects, rather =
than
>> any kind of well-designed, cohesive project.
>>
>> How long can we really keep adding features which are semi- or wholl=
y-
>> incompatible with other features?
>>
>> Consider this a cry in the wilderness for less rushed feature introd=
uction,
>> and a more holistic approach to ext4 design...
>
> It's something I do worry about; and I do share your concern. =A0At t=
he
> same time, the reality is that we are a little like the Old Dutch
> Masters, who had take into account the preference of their patrons
> (i.e., in our case, those who pay our paychecks :-).
>
> In the case of dioread_nolock, I allowed dioread_nolock in even thoug=
h
> it was a not a complete solution since internally, we had critical
> business for it, and in my judgement, (a) it wasn't that horrible
> (most of the horrible code paths was already being used for AIO/DIO),
> and (b) I had a plan for how to clean it up eventually. =A0The
> fs/ext4/page_io.c implementation was in fact the first part of my
> cleanup plan, so we've made some progress; it's just not gone as fast
> as I would like.
>
> Snapshots are an example of a feature where I am very much worried
> about taking on technical debt. =A0On the other hand, there are a lot=
 of
> people who are quite excited of it as a feature, so I'm hoping we can
> clean it up enough we don't put a huge maintenance burden on
> ourselves.
>
> It should be possible to make snapshots work on bigalloc file systems=
,
> once support is added for indirect blocks. =A0The COW granulaity will
> have to be done at the cluster level, of course, though. =A0So from a
> design perspective it should be possible to make things knit together=
=2E
>

The question is why *should* we knit those 2 features together?
There is a patron for snapshots and there is a patron for big_alloc,
but is there a patron for both mixed? I don't thinks so.
*This* is a maintenance burden, because none of the patrons will pay
us to support this configuration.

What's so bad about mutually excluding features, which are useful
on their own? For one thing, it keeps the test matrix smaller, so it is
actually realistic to follow it through.

I hear Eric's cry in the wilderness and I can relate to it.
Maybe is the distros that need to take action about it and declare
only a reduces set of features matrix 'supported'.
We can even try to write generic mutual exclusion rules, which
will be enforced by mke2fs/tune2fs and ext4.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
