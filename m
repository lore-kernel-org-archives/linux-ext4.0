From: Mark Nelson <markn@au1.ibm.com>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Wed, 25 Feb 2009 23:10:05 +1100
Message-ID: <200902252310.05792.markn@au1.ibm.com>
References: <49A2705D.9030008@in.ibm.com> <200902251752.56514.markn@au1.ibm.com> <alpine.LRH.2.00.0902251018060.4063@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Jan Kara <jack@ucw.cz>, Jan Kara <jack@suse.cz>,
	Mel Gorman <mel@csn.ul.ie>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: linuxppc-dev@ozlabs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41443 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbZBYMIs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 07:08:48 -0500
In-Reply-To: <alpine.LRH.2.00.0902251018060.4063@vixen.sonytel.be>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 25 Feb 2009 08:50:46 pm Geert Uytterhoeven wrote:
> On Wed, 25 Feb 2009, Mark Nelson wrote:
> > On Tue, 24 Feb 2009 05:38:37 pm Sachin P. Sant wrote:
> > > Jan Kara wrote:
> > > >   Hmm, OK. But then I'm not sure how that can happen. Obviously, memcpy
> > > > somehow got beyond end of the page referenced by bh->b_data. So it means
> > > > that le16_to_cpu(entry->e_value_offs) + size > page_size. But
> > > > ext3_xattr_find_entry() calls ext3_xattr_check_entry() which in
> > > > particular checks whether e_value_offs + e_value_size isn't greater than
> > > > bh->b_size. So I see no way how memcpy can get beyond end of the page.
> > > >   Sachin, is the problem reproducible? If yes, can you send us contents
> > > >   
> > > Yes, i am able to recreate this problem easily. As i had mentioned if the
> > > earlier kernel is booted with selinux enabled and then 2.6.29-rc6 is booted
> > > i get this crash. But if i specify selinux=0 at command line, 2.6.29-rc6 boots
> > > without any problem.
> > 
> > Hi Sanchin and Geert,
> > 
> > Does the patch below fix the problems you're seeing? If it does I'll send
> > a properly written up and formatted patch to linuxppc-dev (as well as
> > another one to fix the same problem in copy_tofrom_user()).
> 
> Unfortunately not, now it crashes while accessing the memory pointed to by
> GPR16, in
> 
> NIP: copy_page_range+x0608/0x628
> LR:  dup_mm+0x2e4/0x428
> Trace: debug_table+0xcc70/0x1afe0 (unreliable)
> dup_mm+0x2e4/0x428
> copy_process+0x86c/0xf9c
> do_fork+0x188/0x39c
> sys_clone+0x58/0x70
> ppc_clone+0x8/0xc
> 
> However, after reverting 25d6e2d7c58ddc4a3b614fc5381591c0cfe66556, I still see
> similar problems as above (crash in copy_page_range()).
> Which makes me think that
>   1. Your new patch fixes the problem introduced by 25d6e2d7,
>   2. There's still another issue than the one introduced by 25d6e2d7.

Does the following patch fix the errors you're seeing? (it applies the
same fix as the previous patch but this time to copy_tofrom_user, which
I updated in a4e22f02f5b6518c1484faea1f88d81802b9feac)

Thanks!

Mark

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
