From: Joseph Fannin <jfannin@gmail.com>
Subject: Autoremoval of test_fs flag kinda sucks
Date: Sun, 21 Dec 2008 08:43:27 -0500
Message-ID: <20081221134326.GA26216@nineveh.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f13.google.com ([209.85.217.13]:41009 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYLUNnb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Dec 2008 08:43:31 -0500
Received: by gxk6 with SMTP id 6so1535537gxk.13
        for <linux-ext4@vger.kernel.org>; Sun, 21 Dec 2008 05:43:30 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is mostly me blowing off a little steam here, so yeah.  But maybe
it won't hurt to send out a heads up and get this in the archives:

Booting a 2.6.28-pre kernel will cause e2fsck to remove the test_fs
flag from any filesystem it checks, presumably because "ext4dev" has
become "ext4" in 2.6.28.  If your root fs is on ext4, this makes it
impossible to reboot back into a older kernel (i.e. < 2.6.28) since it
will refuse to mount an ext4dev fs without the "test_fs" flag set --
unless you chase after e2fsck and set the flag back.

It's not a huge deal -- and if you have your root on ext4dev before
2.6.28, you get an extra helping of "use at your own risk", anyway --
but it's an extra caveat that it might pay to be aware of.

I didn't mention this when I ran into this before because that first
2.6.28-rc kernel I booted didn't crash after fsck cleared that flag,
and I've just been working around it. I finally managed to get make
one of my computers unbootable this morning because of this, though.
It was user error, but now I have to take the box apart and put a CD
drive in it, just so I can boot a live CD and set that &^*# flag again.

Since (I'm guessing that) the bit that does the clearing seems to be
in e2fsck, and not in the kernel, it doesn't seem like there's much
that could be done about it.  In hindsight though, a deprecation
period might have been called for.

Ehn, it could be worse; I could have lost data.

Thanks.

--
Joseph Fannin
jfannin@gmail.com

