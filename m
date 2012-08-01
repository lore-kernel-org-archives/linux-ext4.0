From: LuVar <luvar@plaintext.sk>
Subject: Re: ext4 unknown problem
Date: Wed, 1 Aug 2012 09:30:39 +0100 (GMT+01:00)
Message-ID: <371434290.179901343809839004.JavaMail.root@shiva>
References: <927688619.179881343809505627.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, info <info@plaintext.sk>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([81.0.124.6]:41208 "EHLO shiva.plaintext.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab2HAIao (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Aug 2012 04:30:44 -0400
In-Reply-To: <927688619.179881343809505627.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

----- "Theodore Ts'o" <tytso@mit.edu> wrote:

> On Tue, Jul 31, 2012 at 08:18:42AM +0100, luvar@plaintext.sk wrote:
> > usb 2-4.4: USB disconnect, device number 10
> 
> So what's this?  Is this at all related to how you've created your
> RAID device?  You haven't told us what your RAID device on dm-3 is
> composed of (i.e., what are the underlying devices).
> 

My raid is on top of five physical sata disc. That usb messages are related to usb keys which I have used on that PC.

> And there were no OOPS or BUG or WARN messages in your dmesg?
> 

My full dmesg is here:
http://dawn.ynet.sk/~luvar/asdf/20120801_1024_dmesg

> > PS: Writing to disk from jbd2/dm-3-8 still active (iotop shows it
> still on top of I/O activity).
> 
> I'm not sure if your kernel has trace debugging enabled, or if you
> have debugfs mounted, but try this:
> 
> echo 1 > /sys/kernel/debug/tracing/events/jbd2/jbd2_run_stats/enable

File does not exist... (if there is something to turn on in kernel config, I could do that for future...)

> cat /sys/kernel/debug/tracing/trace_pipe

again, file does not exist.

> 
> If these commands don't work try running this command and see if it
> works then:
> 
> mount -t debugfs debugfs /sys/kernel/debug

file does not exist (debug directory), but when I have tryied to mount it to /mnt/usbsticke dir, it has failed with unknown filesystem type (again, should I for future turn something on in kernel config?).

> 
> Let us know if you see jbd2 activity.  It's possible that sync isn't
> returning because some process is still writing to the file system,
> and if I recall correctly, Linux 3.2 didn't have some of the sync
> livelock fixes that could cause sync to not return until the file
> system had actually quieted down completely.
> 

Yes, still there is activity (first few lines from iotop):

Total DISK READ: 0.00 B/s | Total DISK WRITE: 134.97 K/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
17873 be/3 root        0.00 B/s    0.00 B/s  0.00 % 64.84 % [jbd2/dm-3-8]

> Regards,
> 
> 					- Ted

Have a nice day,
--
LuVar
