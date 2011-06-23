From: Charles Taylor <taylorc@tinnov.net>
Subject: Big Mess
Date: Thu, 23 Jun 2011 00:11:31 -0400
Message-ID: <BANLkTi=UW-khzRKkfa_vPDzwkUu2YTmRiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56833 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1FWELw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jun 2011 00:11:52 -0400
Received: by vws1 with SMTP id 1so1063817vws.19
        for <linux-ext4@vger.kernel.org>; Wed, 22 Jun 2011 21:11:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Normally I would not be coming here for help, but I made a big mistake
and frankly don't think any other group has sufficient kernel/ext4
knowledge to help me.

My partition table used to look like this:

/dev/sda1     start:6144	end:10743
/dev/sda2     start:10743	end:10946

I deleted /dev/sda1 on a live system and recreated it like so:

/dev/sda1     start:1     end:10742

And rebooted.

Please don't ask why I did that, or how it happened. It is a long
story and was an accident.

Needless to say, it really messed things up. I booted a rescue disk
and changed the table back to this:

/dev/sda1     start:6144	end:10742
/dev/sda2     start:10743	end:10946

Rebooted. No luck.

fsck.ext4 can't find a valid superblock and I haven't had any luck
finding a backup. Some things that may help:

* MBR partition table.
* All changes made with fdisk.
* I found what looks like it may be a superblock at cylinder 6144,
head 4, sector 16, with an offline disk editor but don't know how to
tell fsck to use it.
* Block size is 512 bytes.
* Disk is a 90GB SSD.

So, anyone know how I can return this file system to working order?

Thanks in advance!
