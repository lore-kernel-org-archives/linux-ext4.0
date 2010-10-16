From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext3: ext4: Using uninitialized value
Date: Sat, 16 Oct 2010 19:35:13 -0400
Message-ID: <20101016233513.GA31722@thunk.org>
References: <4CB5C4D6.3020201@nokia.com>
 <4CB5DAC3.3040605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Roman Borisov <ext-roman.borisov@nokia.com>,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Brad Spengler <spender@grsecurity.net>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38015 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784Ab0JPXfW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Oct 2010 19:35:22 -0400
Content-Disposition: inline
In-Reply-To: <4CB5DAC3.3040605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 13, 2010 at 11:13:55AM -0500, Eric Sandeen wrote:
> On 10/13/2010 09:40 AM, Roman Borisov wrote:
> > Hello,
> > 
> > Could you clarify is there a bug in fs/ext4/namei.c,
> > ext4_dx_find_entry() and fs/ext4/namei.c, ext3_dx_find_entry()?

Let me guess, you compiled the kernel using Clang, right?  I recently
had a similar discussion with Brad about this issue.

> here we should find the . or .. (it's always going to be there, right?)

The problem is if '.' or '..' is not present, then when we call
ext3_htree_next_block(), it's not the fact that hash is uninitialized
which is the problem.  The bigger problem is that the frame structure
is not fully initialized; and we could end up dereference a NULL
pointer (on a 32-bit system) or a pointer filled with stack garbage
(on a 64-bit system).

Fortunately most of the time we'll never hit this case, since '.'  and
'..' handling is dealt with in fs/namei.c, and is never passed down to
the fs-specific layer.  The one exception to this is if the file
system is being used as an NFS file server, in which case it is
possible that the fs layer will be asked to look up "..".

So in the case where the directory is corrupted, and the file system
is being exported via NFS, it's possible that we could get a kernel
Oops.  Since we're only reading from the garbaged pointer, I'm pretty
sure this can't be leveraged into a security exposure, but still, it
would be good to fix this.

I have patches chained to this e-mail that should be applied for
ext3, and which I've queued for ext4.

						- Ted
