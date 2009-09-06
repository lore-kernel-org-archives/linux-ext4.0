From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Fix counting routines in blknum.c to take/return __u32
	counts.
Date: Sun, 6 Sep 2009 14:19:44 -0400
Message-ID: <20090906181944.GN3055@mit.edu>
References: <4A9D9574.3010606@redhat.com> <20090902055953.GF4197@webber.adilger.int> <150c16850909012305y2481c54fra671b123780caa80@mail.gmail.com> <4A9EA09E.10509@redhat.com> <13135.1251925342@alphaville.usa.hp.com> <20090906163704.GK3055@mit.edu> <10552.1252258878@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Justin Maggard <jmaggard10@gmail.com>,
	Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46327 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107AbZIFSTt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Sep 2009 14:19:49 -0400
Content-Disposition: inline
In-Reply-To: <10552.1252258878@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 06, 2009 at 01:41:18PM -0400, Nick Dokos wrote:
> 
> Apologies for the breakage, but I invariably do "make check" and I got
> no failures on the "make check" step (log appended). I probably should
> have ported them to a 32-bit platform and tested there but I did not. Is
> that where the failures arose?

Yeah, my laptop is still using an x86 32-bit userspace.  One of these
days I'll update it to be 64-bit but for now it's nice for catching
these sorts of things.

						- Ted
