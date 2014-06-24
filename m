From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Wed, 25 Jun 2014 00:25:51 +0100 (BST)
Message-ID: <alpine.LFD.2.11.1406250018180.23403@eddie.linux-mips.org>
References: <20140403191558.GA8745@thunk.org> <alpine.LFD.2.11.1406242251230.23403@eddie.linux-mips.org> <53A9FE04.2000306@hp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: T Makphaibulchoke <tmac@hp.com>, Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Received: from localhost.localdomain ([127.0.0.1]:53617 "EHLO
        localhost.localdomain" rhost-flags-OK-OK-OK-OK)
        by eddie.linux-mips.org with ESMTP id S6855799AbaFXXZv0ZsnK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org> + 1 other);
        Wed, 25 Jun 2014 01:25:51 +0200
In-Reply-To: <53A9FE04.2000306@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 24 Jun 2014, Thavatchai Makphaibulchoke wrote:

> >  This change causes breakage:
> > 
> > fs/built-in.o: In function `__mb_cache_entry_release':
> > mbcache.c:(.text+0x56b3c): undefined reference to `log2'
> > mbcache.c:(.text+0x56b3c): relocation truncated to fit: R_MIPS_26 against `log2'
> > mbcache.c:(.text+0x56b74): undefined reference to `__fixunsdfsi'
> > mbcache.c:(.text+0x56b74): relocation truncated to fit: R_MIPS_26 against `__fixunsdfsi'
> > mbcache.c:(.text+0x56be4): undefined reference to `log2'
> > mbcache.c:(.text+0x56be4): relocation truncated to fit: R_MIPS_26 against `log2'
> > mbcache.c:(.text+0x56bf0): undefined reference to `__fixunsdfsi'
> > mbcache.c:(.text+0x56bf0): relocation truncated to fit: R_MIPS_26 against `__fixunsdfsi'
> > 
> > and so on, and so on.  It uses __builtin_log2() that is a floating-point 
> > function, its corresponding <math.h> prototype is:
> > 
> >  -- Function: double log2 (double X)
> > 
> > (GCC builtins are of course implicitly prototyped).  Please note that 
> > floating-point calculations are not allowed in the kernel and relying on 
> > the compiler to optimise them away is risky to say the least.
> > 
> >  Can you please rewrite the fragment using __builtin_log2() so as to avoid 
> > the floating-point calculation, using ffs() or suchlike perhaps?
> > 
> >   Maciej
> > 
> 
> Sorry and thanks for notifying me about the problem.
> 
> I've submitted the fix, using ilog2, and could be found at,
> 
> https://lkml.org/lkml/2014/5/30/462
> 
> Please let me know if you have any comment.

 Thanks, that's even better, and the kernel builds and boots.  I saw no 
trace of your proposal going anywhere so I gave it my `Reviewed-by' tag in 
case that helps.

  Maciej
