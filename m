From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Wed, 23 Apr 2008 22:19:22 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0804232217290.5444@sbz-30.cs.Helsinki.FI>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>
 <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
  <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>
 <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>
 <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org>
 <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>
 <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
 <480F857A.3090503@cs.helsinki.fi> <Pine.LNX.4.64.0804231202250.15173@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au
To: Christoph Lameter <clameter@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49505 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbYDWTTs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 15:19:48 -0400
In-Reply-To: <Pine.LNX.4.64.0804231202250.15173@schroedinger.engr.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 23 Apr 2008, Christoph Lameter wrote:
> We should have returned from the function and not printed this message. If 
> we somehow skipped the test for !fault then end could have wrapped around 
> which gets us to 4GB.

Aah, looks like it's just a silly bug in slab_fix(). If this looks ok to 
Christoph, can you re-test with this patch applied Zdenek? That way we'll 
actually know where SLUB expected to see POISON_INUSE.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

diff --git a/mm/slub.c b/mm/slub.c
index 7f8aaa2..dac50e3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -456,6 +456,15 @@ static void print_page_info(struct page *page)
 
 }
 
+static void __slab_bug(struct kmem_cache *s, char *buf)
+{
+	printk(KERN_ERR "========================================"
+			"=====================================\n");
+	printk(KERN_ERR "BUG %s: %s\n", s->name, buf);
+	printk(KERN_ERR "----------------------------------------"
+			"-------------------------------------\n\n");
+}
+
 static void slab_bug(struct kmem_cache *s, char *fmt, ...)
 {
 	va_list args;
@@ -464,11 +473,7 @@ static void slab_bug(struct kmem_cache *s, char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_ERR "========================================"
-			"=====================================\n");
-	printk(KERN_ERR "BUG %s: %s\n", s->name, buf);
-	printk(KERN_ERR "----------------------------------------"
-			"-------------------------------------\n\n");
+	__slab_bug(s, buf);
 }
 
 static void slab_fix(struct kmem_cache *s, char *fmt, ...)
@@ -533,7 +538,7 @@ static void slab_err(struct kmem_cache *s, struct page *page, char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	slab_bug(s, fmt);
+	__slab_bug(s, buf);
 	print_page_info(page);
 	dump_stack();
 }
