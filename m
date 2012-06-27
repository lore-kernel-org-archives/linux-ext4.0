From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Minimal configuration for e2fsprogs
Date: Wed, 27 Jun 2012 08:54:43 -0400
Message-ID: <20120627125443.GA32356@thunk.org>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120627112117.GA15231@thor.bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53017 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab2F0Myt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 08:54:49 -0400
Content-Disposition: inline
In-Reply-To: <20120627112117.GA15231@thor.bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 27, 2012 at 09:21:17PM +1000, Tony Breeds wrote:
> 
> Calling perror/exit from this deep in a library doesn't seem right to me I
> think a better option would be to change rb_get_new_extent()
> to return an errcode_t and pass that up the call chain.  I'm happy to do
> that.  If I read rb_insert_extent() correctly I can simply return if
> rb_get_new_extent() failed, as nothing as been changed at this point
> you've only traversed the rb tree.  The problem is that very few of the
> callers of rb_insert_extent() actually check the return value :( so this
> patch will be a little bigger than I'd like.

Well, rb_insert_extent() isn't returning an error; it's returning
whether or not it needed to insert an extent or not.  And the bigger
problem is there's no way to return an error all the way up the
callchain, since it ultimately gets called by functions like
ext2fs_mark_block_bitmap() which never contemplated that the function
might fail.

So there really is no way to return an error at this point, and if you
fail allocating memory, we're kind of doomed anyway.  We could replace
this with an abort(), but there's really not much else we can do here.

I suppose, more generally, we could add a new callback which gets
called on memory allocation failures; although in practice, the place
where we are most likely to run into trouble is e2fsck, and we already
have sufficient debugging code there thanks to e2fsck/sigcatcher.c.
So maybe just using an abort() is the best approach for now.

> The qsort calls scare me a little.  I expect that bad things would
> happen if the directory block wasn't sorted.  So just providing a
> qsort() in yaboot that does nothing would be a bad thing.  I'm
> kind of hoping you'll just say "as long as you're opening the
> file-system read-only the directory block will be sorted so don't sweat
> it"  Am I dreaming?

So I believe the only place where the dblist.o file is getting dragged
in is due to the call to ext2fs_free_dblist() in freefs.c.  Can you
confirm this?

If so, probably the way to solve this is the via the same trick we do
with fs->write_bitmaps() --- see how we only call fs->write_bitmaps()
if it is defined in ext2fs_close2(); this was done precisely to avoid
dragging in the write_bitmaps code if it's not needed for programs
which are opening the file system read/only.

Regards,

						- Ted
