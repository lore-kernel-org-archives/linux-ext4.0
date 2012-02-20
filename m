From: Rabeeh Khoury <rabeeh3000@gmail.com>
Subject: 16 TB filesystem limit on 32bit machine
Date: Mon, 20 Feb 2012 17:31:15 +0200
Message-ID: <CAJZuRVZ5BC+oJA_4HqdwnJvME8XuDeCWWt_6pugOuBFjp8v_SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35175 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2BTPbR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Feb 2012 10:31:17 -0500
Received: by vbjk17 with SMTP id k17so3573480vbj.19
        for <linux-ext4@vger.kernel.org>; Mon, 20 Feb 2012 07:31:16 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm trying to figure out all issues with regards >16TB filesystem
support on ARM (32bit) machines.
Clearly this issue was hot few years ago, part of the discussions -

https://bugzilla.kernel.org/show_bug.cgi?id=12556
http://www.redhat.com/archives/dm-devel/2009-July/msg00131.html

And there was Eric's patch of checking length of pgoff_t and
accordingly refuse mount.

Now, today with 4TB hard drives in the market, having 5 of those on an
ARM machine is really common and the ext4 limitation is becoming more
reachable and requires attention.
What i'm trying to achieve is the following two items -

---- item #1 ---
Understand where the limitation is really coming from? Is this ext4
implementation limitation or 32bit machines will never work with >16TB
filesystems?
I understand that there is a 16TB file size limitation (2^32*4K page
size so you won't be able to mmap() further than that point) but how
is that related to filesystem size?
Will 64KB page size fix this issue (ARM supports 4KB and 64KB pages) -
clearly memory fragmentation will be a hit here.

----- item #2 ---
Reproduce a failing scenario.
For now i'v created a 24TB volume (thin provisioned) - RAID-0 on a 3 x
loopback on a 3 x truncted 8TB consisting total of 24TB volume
mkfs.ext4 /dev/md0 (e2fsprogrs 1.42 - thanks for the >16TB support)
mount on a hacked kernel (#define pgoff_t unsigned long long thus
making filesystem mounting check disappear)
The volume mounts ok; now how do i get into corruption? I don't have
physical 24TB drive, so best if there is a pin-pointed to test to
reproduce the issue.

Best regards,
Rabeeh
