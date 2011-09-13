From: Matt Parnell <mparnell@gmail.com>
Subject: Bug In ext4 in kernels > 2.6.39 - Not mounting with arguments/options
 I specify in fstab on root remount
Date: Tue, 13 Sep 2011 04:01:04 -0500
Message-ID: <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com>
References: <4E6F1B49.3010803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:50662 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1IMJHp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Sep 2011 05:07:45 -0400
Received: by pzk37 with SMTP id 37so625178pzk.1
        for <linux-ext4@vger.kernel.org>; Tue, 13 Sep 2011 02:07:44 -0700 (PDT)
In-Reply-To: <4E6F1B49.3010803@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all... I usually run my system the zen kernel (zen-kernel.org), but
I've tried this with the default Archlinux kernel (pretty much a
vanilla build) as well and for some reason, the root drive won't mount
with the options I desire on anything above .29 The drive is an SSD,
and this is really getting on my nerves. I've looked at the
initscripts, fstab, everything else, and I just can't get any of this
to work properly. It was mounting with all the options I specified in
2.6.39, but since some change to the kernel (or something else?) I
can't mount with my options anymore. On top of this all, I've tried
using both /dev/root and /dev/sdb1, but for some reason the kernel's
only wanting to use /dev/root - I'm wondering if there's some kind of
conflict due to that symlink...

I know this isn't my initscripts, as I've also tried this using
openrc, aside from the default arch init system, and because upon
downgrading to 2.6.39 everything is working normally again, I know it
is the kernel. Information:

grub.cfg:

linux	/boot/linux-zen root=/dev/sdb1 ro rootfstype=ext4
rootflags=data=writeback noatime barrier=0 discard noinitrd

fstab:

/dev/sdb1 / ext4 data=writeback,noatime,nodiratime,barrier=0,discard 0 1

Upon attempting to remount manually, I only get the following when I
try to use the options I specified above:

EXT4-fs (sdb1): Cannot change data mode on remount

Interestingly, this also happened and worked, which I think is a bug,
how can barrier=0 and 1 at the same time?

EXT4-fs (sdb1): re-mounted. Opts: user_xattr,barrier=1,barrier=0

I'm currently using a .39 kernel and can live with it for now, but I
thought this was serious enough that the ext4 devs should hear about
it. If you need any more information, just let me know.

Thanks!

Matt Parnell
