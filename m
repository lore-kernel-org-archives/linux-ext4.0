From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2freefrag utility
Date: Thu, 23 Jul 2009 11:07:59 -0600
Message-ID: <20090723170759.GB4231@webber.adilger.int>
References: <20090721001750.GD4231@webber.adilger.int>
 <20090722074352.GA21869@mit.edu> <4A67EE3F.4090909@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_GHuGnb0F3+9u9SM6cwTWNQ)"
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:50255 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZGWRIh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2009 13:08:37 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6NH8auV002224
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2009 10:08:37 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KN800C00VK93900@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 23 Jul 2009 10:08:36 -0700 (PDT)
In-reply-to: <4A67EE3F.4090909@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_GHuGnb0F3+9u9SM6cwTWNQ)
Content-type: text/plain; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline

On Jul 22, 2009  23:59 -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> > Here's the output on my root filesystem (which has been in use since
> > February):
> > 
> > Total chunks: 71681
> > Free chunks: 21792 (30.4%)
> > 
> > Min free chunk: 4 KB 
> > Max free chunk: 568232 KB
> > Avg free chunk: 184 KB
> > 
> > HISTOGRAM OF FREE CHUNK SIZES:
> > Chunk Size Range :	Free chunks
> >     4K...    8K- :       35005
> >     8K...   16K- :       33639
:
:
> >   128M...  256M- :           8
> >   512M... 1024M- :           1
> > 
> > Yeah.... pretty fragmented.   :-(
> > 
> 
> 
> Just for comparison, here's a 30G xfs root that has run for a year or
> two, currently about 70% full:
> 
> xfs_db> freesp -s
>    from      to extents  blocks    pct
>       1       1    1849    1849   0.08
>       2       3    1383    3293   0.14
:
:
>  262144  524287       1  509811  21.91
>  524288 1048575       1  554838  23.85
> total free extents 7153
> total free blocks 2326556
> average free extent size 325.256

I like the printing of the total blocks in each section and the
percent of blocks...  Attached is an incremental patch that adds
the same to e2freefrag.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


--Boundary_(ID_GHuGnb0F3+9u9SM6cwTWNQ)
Content-type: text/plain; NAME=e2freefrag-pct.diff; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2freefrag-pct.diff

--- ./misc/e2freefrag.c	2009-07-23 11:02:38.000000000 -0600
+++ ./misc/e2freefrag.c.new	2009-07-23 10:52:22.000000000 -0600
@@ -60,8 +60,10 @@ void init_chunk_info(ext2_filsys fs, str
 	info->max = info->avg = 0;
 	info->real_free_chunks = 0;
 
-	for (i = 0; i < MAX_HIST; i++)
-		info->histogram.fc_buckets[i] = 0;
+	for (i = 0; i < MAX_HIST; i++) {
+		info->histogram.fc_chunks[i] = 0;
+		info->histogram.fc_blocks[i] = 0;
+	}
 }
 
 void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
@@ -101,7 +103,9 @@ void scan_block_bitmap(ext2_filsys fs, s
 				unsigned long index;
 
 				index = ul_log2(last_chunk_size) + 1;
-				info->histogram.fc_buckets[index]++;
+				info->histogram.fc_chunks[index]++;
+				info->histogram.fc_blocks[index] +=
+							last_chunk_size;
 
 				if (last_chunk_size > info->max)
 					info->max = last_chunk_size;
@@ -137,7 +141,7 @@ errcode_t get_chunk_info(ext2_filsys fs,
 	printf("\nChunksize: %u bytes (%u blocks)\n",
 	       info->chunkbytes, info->blks_in_chunk);
 	total_chunks = (fs->super->s_blocks_count + info->blks_in_chunk) >>
-                                       (info->chunkbits - info->blocksize_bits);
+				(info->chunkbits - info->blocksize_bits);
 	printf("Total chunks: %lu\nFree chunks: %lu (%0.1f%%)\n",
 	       total_chunks, info->free_chunks,
 	       (double)info->free_chunks * 100 / total_chunks);
@@ -156,12 +160,17 @@ errcode_t get_chunk_info(ext2_filsys fs,
 	       "Avg free chunk: %lu KB\n", info->min, info->max, info->avg);
 
 	printf("\nHISTOGRAM OF FREE CHUNK SIZES:\n");
-	printf("%15s\t\t%10s\n", "Range", "Free chunks");
+	printf("%s :  %12s  %12s  %7s\n", "Chunk Size Range", "Free chunks",
+	       "Free Blocks", "Percent");
 	for (i = 0; i < MAX_HIST; i++) {
 		end = 1 << (i + info->blocksize_bits - units);
-		if (info->histogram.fc_buckets[i] != 0)
-			printf("%5lu%c...%5lu%c- :  %10lu\n", start, *unitp,
-			       end, *unitp, info->histogram.fc_buckets[i]);
+		if (info->histogram.fc_chunks[i] != 0)
+			printf("%5lu%c...%5lu%c- :  %12lu  %12lu  %6.1f%%\n",
+			       start, *unitp, end, *unitp,
+			       info->histogram.fc_chunks[i],
+			       info->histogram.fc_blocks[i],
+			       (double)info->histogram.fc_blocks[i] * 100 /
+			       fs->super->s_free_blocks_count);
 		start = end;
 		if (start == 1<<10) {
 			start = 1;
--- ./misc/e2freefrag.h	2009-07-23 11:02:38.000000000 -0600
+++ ./misc/e2freefrag.h.new	2009-07-23 10:52:26.000000000 -0600
@@ -4,7 +4,8 @@
 
 #define MAX_HIST	32
 struct free_chunk_histogram {
-	unsigned long fc_buckets[MAX_HIST];
+	unsigned long fc_chunks[MAX_HIST];
+	unsigned long fc_blocks[MAX_HIST];
 };
 
 struct chunk_info {
--- ./misc/e2freefrag.8.in	2009-07-23 11:02:38.000000000 -0600
+++ ./misc/e2freefrag.8.in.new	2009-07-23 11:05:13.000000000 -0600
@@ -44,53 +44,53 @@ is specified on the command line, then t
 .br
 Blocksize: 4096 bytes
 .br
-Total blocks: 5120710
+Total blocks: 1504085
 .br
-Free blocks: 831744 (16.2%)
+Free blocks: 292995 (19.5%)
 .br
 Chunk size: 1048576 bytes (256 blocks)
 .br
-Total chunks: 20003
+Total chunks: 5876
 .br
-Free chunks: 2174 (10.9%)
+Free chunks: 463 (7.9%)
 .br
 
 Min free chunk: 4 KB
 .br
-Max free chunk: 24576 KB
+Max free chunk: 24008 KB
 .br
-Avg. free chunk: 340 KB
+Avg free chunk: 252 KB
 .br
 
 HISTOGRAM OF FREE CHUNK SIZES:
 .br
-          Range         Free chunks
+Chunk Size Range :   Free chunks   Free Blocks  Percent
 .br
-    4K...    8K- :        2824
+    4K...    8K- :           704           704     0.2%
 .br
-    8K...   16K- :        1760
+    8K...   16K- :           810          1979     0.7%
 .br
-   16K...   32K- :        1857
+   16K...   32K- :           843          4467     1.5%
 .br
-   32K...   64K- :        1003
+   32K...   64K- :           579          6263     2.1%
 .br
-   64K...  128K- :         616
+   64K...  128K- :           493         11067     3.8%
 .br
-  128K...  256K- :         479
+  128K...  256K- :           394         18097     6.2%
 .br
-  256K...  512K- :         302
+  256K...  512K- :           281         25477     8.7%
 .br
-  512K... 1024K- :         238
+  512K... 1024K- :           253         44914    15.3%
 .br
-    1M...    2M- :         213
+    1M...    2M- :           143         51897    17.7%
 .br
-    2M...    4M- :         173
+    2M...    4M- :            73         50683    17.3%
 .br
-    4M...    8M- :         287
+    4M...    8M- :            37         52417    17.9%
 .br
-    8M...   16M- :           4
+    8M...   16M- :             7         19028     6.5%
 .br
-   16M...   32M- :           1
+   16M...   32M- :             1          6002     2.0%
 .SH AUTHOR
 This version of e2freefrag was written by Rupesh Thakare, and modified by
 Andreas Dilger <adilger@sun.com>, and Kalpak Shah.

--Boundary_(ID_GHuGnb0F3+9u9SM6cwTWNQ)--
