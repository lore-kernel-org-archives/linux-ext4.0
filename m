From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4 compile error on m68k
Date: Thu, 10 Apr 2008 16:56:57 +0530
Message-ID: <20080410112657.GC23116@skywalker>
References: <20080405102408.GB30987@cs181133002.pp.htv.fi> <Pine.LNX.4.64.0804051345180.7216@anakin> <20080410104059.GA23116@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian Bunk <bunk@kernel.org>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	zippel@linux-m68k.org, linux-ext4@vger.kernel.org,
	linux-m68k@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:55729 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbYDJL1Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Apr 2008 07:27:24 -0400
Content-Disposition: inline
In-Reply-To: <20080410104059.GA23116@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2008 at 04:11:32PM +0530, Aneesh Kumar K.V wrote:
> On Sat, Apr 05, 2008 at 01:48:02PM +0200, Geert Uytterhoeven wrote:
> > On Sat, 5 Apr 2008, Adrian Bunk wrote:
> > > Commit aa02ad67d9b308290fde390682cd039b29f7ab85
> > > "ext4: Add ext4_find_next_bit()" causes the following regression:
> > > 
> > > <--  snip  -->
> > > 
> > > ...
> > >   CC [M]  fs/ext4/mballoc.o
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/ext4/mballoc.c: In function 'mb_find_next_bit':
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/ext4/mballoc.c:696: error: implicit declaration of function 'generic_find_next_le_bit'
> > > make[3]: *** [fs/ext4/mballoc.o] Error 1
> > > 
> > > <--  snip  -->
> > 
> > Known issue. The ext4 developers added a #define (with a different name than in
> > the patch comment) in the commit below, but forgot to make sure
> > generic_find_next_le_bit() is actually available.
> > 
> 
> generic_find_next_le_bit is defined in lib/find_next_bit.c. 
> 
> But m68k doesn't want to use the GENERIC_FIND_NEXT_BIT. Can I request
> somebody knowledgeable about m68k to give a try in implementing
> generic_find_next_le_bit  equivalent on m68k ?
> 

Is this ok ? It is derived out of the ext2_find_next_zero_bit
found in the same file. Compile tested with crosstools

diff --git a/include/asm-m68k/bitops.h b/include/asm-m68k/bitops.h
index 83d1f28..4795bd1 100644
--- a/include/asm-m68k/bitops.h
+++ b/include/asm-m68k/bitops.h
@@ -410,8 +410,51 @@ static inline int ext2_find_next_zero_bit(const void *vaddr, unsigned size,
 	res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
 	return (p - addr) * 32 + res;
 }
-#define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
+
+static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
+{
+	/* vaddr is long aligned */
+	const unsigned long *p = vaddr, *addr = vaddr;
+	int res;
+
+	if (!size)
+		return 0;
+
+	size = (size >> 5) + ((size & 31) > 0);
+	while (*p++ == 0UL)
+	{
+		if (--size == 0)
+			return (p - addr) << 5;
+	}
+
+	--p;
+	for (res = 0; res < 32; res++)
+		if (ext2_test_bit(res, p))
+			break;
+	return (p - addr) * 32 + res;
+}
+
+static inline unsigned long ext2_find_next_bit(const unsigned long *vaddr,
+				unsigned long size, unsigned long offset)
+{
+	const unsigned long *addr = vaddr;
+	const unsigned long *p = addr + (offset >> 5);
+	int bit = offset & 31UL, res;
+
+	if (bit) {
+		/*  addr + offse is not long aligned so search till we
+		 *  have an aligned address
+		 */
+		/* Look for one in first longword */
+		for (res = bit; res < 32; res++)
+			if (ext2_test_bit(res, p))
+				return (p - addr) * 32 + res;
+		p++;
+	}
+	/* No set bit yet, search remaining full bytes for a set bit */
+	res = ext2_find_first_bit(p, size - 32 * (p - addr));
+	return (p - addr) * 32 + res;
+}
 
 #endif /* __KERNEL__ */
 
