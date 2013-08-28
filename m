From: Tim <elatllat@gmail.com>
Subject: resize2fs: Memory allocation failed while trying to resize
Date: Wed, 28 Aug 2013 11:29:49 -0400
Message-ID: <CA+3zgmtOoDGSGQrk4k3QNuAkgpoDgF+xUkFT5qY9cKKS76MiQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:37368 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab3H1P3x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 11:29:53 -0400
Received: by mail-lb0-f172.google.com with SMTP id x18so219460lbi.31
        for <linux-ext4@vger.kernel.org>; Wed, 28 Aug 2013 08:29:50 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I used resize2fs to do an online grow of from 8TB to 12TB and that worked fine.
now I'm trying to offline shrink back down to 8TB and resize2fs is
unable to do so.

Output:
resize2fs -M /dev/mapper/
crypt_left
resize2fs 1.42.5 (29-Jul-2012)
Resizing the filesystem on /dev/mapper/crypt_left to 1885633106 (4k) blocks.
resize2fs: Memory allocation failed while trying to resize
/dev/mapper/crypt_left
Please run 'e2fsck -fy /dev/mapper/crypt_left' to fix the filesystem
after the aborted resize operation.

I am using a raspberrypi so it's 32-bit and limited to 256MB and I
have 2x that in swap.

uname -a
Linux test 3.6.11+ #474 PREEMPT Thu Jun 13 17:14:42 BST 2013 armv6l GNU/Linux

I was watching top and never saw it use more that 53% of the RAM but I
may have missed the crucial moment.
(taken during a "e2fsck -fy ")
free
             total used free shared buffers cached
Mem: 237648 225440 12208 0 63240 11796
-/+ buffers/cache: 150404 87244
Swap: 475132 13444 461688

Please let me know if there is anything that would help solve this issue.
