From: Mark Lord <kernel@teksavvy.com>
Subject: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of ext4
Date: Tue, 12 Apr 2011 13:25:08 -0400
Message-ID: <4DA48AF4.5080803@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:55234 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753272Ab1DLRZM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Apr 2011 13:25:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted et al.

I've only just noticed this, so I have no idea how long it has been this way.

When I build a kernel with CONFIG_EXT4_USE_FOR_EXT23=y and boot from it,
the ext4 root filesystem shows up as "ext2" mode, rather than "ext4".

This looks very wrong to me, and quite dangerous.

Eg.  I test it by building my own kernel (2.6.38.2), with ext4 built-in,
no initramfs required, and boot:

    root=/dev/sda1 init=/bin/bash
    ...
    $ mount /proc
    $ cat /proc/mounts
    /dev/root / ext2 ro,relatime,barrier=1,data=ordered 0 0

So.. it shows "ext2" instead of "ext4".  That really looks like a bug.
Especially since it appears to be using journaling regardless.

Building the kernel without CONFIG_EXT4_USE_FOR_EXT23
results in a proper "ext4" mount entry in /proc/mounts.

