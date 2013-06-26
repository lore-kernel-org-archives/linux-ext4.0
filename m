From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Memory allocation can cause ext4 filesystem to be remounted r/o
Date: Wed, 26 Jun 2013 10:54:17 -0400
Message-ID: <20130626145417.GB32092@thunk.org>
References: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
 <20130626140205.GE3875@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vikram MP <mp.vikram@gmail.com>, linux-ext4@vger.kernel.org
To: Nagachandra P <nagachandra@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33105 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab3FZOyW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 10:54:22 -0400
Content-Disposition: inline
In-Reply-To: <20130626140205.GE3875@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 26, 2013 at 10:02:05AM -0400, Theodore Ts'o wrote:
> 
> In this particular case, we could reflect the error all the way up to
> the ftruncate(2) system call.  Fixing this is going to be a bit
> involved, unfortunately; we'll need to update a fairly large number of
> function signatures, including ext4_truncate(), ext4_ext_truncate(),
> ext4_free_blocks(), and a number of others.

One thing that comes to mind.  If we change things so that ftruncate
reflects an ENOMEM error all the way up to userspace, one side effect
of this is that the file may be partially truncated when ENOMEM is
returned.  Applications may not be prepared for this.

There would be a similar issue if we do the truncate in the unlink
call and return ENOMEM in case of a failure, the file might not be
unlinked, and in fact we might have a partially truncated file in the
directory, which would probably cause all sorts of confusion.  So
we're probably better off, putting the inode on a list of inodes in
memory, and on the orphan list on disk, and then retry the truncation
when memory is available.  Messy, but that probably gives the best
result for applications living constantly in high memory pressure
environments.

							- Ted
