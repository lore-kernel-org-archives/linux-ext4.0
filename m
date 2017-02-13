From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194567] ext4 no longer mounts
Date: Mon, 13 Feb 2017 04:00:11 +0000
Message-ID: <bug-194567-13602-DQj6raDA5A@https.bugzilla.kernel.org/>
References: <bug-194567-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42404 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751413AbdBMEAO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 12 Feb 2017 23:00:14 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5AA4C281D2
        for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2017 04:00:13 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1215A28178
        for <linux-ext4@vger.kernel.org>; Mon, 13 Feb 2017 04:00:12 +0000 (UTC)
In-Reply-To: <bug-194567-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194567

Eric Sandeen (sandeen@sandeen.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@sandeen.net

--- Comment #1 from Eric Sandeen (sandeen@sandeen.net) ---
Can you add the dumpe2fs -h output for the device?

I guess this would be thanks to:

http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?h=linux-4.4.y&id=e21a3cad35bc2f4c7fff317e2c7d38eed363a430

ext4: validate s_first_meta_bg at mount time
commit 3a4b77cd47bb837b8557595ec7425f281f2ca1fe upstream.

Ralf Spenneberg reported that he hit a kernel crash when mounting a
modified ext4 image. And it turns out that kernel crashed when
calculating fs overhead (ext4_calculate_overhead()), this is because
the image has very large s_first_meta_bg (debug code shows it's
842150400), and ext4 overruns the memory in count_overhead() when
setting bitmap buffer, which is PAGE_SIZE.

ext4_calculate_overhead():
  buf = get_zeroed_page(GFP_NOFS);  <=== PAGE_SIZE buffer
  blks = count_overhead(sb, i, buf);

count_overhead():
  for (j = ext4_bg_num_gdb(sb, grp); j > 0; j--) { <=== j = 842150400
          ext4_set_bit(EXT4_B2C(sbi, s++), buf);   <=== buffer overrun
          count++;
  }

This can be reproduced easily for me by this script:

  #!/bin/bash
  rm -f fs.img
  mkdir -p /mnt/ext4
  fallocate -l 16M fs.img
  mke2fs -t ext4 -O bigalloc,meta_bg,^resize_inode -F fs.img
  debugfs -w -R "ssv first_meta_bg 842150400" fs.img
  mount -o loop fs.img /mnt/ext4

Fix it by validating s_first_meta_bg first at mount time, and
refusing to mount if its value exceeds the largest possible meta_bg
number.

Reported-by: Ralf Spenneberg <ralf@os-t.de>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
