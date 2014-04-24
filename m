From: Brian Hutchinson <b.hutchman@gmail.com>
Subject: Ext4 inode & trim errors on Micron eUSB SSD with 2.6.37 kernel
Date: Thu, 24 Apr 2014 16:05:26 -0400
Message-ID: <CAFZh4h9avyDGPMcJnbHZxLFKHr2fAopz_26LqmnSn3Hobni+nA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:64515 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaDXUF0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Apr 2014 16:05:26 -0400
Received: by mail-oa0-f42.google.com with SMTP id i4so3222441oah.1
        for <linux-ext4@vger.kernel.org>; Thu, 24 Apr 2014 13:05:26 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

First post here but have been lurking and searching archives for a while.

I have a custom embedded board that I support which is running Yocto
1.5.  The mkfs.ext4 and all other efs2progs files are fairly
up-to-date ... the kernel is just kind of old (yea, I know, I need to
move up some but that is easier said than done on this thing).

The processor is a TI816x (Cortex A8 armv7 arch).

I've been getting some pretty nasty ext4 errors.  Things like:

EXT4-fs error (device sda1) in ext4_dirty_inode:5716: error -4096

EXT4-fs (sda1): delayed block allocation failed for inode 89 at
logical offset 43008 with max blocks 2016 with error -909004800

EXT4-fs (sda1): This should not happen!! Data will be lost

grow_buffers: requested out-of-range block 14543285590114443400 for device sda1
Aborting journal on device sda1-8.
journal commit I/O error
Apr 17 17:28:38 WCS kernel: jouEXT4-fs error (device sda1):
ext4_journal_start_sb:258: rnal commit I/O Detected aborted
journalerror

EXT4-fs (sda1): Remounting filesystem read-only
Apr 17 17:28:38 WCS kernel: EXT4-fs error (device sda1):
ext4_journal_start_sb:258: Detected aborted journal
Apr 17 17:28:38 WCS kernel: EXT4-fs (sda1): Remounting filesystem read-only


... so I've been educating myself on all things related to Ext4 on SSD
type drives.

The drive I'm using is actually two NAND flash chips on a little
circuit board controller connected to a USB bus that Micron calls an
e230 Real SSD (a 2GB drive).

I discovered that I wasn't mounting the drive with noatime and discard
(for TRIM) so I added those and verified the settings took place:

/dev/sda1 on /media/sda1 type ext4 (rw,noatime,barrier=1,data=ordered,discard)

Doubled checked that the partition was properly aligned by fdisk too:

~# blockdev --getalignoff /dev/sda1
0

I have a script that copies a large file (146M) to four other unique
filenames and once it finishes doing that it does a sync, then erases
them all, does another sync, and the loops doing the same.

This exercises the flash and causes the same errors to appear that the
software team observes while running their application.

After I fixed the mount options (adding noatime and discard) I re-ran
my test and started seeing trim related messages I don't quite know
what to do about:

EXT4-fs error (device sda1) in ext4_dirty_inode:5716: error -4096
EXT4-fs warning (device sda1): ext4_issue_discard:2619: discard not
supported, disabling

In searching this issue, it sounds like trim support isn't in 2.6.37???

Any ideas on what I should do?  I've looked at the commits of the ext4
branch and it isn't obvious to me which of the patches I may need to
fix my issue.

I may just fall back to ext3.

Thanks for any insight.

Regards,

Brian
