From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Performance of ext4
Date: Wed, 11 Jun 2008 08:02:32 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-kernel <linux-kernel@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756384AbYFKIC4@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello

Doing some performance test between ext3 and ext4 I noticed that ext4
is not much faster or in some cases slower then ext3. Two years ago when
I tested ext4 it was a lot faster then ext3 (see my mail:
http://lkml.org/lkml/2006/6/6/65). Doing some simple tests with bonnie++
I got the following results:

Version  1.03        ------Sequential Output------ --Sequential Input- --Random-
                      -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine         Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
ext3(2 years ago)16G 38621  98 194816 94 87776  49 37921  92 239128 54  1402   5
                  16G 47000  99 194276 94 89232  49 38628  92 240539 55  1399   5
                  16G 45873  98 178195 90 89726  50 38482  92 240490 55  1381   4

ext3 (now)       16G 51501  97 210601 91 100479 32 55528  98 301589 44  1198   5
                  16G 52702  98 215540 94 99339  32 55376  97 300933 44  1159   4
                  16G 52426  99 212584 94 99091  31 55656  98 301669 44  1160   4

ext4(2 years ago)16G 59223  91 264155 45 111459 36 57313  99 317944 63  1478   7
                  16G 58814  92 276803 47 110418 36 57105  99 317534 65  1525   5
                  16G 58299  92 274523 48 110290 36 56723  99 318839 65  1502   4

ext4 (now)       16G 52965  98 224199 89 108440 32 56389  99 303792 42  1526   4
                  16G 52792  98 223980 92 107685 32 56350  98 303066 42  1532   4
                  16G 52994  98 222354 92 107802 32 56386  99 303727 41  1455   4

For this system the write performance is the most important factor and one
can see today ext4 is marginally faster then ext3. But 2 years ago ext4 was
a lot faster (~270MB against ~223MB).

Using my own benchmark afdbench where many process copy thousands of small
files around the results are as follows:

   For ext3: 5449.76 files per second 15.58 MiB/s
   For ext4: 5162.16 files per second 15.48 MiB/s

So in this test ext4 is a bit slower then ext3. Since afdbench has seen
considerable changes, one cannot compare these results with those 2 years
ago. But 2 years ago ext4 was 12% faster then ext3.

Test where done with kernel 2.6.25.4 and file system where created as follows:

    ext3: mke2fs -b 4096 -m 0 -O dir_index,large_file,filetype,has_journal,sparse_super -j /dev/md7
    ext4: mke2fs -b 4096 -E test_fs -m 0 -O dir_index,large_file,filetype,has_journal,sparse_super -j /dev/md7

And both where mounted with the following options:

    noatime,nodiratime,commit=15

2 years ago I used 2.6.16.8 but the hardware is still the same. So what has
happened with the performance of ext4? I noticed that 2 years ago I could
use extents+mballoc+delalloc, now there is only extents+mballoc in the
current kernels. Could delalloc make the big difference? I saw that
in Andrew Morton mm tree delalloc is included. Unfortunately when I tried using
2.6.26-rc2-mm1 a sync would never return and there where lot of other
odd things, so I could not do any tests with delalloc.

So any idea what I am doing wrong or what I could do to improve those numbers?
Please CC me since I am not subscribed to the list.

Thanks,
Holger
