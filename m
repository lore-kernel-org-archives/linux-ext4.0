From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Some 64-bit tests
Date: Tue, 9 Jun 2009 01:40:37 +0530
Message-ID: <20090608201037.GB23723@skywalker>
References: <18887.1244469441@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>, linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55643 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZFHUKx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jun 2009 16:10:53 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id n58K8qwL019317
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jun 2009 06:08:52 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n58KAsUv639060
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jun 2009 06:10:54 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n58KArHM030754
	for <linux-ext4@vger.kernel.org>; Tue, 9 Jun 2009 06:10:54 +1000
Content-Disposition: inline
In-Reply-To: <18887.1244469441@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Can you try this patch ?

commit 6a910bd1d28be09ba3a0e073bae78285ce057a5f
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Tue Jun 9 01:38:53 2009 +0530

    ext4: Use different normalization method for allocation size.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ed8482e..7f2423b 100644
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
+	int bsbits, i;
+	loff_t max;
 	ext4_lblk_t end;
+	unsigned int s_mb_stream_request;
 	loff_t size, orig_size, start_off;
 	ext4_lblk_t start, orig_start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
@@ -3090,54 +3092,52 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
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
 
 #define NRL_CHECK_SIZE(req, size, max, chunk_size)	\
-		(req <= (size) || max <= (chunk_size))
+	(((req <= (size)) && (req <= (chunk_size))) || max <= (chunk_size))
 
 	/* first, try to predict filesize */
 	/* XXX: should this table be tunable? */
 	start_off = 0;
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
+
+	/*
+	 * less than s_mb_stream_request is using locality group
+	 * preallocation
+	 */
+	if (size <= s_mb_stream_request)
+		size = s_mb_stream_request;
+	i = 4;
+	while (1) {
+		/*
+		 * if (size <= 4 * s_mb_stream ||
+		 * max <= 2 * s_mb_stream ) size = 2 * s_mb_stream
+		 */
+		if (NRL_CHECK_SIZE(size, i * s_mb_stream_request,
+					max, ((i * s_mb_stream_request) >> 1))) {
+			/* number of blocks */
+			size = (i * s_mb_stream_request) >> 1;
+			size = size << bsbits;
+			start_off = (loff_t)ac->ac_o_ex.fe_logical & ~(size - 1);
+			break;
+		}
+		i = i << 1;
 	}
+
 	orig_size = size = size >> bsbits;
 	orig_start = start = start_off >> bsbits;
 
