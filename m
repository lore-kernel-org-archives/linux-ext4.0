From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] fix strange values displayed by e2freefrag
Date: Thu, 29 Jul 2010 18:03:02 -0600
Message-ID: <32C2860D-6E4D-41CB-8C80-29BAF1C153D4@dilger.ca>
References: <i2fkse$lkr$1@dough.gmane.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: multipart/mixed; boundary=Apple-Mail-27--654211400
Cc: linux-ext4@vger.kernel.org
To: horhe <skrzynka_na_spami@kolekcja.mejor.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:41499 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab0G3AEn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Jul 2010 20:04:43 -0400
In-Reply-To: <i2fkse$lkr$1@dough.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-27--654211400
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On 2010-07-24, at 15:10, horhe wrote:
> Today i run e2freefrag on ext4 partition and i saw:
> Device: /dev/mapper/vg--bez--raidu-lvarchiwumnowe
> Blocksize:           4096 bytes
> Total blocks:    52166656
> Free blocks:        57254 (0.1%)
Here is the problem  ^^^^^^^^^^^^^^^

> Min. free extent: 4 KB
> Max. free extent: 128120 KB
> Avg. free extent: 3396 KB
>=20
> HISTOGRAM OF FREE EXTENT SIZES:
> Extent Size Range :  Free extents   Free Blocks  Percent
>   4K...    8K-  :          1500          1500    2.62%
>   8K...   16K-  :          1566          3933    6.87%
>  16K...   32K-  :          1112          5707    9.97%
>  32K...   64K-  :           228          2480    4.33%
>  64K...  128K-  :           222          5061    8.84%
> 128K...  256K-  :           269         12364   21.59%
> 256K...  512K-  :           307         28279   49.39%
> 512K... 1024K-  :           487         84412  147.43%
>   1M...    2M-  :           621        240621  420.27%
>   2M...    4M-  :           780        574302  1003.08%
>   4M...    8M-  :           803       1162903  2031.13%
>   8M...   16M-  :           488       1317526  2301.19%
>  16M...   32M-  :           312       1728598  3019.17%
>  32M...   64M-  :           119       1269059  2216.54%
>  64M...  128M-  :            49       1088111  1900.50%
>=20
> And I'm suprised when I can see so high percents, I don't know how to
> interpret this values.
>=20
> I was completly full partition, then i freed 15% space (about 30G), =
then I saw strange values.  I can't reproduce this problem, i filled up =
partition, removed files and problem doesn't appear.

That's because the kernel does not update the "free blocks" summary =
value in the superblock on disk.  It only updates the per-group free =
blocks counters in the group descriptor table.  That means the "free =
blocks" value read from the filesystem is totally incorrect (too low in =
your case) and caused the percentage to be incorrect.

For a while, when calling statfs() to get the free blocks information, =
it would also write out the superblock summary values.  However, this =
confused the journal checksum code because the modification wasn't being =
checksummed correctly.

It is possible to change the e2freefrag code to count the number of free =
blocks it finds, instead of depending on the value in the superblock =
(which may be slightly out of date no matter how often it is updated).  =
A patch to fix this, and to make e2freefrag work properly on filesystems =
with more than 2^32 free blocks, is attached.

I'd still like some way for userspace to update the superblock, or have =
the kernel do it periodically, so that "dumpe2fs -h" and other tools =
that look at the superblock are at least close instead of having values =
from the time of last mount.

Cheers, Andreas





--Apple-Mail-27--654211400
Content-Disposition: attachment;
	filename=e2freefrag-blocks.diff
Content-Type: application/octet-stream;
	name="e2freefrag-blocks.diff"
Content-Transfer-Encoding: 7bit

diff --git a/misc/Makefile.in b/misc/Makefile.in
index 8fd7704..5f989b4 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -301,9 +301,10 @@ logsave.profiled: profiled/logsave.o
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o logsave.profiled profiled/logsave.o
 
-e2freefrag: $(E2FREEFRAG_OBJS)
+e2freefrag: $(E2FREEFRAG_OBJS) $(DEP_LIBSE2P)
 	$(E) "	LD $@"
-	$(Q) $(CC) $(ALL_LDFLAGS) -o e2freefrag $(E2FREEFRAG_OBJS) $(LIBS)
+	$(Q) $(CC) $(ALL_LDFLAGS) -o e2freefrag $(E2FREEFRAG_OBJS) $(LIBS) \
+		$(LIBS_E2P)
 
 filefrag: $(FILEFRAG_OBJS)
 	$(E) "	LD $@"
diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index b827a49..b8ca537 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -62,7 +62,7 @@ void init_chunk_info(ext2_filsys fs, struct chunk_info *info)
 	}
 
 	info->min = ~0UL;
