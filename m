From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Does ext4 write anything during reading with relatime?
Date: Mon, 7 Dec 2015 18:19:13 -0500
Message-ID: <20151207231913.GA3094@thunk.org>
References: <5662C472.2050902@inbox.ru>
 <20151206211454.GB2614@thunk.org>
 <5665FD3D.1050603@inbox.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: The Ghost <the-ghost@inbox.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44215 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555AbbLGXTP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Dec 2015 18:19:15 -0500
Content-Disposition: inline
In-Reply-To: <5665FD3D.1050603@inbox.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 08, 2015 at 12:42:21AM +0300, The Ghost wrote:
> 
> I just tried again. With relatime or noatime, the second drive spins up.
> Always. With read-only, it never spins up. And that doesn't make sense...

The superblock *does* get modified at mount time to update the last
mount time and the mount count in the superblock.  But I've tested
using blktrace, and that's the only write I see after copying in a set
of test files, reading them (so that atime > mtime), and then
umounting the file system.  I then started the blktrace, mounted the
file system, and read all of the files using "tar cvzf /tmp/foo.tar.gz /mnt".

Cheers,

						- Ted
