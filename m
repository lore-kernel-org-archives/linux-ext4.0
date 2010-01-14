From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Question about ext4 online defrag test case
Date: Thu, 14 Jan 2010 16:04:01 -0500
Message-ID: <87f94c371001141304n18bcd208kd97f08646d37d1e2@mail.gmail.com>
References: <4B4EEF94.5000902@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Sandeep K Sinha <sandeepksinha@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:59780 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab0ANVEC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2010 16:04:02 -0500
Received: by iwn32 with SMTP id 32so65761iwn.33
        for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2010 13:04:02 -0800 (PST)
In-Reply-To: <4B4EEF94.5000902@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 14, 2010 at 5:19 AM, Akira Fujita <a-fujita@rs.jp.nec.com> wrote:
> Hi Ted,
>
>> E2defrag should hopefully be releasable in Karmic+1.
>> There are still a lot of bugs that are still being fixed in the defrag
>> code,
>> some of which could cause data loss. They work fine
>> if the system isn't under stress, sure, but acid test is to make sure
>> things work OK even when the system is under memory pressure and
>> swapping heavily, or when the file is being actively modified at the point
>> where the defrag takes place.
>
> I found your comment about ext4 online defrag on Ubuntu BBS by accident.
> https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/321528
>
> I would like to address this problem so I ran e4defrag on the system
> which was under memory pressure. But unfortunately I could not find the bug.
> If you have already known how to reproduce this kind of problem,
> could you teach me how?
>
> Regards,
> Akira Fujita

Sandeep, I've added you and I to this thread since oshm is using the
same ext4_move_extents ioctl as E2defrag.

Also, the above highlights the need for us to test ohsm relocates with
data updates in progress.  Also with memory pressure which I had not
really thought about before.

We can discuss that on the ohsm list if needed.

Greg