-	info->max = info->avg = 0;
+	info->max = info->sum = 0;
 	info->real_free_chunks = 0;
 
 	for (i = 0; i < MAX_HIST; i++) {
@@ -73,11 +73,11 @@ void init_chunk_info(ext2_filsys fs, struct chunk_info *info)
 
 void update_chunk_stats(struct chunk_info *info, unsigned long chunk_size)
 {
-	unsigned long index;
+	unsigned index;
 
 	index = ul_log2(chunk_size) + 1;
 	if (index >= MAX_HIST)
-		index = MAX_HIST-1;
+		index = MAX_HIST - 1;
 	info->histogram.fc_chunks[index]++;
 	info->histogram.fc_blocks[index] += chunk_size;
 
@@ -85,7 +85,7 @@ void update_chunk_stats(struct chunk_info *info, unsigned long chunk_size)
 		info->max = chunk_size;
 	if (chunk_size < info->min)
 		info->min = chunk_size;
-	info->avg += chunk_size;
+	info->sum += chunk_size;
 	info->real_free_chunks++;
 }
 
@@ -101,7 +101,7 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 
 	for (chunk_num = 0; chunk_num < chunks; chunk_num++) {
 		unsigned long long blk, num_blks;
-		int chunk_free;
+		unsigned long chunk_free_blocks;
 
 		/* Last chunk may be smaller */
 		if (chunk_start_blk + info->blks_in_chunk > blocks_count)
@@ -109,7 +109,7 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 		else
 			num_blks = info->blks_in_chunk;
 
-		chunk_free = 0;
+		chunk_free_blocks = 0;
 
 		/* Initialize starting block for first chunk correctly else
 		 * there is a segfault when blocksize = 1024 in which case
@@ -123,7 +123,8 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 							     chunk_start_blk);
 			if (!used) {
 				last_chunk_size++;
-				chunk_free++;
+				chunk_free_blocks++;
+				info->free_blocks++;
 			}
 
 			if (used && last_chunk_size != 0) {
@@ -132,7 +133,7 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 			}
 		}
 
-		if (chunk_free == info->blks_in_chunk)
+		if (chunk_free_blocks == info->blks_in_chunk)
 			info->free_chunks++;
 	}
 	if (last_chunk_size != 0)
@@ -141,26 +142,26 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 
 errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
 {
-	unsigned long total_chunks;
+	unsigned long long total_chunks;
 	char *unitp = "KMGTPEZY";
 	int units = 10;
-	unsigned long start = 0, end, cum;
+	unsigned long start = 0, end, cum, mean;
 	int i, retval = 0;
 
 	scan_block_bitmap(fs, info);
 
-	printf("Total blocks: %llu\nFree blocks: %u (%0.1f%%)\n",
-	       ext2fs_blocks_count(fs->super), fs->super->s_free_blocks_count,
-	       (double)fs->super->s_free_blocks_count * 100 /
+	printf("Total blocks: %llu\nFree blocks: %llu (%0.1f%%)\n",
+	       (long long)ext2fs_blocks_count(fs->super), info->free_blocks,
+	       (double)info->free_blocks * 100 /
 	       ext2fs_blocks_count(fs->super));
 
 	if (info->chunkbytes) {
-		printf("\nChunksize: %lu bytes (%u blocks)\n",
+		printf("\nChunksize: %lu bytes (%lu blocks)\n",
 		       info->chunkbytes, info->blks_in_chunk);
 		total_chunks = (ext2fs_blocks_count(fs->super) +
 				info->blks_in_chunk) >>
 			(info->chunkbits - info->blocksize_bits);
-		printf("Total chunks: %lu\nFree chunks: %lu (%0.1f%%)\n",
+		printf("Total chunks: %llu\nFree chunks: %llu (%0.1f%%)\n",
 		       total_chunks, info->free_chunks,
 		       (double)info->free_chunks * 100 / total_chunks);
 	}
@@ -169,15 +170,16 @@ errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
 	if (info->real_free_chunks) {
 		info->min = (info->min * fs->blocksize) >> 10;
 		info->max = (info->max * fs->blocksize) >> 10;
-		info->avg = (info->avg / info->real_free_chunks *
+		mean      = (info->sum / info->real_free_chunks *
 			     fs->blocksize) >> 10;
 	} else {
 		info->min = 0;
+		mean      = 0;
 	}
 
 	printf("\nMin. free extent: %lu KB \nMax. free extent: %lu KB\n"
-	       "Avg. free extent: %lu KB\n", info->min, info->max, info->avg);
-	printf("Num. free extent: %lu\n", info->real_free_chunks);
+	       "Avg. free extent: %lu KB\n", info->min, info->max, mean);
+	printf("Num. free extent: %llu\n", info->real_free_chunks);
 
 	printf("\nHISTOGRAM OF FREE EXTENT SIZES:\n");
 	printf("%s :  %12s  %12s  %7s\n", "Extent Size Range", "Free extents",
@@ -190,15 +192,15 @@ errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
 			sprintf(end_str, "%5lu%c-", end, *unitp);
 			if (i == MAX_HIST-1)
 				strcpy(end_str, "max ");
-			printf("%5lu%c...%7s  :  %12lu  %12lu  %6.2f%%\n",
+			printf("%5lu%c...%7s  :  %12llu  %12llu  %6.2f%%\n",
 			       start, *unitp, end_str,
 			       info->histogram.fc_chunks[i],
 			       info->histogram.fc_blocks[i],
 			       (double)info->histogram.fc_blocks[i] * 100 /
-			       fs->super->s_free_blocks_count);
+			       info->free_blocks);
 		}
 		start = end;
-		if (start == 1<<10) {
+		if (start == 1 << 10) {
 			start = 1;
 			units += 10;
 			unitp++;
@@ -218,7 +220,7 @@ void close_device(char *device_name, ext2_filsys fs)
 
 void collect_info(ext2_filsys fs, struct chunk_info *chunk_info)
 {
-	unsigned int retval = 0, i, free_blks;
+	unsigned int retval = 0, i;
 
 	printf("Device: %s\n", fs->device_name);
 	printf("Blocksize: %u bytes\n", fs->blocksize);
@@ -266,25 +268,21 @@ int main(int argc, char *argv[])
 	progname = argv[0];
 
 	while ((c = getopt(argc, argv, "c:h")) != EOF) {
+		unsigned long long chunkbytes;
+
 		switch (c) {
 		case 'c':
-			chunk_info.chunkbytes = strtoull(optarg, &end, 0);
-			if (*end != '\0') {
-				fprintf(stderr, "%s: bad chunk size '%s'\n",
-					progname, optarg);
-				usage(progname);
-			}
-			if (chunk_info.chunkbytes &
-			    (chunk_info.chunkbytes - 1)) {
+			/* Default input units is in kB, 2^10 bytes */
+			chunkbytes = parse_num_blocks2(optarg, 10);
+			if (chunkbytes & (chunkbytes - 1)) {
 				fprintf(stderr, "%s: chunk size must be a "
 					"power of 2.\n", argv[0]);
 				usage(progname);
 			}
-			chunk_info.chunkbytes *= 1024;
+			chunk_info.chunkbytes = chunkbytes;
 			break;
 		default:
-			fprintf(stderr, "%s: bad option '%c'\n",
-				progname, c);
+			fprintf(stderr, "%s: bad option '%c'\n", progname, c);
 		case 'h':
 			usage(progname);
 			break;
diff --git a/misc/e2freefrag.h b/misc/e2freefrag.h
index 80d1eef..9dbab94 100644
--- a/misc/e2freefrag.h
+++ b/misc/e2freefrag.h
@@ -4,17 +4,20 @@
 
 #define MAX_HIST	32
 struct free_chunk_histogram {
-	unsigned long fc_chunks[MAX_HIST];
-	unsigned long fc_blocks[MAX_HIST];
+	unsigned long long fc_chunks[MAX_HIST];
+	unsigned long long fc_blocks[MAX_HIST];
 };
 
 struct chunk_info {
 	unsigned long chunkbytes;	/* chunk size in bytes */
-	int chunkbits;			/* chunk size in bits */
-	unsigned long free_chunks;	/* total free chunks of given size */
-	unsigned long real_free_chunks; /* free chunks of any size */
-	int blocksize_bits;		/* fs blocksize in bits */
-	int blks_in_chunk;		/* number of blocks in a chunk */
-	unsigned long min, max, avg;	/* chunk size stats */
+	unsigned long blks_in_chunk;	/* number of blocks in a chunk */
+	unsigned chunkbits;		/* chunk size in bits */
+	unsigned blocksize_bits;	/* fs blocksize in bits */
+	unsigned long long free_blocks;	/* free blocks (sb is not uptodate) */
+	unsigned long long free_chunks;	/* total free chunks of given size */
+	unsigned long long real_free_chunks; /* free chunks of any size */
+	unsigned long long sum;		/* sum of whole free chunk blocks */
+	unsigned long min;		/* minimum free chunk size (blocks) */
+	unsigned long max;		/* maximum free chunk size (blocks) */
 	struct free_chunk_histogram histogram; /* histogram of all chunk sizes*/
 };

--Apple-Mail-27--654211400--
