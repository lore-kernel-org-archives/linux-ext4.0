From: Stas Sergeev <stsp@aknet.ru>
Subject: Unable to use ext4 as root fs
Date: Sun, 01 Nov 2009 23:07:04 +0300
Message-ID: <4AEDEA68.3080803@aknet.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imp03.mtu.ru ([62.5.255.20]:34739 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbZKAUMt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Nov 2009 15:12:49 -0500
Received: from imp01.mtu.ru (alt-proxy-1.mtu.ru [62.5.255.74])
	by ss27-so02.mtu.ru (Postfix) with ESMTP id A8082229680
	for <linux-ext4@vger.kernel.org>; Sun,  1 Nov 2009 23:06:55 +0300 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

I am trying to move my PC from
ext3 to ext4, and so far I can't
get it to boot. I am getting this:
---
EXT3-fs: sda3: couldn't mount because of unsupported optional features 
(240).
---

Google reveals that this is normal,
and the next thing would be the
ext4 mount, but this doesn't happen.
The current git kernel just locks
up tight after that message. NMI
watchdog doesn't do anything. The
Fedora kernel doesn't lock up, the
keyboard works, you can Ctrl-Alt-Del,
but nothing happens, ext4 does not
mount.
I know that ext4 support is compilled
in (builtin, not a module), because
this very kernel mounts ext4 fine
if I boot from ext3 root fs.
Now, with the lack of the usual
"unable to mount root, kernel panic",
I am starting to suspect a bug somewhere.
Can someone please give me the hint
about what have to be done to boot
from ext4? Or, in case there is nothing
special to do, where should I start
sticking printk's to get that somehow
debugged?
