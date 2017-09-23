From: Jaco Kroon <jaco@uls.co.za>
Subject: fragmentation optimization
Date: Sat, 23 Sep 2017 09:49:25 +0200
Message-ID: <6f6eb640-cd31-7080-a575-b7c6c4dd9e3f@uls.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from othala.uls.co.za ([154.73.34.12]:42954 "EHLO othala.uls.co.za"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750814AbdIWHtv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 23 Sep 2017 03:49:51 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, Everyone,

During our last discussions you mentioned the following (2017/08/16 5:06 
SAST/GMT+2):

"One other thought.  There is an ext4 block allocator optimization
"feature" which is biting us here.  At the moment we have an
optimization where if there is small "hole" in the logical block
number space, we leave a "hole" in the physical blocks allocated to
the file."

You proceeded to provide the example regarding writing of object files 
as per binutils (ld specifically).

As per the data I provided you previously rsync (with --sparse) is 
generating a lot of "holes" for us due to this.  As a result I end up 
with a rather insane amount of fragmentation:

Blocksize: 4096 bytes
Total blocks: 13153337344
Free blocks: 1272662587 (9.7%)

Min. free extent: 4 KB
Max. free extent: 17304 KB
Avg. free extent: 44 KB
Num. free extent: 68868260

HISTOGRAM OF FREE EXTENT SIZES:
Extent Size Range :  Free extents   Free Blocks  Percent
     4K...    8K-  :      28472490      28472490    2.24%
     8K...   16K-  :      27005860      55030426    4.32%
    16K...   32K-  :       2595993      14333888    1.13%
    32K...   64K-  :       2888720      32441623    2.55%
    64K...  128K-  :       2745121      62071861    4.88%
   128K...  256K-  :       2303439     103166554    8.11%
   256K...  512K-  :       1518463     134776388   10.59%
   512K... 1024K-  :        902691     163108612   12.82%
     1M...    2M-  :        314858     105445496    8.29%
     2M...    4M-  :         97174      64620009    5.08%
     4M...    8M-  :         22501      28760501    2.26%
     8M...   16M-  :           945       2069807    0.16%
    16M...   32M-  :             5         21155    0.00%

Based on the behavior I notice by watching how rsync works[1] I greatly 
suspect that writes are sequential from start of file to end of file.  
Regarding the above "feature" you further proceeded to mention:

"However, it obviously doesn't do the right thing for rsync --sparse,
and these days, thanks to delayed allocation, so long as binutils can
finish writing the blocks within 30 seconds, it doesn't matter if GNU
ld writes the blocks in a completely random order, since we will only
attempt to do the writeback to the disk after all of the holes in the
.o file have been filled in.  So perhaps we should turn off this ext4
block allocator optimization if delayed allocation is enabled (which
is the default these days)."

You mentioned a few pros and cons of this approach as well, and also 
mentioned that it won't help my existing filesystem, however, I suspect 
it might in combination with a e4defrag sweep (which if it takes a few 
weeks in the background that's fine by me).  Also, I suspect disabling 
this might help avoid future holes, and since persistence of files 
varies (from a week to a year) I suspect it may help to over time slowly 
improve performance.

I'm also relatively comfortable to make the 30s write limit even longer 
(as you pointed out the files causing the problems are typically 300GB+ 
even though on average my files are very small), permitting that I won't 
introduce additional file-system corruption risk.  Also keeping in mind 
that I run anything from 10 to 20 concurrent rsync instances at any 
point in time.

I would like to attempt such a patch, so if you (or someone else) could 
possibly point me in an appropriate direction of where to start work on 
this I would really appreciate the help.

Another approach for me may be to simply switch off --sparse since 
especially now I'm unsure of it's benefit.  I'm guessing that I could do 
a sweep of all inodes to determine how much space is really being saved 
by this.

Kind Regards,
Jaco

[1] My observed behaviour when syncing a file (without --inplace which 
is in my opinion a bad idea in general unless you're severely space 
constrained, and then I honestly don't know how this situation would be 
affected) is that rsync will create a new file, and then the file size 
of this file will grow slowly (not, not disk usage, but size as reported 
by ls) until it reaches the file size of the new file, and at this point 
rsync will use rename(2) to replace the old file with the new one (which 
is the right approach).
