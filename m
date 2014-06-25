From: Chin Tzung Cheng <chintzung@gmail.com>
Subject: About changing the UUID of external journal device
Date: Wed, 25 Jun 2014 17:31:15 +0800
Message-ID: <CAPBYzXNb18pwCijLTRrprMjUDGuCwRso7pa0K2foObqr_9pHpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:53954 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaFYJbQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jun 2014 05:31:16 -0400
Received: by mail-vc0-f177.google.com with SMTP id ij19so1587804vcb.36
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jun 2014 02:31:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I have problem while I create a ext4 volume with external journal device.
The UUID of external journal device is not the one I specify.

First, I create a journal device(/dev/sda4).

[root@localhost sbin]# ./mke2fs -O journal_dev /dev/sda4
[root@localhost sbin]# ./blkid /dev/sda4
/dev/sda4: UUID="1313c286-7803-4a40-9010-74964554d13f" TYPE="jbd"

I use tune2fs to change the UUID of journal device. blkid shows the
UUID is changed.

[root@localhost sbin]# ./tune2fs  /dev/sda4 -U
aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
[root@localhost sbin]# ./blkid /dev/sda4
/dev/sda4: UUID="aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa" TYPE="jbd"

Make an ext4 volume with external journal device (dev/sda4)

[root@localhost sbin]# ./mke2fs /dev/sda3 -t ext4 -J device=/dev/sda4

[root@localhost sbin]# ./dumpe2fs -h /dev/sda3 | grep UUID
dumpe2fs 1.42.10 (18-May-2014)
Filesystem UUID:          d8f038e5-9539-4b1d-8ccb-63cc56771fc5
Journal UUID:             1313c286-7803-4a40-9010-74964554d13f

However, the journal device UUID of ext4 volume is still the old one.
It's not the new one.

Test environment
Kernel version: 3.12.10
e2fsprogs version: 1.42.10

Any help would be appreciated.

Thanks,
chintzung
