From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] lib/ext2fs: Add ext2fs_symlink
Date: Sat, 22 Dec 2012 23:33:53 -0500
Message-ID: <20121223043353.GE12563@thunk.org>
References: <ff54dc35c816ae53f149f2f032c12147deac8508.1355971726.git.dvhart@infradead.org>
 <40709903834127afbb1f6eda82cf50c292b3f97c.1355971726.git.dvhart@infradead.org>
 <20121220215154.GB10770@blackbox.djwong.org>
 <50D4984F.2000909@infradead.org>
 <20121221211118.GC4878@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Darren Hart <dvhart@infradead.org>, linux-ext4@vger.kernel.org,
	adilger@dilger.ca, sgw@linux.intel.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39958 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab2LWEeC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Dec 2012 23:34:02 -0500
Content-Disposition: inline
In-Reply-To: <20121221211118.GC4878@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 21, 2012 at 01:11:18PM -0800, Darrick J. Wong wrote:
> > >> --- a/lib/ext2fs/ext2_err.et.in
> > >> +++ b/lib/ext2fs/ext2_err.et.in
> > >> @@ -248,6 +248,9 @@ ec	EXT2_ET_DB_NOT_FOUND,
> > >>  ec	EXT2_ET_DIR_EXISTS,
> > >>  	"Ext2 directory already exists"
> > >>  
> > >> +ec	EXT2_ET_FILE_EXISTS,
> > >> +	"Ext2 file already exists"
> > >> +
> > >>  ec	EXT2_ET_UNIMPLEMENTED,
> > >>  	"Unimplemented ext2 library function"

Error codes have to be added at the end of the error table.  Otherwise
you end up changing the numbers assigned to the error codes, and it
would be like renumbering EINVAL, EAGAIN, etc.  It's part of the ABI
that we don't want to break.

> > >> +#ifndef EXT2_FT_SYMLINK
> > >> +#define EXT2_FT_SYMLINK		7
> > >> +#endif
> > > 
> > > Is this ever /not/ defined?  ext2_fs.h should always define this, right?
> > 
> > I thought the same thing, but I'm following convention here from mkdir.c.
> 
> <shrug> Was hoping Ted or anyone else could comment on this and the next bit...

This was needed a decade or more ago, back when used to include
ext2_fs.h from the kernel headers in /usr/include/linux.

We can remove it from mkdir.c, too.

> > >> +
> > >> +	ext2fs_inode_alloc_stats2(fs, ino, +1, 1);
> > > 
> > > You know, I've always wondered about why there are unary plus scattered
> > > throughout calls to this function in e2fsprogs.
> > 
> > Me too :-) Again, just following convention.

It's to make it easier to understand what is going on.  The inuse
parameter can be either -1 or +1.  If I was redoing this interface
from scratch today, I'd have done something like this:

void ext2fs_alloc_stats(ext2_filsys fs, ext2_ino_t ino, int flags);

#define EXT2FS_ALLOC_STATS_ALLOC_FL	0x0000
#define EXT2FS_ALLOC_STATS_DEALLOC_FL	0x0001
#define EXT2FS_ALLOC_STATS_DIR_FL	0x0002

Oh, well.... legacy....

> > >> +	/*
> > >> +	 * Create the inode structure....
> > >> +	 */
> > >> +	memset(&inode, 0, sizeof(struct ext2_inode));
> > >> +	inode.i_mode = LINUX_S_IFLNK | 0777;
> > >> +	inode.i_uid = inode.i_gid = 0;
> > >> +	/* FIXME: set the time fields */
> > > 
> > > Are you going to fix this? :)
> > 
> > It is an open question as to what they should be initialized to. Should
> > the current time be used? Should a fixed time be used for all of a
> > debugfs (or similar) session? This strikes me as a policy decision which
> > I was hoping to leave to the maintainers to dictate (at which point I
> > would implement it).

Nothing is needed here.  The time fields are set by ext2fs_write_new_inode(), 
as you've already noted.

> (I'm having trouble grokking why
> you'd want to set all the symlink times to a fixed value...) 

The reason for fs->now is so that if we are creating file systems for
the regression test suite; see the use of debugfs's command
set_current_time in tests/f_dup4/script, for example.

> > >> +		inode.i_size = (target_len % fs->blocksize) ?
> > >> +		               target_len + (fs->blocksize - target_len) : target_len;
> > > 
> > > Shouldn't this just be i_size = target_len?

Yup.

> > > Come to think of it, ext4 (kernel) doesn't seem to allow slow symlinks to have
> > > a target longer than $blocksize.  

Yes.  We need to add a check for this.

> > > I think the rest looks more or less ok, barring the 80 char overflows that I
> > > think is happening on the ext2fs_file_write line.
> > 
> > 
> > I'm happy to enforce 80 chars if that is the preferred coding style.
> > There were many instances where the existing code went beyond 80, so I
> > wasn't sure what was preferred and was trying my best to follow convention.

For new code, yes, we should try to keep things to 80 characters,
unless it really makes things harder to read.  Usually there was a
good reason why the rules were bent....


One other thing which I noted when I looked at the patch.  You need
make the cleanup code do the right thing if we get an error half-way
through the operation.  That's one of the reasons why we do the link
at the very end of the ext2fs_mkdir(), and why we allocate the block
by hand and either set i_block[0] by hand, or use
ext2fs_extent_set_bmap(), instead of using the ext2fs_file_*
operations; it makes the code easier to unwind in case of errors.

Basically, if we fail while we are writing the new directory block,
it's no big deal, since we are writing into an unallocated block.  We
save the call to ext2fs_link() for the very last, since that's the
call which is more work to unwind.

     	    	  	       	       	    - Ted
