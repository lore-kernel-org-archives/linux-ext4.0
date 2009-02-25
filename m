From: Mark Nelson <markn@au1.ibm.com>
Subject: [PATCH] powerpc: Fix 64bit __copy_tofrom_user() regression
Date: Thu, 26 Feb 2009 10:46:24 +1100
Message-ID: <200902261046.24367.markn@au1.ibm.com>
References: <49A2705D.9030008@in.ibm.com> <200902251752.56514.markn@au1.ibm.com> <200902261026.48183.markn@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, Jan Kara <jack@ucw.cz>,
	Jan Kara <jack@suse.cz>, Mel Gorman <mel@csn.ul.ie>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: benh@kernel.crashing.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55028 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZBYXov (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 18:44:51 -0500
In-Reply-To: <200902261026.48183.markn@au1.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes a regression introduced by commit
a4e22f02f5b6518c1484faea1f88d81802b9feac ("powerpc: Update 64bit
__copy_tofrom_user() using CPU_FTR_UNALIGNED_LD_STD").

The same bug that existed in the 64bit memcpy() also exists here so fix
it here too. The fix is the same as that applied to memcpy() with the
addition of fixes for the exception handling code required for
__copy_tofrom_user().

This stops us reading beyond the end of the source region we were told
to copy.

Signed-off-by: Mark Nelson <markn@au1.ibm.com>
---
 arch/powerpc/lib/copyuser_64.S |   38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

Index: upstream/arch/powerpc/lib/copyuser_64.S
===================================================================
--- upstream.orig/arch/powerpc/lib/copyuser_64.S
+++ upstream/arch/powerpc/lib/copyuser_64.S
@@ -62,18 +62,19 @@ END_FTR_SECTION_IFCLR(CPU_FTR_UNALIGNED_
 72:	std	r8,8(r3)
 	beq+	3f
 	addi	r3,r3,16
-23:	ld	r9,8(r4)
 .Ldo_tail:
 	bf	cr7*4+1,1f
-	rotldi	r9,r9,32
+23:	lwz	r9,8(r4)
+	addi	r4,r4,4
 73:	stw	r9,0(r3)
 	addi	r3,r3,4
 1:	bf	cr7*4+2,2f
-	rotldi	r9,r9,16
+44:	lhz	r9,8(r4)
+	addi	r4,r4,2
 74:	sth	r9,0(r3)
 	addi	r3,r3,2
 2:	bf	cr7*4+3,3f
-	rotldi	r9,r9,8
+45:	lbz	r9,8(r4)
 75:	stb	r9,0(r3)
 3:	li	r3,0
 	blr
@@ -141,11 +142,24 @@ END_FTR_SECTION_IFCLR(CPU_FTR_UNALIGNED_
 6:	cmpwi	cr1,r5,8
 	addi	r3,r3,32
 	sld	r9,r9,r10
-	ble	cr1,.Ldo_tail
+	ble	cr1,7f
 34:	ld	r0,8(r4)
 	srd	r7,r0,r11
 	or	r9,r7,r9
-	b	.Ldo_tail
+7:
+	bf	cr7*4+1,1f
+	rotldi	r9,r9,32
+94:	stw	r9,0(r3)
+	addi	r3,r3,4
+1:	bf	cr7*4+2,2f
+	rotldi	r9,r9,16
+95:	sth	r9,0(r3)
+	addi	r3,r3,2
+2:	bf	cr7*4+3,3f
+	rotldi	r9,r9,8
+96:	stb	r9,0(r3)
+3:	li	r3,0
+	blr
 
 .Ldst_unaligned:
 	PPC_MTOCRF	0x01,r6		/* put #bytes to 8B bdry into cr7 */
@@ -218,7 +232,6 @@ END_FTR_SECTION_IFCLR(CPU_FTR_UNALIGNED_
 121:
 132:
 	addi	r3,r3,8
-123:
 134:
 135:
 138:
@@ -226,6 +239,9 @@ END_FTR_SECTION_IFCLR(CPU_FTR_UNALIGNED_
 140:
 141:
 142:
+123:
+144:
+145:
 
 /*
  * here we have had a fault on a load and r3 points to the first
@@ -309,6 +325,9 @@ END_FTR_SECTION_IFCLR(CPU_FTR_UNALIGNED_
 187:
 188:
 189:	
+194:
+195:
+196:
 1:
 	ld	r6,-24(r1)
 	ld	r5,-8(r1)
@@ -329,7 +348,9 @@ END_FTR_SECTION_IFCLR(CPU_FTR_UNALIGNED_
 	.llong	72b,172b
 	.llong	23b,123b
 	.llong	73b,173b
+	.llong	44b,144b
 	.llong	74b,174b
+	.llong	45b,145b
 	.llong	75b,175b
 	.llong	24b,124b
 	.llong	25b,125b
@@ -347,6 +368,9 @@ END_FTR_SECTION_IFCLR(CPU_FTR_UNALIGNED_
 	.llong	79b,179b
 	.llong	80b,180b
 	.llong	34b,134b
+	.llong	94b,194b
+	.llong	95b,195b
+	.llong	96b,196b
 	.llong	35b,135b
 	.llong	81b,181b
 	.llong	36b,136b
