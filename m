From: "George Spelvin" <linux@horizon.com>
Subject: Re: 64bit + resize2fs... this is Not Good.
Date: 14 Nov 2012 02:20:21 -0500
Message-ID: <20121114072021.28351.qmail@science.horizon.com>
References: <20121114054347.GA20380@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:34269 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755230Ab2KNHUW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Nov 2012 02:20:22 -0500
In-Reply-To: <20121114054347.GA20380@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> So the first question is figuring out why the on-line resizing didn't
> work for you, since that is what I've spent most of my time trying to
> fix up.  The secondary question then is trying to figure out whappened
> with the off-line resize, and to fix that bug in e2fsprogs.

If you don't mind, *my* primary question is "what can I salvage from this
rubble?", since I didn't happen to have 8 TB of backup space available
to me when I did the resize, and there's soem stuff on the FS I'd
rather not lose...

So my big question is "where the F did inodes 129 through 2048
get copied to?", since the root directory contains a lot of inodes
in that range, and every one I can recover saves a lot of
pawing through lost+found later...


In hindsght, I wish to hell I had turned on -d 14 and logged the
results...


If you happen to want to rerun your test with -d8 and tell me what
happened there, I'd definitely appreciate it.
