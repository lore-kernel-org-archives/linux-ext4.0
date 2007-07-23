From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Request for direction on changes required in e2fsprog.
Date: Mon, 23 Jul 2007 09:49:02 -0500
Message-ID: <20070723094902.3b9b41a0@rx8>
References: <20070720112549.3deb6e36@gara>
	<20070723133250.GB19927@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45802 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbXGWOus (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2007 10:50:48 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6NEojxd002107
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jul 2007 10:50:45 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6NEojF0529904
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jul 2007 10:50:45 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6NEojEX009838
	for <linux-ext4@vger.kernel.org>; Mon, 23 Jul 2007 10:50:45 -0400
In-Reply-To: <20070723133250.GB19927@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 23 Jul 2007 09:32:50 -0400
Theodore Tso <tytso@mit.edu> wrote:

> I've cc'ed the linux-ext4 mailing list since a lot of this is about
> code cleanliness and coding style of e2fsprogs.  Yes, some of this
> probably should be written up in Documentation/CodingStyle file in
> e2fsprogs, since in general it's much like the kernel CodingStyle,
> except that I care a lot more about ABI and API backwards
> compatibility, since e2fsprogs exports a userspace shared library.
> 
> 	       	     	       	       	 	   -
> Ted
> 
> On Fri, Jul 20, 2007 at 11:25:49AM -0500, Jose R. Santos wrote:
> > 
> > As you mentioned in on of the interlock meeting a couple of weeks
> > ago, you said that you don't have that big of a problem changing
> > parts of the libe2fs API/ABI as long as only break it once.  
> 
> I said that we can break it at _most_ once.  But because I believe in
> doing incremental coding, I'd much rather try not to break it at all,
> and then in the worst case, break things only once.  Let me quote from
> Linus Torvalds from a recent posting he made on the git mailing list.
> 
> LT >(Most of the time I actually try to get it right the first time.
> It's LT >actually become a challenge to me to notice when some change
> needs a LT >cleanup first in order to make the later changes much
> easier, so I really LT >*like* trying to actually do the actual
> development in a logical order: LT >first re-organize the code, and
> verify that the re-organized code works LT >identically to the old
> one, then commit that, then start actually working LT >on the new
> feature with the now cleaner code-base). LT >
> LT >And no, I didn't start out programming that way. But when you get
> used to LT >looking at changes as a nice series of independent
> commits in emails, you LT >really start _working_ that way yourself.
> And I'm 100% convinced that it LT >actually makes you a better
> programmer too.
> 
> This is why I **really** dislike mongo patches such as the 64-bit
> patches from that have come out so far.  They change way too much, and
> afterwards it's very hard to see what the heck the patch actually
> *does*.  I am convinced that if we do a better job of breaking up
> patches both for e2fsprogs and for the ext4 patch queue, it will make
> it a lot easier for people to review patches.  Each patch should in
> the ideal world only do one thing.

Agree
 
> So for example, take a look at some of the patches which I just
> commited into the git "master" branch last night (Sunday night).  What
> you are seeing there are all cleanup patches.  Each of them are
> relatively small; none of them change the ABI/API; and after each of
> them e2fsprogs passes the "make check" regression test suite, so the
> whole thing is git bisectable.
> 
> All of these changes was to move any 32-bit bitmap "knowledge" out of
> inline functions, and into the file gen_bitmap.c.  Of course, I had to
> preserve any functions that had been previously called by inline
> functions, as well as anything that had been exported as part of the
> ABI.  But that's easy to do.
> 
> The next step, which I haven't done yet (and probably won't have time
> to do for at least a day or two thanks to my needing to do very Unfun
> things like Fall Plan stuff, as opposed to Fun stuff like e2fsprogs
> hacking :-) is to create a new set of interfaces that look somewhat
> like this:
> 
> int ext2fs_mark_block_nbitmap(ext2fs_block_bitmap bitmap, blk64_t
> block); int ext2fs_unmark_block_nbitmap(ext2fs_block_bitmap bitmap,
> blk64_t block); int ext2fs_test_block_nbitmap(ext2fs_block_bitmap
> bitmap, blk64_t block);
> 
> int ext2fs_mark_inode_nbitmap(ext2fs_block_bitmap bitmap, ino64_t
> inode); int ext2fs_unmark_inode_nbitmap(ext2fs_block_bitmap bitmap,
> ino64_t inode); int ext2fs_test_inode_nbitmap(ext2fs_block_bitmap
> bitmap, ino64_t inode);
> 
> And then rearrage the structure definitions like so:
> 
> in ext2fs.h:
> 
> /* Redefined from original values in ext2fs.h */
> typedef struct ext2fs_struct_nbitmap *ext2fs_generic_bitmap;
> typedef struct ext2fs_struct_inode_bitmap *ext2fs_inode_bitmap;
> typedef struct ext2fs_struct_block_bitmap *ext2fs_block_bitmap;
> 
> (No, we never define ext2fs_struct_block_bitmap and
> ext2fs_struct_inode_bitmap; after doing the appropriate structure
> magic number checking, we cast it to ext2fs_struct_nbitmap and then
> use the nbitmap functions for common handling of the inode and block
> bitmaps.  The two different structures are there just to allow the 
> compiler to enforce proper type-checking.)
> 
> And in ext2fsP.h we add:
> 
> #define EXT2_NBITMAP_TYPE_JBOB	1	/* Just a Bunch of
> Bits */ #define EXT2_NBITMAP_TYPE_RBTREE 2	/* Red-Black Tree */
> 
> struct ext2fs_struct_nbitmap {
>        errcode_t		magic;
>        ext2_filsys 		bm_fs;
>        __u64			bm_start, bm_end;
>        __u64			bm_real_end;
>        char			*bm_description;
>        errcode_t		bm_base_errcode;
>        int			bm_type;
>        void			*bm_private;
>        __u32			bm_reserved[7];
> };
> 
> Now, if bm_type is EXT2_NBITMAP_TYPE_JBOB, then bm_private will just
> be a pointer to a memory array, just like the old-style struct
> ext2fs_struct_generic_bitmap, except the start and end fields are
> 64-bits.
> 
> 
> To provide backwards compatibility, one of the first things that the
> ext2fs_{mark,unmark,test}_{block,inode}_nbitmap() functions is
> something like this:
> 
> 	  errcode_t	magic;
> 
> 	  magic = *((errcode_t *) bitmap);
> 	  if ((magic == EXT2_ET_MAGIC_BLOCK_BITMAP) ||
> 	      (magic == EXT2_ET_MAGIC_INODE_BITMAP) ||
> 	      (magic == EXT2_ET_MAGIC_GENERIC_BITMAP))
> 	      return
> (ext2fs_{mark,unmark,test}_generic_bitmap(bitmap, ...);
> 
> Hence, if you pass an old-style 32-bit bitmap to the ext2fs_*_nbitmap
> routines(), they will automatically handle it by calling out to
> original 32-bit bitmap functions.
> 
> Furthermore, ext2fs_allocate_block_bitmap() will only allocate the
> new-style bitmap data structures if the application passed a special
> new flag, EXT2_FLAG_NEW_BITMAP to the ext2fs_open() function.  This
> new flag indicates that the application will use the new 64-bit
> ext2fs_*_nbitmap() functions.
> 
> In order to minimize the changes needed to e2fsprogs internals, at
> least initially, while we are testing these changes, we can do
> something similar in all of the original
> ext2fs_{mark,unmark_test}_{block,inode}_bitmap() functions --- which
> in the latest git tree have been made so that the guts of their
> functions are no longer inlined.  And that is to do the reverse:
> 
> 	  errcode_t	magic;
> 
> 	  magic = *((errcode_t *) bitmap);
> 	  if ((magic == EXT2_ET_MAGIC_BLOCK_NBITMAP) ||
> 	      (magic == EXT2_ET_MAGIC_INODE_NBITMAP) ||
> 	      (magic == EXT2_ET_MAGIC_GENERIC_NBITMAP))
> 	      return
> (ext2fs_{mark,unmark,test}_generic_nbitmap(bitmap, ...);
> 
> This obviates the need to have to sweep through all of the e2fsprogs
> libraries and userspace applications to change them to use the
> new-style nbitmap calls and change them to use the 64-bit blk_t.  They
> obviously won't be 64-bit capable until we do this step, of course,
> but in the meantime we can test the new ext2fs_*_nbitmap()
> infrastructure, and we can let other people implement the red-black
> tree support for nbitmaps --- and, once implemented, it could be used
> to reduce the memory footprint of e2fsprogs even on 32-bit
> filesystems.  
> 
> So do you see the general idea?  This allows us to upgrade e2fsprogs
> in little tiny steps, where each step/patch can be easily audited and
> reviewed, while keeping e2fsprogs working at each step along the way.
> And in fact, you can see how we can keep backwards compatibility at
> the ABI and API level along the way, without that much extra work.

Yes and now I see what you dislike about the 64bit patches.
 
> At *some* point, we could discuss whether or not we want to sweep away
> the old interfaces, in the name of cleanliness and/or making the
> libraries smaller.  But that's a decision that can be made later,
> along the way.
> 
> > 1. Change the name of all functions that require 64-bit changes  to
> > function64(...) and provide 32bit helper functions that call the
> > 64bit function with the appropriate sizes
> 
> I wouldn't call them 32-bit helper functions.  Rather think of them as
> 32-bit compatibility functions.  Look at lib/ext2fs/openfs.c and at
> the ext2fs_open() and ext2fs_open2() functions.  Originally all of the
> code was in ext2fs_open().  At some point, in order to add a new
> parameter, io_options, we moved all of the guts of ext2fs_open() into
> a new function ext2fs_open2().  (Or if you like, we renamed
> ext2fs_open() to ext2fs_open2(), and then changed the function
> signature).  We then defined ext2fs_open as follows:
> 
> errcode_t ext2fs_open(const char *name, int flags, int superblock,
> 	  		          unsigned int block_size,
> io_manager manager, ext2_filsys *ret_fs)
> {
> 	return ext2fs_open2(name, 0, flags, superblock, block_size, 
> 	       			      manager, ret_fs);
> }
> 
> See what I mean?  This allowed me to add a new parameter to
> ext2fs_open(), while still maintaining ABI and API compatibility. 
> 
> Most 64-bit functions can be done in this way.  The complex ones are
> bitmaps and block iterators, which need some special handling.  

Yes, this is what I meant by helper functions but 32bit compatibility
functions is a better name. :)
 
> > 2. Change the way bitmaps are handle in order to reduce the memory
> > requirements on very large filesystems.  Does this require changes
> > to the API/ABI?
> 
> Happily, nope!  See the above discussion.
>
> > As you mentioned that you wanted to do this done in stages, I
> > wanted to get your input on this subject.  After we figure out what
> > changes need be done to implement this and other feature, we can
> > the figure out work assignments for the IBM folks working on ext4
> > and bring e2fsprogs up to date with the current kernel changes.
> > Since you're the maintainer of e2fsprogs and ultimately have the
> > final say as to what makes it in the source code repositories, your
> > opinion here maters more than anybody else. :)
> > 
> > My plan would be:
> > 
> > 1) Merge Valeries 64-bit patches removing the compile time defines
> > to use 64-bit blk_t.
> 
> As I said, I'm not convinced the existing 64-bit patches are the right
> way to go at all.  They may be OK interim patches, but when I say
> incremental steps, I mean start with the current e2fsprogs git tree,
> and then convert over the various interfaces one at a time, with each
> one potentially being its own patch series.  (Note that so far I
> already have 7 patches so far pushed into git just cleaning up and
> refactoring the bitmap code *before* I even started adding the 64-bit
> infrastructure; basically, think about how you might do things if you
> were submitting kernel patches.  It's the same level of high quality
> which I intend to enforce.)

Agree.
 
> If you're looking for a good set of interfaces to start with, I'd
> suggest lib/ext2fs/badblocks.c.  It's pretty straightforward, and
> doesn't require doing a lot of complex ABI hoops since we never had
> any inline functions that referenced the internal data structures of
> the type ext2_u32_list.  (In fact, we never let the structure
> definition of ext2_struct_u32_list leak out in ext2fs.h, keeping the
> definition in the private header file of ext2fsP.h.)  So making the
> badblocks list be 64-bit clean in an ABI/API compatible way is *easy*.
> 
> Another one that should be even more straightforward is
> lib/ext2fs/dirblock.c.  In fact, you probably should do that one
> first, since there are no internal data structures to mess with.

I'll start looking at these.
 
> Does this make sense?

Thanks, this reply make things very clear.  I good idea of how the
64-bit (and other changes) should be implemented in e2fsprogs.

> 						- Ted

-JRS
