From: Fredrik Andersson <nablaman@gmail.com>
Subject: Fwd: Ext4 bug with f
Date: Sun, 18 Oct 2009 17:47:25 +0200
Message-ID: <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>
References: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:52990 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZJRPrX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Oct 2009 11:47:23 -0400
Received: by ewy4 with SMTP id 4so783021ewy.37
        for <linux-ext4@vger.kernel.org>; Sun, 18 Oct 2009 08:47:26 -0700 (PDT)
In-Reply-To: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, I'd like to report what I'm fairly certain is an ext4 bug. I hope
this is the right place to do so.

My program creates a big file (around 30 GB) with posix_fallocate (to
utilize extents), fills it with data and uses ftruncate to crop it to
its final size (usually somewhere between 20 and 25 GB).
The problem is that in around 5% of the cases, the program locks up
completely in a syscall. The process can thus not be killed even with
kill -9, and a reboot is all that will do.

Here is the contents of my /proc/PID/syscall:
76 0xee4a80 0x486d6aaf8 0x36390113f8 0x7fffc63cd350 0xecc050
0x7fffc63cd3f0 0x7fffc63cd5c8 0x36380e0cc7

Syscall 76 is as far as I can tell getrlimit, which I do not call. It
must have been called somewhere from ftruncate.

The file is on a software raid 0 mount with two disks, handled by
mdadm. I have reported the problem to the md people but they insist
it's an ext4 problem.

I have also tried closing the file and opening it again prior to the
ftruncate. No change.

There are no other strange phenomena whatsoever with ext4. This
problem only arises in this particular situation.

I'm running Fedora on an x86_64 system.
I have tried this on several kernel versions, the last one 2.6.31.1.
It has persisted all the way since the kernel that originally shipped
with Fedora 11.

Is this a bug/known problem? Thankful for any insights!

/Fredrik
