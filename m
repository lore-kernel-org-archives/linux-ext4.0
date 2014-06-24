From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Tue, 24 Jun 2014 16:39:00 -0600
Message-ID: <53A9FE04.2000306@hp.com>
References: <20140403191558.GA8745@thunk.org> <alpine.LFD.2.11.1406242251230.23403@eddie.linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Maciej W. Rozycki" <macro@linux-mips.org>,
	T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t2352.austin.hp.com ([15.217.128.51]:54317 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaFXWjV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2014 18:39:21 -0400
In-Reply-To: <alpine.LFD.2.11.1406242251230.23403@eddie.linux-mips.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/24/2014 04:03 PM, Maciej W. Rozycki wrote:
> On Thu, 3 Apr 2014, Theodore Ts'o wrote:
> 
>>       fs/mbcache.c: doucple the locking of local from global data
> 
>  This change causes breakage:
> 
> fs/built-in.o: In function `__mb_cache_entry_release':
> mbcache.c:(.text+0x56b3c): undefined reference to `log2'
> mbcache.c:(.text+0x56b3c): relocation truncated to fit: R_MIPS_26 against `log2'
> mbcache.c:(.text+0x56b74): undefined reference to `__fixunsdfsi'
> mbcache.c:(.text+0x56b74): relocation truncated to fit: R_MIPS_26 against `__fixunsdfsi'
> mbcache.c:(.text+0x56be4): undefined reference to `log2'
> mbcache.c:(.text+0x56be4): relocation truncated to fit: R_MIPS_26 against `log2'
> mbcache.c:(.text+0x56bf0): undefined reference to `__fixunsdfsi'
> mbcache.c:(.text+0x56bf0): relocation truncated to fit: R_MIPS_26 against `__fixunsdfsi'
> 
> and so on, and so on.  It uses __builtin_log2() that is a floating-point 
> function, its corresponding <math.h> prototype is:
> 
>  -- Function: double log2 (double X)
> 
> (GCC builtins are of course implicitly prototyped).  Please note that 
> floating-point calculations are not allowed in the kernel and relying on 
> the compiler to optimise them away is risky to say the least.
> 
>  Can you please rewrite the fragment using __builtin_log2() so as to avoid 
> the floating-point calculation, using ffs() or suchlike perhaps?
> 
>   Maciej
> 

Sorry and thanks for notifying me about the problem.

I've submitted the fix, using ilog2, and could be found at,

https://lkml.org/lkml/2014/5/30/462

Please let me know if you have any comment.

Thanks,
Mak.



