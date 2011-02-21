From: =?UTF-8?Q?Pawe=C5=82_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: Re: fsck performance.
Date: Mon, 21 Feb 2011 17:04:26 +0100
Message-ID: <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com>
References: <20110220090656.GA11402@bitwizard.nl>
	<20110220170931.GB3017@thunk.org>
	<20110220193406.GC3017@thunk.org>
	<20110220215531.GA21917@bitwizard.nl>
	<20110220222013.GA2849@thunk.org>
	<20110220231514.GC21917@bitwizard.nl>
	<20110220234131.GC4001@thunk.org>
	<AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ted Ts'o" <tytso@mit.edu>, Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47282 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab1BUQE1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Feb 2011 11:04:27 -0500
Received: by wyb38 with SMTP id 38so1256793wyb.19
        for <linux-ext4@vger.kernel.org>; Mon, 21 Feb 2011 08:04:26 -0800 (PST)
In-Reply-To: <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/2/21 Amir Goldstein <amir73il@gmail.com>:
> One thing I am not sure I understand is (excuse my ignorance) why is the
> swap space solution good only for 64bit processors?

It's an address space limit on 32 bit processors. Even with PAE the
user space process still won't have access to more than 2^32 bits,
that is 4 GiB of memory. Due to practical limitations (e.g. kernel
needing some address space) usually a process won't have access to
more than 3 GiB.

> Is it a common knowledge that fsck can require more than 3GB of memory?

It is, for a given value of common. Disk sizes exploded and there have
been reports of people running out of memory on 32 bit boxes with
terabyte-sized filesystems for several years now. I did a bit of
googling and found descriptions of such case from 2008.

> If it is common knowledge, do you know of an upper limit (depending on fs size,
> no. of inodes, etc)?
>

I vaguely remember some estimation of memory requirements of fsck
being given somewhere, but I'm not able to find the posts now :(.
