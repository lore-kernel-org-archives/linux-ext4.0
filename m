From: Chris Frost <chris@frostnet.net>
Subject: [PATCH] mke2fs.8.in: correct the sign of a block-size constraint.
Date: Sat, 24 Jul 2010 15:01:24 -0700
Message-ID: <20100724220124.GO4032@pooh.frostnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from owl.frostnet.net ([205.134.225.164]:53998 "EHLO
	owl.frostnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab0GXWX2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Jul 2010 18:23:28 -0400
Received: from pool-71-106-209-101.lsanca.dsl-w.verizon.net ([71.106.209.101] helo=pooh.frostnet.net)
	by owl.frostnet.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <chris@frostnet.net>)
	id 1Ocmn1-0006YC-0N
	for linux-ext4@vger.kernel.org; Sat, 24 Jul 2010 15:01:56 -0700
Received: from chris by pooh.frostnet.net with local (Exim 4.71)
	(envelope-from <chris@frostnet.net>)
	id 1Ocmmf-0006G3-N7
	for linux-ext4@vger.kernel.org; Sat, 24 Jul 2010 15:01:29 -0700
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Small but technical typo correction.

There may be more preferred mark ups (e.g., no space between the negative
sign and "block-sized") or expressions (e.g., absolute value instead of
negation).


Signed-off-by: Chris Frost <chris@frostnet.net>
---
 misc/mke2fs.8.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 45a99f8..05cfe17 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -177,7 +177,7 @@ is negative, then
 .B mke2fs
 will use heuristics to determine the
 appropriate block size, with the constraint that the block size will be
-at least
+at least \-
 .I block-size
 bytes.  This is useful for certain hardware devices which require that
 the blocksize be a multiple of 2k.
-- 
1.7.0.4

-- 
Chris Frost
http://www.frostnet.net/chris/
