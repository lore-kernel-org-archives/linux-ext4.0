From: Tom <0x6d3468@gmail.com>
Subject: df report incorrect free space for a filesystem (ext4)
Date: Mon, 08 Aug 2016 11:15:46 +0300
Message-ID: <1470644146.31920.2.camel@gmail.com>
Reply-To: 0x6d3468@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35772 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbcHHISX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Aug 2016 04:18:23 -0400
Received: by mail-wm0-f65.google.com with SMTP id i5so13939139wmg.2
        for <linux-ext4@vger.kernel.org>; Mon, 08 Aug 2016 01:18:22 -0700 (PDT)
Received: from dopsbox-001 (cablep-179-104-14.cablep.bezeqint.net. [212.179.104.14])
        by smtp.googlemail.com with ESMTPSA id g7sm31597911wjx.10.2016.08.08.01.18.20
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Aug 2016 01:18:21 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Greetings,

This is my first message to community - so please forgive me message
format and mistakes I did :-)
I am writing to you, as I have a strong suspect that problem related to
filesystem/kernel internals.

I are continuosly having problems with inconsistency of free space
reported by `df` and calculating free size from SB. I are using LVM and
ext4 for our volumes (/, /tmp, /opt and etc).
Here is an example of / volume on bare metal server.

Reported by df:
Filesystem                  Size  Used Avail Use% Mounted on
/dev/mapper/rootvg-lv_root   20G   16G  2.8G  86% /

Super-Block:
Last mounted on:          /
Filesystem magic number:  0xEF53
Filesystem state:         clean
Filesystem OS type:       Linux
Inode count:              1290240
Block count:              5242880
Reserved block count:     227170
Free blocks:              3616906
Free inodes:              1201391
First block:              0
Block size:               4096
Fragment size:            4096

`df` reports 2.8G free space for /, but by binding fs and calculating
with `du` clearly seen that about ~12GB is free:
    root@none:~# mount -o bind / /tmp/root/
    root@none:~# du -sk /tmp/root/* | awk '{sum += $1} END {print sum}'
    8688976

I tried to remount the fs without any results:
    root@none:~# mount /dev/rootvg/lv_root -oremount,rw
    root@none:~# df -h
    Filesystem                  Size  Used Avail Use% Mounted on
    /dev/mapper/rootvg-lv_root   20G   17G  2.7G  86% /

The problem was resolved by remounting the fs with RO option:
    root@none:~# df -h
    Filesystem                  Size  Used Avail Use% Mounted on
    /dev/mapper/rootvg-lv_root   20G   17G  2.7G  86% /
    root@none:~# mount /dev/rootvg/lv_root -oremount,ro
    mount: / is busy
    root@none:~# mount /dev/rootvg/lv_root -oremount,rw
    root@none:~# df -h
    Filesystem                  Size  Used Avail Use% Mounted on
    /dev/mapper/rootvg-lv_root   20G  8.1G   11G  44% /

By looking for a solution, I found that this topic relatively hot and
there are no clear and certain answers.
My questions are:
- what cause to df report wrong information?
- what can be done to proactively avoid it (usually we get an alert on
partition and discover the problem)?

P.S.
Here is a link to question i created - http://serverfault.com/questions
/795324/df-report-incorrect-free-space-for-a-filesystem-ext4

Cheers,
Tom 
