From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2freefrag utility
Date: Wed, 22 Jul 2009 03:43:52 -0400
Message-ID: <20090722074352.GA21869@mit.edu>
References: <20090721001750.GD4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57149 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbZGVHpB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jul 2009 03:45:01 -0400
Content-Disposition: inline
In-Reply-To: <20090721001750.GD4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 20, 2009 at 06:17:50PM -0600, Andreas Dilger wrote:
> Attached is the e2freefrag tool.  It grabs the block bitmaps, creates
> buddy bitmaps from them and displays the total/free chunks (default
> 1MB chunk size), and a histogram of free space.
> 
> It could probably be enhanced to print the chunk sizes based on the
> RAID chunk size stored in the superblock, but I just thought of that
> this minute...

Thanks, checked in with some minor changes to fix some printf
warnings.

Here's the output on my root filesystem (which has been in use since
February):

Device: /dev/ssd/root
Blocksize: 4096 bytes
Total blocks: 18350080
Free blocks: 10774142 (58.7%)

Chunksize: 1048576 bytes (256 blocks)
Total chunks: 71681
Free chunks: 21792 (30.4%)

Min free chunk: 4 KB 
Max free chunk: 568232 KB
Avg free chunk: 184 KB

HISTOGRAM OF FREE CHUNK SIZES:
Chunk Size Range :	Free chunks
    4K...    8K- :       35005
    8K...   16K- :       33639
   16K...   32K- :       31419
   32K...   64K- :       33953
   64K...  128K- :       26397
  128K...  256K- :        7314
  256K...  512K- :        1855
  512K... 1024K- :        1612
    1M...    2M- :        1160
    2M...    4M- :         567
    4M...    8M- :         303
    8M...   16M- :         106
   16M...   32M- :          40
   32M...   64M- :          51
   64M...  128M- :         123
  128M...  256M- :           8
  512M... 1024M- :           1

Yeah.... pretty fragmented.   :-(

						- Ted
