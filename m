From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Some 64-bit tests
Date: Thu, 11 Jun 2009 11:20:06 +0530
Message-ID: <20090611055006.GA8073@skywalker>
References: <18887.1244469441@gamaville.dokosmarshall.org> <20090608201037.GB23723@skywalker> <14597.1244517228@gamaville.dokosmarshall.org> <20090610181320.GA6953@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Dokos <nicholas.dokos@hp.com>,
	Valerie Aurora <vaurora@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49662 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbZFKFum (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Jun 2009 01:50:42 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id n5B5oMGY014877
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2009 15:50:22 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5B5oR1X475534
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2009 15:50:27 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5B5oQfi003258
	for <linux-ext4@vger.kernel.org>; Thu, 11 Jun 2009 15:50:27 +1000
Content-Disposition: inline
In-Reply-To: <20090610181320.GA6953@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 10, 2009 at 02:13:20PM -0400, Theodore Tso wrote:
> On Mon, Jun 08, 2009 at 11:13:48PM -0400, Nick Dokos wrote:
> > 
> > I tried this on top of 2.6.30-rc8 and I hit a couple of BUGs, one in pdflush
> > and the other in the Lustre teest program (liverfs):
> > 
> > Jun  8 22:49:13 shifter kernel: ------------[ cut here ]------------
> > Jun  8 22:49:13 shifter kernel: kernel BUG at fs/ext4/mballoc.c:3245!
> > Jun  8 22:49:13 shifter kernel: invalid opcode: 0000 [#1] SMP 
> 
> Hmmm, that would be the BUG_ON check:
> 
>      BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
> 

I already have a RFC patch which Nick actually tested. It is giving 32MB
extents, which is expected because the max order in buddy cache is
blocksize_bits + 1. I have a Fixme in there regarding scaling the start
block which was hoping to fix soon.

Attaching the patch below.

commit f1fbc2ac43fefb6bac227fc995fe2b79c67ccfad
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Tue Jun 9 01:38:53 2009 +0530

    ext4: Use different normalization method for allocation size.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ed8482e..9745b84 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -633,7 +633,7 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
 
 	BUG_ON(len > EXT4_BLOCKS_PER_GROUP(sb));
 
-	border = 2 << sb->s_blocksize_bits;
+	border = 1 << (sb->s_blocksize_bits + 1);
 
 	while (len > 0) {
 		/* find how many blocks can be covered since this position */
@@ -3063,8 +3063,10 @@ static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
 ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 				struct ext4_allocation_request *ar)
 {
-	int bsbits, max;
+	loff_t max;
 	ext4_lblk_t end;
+	int bsbits, chunk_blks;
+	unsigned int s_mb_stream_request;
 	loff_t size, orig_size, start_off;
 	ext4_lblk_t start, orig_start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
@@ -3090,54 +3092,61 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	}
 
 	bsbits = ac->ac_sb->s_blocksize_bits;
+	s_mb_stream_request = EXT4_SB(ac->ac_sb)->s_mb_stream_request;
+	/* make sure this is power of 2 */
+	s_mb_stream_request =
+		roundup_pow_of_two((unsigned long)s_mb_stream_request);
 
 	/* first, let's learn actual file size
 	 * given current request is allocated */
 	size = ac->ac_o_ex.fe_logical + ac->ac_o_ex.fe_len;
-	size = size << bsbits;
-	if (size < i_size_read(ac->ac_inode))
-		size = i_size_read(ac->ac_inode);
-
-	/* max size of free chunks */
-	max = 2 << bsbits;
+	if (size < (i_size_read(ac->ac_inode) >> bsbits))
+		size = i_size_read(ac->ac_inode) >> bsbits;
+	/*
+	 * max free chunk blocks.
+	 * (max buddy cache order is (bsbits + 1).
+	 */
+	max = 1 << (bsbits + 1);
 
-#define NRL_CHECK_SIZE(req, size, max, chunk_size)	\
-		(req <= (size) || max <= (chunk_size))
+	/*
+	 * If buddy cache says it can have more than
+	 * blocks per group then limit to blocks per group.
+	 */
+	if (max > EXT4_BLOCKS_PER_GROUP(ac->ac_sb))
+		max = EXT4_BLOCKS_PER_GROUP(ac->ac_sb);
 
 	/* first, try to predict filesize */
 	/* XXX: should this table be tunable? */
-	start_off = 0;
-	if (size <= 16 * 1024) {
-		size = 16 * 1024;
-	} else if (size <= 32 * 1024) {
-		size = 32 * 1024;
-	} else if (size <= 64 * 1024) {
-		size = 64 * 1024;
-	} else if (size <= 128 * 1024) {
-		size = 128 * 1024;
-	} else if (size <= 256 * 1024) {
-		size = 256 * 1024;
-	} else if (size <= 512 * 1024) {
-		size = 512 * 1024;
-	} else if (size <= 1024 * 1024) {
-		size = 1024 * 1024;
-	} else if (NRL_CHECK_SIZE(size, 4 * 1024 * 1024, max, 2 * 1024)) {
-		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
-						(21 - bsbits)) << 21;
-		size = 2 * 1024 * 1024;
-	} else if (NRL_CHECK_SIZE(size, 8 * 1024 * 1024, max, 4 * 1024)) {
-		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
-							(22 - bsbits)) << 22;
-		size = 4 * 1024 * 1024;
-	} else if (NRL_CHECK_SIZE(ac->ac_o_ex.fe_len,
-					(8<<20)>>bsbits, max, 8 * 1024)) {
-		start_off = ((loff_t)ac->ac_o_ex.fe_logical >>
-							(23 - bsbits)) << 23;
-		size = 8 * 1024 * 1024;
-	} else {
-		start_off = (loff_t)ac->ac_o_ex.fe_logical << bsbits;
-		size	  = ac->ac_o_ex.fe_len << bsbits;
+	/*
+	 * less than s_mb_stream_request is using
+	 * locality group preallocation
+	 */
+	if (size <= s_mb_stream_request) {
+		size = s_mb_stream_request << bsbits;
+		goto found_size;
+	}
+	chunk_blks = s_mb_stream_request << 1;
+	while (1) {
+		if (size <= chunk_blks) {
+			if (max <= chunk_blks)
+				size = max << bsbits;
+			else
+				size = chunk_blks << bsbits;
+			break;
+		}
+		chunk_blks = chunk_blks << 1;
 	}
+
+found_size:
+#if 0
+	/* Will i end up requesting for less that what i asked for ? */
+	start_off = (loff_t)(ac->ac_o_ex.fe_logical << bsbits) & ~(size - 1);
+	start_off = start_off * size;
+#else
+	start_off = (loff_t)(ac->ac_o_ex.fe_logical << bsbits);
+#endif
+
+	/* convert into blocks */
 	orig_size = size = size >> bsbits;
 	orig_start = start = start_off >> bsbits;
 
@@ -3216,6 +3225,10 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	}
 	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
 			start > ac->ac_o_ex.fe_logical);
+
+	if (size <= 0 ||  size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb))
+		printk(KERN_ALERT "size is %ld orig size is %ld\n", (long)size, (long)orig_size);
+
 	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 
 	/* now prepare goal request */
