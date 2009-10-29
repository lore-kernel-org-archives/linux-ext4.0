From: Justin Maggard <jmaggard10@gmail.com>
Subject: EXT4 >16TB resize2fs support
Date: Thu, 29 Oct 2009 14:54:11 -0700
Message-ID: <150c16850910291454j18db2729m572dc0fe22658f1e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:44300 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbZJ2VyH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2009 17:54:07 -0400
Received: by pxi9 with SMTP id 9so1457846pxi.4
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2009 14:54:11 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

What is the current expected status of resize2fs support with 64-bit
filesystems?  Specifically, expanding from <16TB to >16TB.  I'm using
the latest code from pu, and seeing some odd things.  I'm not sure
what the 64bit feature flag does exactly, but is the transition not
handled properly?

I started with a 15TB LV and filesystem, and then added a new 2TB
drive to the LV.  I tried resize2fs (compiled for x86_64) with the
filesystem online.  It said it expanded successfully, but it was very
quick, and the filesystem was still the same size.
resize2fs 1.41.9 (22-Aug-2009)
Filesystem at /dev/vg/lv is mounted on /lv; on-line resizing required
old desc_blocks = 955, new_desc_blocks = 1161
Performing an on-line resize of /dev/vg/lv to 4869357568 (4k) blocks.
The filesystem on /dev/vg/lv is now 4869357568 blocks long.

Then I unmounted and re-ran resize2fs.  It claimed it was going to
resize to 4869357568 (4k) blocks, but after it was done, my filesystem
was only 2.2TB.  Resize2fs output is below:
resize2fs 1.41.9 (22-Aug-2009)
Resizing the filesystem on /dev/vg/lv to 4869357568 (4k) blocks.
Begin pass 2 (max = 32768)
Relocating blocks             XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Begin pass 3 (max = 122222)
Scanning inode table          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
The filesystem on /dev/vg/lv is now 574390272 blocks long.

After that, I re-mounted and tried doing another online resize, which
resulted in a floating point exception:
resize2fs 1.41.9 (22-Aug-2009)
Filesystem at /dev/vg/lv is mounted on /lv; on-line resizing required
old desc_blocks = 137, new_desc_blocks = 1161
Performing an on-line resize of /dev/vg/lv to 4869357568 (4k) blocks.
Floating point exception

After that, I ran e2fsck -f, which reported that the filesystem was clean.

So... what is expected to work at this point, and what is expected to
be broken with the resize process?  Any idea why my fs was shrunk down
to 2.2TB when it was supposed to grow to 18TB?

Thanks!
-Justin
