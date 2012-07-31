From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 unknown problem
Date: Tue, 31 Jul 2012 12:34:33 -0400
Message-ID: <20120731163433.GA32228@thunk.org>
References: <613523755.179491343719039762.JavaMail.root@shiva>
 <1343355595.179511343719122536.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, info <info@plaintext.sk>
To: luvar@plaintext.sk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42296 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab2GaQej (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 12:34:39 -0400
Content-Disposition: inline
In-Reply-To: <1343355595.179511343719122536.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 31, 2012 at 08:18:42AM +0100, luvar@plaintext.sk wrote:
> usb 2-4.4: USB disconnect, device number 10

So what's this?  Is this at all related to how you've created your
RAID device?  You haven't told us what your RAID device on dm-3 is
composed of (i.e., what are the underlying devices).

And there were no OOPS or BUG or WARN messages in your dmesg?

> PS: Writing to disk from jbd2/dm-3-8 still active (iotop shows it still on top of I/O activity).

I'm not sure if your kernel has trace debugging enabled, or if you
have debugfs mounted, but try this:

echo 1 > /sys/kernel/debug/tracing/events/jbd2/jbd2_run_stats/enable
cat /sys/kernel/debug/tracing/trace_pipe

If these commands don't work try running this command and see if it
works then:

mount -t debugfs debugfs /sys/kernel/debug

Let us know if you see jbd2 activity.  It's possible that sync isn't
returning because some process is still writing to the file system,
and if I recall correctly, Linux 3.2 didn't have some of the sync
livelock fixes that could cause sync to not return until the file
system had actually quieted down completely.

Regards,

					- Ted

