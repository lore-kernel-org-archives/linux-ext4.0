From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: Question about ext4 online defrag test case
Date: Fri, 15 Jan 2010 19:11:28 +0530
Message-ID: <37d33d831001150541o1b674580u14719e72e3ad8e78@mail.gmail.com>
References: <4B4EEF94.5000902@rs.jp.nec.com>
	 <87f94c371001141304n18bcd208kd97f08646d37d1e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:38481 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab0AONla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jan 2010 08:41:30 -0500
Received: by bwz27 with SMTP id 27so546232bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 05:41:28 -0800 (PST)
In-Reply-To: <87f94c371001141304n18bcd208kd97f08646d37d1e2@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 15, 2010 at 2:34 AM, Greg Freemyer <greg.freemyer@gmail.com=
> wrote:
> On Thu, Jan 14, 2010 at 5:19 AM, Akira Fujita <a-fujita@rs.jp.nec.com=
> wrote:
>> Hi Ted,
>>
>>> E2defrag should hopefully be releasable in Karmic+1.
>>> There are still a lot of bugs that are still being fixed in the def=
rag
>>> code,
>>> some of which could cause data loss. They work fine
>>> if the system isn't under stress, sure, but acid test is to make su=
re
>>> things work OK even when the system is under memory pressure and
>>> swapping heavily, or when the file is being actively modified at th=
e point
>>> where the defrag takes place.
>>
>> I found your comment about ext4 online defrag on Ubuntu BBS by accid=
ent.
>> https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/321528
>>
>> I would like to address this problem so I ran e4defrag on the system
>> which was under memory pressure. But unfortunately I could not find =
the bug.
>> If you have already known how to reproduce this kind of problem,
>> could you teach me how?
>>
>> Regards,
>> Akira Fujita
>
> Sandeep, I've added you and I to this thread since oshm is using the
> same ext4_move_extents ioctl as E2defrag.
>
> Also, the above highlights the need for us to test ohsm relocates wit=
h
> data updates in progress. =A0Also with memory pressure which I had no=
t
> really thought about before.
>

We have been testing ext4_move_extent through OHSM relocation till now.
Also, we have been testing it on real-world data
(http://edrm.net/activities/projects/data-set).

But yes we surely need to test then on a system under memory pressure.

> We can discuss that on the ohsm list if needed.
>
> Greg
>

--=20
Regards,
Sandeep
OHSM Team
https://sourceforge.net/projects/ohsm/


=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
