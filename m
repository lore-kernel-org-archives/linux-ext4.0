From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: punch command works incorrect in debugfs
Date: Tue, 29 Jan 2013 01:36:47 +0800
Message-ID: <20130128173647.GA23868@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:62181 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab3A1RWp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2013 12:22:45 -0500
Received: by mail-pb0-f50.google.com with SMTP id ro8so721326pbb.9
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jan 2013 09:22:44 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I found a bug in debugfs that 'punch' command work incorrect for a
indirect-based file.  The bug can be triggered by the following
commands, and it seems that the problem is in libext2fs library.  I
file this bug in mailing list because I have no time to look at it
carefully and I doubt that this command is not used frequently.

[reproduce steps]
  sudo mkfs.ext4 -O ^extent ${DEV}
  sudo mount -t ext4 ${DEV} ${MNT}
  sudo dd if=/dev/zero of=${MNT}/punch-file bs=4k count=16
  sync
  sudo umount ${MNT}
  sudo debugfs ${DEV} -R 'stat punch-file'
  sudo debugfs -w ${DEV} -R 'punch punch-file 4 6'
  sudo debugfs ${DEV} -R 'stat punch-file'

[expected result]
...
BLOCKS:
(0-3):34304-34307, (6-11):34310-34315, (IND):33793, (12-15):34316-34319
...

[wrong result]
...
BLOCKS:
(0-11):34304-34315, (IND):33793, (12-15):34316-34319
...

Regards,
                                                - Zheng
