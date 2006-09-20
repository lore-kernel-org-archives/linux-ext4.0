From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: [patch] small fix for e2p_percent()
Date: Wed, 20 Sep 2006 10:56:08 +0200
Message-ID: <20060920085608.GA18351@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:62635 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1750745AbWITI4a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Sep 2006 04:56:30 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 8B9F219D943
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 10:56:28 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 22796-03 for <linux-ext4@vger.kernel.org>;
 Wed, 20 Sep 2006 10:56:25 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 8D8AB19D94C
	for <linux-ext4@vger.kernel.org>; Wed, 20 Sep 2006 10:56:09 +0200 (CEST)
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

hello,

e2p_percent() doesn't work for zero percent (``mke2fs -m0'' gets killed with
SIGFPE).

is there a reason for not simply using 64 bit arithmetic? perhaps to avoid
overflows for 7e+9TB file-systems :-), or just for correctness...

So, here is the patch that fixes this. In order to avoid integer overflows,
we pick 16 more bits to store ``base'' and do the exact division on 48 bits.
Since ``100 * base'' always fits in 48 bits, there's never overflow. This
still work if we remplace 'unsigned int' by 'unsigned long long'.

cheers,

-- Alexandre

Signed-off-by: Alexandre Ratchov <alexandre.ratchov@bull.net>

Index: e2fsprogs-1.39/lib/e2p/percent.c
===================================================================
--- e2fsprogs-1.39.orig/lib/e2p/percent.c	2006-09-20 12:07:05.000000000 +0200
+++ e2fsprogs-1.39/lib/e2p/percent.c	2006-09-20 12:33:20.000000000 +0200
@@ -14,18 +14,41 @@
 /*
  * We work really hard to calculate this accurately, while avoiding
  * an overflow.  "Is there a hyphen in anal-retentive?"  :-)
+ *
+ * -- "Yes there is, as in hair-splitting and nit-picking"
  */
 unsigned int e2p_percent(int percent, unsigned int base)
 {
-	unsigned int mask = ~((1 << (sizeof(unsigned int) - 1) * 8) - 1);
+	unsigned hi, lo, q, r;
 
-	if (100 % percent == 0)
-		return base / (100 / percent);
-	if (mask & base) 
-		return (base / 100) * percent;
-	return base * percent / 100;
+	/* 
+	 * in order to avoid overflow we write 'base' as:
+	 *
+	 *	base = hi * 2^16 + lo 
+	 * 
+	 * then we do all computations separately on 'hi' and 'lo'.
+	 * By using the definition of division:
+	 *
+	 *	precent * base = result * 100 + reminder
+	 *
+	 * (reminder < 100), we obtain the exact value of 'result' 
+	 * as follows:
+	 */
+#define BITS	16
+#define MASK	((1 << BITS) - 1)
+
+	hi = percent * (base >> BITS);
+	lo = percent * (base & MASK);
+
+	q = ((hi / 100) << BITS) + lo / 100;
+	r = ((hi % 100) << BITS) + lo % 100;
+		
+	return q + r / 100;
+#undef BITS
+#undef MASK
 }
 
+
 #ifdef DEBUG
 #include <unistd.h>
 #include <stdio.h>

