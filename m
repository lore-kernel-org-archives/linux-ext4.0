From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Race affecting superblock buffer_head
Date: Wed, 2 Apr 2014 10:37:04 -0400
Message-ID: <20140402143703.GB6901@thunk.org>
References: <20140402140757.GE5667@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49055 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbaDBOh2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2014 10:37:28 -0400
Content-Disposition: inline
In-Reply-To: <20140402140757.GE5667@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 02, 2014 at 10:07:57AM -0400, Matthew Wilcox wrote:
> Looking forther down the call stack, this call to ext4_commit_super()
> comes via __ext4_abort's call to save_error_info() which calls
> ext4_commit_super().  I've had a good look around, and I can't see any
> locking that prevents ext4_commit_super() from being called in parallel
> with ... well, anything else.

Ext4_commit_super() only gets called:

* When mounting and unmounting the file system (where the code path
	has exclusive access to the superblock)
* When remounting the file system read-only
* When reporting an error

So what you're probably seeing is a case where we have multiple cpu's
calling some form of ext4_error* in parallel, and indeed there is
nothing prevent us from trying to update the superblock and calling
ext4_commit_super() in parallel.

We'll need to be careful because at the moment we don't make any
assumptions about any mutexes being locked --- or not locked --- when
we call into ext4_error().

Since this is happening on the error paths, and these are just
warnings, it's not a disaster.  But we really should do something to
clean up the warning, and the fact that we aren't being careful about
what happens if two CPU's are trying to update the s_last_error_*
information might mean that the information that we get back is
misleading, so this is something we should fix.

Thanks for pointing this out!

					- Ted
