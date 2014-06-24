From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Tue, 24 Jun 2014 23:03:32 +0100 (BST)
Message-ID: <alpine.LFD.2.11.1406242251230.23403@eddie.linux-mips.org>
References: <20140403191558.GA8745@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: T Makphaibulchoke <tmac@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eddie.linux-mips.org ([78.24.191.182]:34538 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaFXWDf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jun 2014 18:03:35 -0400
Received: from localhost.localdomain ([127.0.0.1]:53380 "EHLO
        localhost.localdomain" rhost-flags-OK-OK-OK-OK)
        by eddie.linux-mips.org with ESMTP id S6816503AbaFXWDcJFKty (ORCPT
        <rfc822;linux-ext4@vger.kernel.org> + 1 other);
        Wed, 25 Jun 2014 00:03:32 +0200
In-Reply-To: <20140403191558.GA8745@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 3 Apr 2014, Theodore Ts'o wrote:

>       fs/mbcache.c: doucple the locking of local from global data

 This change causes breakage:

fs/built-in.o: In function `__mb_cache_entry_release':
mbcache.c:(.text+0x56b3c): undefined reference to `log2'
mbcache.c:(.text+0x56b3c): relocation truncated to fit: R_MIPS_26 against `log2'
mbcache.c:(.text+0x56b74): undefined reference to `__fixunsdfsi'
mbcache.c:(.text+0x56b74): relocation truncated to fit: R_MIPS_26 against `__fixunsdfsi'
mbcache.c:(.text+0x56be4): undefined reference to `log2'
mbcache.c:(.text+0x56be4): relocation truncated to fit: R_MIPS_26 against `log2'
mbcache.c:(.text+0x56bf0): undefined reference to `__fixunsdfsi'
mbcache.c:(.text+0x56bf0): relocation truncated to fit: R_MIPS_26 against `__fixunsdfsi'

and so on, and so on.  It uses __builtin_log2() that is a floating-point 
function, its corresponding <math.h> prototype is:

 -- Function: double log2 (double X)

(GCC builtins are of course implicitly prototyped).  Please note that 
floating-point calculations are not allowed in the kernel and relying on 
the compiler to optimise them away is risky to say the least.

 Can you please rewrite the fragment using __builtin_log2() so as to avoid 
the floating-point calculation, using ffs() or suchlike perhaps?

  Maciej
