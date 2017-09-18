From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: mounting with lazytime doesn't work on ext4
Date: Mon, 18 Sep 2017 21:26:44 +0200
Message-ID: <20170918192644.GA232@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:52642 "EHLO
        mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbdIRTd1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Sep 2017 15:33:27 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I switched back to ext4 yesterday, because my btrfs fs got corrupted.
However mounting with lazytime doesn't work, neither specifying it in
/etc/fstab nor a manual remount. It looks like the option is simply
ignored.

Strace shows, e.g.:

 # mount -o lazytime /boot
mount("/dev/sdc2", "/boot", "ext4", MS_LAZYTIME, NULL) = 0 
EXT4-fs (sdc2): mounted filesystem with ordered data mode. Opts: (null) 
/dev/sdc2 on /boot type ext4 (rw,relatime,data=ordered)

 # mount -o remount,lazytime /var
mount("/dev/sdb2", "/var", 0x12c4460, MS_REMOUNT|MS_NOATIME|MS_LAZYTIME, NULL) = 0 
EXT4-fs (sdb2): re-mounted. Opts: (null)
/dev/sdb2 on /var type ext4 (rw,noatime,data=ordered)

When I set "sb->s_flags |= MS_LAZYTIME;" unconditionally in
fs/ext4/super.c:5057 (just deleting the if statement), then lazytime
gets used when I remount.

I'm running the latest git tree (4.14.0-rc1).

-- 
Markus
