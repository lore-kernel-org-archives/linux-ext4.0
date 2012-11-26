From: Ryan Wang <openspace.wang@gmail.com>
Subject: How to run xfstests against multipath disks on SuSE?
Date: Mon, 26 Nov 2012 08:00:05 +0800
Message-ID: <CAPxxNQmwX+TmJ=B-H0f+bzpx5JdijyyRrxCAAZRi9+c8HjQL9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42233 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab2KZAAI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Nov 2012 19:00:08 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so4200126eaa.19
        for <linux-ext4@vger.kernel.org>; Sun, 25 Nov 2012 16:00:05 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I tried to kick off xfstests on multipath device, e.g I set
TEST_DEV="/dev/mapper/mpatha", which is a symlink
to "/dev/dm-0". I run mkfs on mpatha beforehand.

When I run "./check 001", it said:
"
common.rc: Error: $TEST_DEV (/dev/dm-0) is not a MOUNTED ext4 filesystem
"

The I checked the script common.rc, and found that it uses
df to determine the filesystem type and it uses the realpath
"/dev/dm-0" instead of "/dev/mapper/mpatha", while df always
shows "devtmpfs" instead of "ext4" for /dev/dm-0.

I run "mount" and found that devtmpfs is mount on /dev/ on opensuse
***by default***. Even though  I run "mount -t btrfs /dev/dm-0 /somedir",
df still showed devtmpfs.

Any ideas to kick off the xfstests?

thanks,
