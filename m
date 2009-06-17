From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: grub / ext4 compatibility problem?
Date: Wed, 17 Jun 2009 16:48:59 +0200
Message-ID: <200906171648.59573.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:63367 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZFQOnc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jun 2009 10:43:32 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so565448ewy.37
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2009 07:43:34 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

I've run into a really peculiar problem today..

After the last /boot/grub/grub.conf update (just to test today's linux-next)
grub reads the file's content as a garbage and drops into the interactive
mode (cat /boot/grub/grub.conf from within the inteactive mode shows garbage,
other files are read fine).

This makes booting quite challenging (interactive mode is easy to manage,
remembering kernel name derived from the git tree is the difficult part ;)
but once the system is running I can read the content of the file just fine.

On the first manual boot ext4 reported some filesystem problems & fixed them:

EXT4-fs (hda1): barriers enabled
kjournald2 starting: pid 449, dev hda1:20, commit interval 5 seconds
EXT4-fs (hda1): delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs (hda1): orphan cleanup on readonly fs
EXT4-fs (hda1): ext4_orphan_cleanup: deleting unreferenced inode 261260
EXT4-fs (hda1): 1 orphan inode deleted
EXT4-fs (hda1): recovery complete
EXT4-fs (hda1): mounted filesystem with ordered data mode

but the /etc/grub/grub.conf problem is still there (I thought that it may
be a good idea to report it first before trying to run fsck manually).

This is on Fedora 11 system (I upgraded from Fedora 10 few days ago) with
all updates and ext3 migrated (per HOWTO on ext4 wiki) to ext4 yesterday.

Is this something worth people's attention or should I just try to run fsck
manually?

Thanks,
Bart
