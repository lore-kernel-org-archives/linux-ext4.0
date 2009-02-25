From: Mark Nelson <markn@au1.ibm.com>
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
Date: Wed, 25 Feb 2009 12:27:38 +1100
Message-ID: <200902251227.38741.markn@au1.ibm.com>
References: <49A2705D.9030008@in.ibm.com> <18850.31567.212454.514549@cargo.ozlabs.ibm.com> <alpine.LRH.2.00.0902241857170.544@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Paul Mackerras <paulus@samba.org>, Jan Kara <jack@ucw.cz>,
	Mel Gorman <mel@csn.ul.ie>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: linuxppc-dev@ozlabs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39194 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbZBYB0G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 20:26:06 -0500
In-Reply-To: <alpine.LRH.2.00.0902241857170.544@vixen.sonytel.be>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 25 Feb 2009 05:01:59 am Geert Uytterhoeven wrote:
> On Mon, 23 Feb 2009, Paul Mackerras wrote:
> > Andrew Morton writes:
> > > It looks like we died in ext3_xattr_block_get():
> > > 
> > > 		memcpy(buffer, bh->b_data + le16_to_cpu(entry->e_value_offs),
> > > 		       size);
> > > 
> > > Perhaps entry->e_value_offs is no good.  I wonder if the filesystem is
> > > corrupted and this snuck through the defenses.
> > > 
> > > I also wonder if there is enough info in that trace for a ppc person to
> > > be able to determine whether the faulting address is in the source or
> > > destination of the memcpy() (please)?
> > 
> > It appears to have faulted on a load, implicating the source.  The
> > address being referenced (0xc00000003f380000) doesn't look
> > outlandish.  I wonder if this kernel has CONFIG_DEBUG_PAGEALLOC turned
> > on, and what page size is selected?
> 
> I'm seeing a similar thing on PS3, but not in ext3. During early userspace
> setup (udevd), it crashes accessing a 0xc00* address in:
> 
> | NIP setup+0x20/0x130
> | LR copy_user_page+0x18/0x6c
> | Call trace:
> | do_wp_page+0x5b4/0x89c
> | do_page_fault+0x3a8/0x58c
> | handle_page_fault+0x20/0x5c
> 
> I have CONFIG_DEBUG_PAGEALLOC=y. If I disable it, the system boots fine.
> 
> If needed, I can probably bisect this tomorrow. It definitely didn't happen in
> 2.6.29-rc5.

No need to bisect - it was 25d6e2d7c58ddc4a3b614fc5381591c0cfe66556, my
commit that "optimised" 64bit memcpy() for Power6 and Cell.

The bug was in -rc1, but if your copies were 8-byte aligned with respect
to the source the problem wouldn't have been seen... Could this have
been why you didn't see it in -rc5?

I'll work on a fix now.

Thanks!

Mark
