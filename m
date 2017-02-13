From: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] ext4: don't BUG when truncating encrypted inodes on the
 orphan list
Date: Mon, 13 Feb 2017 03:58:46 +0100
Message-ID: <CAOMGZ=GrnLVSX5xEzn5m4ASsiBhpWv8U8SL0im-xNway9pNktw@mail.gmail.com>
References: <20170211031942.11783-1-tytso@mit.edu> <CAOMGZ=FGDTY2p0r4G30=nGvCKVMG6n-JZfcREsys6Xa1Oiz9bg@mail.gmail.com>
 <20170213003137.u6xqaswur7gka325@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33110 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbdBMC6s (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Feb 2017 21:58:48 -0500
Received: by mail-wm0-f54.google.com with SMTP id t18so3553584wmt.0
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 18:58:48 -0800 (PST)
In-Reply-To: <20170213003137.u6xqaswur7gka325@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13 February 2017 at 01:31, Theodore Ts'o <tytso@mit.edu> wrote:
> As a wishlist item, it would be nice if your web reports included
> hotlinks from the addresses / symbol_name+offset to the git tree
> sources at the indicated line number.  For example:
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/ext4/inode.c?id=07f00f06ba9a5533d6650d46d3e938f6cbeee97e#n3738
>
> One of the crash dump analysis tool at $WORK does that, and it saves a
> huge amount of developer time.
>
> Anyway, at least for the ones where there is an explicit BUG_ON with a
> line number, I should revisit your reports to see if I might not be
> able clear out more of them.  (Is there a list of which ones are still
> valid?)
>
> But for ones where there is a stack trace without a BUG_INFO or
> WARN_ON to give me a line number, any chance you could use addr2line
> or otherwise make the kernel (with debugging information compiled in)
> available?

Those reports all include the hotlinks actually. The one for this problem was:

http://139.162.151.198/f/ext4/5bdefda69f39b2f2c56d9b67d5b7d9e2cc8dfd5f/

If you go to the stack trace then any line containing a kernel address
that can be addr2lined appears in green and clicking it should expand
a link to git.kernel.org. It does probably need javascript to work.

I'll get around to rerunning all the testcases soon on a recent kernel.


Vegard
