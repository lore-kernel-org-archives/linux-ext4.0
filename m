From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4 still broken on arm (at least)
Date: Wed, 28 Nov 2007 11:00:20 +0530
Message-ID: <20071128053020.GA6977@skywalker>
References: <20071127211444.703741a9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:60815 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbXK1GBv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Nov 2007 01:01:51 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id lAS5UrPC030714
	for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2007 16:30:53 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lAS5YWj7194508
	for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2007 16:34:32 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAS5UeBc010877
	for <linux-ext4@vger.kernel.org>; Wed, 28 Nov 2007 16:30:40 +1100
Content-Disposition: inline
In-Reply-To: <20071127211444.703741a9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 27, 2007 at 09:14:44PM -0800, Andrew Morton wrote:
> fs/ext4/mballoc.c: In function `ext4_mb_generate_buddy':
> fs/ext4/mballoc.c:836: error: implicit declaration of function `ext2_find_next_bit'                                                                             


I actually sent in a patch which changes asking for review to
linux-arch. I haven't got the response yet. Attaching the patch
below 

Introduce ext4_find_next_bit

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This gets used by the ext4 multi block allocator patches.

Also add generic_find_next_le_bit

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/bitops.h                     |    2 +
 include/asm-generic/bitops/ext2-non-atomic.h |    2 +
 include/asm-generic/bitops/le.h              |    4 ++
 include/asm-m68k/bitops.h                    |    2 +
 include/asm-m68knommu/bitops.h               |    2 +
 include/asm-powerpc/bitops.h                 |    4 ++
 include/asm-s390/bitops.h                    |    2 +
 include/linux/ext4_fs.h                      |    1 +
 lib/find_next_bit.c                          |   43 ++++++++++++++++++++++++++
 9 files changed, 62 insertions(+), 0 deletions(-)


diff --git a/include/asm-arm/bitops.h b/include/asm-arm/bitops.h
index 47a6b08..5c60bfc 100644
--- a/include/asm-arm/bitops.h
+++ b/include/asm-arm/bitops.h
@@ -310,6 +310,8 @@ static inline int constant_fls(int x)
 		_find_first_zero_bit_le(p,sz)
 #define ext2_find_next_zero_bit(p,sz,off)	\
 		_find_next_zero_bit_le(p,sz,off)
+#define ext2_find_next_bit(p, sz, off) \
+		_find_next_bit_le(p, sz, off)
 
 /*
  * Minix is defined to use little-endian byte ordering.
diff --git a/include/asm-generic/bitops/ext2-non-atomic.h b/include/asm-generic/bitops/ext2-non-atomic.h
index 1697404..63cf822 100644
--- a/include/asm-generic/bitops/ext2-non-atomic.h
+++ b/include/asm-generic/bitops/ext2-non-atomic.h
@@ -14,5 +14,7 @@
 	generic_find_first_zero_le_bit((unsigned long *)(addr), (size))
 #define ext2_find_next_zero_bit(addr, size, off) \
 	generic_find_next_zero_le_bit((unsigned long *)(addr), (size), (off))
+#define ext2_find_next_bit(addr, size, off) \
+	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
 
 #endif /* _ASM_GENERIC_BITOPS_EXT2_NON_ATOMIC_H_ */
diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index b9c7e5d..80e3bf1 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -20,6 +20,8 @@
 #define generic___test_and_clear_le_bit(nr, addr) __test_and_clear_bit(nr, addr)
 
 #define generic_find_next_zero_le_bit(addr, size, offset) find_next_zero_bit(addr, size, offset)
+#define generic_find_next_le_bit(addr, size, offset) \
+			find_next_bit(addr, size, offset)
 
 #elif defined(__BIG_ENDIAN)
 
@@ -42,6 +44,8 @@
 
 extern unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
 		unsigned long size, unsigned long offset);
+extern unsigned long generic_find_next_le_bit(const unsigned long *addr,
+		unsigned long size, unsigned long offset);
 
 #else
 #error "Please fix <asm/byteorder.h>"
diff --git a/include/asm-m68k/bitops.h b/include/asm-m68k/bitops.h
index 2976b5d..83d1f28 100644
--- a/include/asm-m68k/bitops.h
+++ b/include/asm-m68k/bitops.h
@@ -410,6 +410,8 @@ static inline int ext2_find_next_zero_bit(const void *vaddr, unsigned size,
 	res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
 	return (p - addr) * 32 + res;
 }
