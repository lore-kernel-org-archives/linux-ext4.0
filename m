From: LuVar <luvar@plaintext.sk>
Subject: sustained write to disk, frozen copy
Date: Sat, 27 Apr 2013 08:16:02 +0100 (GMT+01:00)
Message-ID: <918096296.2221367046962554.JavaMail.root@shiva>
References: <1719908460.2201367046573138.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([85.248.156.6]:48185 "EHLO
	shiva.plaintext.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3D0H02 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Apr 2013 03:26:28 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by shiva.plaintext.sk (Postfix) with ESMTP id BDDB926CE4
	for <linux-ext4@vger.kernel.org>; Sat, 27 Apr 2013 09:16:10 +0200 (CEST)
Received: from shiva.plaintext.sk ([127.0.0.1])
	by localhost (shiva.plaintext.sk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b+XrU9ylkTex for <linux-ext4@vger.kernel.org>;
	Sat, 27 Apr 2013 09:16:02 +0200 (CEST)
Received: from shiva.plaintext.sk (shiva.plaintext.sk [85.248.156.6])
	by shiva.plaintext.sk (Postfix) with ESMTP id B8EEA26354
	for <linux-ext4@vger.kernel.org>; Sat, 27 Apr 2013 09:16:02 +0200 (CEST)
In-Reply-To: <1719908460.2201367046573138.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I have my desktop about 24 hours in "deadlock". I was copying (as root in krusader from USB key (mounted as [1]) data to filesystem [2]) some files from one point to another. Now it is more than 24 hours with sustained disk write, see [3].

How can I help and "debug" this problem? I have 3.5.7 gentoo kernel ([4]).

PS: I am an average user, so please by verbose to me.

[1] sudo mount -o rw,uid=luvar,gid=luvar,iocharset=utf8 /dev/sdg1 /mnt/usbstick/

[2]:
luvar@blacktroja ~ $ mount | grep music
/dev/mapper/vg-music on /var/lib/mpd/music/local type ext4 (rw,noatime,commit=0)

[3]:
iotop, two first records :
17714 be/3 root        0.00 B/s    0.00 B/s  0.00 % 97.60 % [jbd2/dm-3-8]
 6546 be/4 root        0.00 B/s    0.00 B/s  0.00 % 93.48 % kdeinit4: kio_file [kdeinit] file local:/tmp/ksocket-root/~-socket local:/tmp/ksocket-root/krusaderZz6431.slave-socket

[4]:
luvar@blacktroja ~ $ uname -a
Linux blacktroja 3.5.7-gentoo #1 SMP Sun Oct 28 17:18:07 CET 2012 x86_64 Intel(R) Core(TM) i7 CPU 930 @ 2.80GHz GenuineIntel GNU/Linux

Thanks, LuVar
