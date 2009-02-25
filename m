From: Mark Nelson <markn@au1.ibm.com>
Subject: [PATCH] powerpc: Fix 64bit memcpy() regression
Date: Thu, 26 Feb 2009 10:26:48 +1100
Message-ID: <200902261026.48183.markn@au1.ibm.com>
References: <49A2705D.9030008@in.ibm.com> <49A395ED.5030607@in.ibm.com> <200902251752.56514.markn@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, "Sachin P. Sant" <sachinp@in.ibm.com>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Jan Kara <jack@ucw.cz>, Jan Kara <jack@suse.cz>,
	Mel Gorman <mel@csn.ul.ie>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: benh@kernel.crashing.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:43657 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566AbZBYXZT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 18:25:19 -0500
In-Reply-To: <200902251752.56514.markn@au1.ibm.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes a regression introduced by commit
25d6e2d7c58ddc4a3b614fc5381591c0cfe66556 ("powerpc: Update 64bit memcpy()
using CPU_FTR_UNALIGNED_LD_STD").

This commit allowed CPUs that have the CPU_FTR_UNALIGNED_LD_STD CPU
feature bit present to do the memcpy() with unaligned load doubles. But,
along with this came a bug where our final load double would read bytes
beyond a page boundary and into the next (unmapped) page. This was caught
by enabling CONFIG_DEBUG_PAGEALLOC, 

The fix was to read only the number of bytes that we need to store rather
than reading a full 8-byte doubleword and storing only a portion of that.

In order to minimise the amount of existing code touched we use the
original do_tail for the src_unaligned case.

Below is an example of the regression, as reported by Sachin Sant:

Unable to handle kernel paging request for data at address 0xc00000003f380000
Faulting instruction address: 0xc000000000039574
cpu 0x1: Vector: 300 (Data Access) at [c00000003baf3020]
    pc: c000000000039574: .memcpy+0x74/0x244
    lr: d00000000244916c: .ext3_xattr_get+0x288/0x2f4 [ext3]
    sp: c00000003baf32a0
   msr: 8000000000009032
   dar: c00000003f380000
 dsisr: 40000000
  current = 0xc00000003e54b010
  paca    = 0xc000000000a53680
    pid   = 1840, comm = readahead
enter ? for help
[link register   ] d00000000244916c .ext3_xattr_get+0x288/0x2f4 [ext3]
[c00000003baf32a0] d000000002449104 .ext3_xattr_get+0x220/0x2f4 [ext3]
(unreliab
le)
[c00000003baf3390] d00000000244a6e8 .ext3_xattr_security_get+0x40/0x5c [ext3]
[c00000003baf3400] c000000000148154 .generic_getxattr+0x74/0x9c
[c00000003baf34a0] c000000000333400 .inode_doinit_with_dentry+0x1c4/0x678
[c00000003baf3560] c00000000032c6b0 .security_d_instantiate+0x50/0x68
[c00000003baf35e0] c00000000013c818 .d_instantiate+0x78/0x9c
[c00000003baf3680] c00000000013ced0 .d_splice_alias+0xf0/0x120
[c00000003baf3720] d00000000243e05c .ext3_lookup+0xec/0x134 [ext3]
[c00000003baf37c0] c000000000131e74 .do_lookup+0x110/0x260
[c00000003baf3880] c000000000134ed0 .__link_path_walk+0xa98/0x1010
[c00000003baf3970] c0000000001354a0 .path_walk+0x58/0xc4
[c00000003baf3a20] c000000000135720 .do_path_lookup+0x138/0x1e4
[c00000003baf3ad0] c00000000013645c .path_lookup_open+0x6c/0xc8
[c00000003baf3b70] c000000000136780 .do_filp_open+0xcc/0x874
[c00000003baf3d10] c0000000001251e0 .do_sys_open+0x80/0x140
[c00000003baf3dc0] c00000000016aaec .compat_sys_open+0x24/0x38
[c00000003baf3e30] c00000000000855c syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 000000000ff0ef18
SP (ffc6f4b0) is in userspace
1:mon>

Signed-off-by: Mark Nelson <markn@au1.ibm.com>
Reported-by: Sachin Sant <sachinp@in.ibm.com>
Tested-by: Sachin Sant <sachinp@in.ibm.com>
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
