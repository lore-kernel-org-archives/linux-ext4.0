From: mfe555 <mfe555@web.de>
Subject: Significant difference in 'file size' and 'disk usage' for single
 files
Date: Thu, 2 Nov 2017 20:17:25 +0100
Message-ID: <472fde11-654a-4826-0256-46149e90216e@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: mfe555@web.de
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:60430 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932571AbdKBTRU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 2 Nov 2017 15:17:20 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, I'm using ext4 on a Linux based Enigma2 set-top box, kernel 4.8.3.

When creating a fresh file, there is a significant difference in file 
size (ls -la) and disk usage (du). When making two copies of the file ..

gbquad:/hdd/test# cp file file.copy1
gbquad:/hdd/test# cp file file.copy2
gbquad:/hdd/test# ls -la
-rw-------    1 root     root     581821460 Nov  1 18:52 file
-rw-------    1 root     root     581821460 Nov  1 18:56 file.copy1
-rw-------    1 root     root     581821460 Nov  1 18:57 file.copy2
gbquad:/hdd/test# du *
607232  file
658176  file.copy1
644864  file.copy2

... all three files show an overhead in the ~10% range, and the overhead 
is different for these files although their md5sums are equal.

When deleting a file (rm), the overhead remains occupied on the disk. 
For example, after deleting "file", "df" reports approx. 581821460 more 
bytes free, not 607232 kbytes more free space. The overhead (607232 kB - 
581821460 B = approx. 39 MB) remains blocked.

When re-booting, the blocked space becomes free again, and in addition 
the overhead of those files that were not deleted also disappears, so 
that after a reboot the'file size' and 'disk usage' match for all files 
(except for rounding up to some block size).

A colleague and I have observed this on two different "kernel 4.8.3" 
boxes and three ext4 disks, but not on a "kernel 3.14" box also using ext4.

Can anyone help me with this ?

Thanks a lot
Lukas
