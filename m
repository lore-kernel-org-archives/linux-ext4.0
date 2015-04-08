From: Davide Italiano <dccitaliano@gmail.com>
Subject: [PATCH] ext4: move check under lock to avoid race
Date: Tue,  7 Apr 2015 21:46:49 -0700
Message-ID: <1428468410-12793-1-git-send-email-dccitaliano@gmail.com>
Cc: Davide Italiano <dccitaliano@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36570 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbbDHEq7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2015 00:46:59 -0400
Received: by pablj1 with SMTP id lj1so25342977pab.3
        for <linux-ext4@vger.kernel.org>; Tue, 07 Apr 2015 21:46:59 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I originally thought that ext4_zero_range() and ext4_collapse() range
duplicated the check in fallocate(), performing it under the lock.
Dmitry explained to me how I was wrong, because there's nothing to
prevent ioctl() to convert indirect <==> extent, so the check needs to
be done with the inode lock held.
Further inspection showed that ext4_fallocate() doesn't re-check inside
the lock scope so I'm not entirely sure it's safe. 
I propose this patch that moves the check inside the lock scope to
guarantee safeness. My original point remains, i.e. there's no need to
duplicate it, in particular if there's nothing that prevents things to
change.
I hope this (take two) is slightly more correct.

Davide Italiano (1):
  ext4: Move check under lock scope to close a race.

 fs/ext4/extents.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

-- 
2.3.4

