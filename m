From: Nix <nix@esperi.org.uk>
Subject: 2.6.32+: ext4 direct-io kernel thread invasion
Date: Mon, 18 Jan 2010 23:40:23 +0000
Message-ID: <87y6jv9e3c.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mingming Cao <cmm@us.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:43943 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0ASARH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jan 2010 19:17:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So I upgraded one of my servers to 2.6.32 recently. It's got twelve ext4
filesystems on it, right now, and has direct I/O enabled because I have
one program that wants to do direct I/O to one of those filesystems on
rare occasions, and because you never know but someone might install
something else that wants to do direct I/O.

But what did I find in 2.6.32 but a new set of per-CPU, per-sb
workqueues whose raison d'etre appears to be something related to direct
I/O. Per-CPU, per-sb, that's a lot. Their full name is apparently
'ext4-dio-unwritten', apparently something to do with writing extents
for direct I/O-written blocks. But, boyoboy are there a lot of them:

nix@spindle 9 /home/nix% ps -fC ext4-dio-unwrit | wc -l
97

Now kernel threads are all very well --- it's obvious that e.g. a per-sb
journal flushing thread is worthwhile --- but *ninety-seven* kernel
threads for something like direct I/O, which in all but very unusual
high-end Oracle workloads is going to be a small proportion of I/O, is
just *insane*. And as core count goes up it's just going to get more
insane. Even my readonly-mounted filesystems seem to have some.

Do these threads really have to be per-CPU? Can't they default to
something much less aggressive, and then people with massive beefy
Oracle installations can up the number of these threads? (Dynamically
tuning their numbers according to the workload would be ideal: the
slow-work infrastructure can do this, IIRC, spawning new threads when
needed.)
