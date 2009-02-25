From: Mark Nelson <markn@au1.ibm.com>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Wed, 25 Feb 2009 17:52:56 +1100
Message-ID: <200902251752.56514.markn@au1.ibm.com>
References: <49A2705D.9030008@in.ibm.com> <20090223155116.GB5764@atrey.karlin.mff.cuni.cz> <49A395ED.5030607@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, Jan Kara <jack@suse.cz>,
	Jan Kara <jack@ucw.cz>, Mel Gorman <mel@csn.ul.ie>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, benh@kernel.crashing.org
To: "Sachin P. Sant" <sachinp@in.ibm.com>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48354 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZBYGvZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 01:51:25 -0500
In-Reply-To: <49A395ED.5030607@in.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 24 Feb 2009 05:38:37 pm Sachin P. Sant wrote:
> Jan Kara wrote:
> >   Hmm, OK. But then I'm not sure how that can happen. Obviously, memcpy
> > somehow got beyond end of the page referenced by bh->b_data. So it means
> > that le16_to_cpu(entry->e_value_offs) + size > page_size. But
> > ext3_xattr_find_entry() calls ext3_xattr_check_entry() which in
> > particular checks whether e_value_offs + e_value_size isn't greater than
> > bh->b_size. So I see no way how memcpy can get beyond end of the page.
> >   Sachin, is the problem reproducible? If yes, can you send us contents
> >   
> Yes, i am able to recreate this problem easily. As i had mentioned if the
> earlier kernel is booted with selinux enabled and then 2.6.29-rc6 is booted
> i get this crash. But if i specify selinux=0 at command line, 2.6.29-rc6 boots
> without any problem.

Hi Sanchin and Geert,

Does the patch below fix the problems you're seeing? If it does I'll send
a properly written up and formatted patch to linuxppc-dev (as well as
another one to fix the same problem in copy_tofrom_user()).

Thanks and sorry again!

Mark

---
 arch/powerpc/lib/memcpy_64.S |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

Index: upstream/arch/powerpc/lib/memcpy_64.S
===================================================================
--- upstream.orig/arch/powerpc/lib/memcpy_64.S
+++ upstream/arch/powerpc/lib/memcpy_64.S
@@ -53,18 +53,19 @@ END_FTR_SECTION_IFCLR(CPU_FTR_UNALIGNED_
 3:	std	r8,8(r3)
 	beq	3f
 	addi	r3,r3,16
-	ld	r9,8(r4)
 .Ldo_tail:
 	bf	cr7*4+1,1f
-	rotldi	r9,r9,32
+	lwz	r9,8(r4)
+	addi	r4,r4,4
 	stw	r9,0(r3)
 	addi	r3,r3,4
 1:	bf	cr7*4+2,2f
-	rotldi	r9,r9,16
+	lhz	r9,8(r4)
+	addi	r4,r4,2
 	sth	r9,0(r3)
 	addi	r3,r3,2
 2:	bf	cr7*4+3,3f
-	rotldi	r9,r9,8
+	lbz	r9,8(r4)
 	stb	r9,0(r3)
 3:	ld	r3,48(r1)	/* return dest pointer */
 	blr
@@ -133,11 +134,24 @@ END_FTR_SECTION_IFCLR(CPU_FTR_UNALIGNED_
 	cmpwi	cr1,r5,8
 	addi	r3,r3,32
 	sld	r9,r9,r10
-	ble	cr1,.Ldo_tail
+	ble	cr1,6f
 	ld	r0,8(r4)
 	srd	r7,r0,r11
 	or	r9,r7,r9
-	b	.Ldo_tail
+6:
+	bf	cr7*4+1,1f
+	rotldi	r9,r9,32
+	stw	r9,0(r3)
+	addi	r3,r3,4
+1:	bf	cr7*4+2,2f
+	rotldi	r9,r9,16
+	sth	r9,0(r3)
+	addi	r3,r3,2
+2:	bf	cr7*4+3,3f
+	rotldi	r9,r9,8
+	stb	r9,0(r3)
+3:	ld	r3,48(r1)	/* return dest pointer */
+	blr
 
 .Ldst_unaligned:
 	PPC_MTOCRF	0x01,r6		# put #bytes to 8B bdry into cr7
