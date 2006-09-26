From: Alexandre Ratchov <alexandre.ratchov@bull.net>
Subject: [patch 02/12] rfc: 2fsprogs update
Date: Tue, 26 Sep 2006 16:45:42 +0200
Message-ID: <20060926144542.GB25755@openx1.frec.bull.fr>
References: <20060926143343.GA20020@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41349 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S932090AbWIZOpu
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 10:45:50 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 2E3D719D915
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:45:47 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12070-09 for <linux-ext4@vger.kernel.org>;
 Tue, 26 Sep 2006 16:45:44 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 199AC19D90C
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 16:45:44 +0200 (CEST)
To: linux-ext4@vger.kernel.org
In-Reply-To: <20060926143343.GA20020@openx1.frec.bull.fr>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Alexandre Ratchov <alexandre.ratchov@bull.net>

Index: e2fsprogs-1.39/lib/e2p/percent.c
===================================================================
--- e2fsprogs-1.39.orig/lib/e2p/percent.c	2006-09-20 12:07:05.000000000 +0200
+++ e2fsprogs-1.39/lib/e2p/percent.c	2006-09-20 12:36:32.000000000 +0200
@@ -7,25 +7,50 @@
  * Public License
  */
 
+/*
 #include "e2p.h"
+*/
 
 #include <stdlib.h>
 
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
