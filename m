From: Justin Maggard <jmaggard10@gmail.com>
Subject: >16TB issues
Date: Thu, 2 Jul 2009 15:23:42 -0700
Message-ID: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:31931 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbZGBWXj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Jul 2009 18:23:39 -0400
Received: by wa-out-1112.google.com with SMTP id j5so401398wah.21
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2009 15:23:42 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been toying with ext4 and e2fsprogs pu branch (pulled from git
yesterday) on very large volumes, and I've run into some issues.  What
I've found so far with an 19TB MD RAID0 volume, running 2.6.29.4 (I'm
planning on trying 2.6.30 soon):

-  mkfs.ext4 *appears* to work fine, reporting no errors.  Examining
the superblock info with dumpe2fs -h looks normal -- although I'm
unfamiliar with "Lifetime writes" field, and I'm not sure why it's at
73GB immediately after doing mkfs, before ever mount it.

-  Immediately running e2fsck on the volume before ever mounting it
will not complete, and results in the following:
# e2fsck -n /dev/md2
e2fsck 1.41.7 (29-June-2009)
Error reading block 2435874816 (Attempt to read block from filesystem
resulted in short read).  Ignore error? no
/dev/md2: Attempt to read block from filesystem resulted in short read
while reading block 2435874816
/dev/md2: Attempt to read block from filesystem resulted in short read
reading journal superblock
e2fsck: Attempt to read block from filesystem resulted in short read
while checking ext3 journal for /dev/md2

-  Trying to mount normally with no options does not work.  The kernel
log contains these messages:
EXT4-fs: barriers enabled
JBD: no valid journal superblock found
EXT4-fs: error loading journal.

-  Mounting with -o noload does appear to work, and reading and
writing seems to work fine.

-  Setting default mount options with tune2fs works fine, as expected.

-  Then, I went on to check out filesystem resizing.  I created an LVM
15TB LV, and ran mkfs.ext4 on it.  Looking at the superblock info, it
did not contain the 64bit flag, which I assume is expected behavior.
I extended the LV to ~18TB and tried resize2fs, and got this error:
resize2fs: Can't read an block bitmap while trying to resize /dev/data/data0

If there's anything else anyone would have me try, or any patches to
test, just let me know.

Thanks!
-Justin
