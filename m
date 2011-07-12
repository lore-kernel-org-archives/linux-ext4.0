From: Andy Campbell <andycampbell.uk@gmail.com>
Subject: High latency with ext4 / jbd2 kernel thread
Date: Tue, 12 Jul 2011 01:07:27 +0100
Message-ID: <CALEedhfHQBiCxv06X3w-JwUzP+beJ9+_zUbr=9vHErp+ew1r=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51589 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1GLAH2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jul 2011 20:07:28 -0400
Received: by gwaa18 with SMTP id a18so1724444gwa.19
        for <linux-ext4@vger.kernel.org>; Mon, 11 Jul 2011 17:07:28 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi ext4 mailing list members,

I hope you can help me with a problem.

I recently upgraded my main audio PC to Fedora FC15 and, at the same
time, reformatted by root drive to ext4.  Since this upgrade this, my
system has high system latency which is causing my audio hardware
(firewire) to experience buffer under-runs (XRUNs).  This causes
"unhandled xrun" errors and the audio software fails.

My audio software (jackd) is running in realtime mode with SCHED_FIFO priority.

I have been using latencytop (http://www.latencytop.org/) to try to
understand what is causing the system latency.
Typically my system runs with a max latency around 5ms.  If i run a
disk heavy operation (such as updatedb) I see a max latency of around
20ms.

Around the time that jackd fails, I can see events like this with a
latency of 40 - 120 ms:
"writing buffer to disk (synchronous)"  = "jbd2_journal_commit_transaction"
Screenshot here
http://dl.dropbox.com/u/3289905/latencytop.png

My kernel version is
Linux speedy.local 2.6.38.8-32.fc15.i686.PAE #1 SMP Mon Jun 13
19:55:27 UTC 2011 i686 i686 i386 GNU/Linu

The ext4 drive is mounted with these options:
/dev/sda4 on / type ext4 (rw,relatime,seclabel,barrier=1,data=ordered)
I also tried mounting using using noatime and also using
data=writeback options.  Unfortunately neither of these parameters
resolved the problem

Could you give me any advice or ideas about how I could minimize this latency?

Thanks!

Andy
