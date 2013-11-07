From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 01/11] rbtree: Fix
 rbtree_postorder_for_each_entry_safe() iterator
Date: Thu, 7 Nov 2013 23:14:46 +0100
Message-ID: <20131107221446.GA2054@quack.suse.cz>
References: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
 <1383788572-25938-2-git-send-email-cody@linux.vnet.ibm.com>
 <20131107133800.c779b2f2b2ec73c91cd25f47@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>,
	EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org, Seth Jennings <sjenning@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367Ab3KGWOu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Nov 2013 17:14:50 -0500
Content-Disposition: inline
In-Reply-To: <20131107133800.c779b2f2b2ec73c91cd25f47@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-11-13 13:38:00, Andrew Morton wrote:
> On Wed,  6 Nov 2013 17:42:30 -0800 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
> 
> > The iterator rbtree_postorder_for_each_entry_safe() relies on pointer
> > underflow behavior when testing for loop termination. In particular
> > it expects that
> >   &rb_entry(NULL, type, field)->field
> > is NULL. But the result of this expression is not defined by a C standard
> > and some gcc versions (e.g. 4.3.4) assume the above expression can never
> > be equal to NULL. The net result is an oops because the iteration is not
> > properly terminated.
> > 
> > Fix the problem by modifying the iterator to avoid pointer underflows.
> 
> So the sole caller is in zswap.c.  Is that code actually generating oopses?
  Oh, I didn't know there is any user of that iterator already in tree. Let
me check... Umm, looking at the disassembly of
zswap_frontswap_invalidate_aread:
   0xffffffff8112c9a5 <+37>:	mov    %r13,%rdi
   0xffffffff8112c9a8 <+40>:	callq  0xffffffff81227620 <rb_first_postorder>
   0xffffffff8112c9ad <+45>:	mov    %rax,%rdi
   0xffffffff8112c9b0 <+48>:	mov    %rax,%rbx
   0xffffffff8112c9b3 <+51>:	callq  0xffffffff812275d0 <rb_next_postorder>
   0xffffffff8112c9b8 <+56>:	mov    %rax,%r12
   0xffffffff8112c9bb <+59>:	nopl   0x0(%rax,%rax,1)
   0xffffffff8112c9c0 <+64>:	mov    0x28(%rbx),%rsi
   0xffffffff8112c9c4 <+68>:	mov    0x40(%r13),%rdi
   0xffffffff8112c9c8 <+72>:	callq  0xffffffff811352b0 <zbud_free>
   0xffffffff8112c9cd <+77>:	mov    0x1105504(%rip),%rdi
   0xffffffff8112c9d4 <+84>:	mov    %rbx,%rsi
   0xffffffff8112c9d7 <+87>:	callq  0xffffffff81130b80 <kmem_cache_free>
   0xffffffff8112c9dc <+92>:	lock decl 0x110539d(%rip)
   0xffffffff8112c9e3 <+99>:	mov    %r12,%rdi
   0xffffffff8112c9e6 <+102>:	mov    %r12,%rbx
   0xffffffff8112c9e9 <+105>:	callq  0xffffffff812275d0 <rb_next_postorder>
   0xffffffff8112c9ee <+110>:	mov    %rax,%r12
   0xffffffff8112c9f1 <+113>:	jmp 0xffffffff8112c9c0 <zswap_frontswap_invalidate_area+64>

So my gcc helpfully compiled that iterator into an endless loop as well,
although now it is a perfectly valid C code.  According to our gcc guys
that was a bug in some gcc versions which is already fixed.  But anyway
pushing my patch to 3.12 or anything that actually uses that iterator will
probably save us some bug reports.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
