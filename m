From: Nebojsa Trpkovic <trx.lists@gmail.com>
Subject: lifetime_write_kbytes isn't preserved during unclean shutdown
Date: Sun, 27 Jun 2010 18:56:07 +0200
Message-ID: <4C2782A7.7040301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60431 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab0F0Q4K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jun 2010 12:56:10 -0400
Received: by bwz10 with SMTP id 10so422022bwz.19
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jun 2010 09:56:08 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've noticed that lifetime_write_kbytes isn't preserved during unclean
shutdown.
At least on my Intel X25-V, but I guess it's ext4's issue, not Intel's
one. :)

lifetime_write_kbytes constantly grow while using filesystem. If
computer is rebooted regulary with clean unmount, next time it boots
lifetime_write_kbytes will continue incrementing counter and everything
seems to work right.

Then again, if there was unclean shutdown/reboot, lifetime_write_kbytes
will be reset to value of last clean unmount. Example:

lifetime_write_kbytes 18 GB
lifetime_write_kbytes 20 GB
lifetime_write_kbytes 22 GB
clean reboot
lifetime_write_kbytes 22 GB
lifetime_write_kbytes 24 GB
lifetime_write_kbytes 26 GB
unclean reboot (reboot switch/power failure/whatever)
lifetime_write_kbytes 22 GB
...

I guess that /sys takes value written in filesystem itself and increment
it during system operation, but writes back new lifetime_write_kbytes
value to filesystem just on clean unmount.
It seems it would not hurt to write periodicly, maybe not too often - 10
minutes or so, intermidiate lifetime_write_kbytes value to filesystem
and avoid unnecessary lost of lifetime_writes on unclean reboot.

Nebojsa Trpkovic

