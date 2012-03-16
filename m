From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: Oops in ext3_block_to_path.isra.40+0x26/0x11b
Date: Fri, 16 Mar 2012 10:29:56 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1203161028420.18356@pobox.suse.cz>
References: <20120313133945.4642.qmail@science.horizon.com> <20120316085231.GA24821@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: George Spelvin <linux@horizon.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759361Ab2CPJ36 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Mar 2012 05:29:58 -0400
In-Reply-To: <20120316085231.GA24821@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 16 Mar 2012, Jan Kara wrote:

> > CPU is a Core i3 530, on a Gigabyte motherbord, 4 GB RAM.  No ECC,
> > unfortunately, so I can't rule out hardware bit rot.  Distribution is
> > a fairly stock Debian/unstable.
>   Hmm, is any mounting & unmounting happening during your backup? Because
> the oops happened because sb->s_fs_info was NULL. Dissassembly shows:
>   16:	48 8b 47 18          	mov    0x18(%rdi),%rax
> store sb->s_blocksize into RAX
>   1a:	48 8b 8f b0 02 00 00 	mov    0x2b0(%rdi),%rcx
> store sb->s_fs_info into RCX
>   21:	48 c1 e8 02          	shr    $0x2,%rax
> This is division from EXT3_ADDR_PER_BLOCK() - RAX carries 1024 after
> division so that looks correct.
> 
>   25:	48 85 db             	test   %rbx,%rbx
> Now check passed i_block argument.
> 
>   28:	41 89 c4             	mov    %eax,%r12d
>   2b:*	8b b1 94 00 00 00    	mov    0x94(%rcx),%esi     <-- trapping ins
> Try to get RCX->s_addr_per_block_bits...
> 
>  sb->s_fs_info is set when a superblock is mounted and cleared when
> superblock gets unmounted and otherwise it is never changed. So most likely
> it was some memory corruption clearing that pointer (I wouldn't really
> suspect HW here).
> 
> It somewhat looks like the issue described here:
> http://lkml.indiana.edu/hypermail/linux/kernel/1202.3/00132.html
> 
> Although there we had f_path.dentry (completely different structure) being
> NULL. But similarity here is that something stomped NULL over our existing
> structure.
> 
> Linus, Jiri, that bug didn't get resolved, did it?

I am not aware of anything, but I have a question -- George, did the 
machine get suspended/resumed before this happened?

-- 
Jiri Kosina
SUSE Labs
