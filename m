From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] ext4: Fix memory leak in groupinfo cache name
Date: Mon, 22 Nov 2010 11:05:09 -0600
Message-ID: <1290445509.10595.105.camel@calx>
References: <1290376931-2129-1-git-send-email-zeng.zhaoming@freescale.com>
	 <1290376931-2129-2-git-send-email-zeng.zhaoming@freescale.com>
	 <4CEA1208.4060005@cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: zeng.zhaoming@freescale.com, linux-ext4@vger.kernel.org,
	tytso@mit.edu, adilger.kernel@dilger.ca, rientjes@google.com,
	Zeng Zhaoming <zengzm.kernel@gmail.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from waste.org ([173.11.57.241]:37873 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab0KVRFN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Nov 2010 12:05:13 -0500
In-Reply-To: <4CEA1208.4060005@cs.helsinki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2010-11-22 at 08:47 +0200, Pekka Enberg wrote:
> On 11/22/10 12:02 AM, zeng.zhaoming@freescale.com wrote:
> > From: Zeng Zhaoming<zengzm.kernel@gmail.com>
> >
> > please check the discuss with allocator guys.
> > http://marc.info/?l=linux-kernel&m=129004890020256&w=2
> >
> > Get a memory leak about ext4:
> >    comm "mount", pid 1159, jiffies 4294904647 (age 6077.804s)
> >    hex dump (first 32 bytes):
> >      65 78 74 34 5f 67 72 6f 75 70 69 6e 66 6f 5f 31  ext4_groupinfo_1
> >      30 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  0.kkkkkkkkkkkkk.
> >    backtrace:
> >      [<c068ade3>] kmemleak_alloc+0x93/0xd0
> >      [<c024e54c>] __kmalloc_track_caller+0x30c/0x380
> >      [<c02269d3>] kstrdup+0x33/0x60
> >      [<c0318a70>] ext4_mb_init+0x4e0/0x550
> >      [<c0304e0e>] ext4_fill_super+0x1e6e/0x2f60
> >      [<c0261140>] mount_bdev+0x1c0/0x1f0
> >      [<c02fc00f>] ext4_mount+0x1f/0x30
> >      [<c02603d8>] vfs_kern_mount+0x78/0x250
> >      [<c026060e>] do_kern_mount+0x3e/0x100
> >      [<c027b4c2>] do_mount+0x2e2/0x780
> >      [<c027ba04>] sys_mount+0xa4/0xd0
> >      [<c010429f>] sysenter_do_call+0x12/0x38
> >      [<ffffffff>] 0xffffffff
> >
> > ext4 allocate memory for cache name by:
> >      namep = kstrdup(name, GFP_KERNEL);
> > and reclaim it by:
> >      name = kmem_cache_name(cache);
> >      kfree(name)
> >
> > This is ok if allocator only reference to the cache name memory, and return
> > the name memory pass to kmem_cache_create() by kmem_cache_name();
> > But not true in slub, when using slub, memory leak and double free error appears.
> >
> > In this patch, we track the cache name memory in ext4, rather than allocator.
> >
> > Signed-off-by: Zeng Zhaoming<zengzm.kernel@gmail.com>
> > ---
> 
> Hmm. Maybe it's better to change SLAB and SLOB to do kstrdup() 
> internally so we can drop it from ext4 code. Matt, are you OK with that?

If we drop the kmem_cache_name interface, then SLOB can drop tracking
the name entirely.

-- 
Mathematics is the supreme nostalgia of our time.


