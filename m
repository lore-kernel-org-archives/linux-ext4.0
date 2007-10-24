From: "Bram Neijt" <bneijt@gmail.com>
Subject: User permissions or UID/GIDs for portable disks?
Date: Wed, 24 Oct 2007 20:10:16 +0200
Message-ID: <46c2f4ab0710241110o582dcc27pbd6d2c31474b526b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:29213 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094AbXJXSKR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 14:10:17 -0400
Received: by wa-out-1112.google.com with SMTP id v27so325126wah
        for <linux-ext4@vger.kernel.org>; Wed, 24 Oct 2007 11:10:16 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dear ext4 developers,

Currently using ext3 on an usbstick seems to have a few drawbacks.
Consider the following situations:
1. Lend my usbstick to a college at work, but I don't want them to be
able to place files on it which I can't delete at work (where I don't
have root access).
2. Lend my usbstick to a friend and ask him/her to put another large
file on it before returning it.

One of the best solutions I can come up with is if the filesystem
would allow for a switch that would help ignore these permissions as
part of the filesystem. Any other solution would either require
specialized userspace solutions (which would probably make any
unpluggable usb device unsecure) or special options while mounting.
The latter would require root privileges and the UUID (for exmple)
would have to be known in advance.

Although using vfat is a solution, I would love to hear wether this is
considered a possible problem and wether it could be implementable at
a filesystem level?

I would be happy to discuss any and all possible solutions to these problems.

Greetings,
  Bram

PS The only reason I don't want to use vfat is because I _think_ it's
old and don't think it's _cooool_.
