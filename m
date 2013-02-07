From: Autif Khan <autif.mlist@gmail.com>
Subject: How can I flush all writes before yanking the power cable?
Date: Thu, 7 Feb 2013 11:43:23 -0500
Message-ID: <CADzUK1LUXH=w+FMxScugv-jW8ECHYmDBOrwT8OpXJdA336XA4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40794 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3BGQnY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2013 11:43:24 -0500
Received: by mail-lb0-f178.google.com with SMTP id n1so2292750lba.9
        for <linux-ext4@vger.kernel.org>; Thu, 07 Feb 2013 08:43:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The standard operating procedure to power down my machine is to switch
it off. To work around this, we use mSATA SSDs (actually we recently
switched from SATA SSDs) with linux on a read only partition.

This works just fine, however, we want to be able to upgrade some
parts of the application. To do this, we have put the application on
/app partition. We mount it read only at start up. When we want to
upgrade the app, we remount read-write sync (mount -o remount,rw,sync
/app) perform the write operations and remount read only.

If we yank the power cable after this, we get file system errors on
the next reboot.

We can display a message to the user telling them that it is safe to
power down the machine.

My question is

1) Is this the right place to discuss this or should I have posted
this in the file systems mailing list?

2) how can we determine that all the writes are flushed? (and this it
is safe to yank the power cable)

3) is there a better way to do this? - for example we may not have to
remount read write sync - and we can force a sync before remounting
read only or something

I have already tried "sudo sync" before remounting the filesystem as
read only. It does not help.

Please advise.

Thanks

Autif
