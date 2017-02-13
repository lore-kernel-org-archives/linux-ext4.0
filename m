From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't BUG when truncating encrypted inodes on the
 orphan list
Date: Sun, 12 Feb 2017 19:31:37 -0500
Message-ID: <20170213003137.u6xqaswur7gka325@thunk.org>
References: <20170211031942.11783-1-tytso@mit.edu>
 <CAOMGZ=FGDTY2p0r4G30=nGvCKVMG6n-JZfcREsys6Xa1Oiz9bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60472 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751131AbdBMAbl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 12 Feb 2017 19:31:41 -0500
Content-Disposition: inline
In-Reply-To: <CAOMGZ=FGDTY2p0r4G30=nGvCKVMG6n-JZfcREsys6Xa1Oiz9bg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 12, 2017 at 09:38:20AM +0100, Vegard Nossum wrote:
> You may consider adding a Reported-by: and/or a link to the previous discussion:
> 
> https://patchwork.ozlabs.org/patch/648817/

I'm trying to remember if you always included the git commit of the
kernel you were testing.  One of the reasons why I had trouble root
causes some of your crashes was because I wasn't able to map the
addresses back to line numbers.  I think I must have missed the git
commit ID, since I see you have historical information for all of
them in your reports.

In any case, what happened is for those reports that weren't caused by
superblock corruption (where you had provided the superblock dump), if
it wasn't immediately obvious from the stack trace, I eventually gave
up, because I had a finite amount of time and energy, and it was too
hard to figure out *where* in the source the kernel was actually
crashing.

As a wishlist item, it would be nice if your web reports included
hotlinks from the addresses / symbol_name+offset to the git tree
sources at the indicated line number.  For example:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/ext4/inode.c?id=07f00f06ba9a5533d6650d46d3e938f6cbeee97e#n3738

One of the crash dump analysis tool at $WORK does that, and it saves a
huge amount of developer time.

Anyway, at least for the ones where there is an explicit BUG_ON with a
line number, I should revisit your reports to see if I might not be
able clear out more of them.  (Is there a list of which ones are still
valid?)

But for ones where there is a stack trace without a BUG_INFO or
WARN_ON to give me a line number, any chance you could use addr2line
or otherwise make the kernel (with debugging information compiled in)
available?  

Thanks!!

					- Ted
