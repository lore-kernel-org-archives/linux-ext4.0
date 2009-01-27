From: Nick Warne <nick@ukfsn.org>
Subject: [QUESTION] root ext4 strange couldn't mount/can mount report
Date: Tue, 27 Jan 2009 13:42:31 +0000
Message-ID: <20090127134231.6daf4cbb@sauron.linicks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.10]:54676 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbZA0Nmf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 08:42:35 -0500
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id 65DD9DEE17
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2009 13:42:36 +0000 (GMT)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id wyECJYNzIgWB for <linux-ext4@vger.kernel.org>;
	Tue, 27 Jan 2009 12:22:20 +0000 (GMT)
Received: from sauron.linicks.net (linicks.net [87.127.191.50])
	by mail.ukfsn.org (Postfix) with ESMTP id 99B44DED30
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jan 2009 13:42:35 +0000 (GMT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

kernel 2.6.28.2
Slamd64 (Slackware 64bit port).

I have been running my /home partition as ext4 for a few weeks, and it
works very well, so today I converted / root partition over too.

All works great, but I saw I was getting a funny error/no error
reported in syslog:

Jan 27 12:54:57 sauron kernel: EXT3-fs: sda2: couldn't mount because of unsupported optional features (40).
Jan 27 12:54:57 sauron kernel: VFS: Mounted root (ext4 filesystem) readonly.

i.e. root / -> /dev/sda2 couldn't mount, but it does mount, and system
boots normally and functions fine.

Reading up I found that passing rootfstype=ext4 to kernel fixes up this
warning/error, but it appears only to apply to initramfs, of which I
do not use.

Searching boot scripts, I can find no mention of ext3 mounts.

Any ideas what makes the kernel try to mount the / as ext3?  Is it a
kernel build option I missed?

Thanks,

Nick
-- 
Free Software Foundation Associate Member 5508
http://linicks.net/
