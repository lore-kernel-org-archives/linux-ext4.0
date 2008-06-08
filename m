From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Add ext2_find_{first,next}_bit() for ext4
Date: Sun, 8 Jun 2008 22:30:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806082229350.25145@anakin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: stable@kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Linux/m68k <linux-m68k@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from monty.telenet-ops.be ([195.130.132.56]:52110 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbYFHUaw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Jun 2008 16:30:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Add ext2_find_{first,next}_bit(), which are needed for ext4.
They're derived out of the ext2_find_next_zero_bit found in the same file.
Compile tested with crosstools

[Reworked to preserve all symmetry with ext2_find_{first,next}_zero_bit()]

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=10393

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/bitops.h |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

--- a/include/asm-m68k/bitops.h
+++ b/include/asm-m68k/bitops.h
@@ -410,8 +410,50 @@ static inline int ext2_find_next_zero_bi
 	res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
 	return (p - addr) * 32 + res;
 }
-#define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
+
+static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
+{
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
+static inline int ext2_find_next_bit(const void *vaddr, unsigned size,
+				     unsigned offset)
+{
+	const unsigned long *addr = vaddr;
+	const unsigned long *p = addr + (offset >> 5);
+	int bit = offset & 31UL, res;
+
+	if (offset >= size)
+		return size;
+
+	if (bit) {
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
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
