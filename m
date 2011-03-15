From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 13:08:27 -0400
Message-ID: <20110315170827.GH8120@thunk.org>
References: <4D7E7990.90209@cfl.rr.com>
 <4D7E7C7F.1040509@redhat.com>
 <4D7E8005.4030201@cfl.rr.com>
 <20110314215249.GE8120@thunk.org>
 <4D7EA83D.20400@cfl.rr.com>
 <20110315001448.GG8120@thunk.org>
 <4D7F7134.7080209@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57406 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390Ab1CORId (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2011 13:08:33 -0400
Content-Disposition: inline
In-Reply-To: <4D7F7134.7080209@cfl.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 15, 2011 at 10:01:24AM -0400, Phillip Susi wrote:
> On 3/14/2011 8:14 PM, Ted Ts'o wrote:
> > The reason why we have to traverse the directory tree in htree order
> > is because the POSIX requirements of how readdir() works in the face
> > of file deletes and creations, and what needs to happen if a leaf
> > block needs to be split.  Even if the readdir() started three months
> > ago, if in the intervening time, leaf nodes have been split, readdir()
> > is not allowed to return the same file twice.
> 
> This would also be fixed by having readdir() traverse the linear
> directory entries rather than the htree.

No, because the directory blocks are the leaf nodes, and in the case
of a node split, we need to copy half of the directory entries in one
block, and move it to a newly allocated block.  If readdir() was
traversing the linear directory entries, and had already traversed
that directory block that needs to split, then you'll return those
directory entries that got copied into a new leaf (i.e., new directory
block) a second time.

> > Well, if the file system has been around for a long time, and there
> > are lots of "holes" in the inode allocation bitmap, it can happen that
> > even without indexing.
> 
> Why is that?  Sure, if the inode table is full of small holes I can see
> them not being allocated sequentially, but why don't they tend to at
> least be allocated in ascending order?

Unless some files get deleted in between.  Now depending on the
"holes" in the directory blocks, where the new directory entries are
added, even in the non-htree case, could either be wherever an empty
directory entry could be found, or in the worst case, we might need to
allocate a new block and that new directory entry gets added to the
end of the block.

I suggest that you try some experiments, using both dir_index and
non-dir_index file systems, and then looking at the directory using
the debugfs "ls" and "htree_dump" commands.  Either believe me, or
learn how things really work.  :-)

> > As another example, if you have a large maildir directory w/o
> > indexing, and files get removed, deleted, etc., over time the order of
> > the directory entries will have very little to do with the inode
> > number.  That's why programs like mutt sort the directory entries by
> > inode number.
> 
> Is this what e2fsck -D fixes?  Does it rewrite the directory entries in
> inode order?  I've been toying with the idea of adding directory
> optimization support to e2defrag.

Yes, e2fsck -D will optimize directory entries, as best it can.  In
the non-dir_index case, it will sort the directory entries so they are
in inode order, and squeeze out "holes" in the directory blocks, thus
compatifying the directory.  In the dir_index case, it will optimize
the hash_tree of the directory as much as possible.

> To try and clarify this point a bit, are you saying that applications
> like tar and rsync should be patched to sort the directory by inode
> number, rather than it being the job of the fs to return entries in a
> good order?

That's correct.

I wish the file system could do this for the applications, but there
are some corner cases involving very large directories, and programs
that use readdir() but then stall for days, months, and years, that
make this very hard.

I suppose we could allocate up to some tunable amount worth of
directory space, say 64k or 128k, and do the sorting inside the
kernel.  We then have to live with the fact that each badly behaved
program which calls opendir(), and then a single readdir(), and then
stops, will consume 128k of non-swappable kernel memory until the
process gets killed.  A process which does this thousands of times
could potentially carry out a resource exhaustion attack on the
system.  Which we could then try to patch over, by say creating a new
resource limit of the number of directories a process can keep open at
a time, but then the attacker could just fork some additional child
processes....

If someone wants to try to solve this problem, patches that are clean
and which don't open up the kernel to a nasty DOS attack are welcome.

    	  	     	    	   - Ted

