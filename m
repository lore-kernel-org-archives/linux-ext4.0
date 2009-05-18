From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext3/ext4 directories don't shrink after deleting lots of files
Date: Sun, 17 May 2009 23:21:50 -0400
Message-ID: <20090518032150.GE32019@mit.edu>
References: <1242338523.6933.664.camel@timo-desktop> <1b7401870905141732v43bd7321g1f0d9721b5e3f761@mail.gmail.com> <605A8D56-81CD-4775-8FCD-58CDB12CBA36@iki.fi> <20090517213335.GB32019@mit.edu> <alpine.DEB.1.10.0905171935310.32210@asgard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Timo Sirainen <tss@iki.fi>, Josef Bacik <josef@toxicpanda.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: david@lang.hm
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33326 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbZERDWE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 May 2009 23:22:04 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905171935310.32210@asgard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 17, 2009 at 07:49:09PM -0700, david@lang.hm wrote:
>> The constraints that we have is that for backwards compatibility's
>> sake, we can't support spares directories.  So if a block in the of
>
> s/spares/sparse/ ?

Yes, sorry "sparse"

>> Next, to handle the case where the empty directory block is *not* the
>> last block in the directory, what ext4_shrink_directory() can do is to
>> take the contents of the last directory block, and copy it to the
>> empty directory block, and then do the truncate operation.  In the
>> case of htree directories, the htree index blocks would also have to
>> be updated (both removing the index entry pointing to the empty
>> directory block, as well as updating the index entry which had been
>> pointing to the last directory block).
>
> I think this is more complex. I think you can't just move the last  
> directory block to one earlier because that would change the order of  
> things in the directory, messing up things that do a partial readdir of  
> the directory and then come back to pick up where they left off. you 
> would need to move all blocks after the empty up one.

For htree directories we can do this, because the iterate over the
directory in hash sort order, and moving the directory blocks around
doesn't change this.  For non-htree directories, you're right;
ext4_shrink_direcotry() would have to bail and not do anything if
there was a readdir() in progress for the directory in question.

> this sounds like something that's best implemented as a nighly cron job  
> (run similar to updatedb) to defrag the directory blocks. given changes  
> over the years to disk technology (both how much slower seeks have become 
> relative to sequential reads on rotating media, and how SSDs really have  
> much larger block sizes internally than what's exposed to users), it may  
> make sense to consider having a defrag tool for the data blocks as well.

Yes, that's the other way to do this; we could have an ioctl which
defrags a directory, and which will return an error if there is
another fd open on the directory (which would imply that there was a
readdir() in progress) and then do a complete defrag operation on the
directory.  It would have to be done in kernel space so the filesystem
wouldn't have to be unmounted.  Doing this all at once is more
efficient from an I/O perspective, but it's tricker to do in the
kernel because for very large directories, the method used in
e2fsck/rehash.c assumes you can allocate enough memory for all of the
directory entries all at once, which might not be true in the kernel,
since kernel memory can't be swapped or paged out.

Doing a little bit at a time means that we're O(1) in time/space for
each unlink operation.  Doing it all at once is O(n) in space, and for
very, *very* large directories that could be problematic.  It's not
impossible, but try sketching out the algorithm first.  You may find
it's more complicated than you first thought.

Regards,

					- Ted
