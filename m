From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Fri, 16 Sep 2011 15:36:07 +0300
Message-ID: <CAOQ4uxhhH0ApB04XaLC4c7QQSf29-x_0AdO6WwvK_9WhXTN4=A@mail.gmail.com>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org>
	<4E66478E.90102@redhat.com>
	<alpine.DEB.2.01.1109060923340.9183@trent.utfs.org>
	<4E664DFD.80308@redhat.com>
	<20110908185139.GA2393@quack.suse.cz>
	<alpine.DEB.2.01.1109091809180.9183@trent.utfs.org>
	<20110910200414.GA6709@quack.suse.cz>
	<alpine.DEB.2.01.1109122150060.9183@trent.utfs.org>
	<alpine.DEB.2.01.1109152044090.5628@trent.utfs.org>
	<CAOQ4uxgvUsV7Qee6URzWvAkoV5VwLQWVLJWQ3VEpyVh3qbJXVA@mail.gmail.com>
	<alpine.DEB.2.01.1109160512290.5628@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, mszeredi@suse.cz,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f180.google.com ([74.125.82.180]:50784 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1IPMgJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Sep 2011 08:36:09 -0400
Received: by wyj26 with SMTP id 26so4693942wyj.11
        for <linux-ext4@vger.kernel.org>; Fri, 16 Sep 2011 05:36:08 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.01.1109160512290.5628@trent.utfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 16, 2011 at 3:17 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Fri, 16 Sep 2011 at 15:04, Amir Goldstein wrote:
>> This is just a shot in the dark, but are you using Ubuntu on your
>> production machine by any chance?
>
> No, I'm using Debian/stable on the "production" machine (the powerpc32
> box, where the error occurs). I was trying to reproduce this in a x86
> Ubuntu/10.04 VM, but could not.

Actually, now I recall that Yongqiang did say he saw the same problem on Debian,
but I may be wrong.

>
>> The reason I am asking is becasue I have been getting failures to
>> umount fs, while running xfstests on ext4
>> with Ubuntu for a long time and nobody else seems to share this problem.
>
> Is there a bug open for that?
>

No, I couldn't find any trace of bug reports on this behavior, so I wrote it off
as "miss-configuration" of my server.
I did write to xfs list to ask if anyone else has seen this problem.
You could try to run xfstests on your server and see if the problem is
reproducible.

>> I always suspected Ubuntu has some service that keeps open handles on
>> mounted fs, but I never got to examine this.
>
> Yeah...their "server" version needs major surgery to disable all the
> bells and whistles before it's becoming usable.
>

And I installed the "desktop" version, so where does this leave me...

Amir.
