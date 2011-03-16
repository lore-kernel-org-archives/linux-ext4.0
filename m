From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 21:50:21 -0400
Message-ID: <20110316015021.GK8120@thunk.org>
References: <4D7E7990.90209@cfl.rr.com>
 <4D7E7C7F.1040509@redhat.com>
 <4D7E8005.4030201@cfl.rr.com>
 <20110314215249.GE8120@thunk.org>
 <4D7EA83D.20400@cfl.rr.com>
 <20110315001448.GG8120@thunk.org>
 <4D7F7134.7080209@cfl.rr.com>
 <20110315170827.GH8120@thunk.org>
 <4D7FB945.1070209@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43041 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab1CPBu2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2011 21:50:28 -0400
Content-Disposition: inline
In-Reply-To: <4D7FB945.1070209@cfl.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 15, 2011 at 03:08:53PM -0400, Phillip Susi wrote:
> 
> When you split the htree node, aren't you just moving around the
> "deleted entries"?  So the normal names remain in the same order so
> readdir() doesn't have a problem when it is ignoring the htree entries
> and just walking the normal names?

No, because the leaf entries of the htree are the actual directory
entries in the directory block.

> Why was the htree hidden inside the normal directory structure anyway?

So that we had full backwards compatibility with ext2.  I had planned
this feature in advance, and ext2 (and pre-htree ext3 implementations)
would clear the htree flag if they tried to modify an htree directory.
Since the leaf nodes (which are the ones that get split) are normal
directory blocks, and interior nodes of the tree are directory blocks
that have what appears to ext2 to be a deleted directory entry
covering the entire block, it's fully backwards compatible with
ext2/older ext3 systems.

> > Unless some files get deleted in between.  Now depending on the
> > "holes" in the directory blocks, where the new directory entries are
> > added, even in the non-htree case, could either be wherever an empty
> > directory entry could be found, or in the worst case, we might need to
> > allocate a new block and that new directory entry gets added to the
> > end of the block.
> 
> Right, but on an otherwise idle system, when you make all the files at
> once via rsync or untaring an archive, this shouldn't happen and they
> should be ( generally ) in ascending order, shouldn't they?

If the directory is freshly created, yes.  But over time, if you are
adding and deleting files, such as a Maildir directory, this will not
be the case forever.

> > I suggest that you try some experiments, using both dir_index and
> > non-dir_index file systems, and then looking at the directory using
> > the debugfs "ls" and "htree_dump" commands.  Either believe me, or
> > learn how things really work.  :-)
> 
> Now THAT sounds interesting.  Is this documented somewhere?

The debugfs man page has some documentation.

> Also, why can't chattr set/clear the 'I' flag?  Is it just a runtime
> combersome thing?  So setting and clearing the flag with debugfs
> followed by a fsck should do the trick?  And when is it automatically
> enabled?

You can't clear the 'I' flag because I didn't want to bother getting
the locking right so that it would be safe.  And turning off the 'I'
flag isn't going to help, since the directory entries are scrambled
anyway --- again, because the leaf nodes of the htree *are* normal
directory blocks.  Turning the 'I' flag on would require reindexing
the whole directory, which would be a major headache.  You'd have to
lock out all directory accesses, and then do a full copy operation ---
and remember, a directory could be potentially many megabytes, and
kernel memory is non-swappable.

> I think you are right in that if sorting is to be done at
> opendir()/readdir() time, then it should be done in libc, not the
> kernel, but it would be even better if the fs made some effort store the
> entries in a good order so no sorting is needed at all.

The problem is that we have to store them in hash tree order so the
lookups happen correctly.  We could have done what JFS does, which is
to keep three separate b-trees for its directories, and where every
single time you add or modify a file, you have to update multiple
btrees.  But, (a) this would have required an non-backwards compatible
file system format change from ext2/older ext3 file systems, and (b)
the extra b-trees updates are their own source of overhead.

    	  	  	      	    	       - Ted
