From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Correction to check_filetype()
Date: Sat, 31 Mar 2007 08:35:09 -0400
Message-ID: <20070331123509.GA25539@thunk.org>
References: <1172049359.4727.15.camel@garfield> <20070331004417.GJ3198@thunk.org> <20070331081624.GF5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Lustre-discuss <Lustre-discuss@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51307 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbXCaMfR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 Mar 2007 08:35:17 -0400
Content-Disposition: inline
In-Reply-To: <20070331081624.GF5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Mar 31, 2007 at 02:16:24AM -0600, Andreas Dilger wrote:
> On Mar 30, 2007  20:44 -0400, Theodore Tso wrote:
> > On Wed, Feb 21, 2007 at 02:45:59PM +0530, Kalpak Shah wrote:
> > > If the mode of a directory gets corrupted, check_filetype() makes
> > > wrong decisions for all its sub-directories. For example, using
> > > debugfs we can corrupt the mode of a directory to 0140755 (i.e. a
> > > socket). e2fsck will set the filetype of all its subdirectories as 6
> > > (filetype for socket). All the subdirectories would be moved to
> > > lost+found, and in second run of e2fsck their filetype would be set
> > > back to 2.

Ah, OK, I misunderstand the original bug report.  It wasn't that the
filetype of all of the subdirectories are set incorrectly; it was the
filetype of the .. entry in all of the subdirectories.  And my test
case created files, not directories in the corrupted directory.

So the correct fix for this problem isn't to add a special case in
pass2's check_filetype() --- since the directory entry being pointed
to really isn't a directory --- but rather in pass3's
fix_dot_dot_proc(), which gets executed when we reparent the
subdirectories to lost+found:

diff -r 11d3e029aa83 e2fsck/pass3.c
--- a/e2fsck/pass3.c	Thu Mar 29 00:32:23 2007 -0400
+++ b/e2fsck/pass3.c	Sat Mar 31 07:22:40 2007 -0400
@@ -645,6 +645,7 @@ static int fix_dotdot_proc(struct ext2_d
 		fix_problem(fp->ctx, PR_3_ADJUST_INODE, &pctx);
 	}
 	dirent->inode = fp->parent;
+	dirent->name_len = (dirent->name_len & 0xFF) | EXT2_FT_DIR << 8;
 
 	fp->done++;
 	return DIRENT_ABORT | DIRENT_CHANGED;

The question though is whether we should be doing anything more to
notice that the real problem isn't the file type information is
incorrect, but rather that i_mode in the parent directory is
incorrect.  Put another way, we can detect that perhaps i_mode is what
is inconsistent, given the following clues:

	* The inode contains data blocks (although we have to be careful 
		since a block or char device will have a non-zero 
		i_block[0])
	* The inode's i_block[0] is valid, isn't being used by any other 
		inode, and the contents of the data block pointed to
		be i_block[0] appears to be a directory (i.e., has a
		. and .. entry where '.' points to itself).
	* One or more directory entries point to the inode a filetype
		of EXT2_FT_DIR.

On the other hand, this is difficult to do right, because the first
clue has a significant chance of false positives in the case of block
and character devices; the second clue can only be completely verified
after pass 1 is completely finished; and the third clue can only be
verified while executing pass 2.  

Furthermore, how often and how likely that we would suffer a
single-bit error in i_mode, where the rest of the inode (especially
i_blocks and i_block) won't be trashed, and the worst case if we get
this wrong is that the files end up in lost+found so we don't lose any
data anyway?  (This would be less true in the 64-bit "inode in
directory" design, which is one of the reasons why while I like it a
lot, it is definitely a lot more fragile and will require some very
careful handling.)

And of course, if we're going to handle the case where a directory was
wrongly turned into a socket/device/fifo, we should also handle the
case where a regular file is wrongly turned into a socket/device/fifo,
although this gets more difficult since we can't do a test based on
'.' and '..' in the case of a regular file has its i_mode field corrupted.

What we can do in the directory case is to perform the '.' and '..'
check in pass1, although it would require a fair amount of special
case code, and hope that it isn't a false positive or that it happens
to be pointing at another (valid) directory --- although if '.' points
to itself that would seem unlikely.

	dir->name_len = (dir->name_len & 0xFF) | EXT2_FT_DIR << 8;

And we can't really check the case where a directory gets turned into
a regular file without destroying e2fsck's performance, since that
would require reading the first block of every single file, and this
also significantly increases the chance of false positives.  So it's a
lot of complexity for what seems to have always been an artificial
test case.

Let me see what I can do, but the controlling consideration is going
to be "first, do no harm", which means (a) it must not harm
performance, and (b) it must never cause e2fsck to stop and ask a
question on a valid filesystem.

						- Ted
