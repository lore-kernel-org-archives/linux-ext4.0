From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Memory allocation can cause ext4 filesystem to be remounted r/o
Date: Wed, 26 Jun 2013 10:02:05 -0400
Message-ID: <20130626140205.GE3875@thunk.org>
References: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vikram MP <mp.vikram@gmail.com>, linux-ext4@vger.kernel.org
To: Nagachandra P <nagachandra@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33084 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab3FZOCK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 10:02:10 -0400
Content-Disposition: inline
In-Reply-To: <CAFy9=U5n-YF017L+gni4v8pgq-AsLVTZBLwaZhPjHJCMXzLLag@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 25, 2013 at 02:55:33PM +0530, Nagachandra P wrote:
> 
> Here are some details on the platform
> 
> Linux kernel version - 3.4.5
> Android - 4.2.2
> ext4 mounted with *errors=panic* option.
> 
> We see memory allocation failures mostly caused by low memory kill the
> ext4 process which is waiting for a allocation on slow path. (below is
> one such instance)
>
> Is there a way in which we could avoid ext4 panic caused by allocation
> failure (a method other than setting errors=continue :-) )? (or is
> memory allocation failure considered as fatal as any other IO error)

In this particular case, we could reflect the error all the way up to
the ftruncate(2) system call.  Fixing this is going to be a bit
involved, unfortunately; we'll need to update a fairly large number of
function signatures, including ext4_truncate(), ext4_ext_truncate(),
ext4_free_blocks(), and a number of others.

One of the problems is that there are code paths, such as ext4's
evict_inode() call, where there is the potential that if there was a
file descriptor holding the inode open at the time when it was
unlinked, we can only delete the file (which involves a call to
ext4_truncate) in ext4_evict_inode(), and there isn't a good error
recovery path in that case.

Probably the best short-term fix for now is to add a flag used by
ext4_free_blocks() which retries the memory allocation in a loop (see
the retry_alloc loop in jbd2_journal_write_metadata_buffer() in
fs/jbd2/journal.c) and then initially add this flag to all of the
callers of ext4_free_blocks().

We'll then need to fix the various callers where we can reflect the
error back to userspace to do so, and then drop the flag.  In the case
of ext4_evict_inode(), what we can do is to call ext4_truncate() inode
truncation in the unlink() system call if there are no other file
descriptors keeping the inode from being deleted immediately.

	    	    	      	   	 - Ted