+#define ext2_find_next_bit(addr, size, off) \
+	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
 
 #endif /* __KERNEL__ */
 
diff --git a/include/asm-m68knommu/bitops.h b/include/asm-m68knommu/bitops.h
index f8dfb7b..f43afe1 100644
--- a/include/asm-m68knommu/bitops.h
+++ b/include/asm-m68knommu/bitops.h
@@ -294,6 +294,8 @@ found_middle:
 	return result + ffz(__swab32(tmp));
 }
 
+#define ext2_find_next_bit(addr, size, off) \
+	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-powerpc/bitops.h b/include/asm-powerpc/bitops.h
index 733b4af..220d9a7 100644
--- a/include/asm-powerpc/bitops.h
+++ b/include/asm-powerpc/bitops.h
@@ -359,6 +359,8 @@ static __inline__ int test_le_bit(unsigned long nr,
 unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
 				    unsigned long size, unsigned long offset);
 
+unsigned long generic_find_next_le_bit(const unsigned long *addr,
+				    unsigned long size, unsigned long offset);
 /* Bitmap functions for the ext2 filesystem */
 
 #define ext2_set_bit(nr,addr) \
@@ -378,6 +380,8 @@ unsigned long generic_find_next_zero_le_bit(const unsigned long *addr,
 #define ext2_find_next_zero_bit(addr, size, off) \
 	generic_find_next_zero_le_bit((unsigned long*)addr, size, off)
 
+#define ext2_find_next_bit(addr, size, off) \
+	generic_find_next_le_bit((unsigned long *)addr, size, off)
 /* Bitmap functions for the minix filesystem.  */
 
 #define minix_test_and_set_bit(nr,addr) \
diff --git a/include/asm-s390/bitops.h b/include/asm-s390/bitops.h
index 34d9a63..dba6fec 100644
--- a/include/asm-s390/bitops.h
+++ b/include/asm-s390/bitops.h
@@ -772,6 +772,8 @@ static inline int sched_find_first_bit(unsigned long *b)
 	test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
 #define ext2_test_bit(nr, addr)      \
 	test_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
+#define ext2_find_next_bit(addr, size, off) \
+	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
 
 #ifndef __s390x__
 
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 85395c1..cf7e90e 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -493,6 +493,7 @@ do {									       \
 #define ext4_test_bit			ext2_test_bit
 #define ext4_find_first_zero_bit	ext2_find_first_zero_bit
 #define ext4_find_next_zero_bit		ext2_find_next_zero_bit
+#define ext4_find_next_bit		ext2_find_next_bit
 
 /*
  * Maximal mount counts between two filesystem checks
diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
index bda0d71..78ccd73 100644
--- a/lib/find_next_bit.c
+++ b/lib/find_next_bit.c
@@ -178,4 +178,47 @@ found_middle_swap:
 
 EXPORT_SYMBOL(generic_find_next_zero_le_bit);
 
+unsigned long generic_find_next_le_bit(const unsigned long *addr, unsigned
+		long size, unsigned long offset)
+{
+	const unsigned long *p = addr + BITOP_WORD(offset);
+	unsigned long result = offset & ~(BITS_PER_LONG - 1);
+	unsigned long tmp;
+
+	if (offset >= size)
+		return size;
+	size -= result;
+	offset &= (BITS_PER_LONG - 1UL);
+	if (offset) {
+		tmp = ext2_swabp(p++);
+		tmp &= (~0UL << offset);
+		if (size < BITS_PER_LONG)
+			goto found_first;
+		if (tmp)
+			goto found_middle;
+		size -= BITS_PER_LONG;
+		result += BITS_PER_LONG;
+	}
+
+	while (size & ~(BITS_PER_LONG - 1)) {
+		tmp = *(p++);
+		if (tmp)
+			goto found_middle_swap;
+		result += BITS_PER_LONG;
+		size -= BITS_PER_LONG;
+	}
+	if (!size)
+		return result;
+	tmp = ext2_swabp(p);
+found_first:
+	tmp &= (~0UL >> (BITS_PER_LONG - size));
+	if (tmp == 0UL)		/* Are any bits set? */
+		return result + size; /* Nope. */
+found_middle:
+	return result + __ffs(tmp);
+
+found_middle_swap:
+	return result + __ffs(ext2_swab(tmp));
+}
+EXPORT_SYMBOL(generic_find_next_le_bit);
 #endif /* __BIG_ENDIAN */
