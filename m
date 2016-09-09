From: Jerry Lee <jerrylee@qnap.com>
Subject: resizing file system fails when file system block size is smaller
 than page size
Date: Fri, 9 Sep 2016 19:36:06 +0800
Message-ID: <CAA1ppbijDUUH2AN40qkoC-w88sz6BBSz89rtvXPiT089pHYgqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34406 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754485AbcIILgI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Sep 2016 07:36:08 -0400
Received: by mail-oi0-f44.google.com with SMTP id m11so135278026oif.1
        for <linux-ext4@vger.kernel.org>; Fri, 09 Sep 2016 04:36:07 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have a file system with 4K block size on a 32K page size platform, and
something strange happened when expanding the file system from size 17TB to
20TB.  It seems that the new file system size is not calculated correctly.

$ resize2fs /dev/mapper/dev
resize2fs 1.43.3 (04-Sep-2016)
Filesystem at /dev/mapper/dev is mounted on /share/DATA; on-line
resizing required
resize2fs: On-line shrinking not supported

After digging into the issue, I find that the following operation makes the
high 32bit of the new_size variable be wiped out and results in a smaller
size compared to the currently used block counts.  Here's the patch:

diff --git a/resize/main.c b/resize/main.c
index 5a99483..396391b 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -505,7 +505,7 @@ int main (int argc, char ** argv)
                new_size = max_size;
                /* Round down to an even multiple of a pagesize */
                if (sys_page_size > blocksize)
-                       new_size &= ~((sys_page_size / blocksize)-1);
+                       new_size &= ~((blk64_t)((sys_page_size / blocksize)-1));
        }
        /* If changing 64bit, don't change the filesystem size. */
        if (flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)) {


Thanks!


- Jerry
