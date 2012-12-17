From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: m68k bitops fixes
Date: Mon, 17 Dec 2012 09:49:02 -0500
Message-ID: <20121217144902.GC31563@thunk.org>
References: <20685.53075.403265.997210@pilspetsen.it.uu.se>
 <20686.16276.932405.296864@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38876 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab2LQOtN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Dec 2012 09:49:13 -0500
Content-Disposition: inline
In-Reply-To: <20686.16276.932405.296864@pilspetsen.it.uu.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 16, 2012 at 10:39:32PM +0100, Mikael Pettersson wrote:
> Andreas Schwab suggested that there was no longer an advantage
> to using inline asm for these operations, so this new patch
> deletes the m68k-specific code from lib/ext2fs/bitops.h (leaving
> only 32-bit x86 to still use inline asm there).

Yep, agreed.  Thanks for the patch!  I've applied it in the e2fsprogs
maint branch.

It would be a good idea to check the m68k kernel, since it was cribbed
from the kernel sources.  I do agree though that it's unlikely to be a
problem in kernel code.

Thanks again!!

					- Ted
