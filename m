From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Introduce ext4_find_next_bit
Date: Tue, 13 Nov 2007 12:43:02 -0800
Message-ID: <20071113124302.3eb4aa9d.akpm@linux-foundation.org>
References: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20071112235910.35a635e4.akpm@linux-foundation.org>
	<4739F6C7.90408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39763 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756705AbXKMUnU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Nov 2007 15:43:20 -0500
In-Reply-To: <4739F6C7.90408@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 14 Nov 2007 00:41:03 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> 
> 
> Andrew Morton wrote:
> > On Fri, 21 Sep 2007 10:55:05 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > 
> >> Also add generic_find_next_le_bit
> >>
> >> This gets used by the ext4 multi block allocator patches.
> >>
> > 
> > arm allmodconfig:
> > 
> > fs/ext4/mballoc.c: In function `ext4_mb_generate_buddy':
> > fs/ext4/mballoc.c:836: error: implicit declaration of function `ext2_find_next_bit'
> > 
> > This patch makes my head spin.
> > 
> > Why did we declare generic_find_next_le_bit() in
> > include/asm-powerpc/bitops.h (wrong) as well as in
> > include/asm-generic/bitops/le.h (presumably correct)?
> > 
> 
> I was following the coding style used for rest of the APIs
> like ext4_set_bit.

Well.  There's quite a bit of cruft in there.  If you do come across
something which isn't right, please do try to find the time to fix it up
first.

That might be non-trivial - powerpc does seem to have gone off on a strange
tangent there.

> 
> > Why is it touching a powerpc file and no any other architectures? 
> > Something screwed up in powerpc land?
> > 
> > And why did arm break?
> 
> arm and below list of arch doesn't include the asm-generic/bitops/ext2-non-atomic.h 
> 
> I did a grep and that list the below architectures as also affected.
> arm, m68k, m68knommu, s390
> 
> > 
> > Shudder.  Anyway, please fix, and if that fix requires that various
> > braindamaged be repaired, please repair the braindamage rather than going
> > along with it.
> > 
> > 
> 
> That should be a separate patch altogether. I wanted to do the cleanup
> along with the usages such as but never got time to do the same.
> 
> #define ocfs2_set_bit ext2_set_bit
> #define udf_set_bit(nr,addr) ext2_set_bit(nr,addr)
> direct usage in mb
> md/bitmap.c +799
> md/dm-log.c +177
> 
> I will send a patch tomorrow that fix  arm and other architectures. I guess the cleanup
> can be a separate patch ? 
> 

Yes, that's a separate work, thanks.
