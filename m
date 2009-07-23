From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2freefrag utility
Date: Wed, 22 Jul 2009 23:59:43 -0500
Message-ID: <4A67EE3F.4090909@redhat.com>
References: <20090721001750.GD4231@webber.adilger.int> <20090722074352.GA21869@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43978 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZGWE7s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jul 2009 00:59:48 -0400
In-Reply-To: <20090722074352.GA21869@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
...

> Here's the output on my root filesystem (which has been in use since
> February):
> 
> Device: /dev/ssd/root
> Blocksize: 4096 bytes
> Total blocks: 18350080
> Free blocks: 10774142 (58.7%)
> 
> Chunksize: 1048576 bytes (256 blocks)
> Total chunks: 71681
> Free chunks: 21792 (30.4%)
> 
> Min free chunk: 4 KB 
> Max free chunk: 568232 KB
> Avg free chunk: 184 KB
> 
> HISTOGRAM OF FREE CHUNK SIZES:
> Chunk Size Range :	Free chunks
>     4K...    8K- :       35005
>     8K...   16K- :       33639
>    16K...   32K- :       31419
>    32K...   64K- :       33953
>    64K...  128K- :       26397
>   128K...  256K- :        7314
>   256K...  512K- :        1855
>   512K... 1024K- :        1612
>     1M...    2M- :        1160
>     2M...    4M- :         567
>     4M...    8M- :         303
>     8M...   16M- :         106
>    16M...   32M- :          40
>    32M...   64M- :          51
>    64M...  128M- :         123
>   128M...  256M- :           8
>   512M... 1024M- :           1
> 
> Yeah.... pretty fragmented.   :-(
> 


Just for comparison, here's a 30G xfs root that has run for a year or
two, currently about 70% full:

xfs_db> freesp -s
   from      to extents  blocks    pct
      1       1    1849    1849   0.08
      2       3    1383    3293   0.14
      4       7    1034    5429   0.23
      8      15    1061   12260   0.53
     16      31     641   13261   0.57
     32      63     355   15601   0.67
     64     127     221   19940   0.86
    128     255     195   35841   1.54
    256     511     173   63066   2.71
    512    1023     122   89824   3.86
   1024    2047      51   70032   3.01
   2048    4095      22   60982   2.62
   4096    8191      20  116580   5.01
   8192   16383      10  109896   4.72
  16384   32767       7  152026   6.53
  32768   65535       4  206283   8.87
  65536  131071       3  285744  12.28
 262144  524287       1  509811  21.91
 524288 1048575       1  554838  23.85
total free extents 7153
total free blocks 2326556
average free extent size 325.256

from...to units are in 4k blocks.

Maybe the fancy ext4 defragger will have a good second use case in
cleaning up some of that freespace fragmentation.

-Eric
