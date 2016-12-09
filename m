From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Fwd: Filesystem size problem.
Date: Thu, 8 Dec 2016 21:40:36 -0800
Message-ID: <CAEUYfyOTkgczw5=T3PLcquT1qAcF4b2aKUEvsbX2DH5QBs5yJg@mail.gmail.com>
References: <CAEUYfyP7U9L4mB12awB_YWEqixh9R8RpRZXjYTG6mpiZeBW4OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:34700 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932351AbcLIFkh (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Dec 2016 00:40:37 -0500
Received: by mail-qt0-f176.google.com with SMTP id n6so7357937qtd.1
        for <linux-ext4@vger.kernel.org>; Thu, 08 Dec 2016 21:40:37 -0800 (PST)
In-Reply-To: <CAEUYfyP7U9L4mB12awB_YWEqixh9R8RpRZXjYTG6mpiZeBW4OQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Forwarding this to linux-ext4 list because the linux-admin list
appears to be very quiet.

Please accept my apologies in advance if this is the wrong forum for
this question!

Simon

---------- Forwarded message ----------
From: Simon Matthews <simon.d.matthews@gmail.com>
Date: Thu, Dec 8, 2016 at 8:29 PM
Subject: Filesystem size problem.
To: linux-admin@vger.kernel.org


I have an ext3 filesystem that will not mount under newer versions of
the kernel and I hope someone here can help.

Obviously, one solution is "backup and re-create from scratch". I have
the backups, but I hope that there may be a quicker method to fix the
issues.

The root issue is that the filesystem is very slightly smaller than
the allocated space. The filesystem exists on a MDRAID device and I
think that when I converted the MDRAID to a newer metadata version, it
truncated the available size, slightly. However, how I got here isn't
really important, fixing it now is.

With an slightly older kernel (4.0.5), the filesystem can be mounted.
With 4.4.26, the ext3 support is provided by the ext4 subsystem and it
appears that it will not accept the size issues. dmesg showed this
from the mount attempt:

md5: detected capacity change from 0 to 2839999799296
[ 1162.508338] EXT4-fs (md5): mounting ext3 file system using the ext4 subsystem
[ 1162.508560] EXT4-fs (md5): bad geometry: block count 693359344
exceeds size of device (693359326 blocks)

As I stated, the difference is very small, so it was working OK for a long time.

My attempts to re-size the filesystem did not work. I don't have the
error messages available. Getting the system up and running was more
important at the time.

Apart from "backup and re-create", how can I fix this? What would be
the correct options to use with resize2fs (if that is the correct
approach)? fsck gave me some serious warnings about possibly
destroying the filesystem, so I did not want to do this without
advice.

Simon
