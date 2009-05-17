From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext3/ext4 directories don't shrink after deleting lots of files
Date: Sun, 17 May 2009 17:33:35 -0400
Message-ID: <20090517213335.GB32019@mit.edu>
References: <1242338523.6933.664.camel@timo-desktop> <1b7401870905141732v43bd7321g1f0d9721b5e3f761@mail.gmail.com> <605A8D56-81CD-4775-8FCD-58CDB12CBA36@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
	david@lang.hm, linux-ext4@vger.kernel.org
To: Timo Sirainen <tss@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37795 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbZEQVd5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 May 2009 17:33:57 -0400
Content-Disposition: inline
In-Reply-To: <605A8D56-81CD-4775-8FCD-58CDB12CBA36@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 08:45:38PM -0400, Timo Sirainen wrote:
> I was rather thinking something that I could run while the system was  
> fully operational. Otherwise just moving the files to a temp directory + 
> rmdir() + rename() would have been fine too.
>
> I just tested that xfs, jfs and reiserfs all shrink the directories  
> immediately. Is it more difficult to implement for ext* or has no one  
> else found this to be a problem?

I've sketched out a design that shouldn't be too hard to implement
that will address the problem which you've raised.  I'm not sure when
I will have to implement it, so in case there's an ext4 developer who
has time, I thought I would throw it out there.  For folks who are
looking for something simple to get started, perhaps after submitting
a few bug fixes or cleanups, this should be a fairly straight forward
project.

The constraints that we have is that for backwards compatibility's
sake, we can't support spares directories.  So if a block in the of
the directory becomes empty, we can't just unallocate it unless the it
is at the very end of the directory.  In addition, if htree support is
enabled, we also need to make sure the hash tree index is updated
remove the reference to the block we are about to remove.  Finally, if
journalling is enabled, we need to know in advance how many blocks the
unlink() operations will need to touch.

So the basic design is as follows.  We add a new parameter to
ext4_delete_entry(), which is a pointer to a new data structure,
ext4_dir_cleanup.  This it gets filled in with information about the
directory block containing the directory entry which was removed:
directory inode, logical and physical block number, the directory
index blocks if present, etc.  Then the callers of ext4_delete_entry()
(ext4_rmdir, ext4_rename, and ext4_unlink) take that information ad
pass it another function which takes tries to shrink the directory ---
but this function gets called *after* the call to ext4_journal_stop().
That way we don't have to change any of the journal accounting credits
and the ext4_shrink_directory() function is does purely optional work.

At least initially, the ext4_shrink_directory() might only do
something useful if the last directory block in the directory is
empty, and htree is not enabled; in that case, it can just simply
truncate the last block, and return.   

The next step would be to teach ext4_shrink_directory() how to handle
removing the last directory block for htree directories; this means
that it will need to find the the entry in the htree index block, and
remove the entry in the htree index.

Next, to handle the case where the empty directory block is *not* the
last block in the directory, what ext4_shrink_directory() can do is to
take the contents of the last directory block, and copy it to the
empty directory block, and then do the truncate operation.  In the
case of htree directories, the htree index blocks would also have to
be updated (both removing the index entry pointing to the empty
directory block, as well as updating the index entry which had been
pointing to the last directory block).

Finally, ext4_shrink_directory() could be taought how to take an
*almost* empty directory block, and attempts to move the directory
entries to the previous and/or next directory block.

The basic idea is that ext4_shrink_directory() could be implemented
and tested incrementally, with at each stage it becoming more
aggressive about being able to shrink directories.

Anyway, if there's someone interested in trying to implement this,
give me a holler; I'd be happy to give more details as necessary.

     	  	      	       	  	- Ted
