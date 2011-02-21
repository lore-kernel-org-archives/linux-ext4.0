From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: fsck performance.
Date: Mon, 21 Feb 2011 12:31:20 +0200
Message-ID: <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com>
References: <20110220090656.GA11402@bitwizard.nl>
	<20110220170931.GB3017@thunk.org>
	<20110220193406.GC3017@thunk.org>
	<20110220215531.GA21917@bitwizard.nl>
	<20110220222013.GA2849@thunk.org>
	<20110220231514.GC21917@bitwizard.nl>
	<20110220234131.GC4001@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42138 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab1BUKbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Feb 2011 05:31:21 -0500
Received: by qyk7 with SMTP id 7so1830284qyk.19
        for <linux-ext4@vger.kernel.org>; Mon, 21 Feb 2011 02:31:20 -0800 (PST)
In-Reply-To: <20110220234131.GC4001@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 21, 2011 at 1:41 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Feb 21, 2011 at 12:15:14AM +0100, Rogier Wolff wrote:
>> > BTW, my backup plan was to replace tdb with something else. =A0One=
 of
>> > the candidates I was looking at was sqlite, but rumors of its spee=
d
>> > deficiencies are making me worry that it won't be a good fit. =A0I=
 don't
>> > want to use berk_db because it has a habit of changing API's
>> > regularly, and you can never be sure which version of berk_db
>> > different distributions might be using. =A0One package which I tho=
ught
>> > held promise was Koyoto Cabinet, but unfortunately, it's released
>> > under GPLv3, which makes it incompatible with the license used by
>> > e2fsprogs (which has to be GPLv2, since there are a few files whic=
h
>> > are shared with the Linux kernel).
>>

What about Tokyo Cabinet? it seems to be released under GPLv2.1.
Isn't it sufficient (or even better suiting) for scratch files?

>> Hmm. I'll take a look.
>
> If you could put a bit of time into this, that would be really great.
> I have a lot of things that I need to do at the moment, and trying to
> improve [scratch_files] performance is something I've known about for
> a while, but I just haven't had time to get to it.
>
> The fact that the problem can be solved by using 64-bit capable CPU's
> and a large swap space has kept this from rising to the top of the
> priority heap, but it is an important use case, since we do have NAS
> boxes that use cheap-sh*t 32-bit processors, and I'd like to be able
> to support them. =A0But I just don't have the time ATM, so if I can
> delegate this out to someone else, that would be really helpful.
>

CTERA uses *affordable* 32-bit processors for it's low-end NAS products=
,
which still need to be able to complete fsck of a 8TB fs in a reasonabl=
e time
(less than the time is takes the customer to loose it's patient and loo=
k for
alternative products).

We would be willing to invest resources for this cause,
should we know there is a promising path to follow.

One thing I am not sure I understand is (excuse my ignorance) why is th=
e
swap space solution good only for 64bit processors?
Is it a common knowledge that fsck can require more than 3GB of memory?
If it is common knowledge, do you know of an upper limit (depending on =
fs size,
no. of inodes, etc)?

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
