From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: increase inode reference count after link
Date: Mon, 30 Jan 2017 22:48:52 -0500
Message-ID: <20170131034852.snc2xdfo26kg3icg@thunk.org>
References: <CAO3qy=EnXgiYPFDPkksSzGAaYms2KpNgAb55S_=GryJCRyhg5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47474 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750793AbdAaDs4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 22:48:56 -0500
Content-Disposition: inline
In-Reply-To: <CAO3qy=EnXgiYPFDPkksSzGAaYms2KpNgAb55S_=GryJCRyhg5A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 20, 2017 at 07:53:42PM +0300, Artem Blagodarenko wrote:
> Inode reference count is not increased after debugfs link command.
> This leads to inconsistent file system state.

That was deliberate.  Originally the "link" and "unlink" commands were
designed as a low-level command that didn't change the link count.
There are *many* commands in debugfs that can lead to inconsistent
file system state.  In fact, the original raison d'être of debugfs was
to create corrupted file systems to test e2fsck.  :-)

The "rm" command is user-friendly command that I added later which
decrements the link count and deallocates the blocks if the link count
goes to zero.

I never got around to adding a user-friendly 'ln' command which
creates the directory entry and also increments the link count.
That's mainly because no one has really needed or wanted that
functionality.  Or at least, no one has requested it up until now.

If you really want it, probably the best thing to do would be unalias
the "link" and "ln" commands, and make the "ln" command the
user-friendly command that works like the /bin/ln command.

Cheers,

						- Ted
