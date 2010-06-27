From: Nebojsa Trpkovic <trx.lists@gmail.com>
Subject: Re: Ext4 on SSD Intel X25-M
Date: Sun, 27 Jun 2010 19:47:46 +0200
Message-ID: <4C278EC2.1080903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60435 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab0F0Rrt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jun 2010 13:47:49 -0400
Received: by fxm14 with SMTP id 14so243099fxm.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jun 2010 10:47:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello.

I've found this old thread

http://thread.gmane.org/gmane.comp.file-systems.ext4/16386/focus=16444

and wanted to contribute a piece of my exiriance.

As I don't know if putting right subject will be enough to make reply on
right thread, I'm putting to BCC addresses of all coresponders in old
thread.

I've noticed that there is a difference between
/sys/fs/ext4/sdXX/lifetime_write_kbytes
and host writes read from SSD itself.

I'll put aside issue of losing lifetime_write_kbytes accuracy after
unclean reboot/shutdown:
http://thread.gmane.org/gmane.comp.file-systems.ext4/19734

Guess that session_write_kbytes doesn't succed to be added to
lifetime_write_kbytes in that particular case.

In normal desktop operation "host writes" counter on SSD increases at
roughly ~2/3 compared to lifetime_write_kbytes.

My best guess is that host itself uses a lot of optimisation to reduce
writing to NAND itself.

Besides that, I've noticed that my commit=100 mount option helps also.
Changing (just for testing) to something realy big, like commit=9000,
gave even further improvement, but not worth staying with risk of losing
(that much) data. It seems that ext4 writes a lot to filesystem, but
many of those writes are overwrites. If we flush them to host just once
in 100 seconds, we're getting a lot of saving.

As I wanted to make even my swap TRIMable, I've put it in the file on
ext4 instead of separate partition. I've made it using dd with seek=500
bs=1M options. ext4's lifetime_write_kbytes increased by 500MB, and host
writes did not incrase at all, even after 100 seconds. Ok, I know that
ext4 did not write 500MB of data to filesystem, but this is one more
thing why one should not trust lifetime_write_kbytes.

So, the moral of my story would be not to trust lifetime_write_kbytes,
but to read host writes from SSD.

I noticed that Intel's Solid State Drive Toolbox software (running in
Windows) gives the amount of Host Lifetime Writes that equales to
S.M.A.R.T attribute 225 (Load_Cycle_Count) multiplied with 32MB.
That's the way I track it in Linux.

Nebojsa Trpkovic




