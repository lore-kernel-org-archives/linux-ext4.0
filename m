From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Wed, 23 Apr 2008 07:55:00 -0400
Message-ID: <20080423115500.GA7003@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <20080229154333.GC8968@mit.edu> <20080402000956.GC302@mit.edu> <20080407171230.GE11997@mit.edu> <20080418184329.GB25797@mit.edu> <20080421164144.GG9700@mit.edu> <20080423073231.GC10003@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:56913 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750897AbYDWLzo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 07:55:44 -0400
Content-Disposition: inline
In-Reply-To: <20080423073231.GC10003@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 23, 2008 at 01:02:31PM +0530, Aneesh Kumar K.V wrote:
> > 	Unfortunately, there appears to be some kind of data
> > 	corruption bug if I force a tdb_data_size of 32768, so I'm not
> > 	entirely sure I trust the undo manager to be working
> > 	correctly.  The undo_manager code itself needs a pretty
> > 	serious auditing and checking to make sure it's doing the
> > 	right thing with large tdb_data_sizes.
> > 
> 
> undo-mgr is using the first blocks size used to write. This was done as
> per the discussion at
> 
> http://thread.gmane.org/gmane.comp.file-systems.ext4/1942
> http://thread.gmane.org/gmane.comp.file-systems.ext4/2056
> 
> I am not sure how you are forcing larger tdb_data_size. Can you send me
> the changes so that I can test it and see what is wrong.

There's a reason why I publish the "What's Cooking" messages, so
people can see what's in the master, next, and pu branches, and can
examine them to see what's in there.  I find the easiest way to look
at what's gone into the git repository is by using the gitk command,
i.e., "gitk pu", or "gitk maint", etc.  If you like terminal based
approaches, you can also use "git log pu", or "git log -p pu" if you
want to see the patches along side the changelog commit.

(BTW, it's good to browse the Linux kernel tree using git in this way
so you can get a good feel for the level of verbosity generally
favored by kernel maintainers, and match this in the ext4 patch
queue....)

------ 

   [This begins a git tutorial for those who don't know how to dig out
    the changes out of the 'pu' branch in the e2fsprogs git tree.
    Given that you asked me to send me the changes without realizing I
    had already pushed them out, I'm going to assume that you didn't
    know how to do this.  My apologies if you already did, and please
    skip to the next section; maybe someone else will find this mini
    git tutorial useful.]

I don't normally push out the heads of the individual components which
make up the 'pu' branch (mainly to avoid confusion), but it's normally
pretty easy to isolate the beginning of the ak/undo-mgr branch simply
by looking at the gitk output, or by doing something like this: "git
log --abbrev-commit --pretty=oneline --parents pu", which will show
you something like this:

0f83612... 2934064... 61639ff... Merge branch 'tt/64bit-bitmaps' into pu
2934064... 1140583... 9ba4000... Merge branch 'tt/flex-bg' into pu
1140583... d11736c... 625d7bf... Merge branch 'ak/undo-mgr' into pu
9ba4000... 494a1da... mke2fs: New bitmap and inode table allocation for FLEX_BG
494a1da... d11736c... Basic flexible block group support
d11736c... 0f2794c... ext2fs_open_inode_scan: Handle an non-zero bg_itable_used
0f2794c... 4476105... mke2fs/libext2fs: Fix lazy inode table initialization
625d7bf... 954b213... Add test cases for undoe2fs: u_undoe2fs_mke2fs and u_undo
954b213... cd81b90... Fix the resize inode test case
cd81b90... eadc218... tune2fs: Support for large inode migration.
eadc218... 5af269b... mke2fs: Add support for the undo I/O manager.
5af269b... 31db6f7... Add undoe2fs command
31db6f7... 4476105... libext2fs: Add undo I/O manager
4476105... 5711ed2... 748d071... Merge branch 'maint'

Either by looking at the "Merge branch 'ak/undo-mgr' into pu" line, or
by matching the subject lines from the "What's Cooking" e-mail, you
can easily determine that the head of the ak/undo-mgr branch is
625d7bf.  So you can, if you like set a branch point for ak/undo-mgr
in your own git repository and change to it, like this:

	git branch -f ak/undo-mgr 625d7bf
	git checkout ak/undo-mgr

You can then rebase all of the patches on that branch to be against
the latest master branch, like this:

	git rebase master

You can also look at the patches as ascii text via a command like this:

	git format-patch --subject-prefix="E2FSPROGS" -o /tmp/patches master

Or, you can edit individual patches, like this:

	git rebase --interactive master

This will throw up an editor window with the individual patches,
between the head of the branch and "master"; if you reorder the
patches by cutting and pasting lines, the patches will be reordered in
the branch.  If you delete a line, the patch will be dropped from the
branch.  If you change the first word in the editor window from "pick"
to "edit", during the rebasing process, it will stop, and you can look
at the tree right after the patch was applied, modify files, and then
use "git commit --amend -a" to ammend the current patch, and then type
"git rebase --continue" to continue the rebasing process.  It is
possible to edit multiple patches in a branch this way; DO NOT do this
to try to modify commits that have already been pushed out on the
'master' or the 'next' branches.  One of the reasons why we use the
'pu' branch is specifically for patches that need refinement in this
way, since commits between master/next and 'pu' aren't guaranteed to
be invariant.  It is therefore a bad idea to base patches off of the
'pu' branch, and this is why in general all of the topics branches
shown in the 'What's Cooking' reports are based off of 'master'.

And finally, when you want to send out a patch series for people to
see, you can use the git-format-patch command above (make sure you
clear out the /tmp/patches directory first, or use a new, non-existent
directory name), and then use the command:

	  git send-email --to linux-ext4@vger.kernel.org /tmp/patches

You can use the --compose option if you want to compose an
introductory message describing the patchset first.  Or use --dry-run
if you're not sure it will do what you want, first.  See the man pages
for all of these commands for more details.

-----------

Anyway, getting back to the subject at hand, how I am forcing the
larger tdb_data_size is in the modified ak/undo-mgr patches which are
in the 'pu' branch.  Most of the key bits are in the undo_io manager;
note especially:

	* tdb_data_size is now stored in the private data
	  section of the structure, instead of being a global static 
	  variable.  (Why this is so much better than a static variable 
	  is left as an exercise to the reader.)
	* setting the tdb_data_size has been moved from undo_write_tdb()
	  to undo_set_blksize().
	* new support added for the tdb_data_size option in undo_set_option()

The other key bit is in misc/mke2fs.c, in the main() function:

#if 0	      	  /* XXX bug in undo_io.c if we set this? */
    io_channel_set_options(fs->io, "tdb_data_size=32768");
#endif

Since ext2fs_initialize() calls io_channel_set_blksize(), this forces
tdb_data_size to be fs->blocksize, or 4096.  The call to
io_channel_set_options(), above forces the tdb_data_size to another
value.  If you set it to be 512, you will get the old, horrible
performance of the small tdb_data_size.  If you set it to 32768, then
when you use undoe2fs to replay the undo log, you get back a different
md5sum checksum, so the u_undoe2fs_mke2fs test ends up failing.

       		    			       - Ted

P.S.  Unfortunately, ext2fs_open() first sets the blocksize to 1024,
in order to read the superblock.  This means we need to either add an
io_channel_set_options(io, "tdb_data_size=<fs->blocksize>") to callers
of ext2fs_open(), or to ext2fs_open() itself.  I've held off on that
because for the tune2fs -I case, it may make more sense to set the
tdb_data_size to something really big, like 32768, once we figure out
why that isn't working in the mke2fs case.







