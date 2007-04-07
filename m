From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Call for testers w/ using BackupPC (or equivalent)
Date: Sat, 07 Apr 2007 11:53:16 -0400
Message-ID: <E1HaDE4-0000S5-3t@candygram.thunk.org>
To: Ext3-users@redhat.com, linux-ext4@vger.kernel.org,
	"Villalovos, John L" <john.l.villalovos@intel.com>,
	Bill Broadley <bill@cse.ucdavis.edu>,
	Lenny Foner <foner@media.mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49410 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966035AbXDGPxZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Apr 2007 11:53:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


For a while now, I've been receiving complaints from users who have been
using BackupPC, or some other equivalent backup progam which functions
by using hard links to create incremental backups.  (There may be some
people who are using rsync to do the same thing; if you know of other
such backup programs with such properties, please let me know.)

BackupPC works by creating hard link trees, so that files that have not
changed across incremental backups.  With a large enough filesystem,
this is sufficient to cause memory usage issues when e2fsck needs to run
a full check on the filesystem.   There are two causes of this problem:

* Even if directories are equivalent, Unix does not allow directories to
  be hardlinked, so if a filesystem has 100,000 directories, each
  incremental backup will create 100,000 new directories in the BackupPC
  directory.  E2fsck requires 12 bytes of storage per directory in order
  to store accounting information.

* E2fsck uses an icount abstraction to store the i_links_count
  information from the inode, as well as the number of times an inode is
  actually referenced by directory.   This abstraction uses an
  optimization based on the observation that on most normal filesystems,
  there are very few hard links (i.e., i_links_count for most regular
  files is 1).   The icount abstraction uses 6 bytes of memory for each
  directory and regular file which has been hardlinked, and two of them
  are used.

One such filesystem that was reported to me had 88 million inodes, of
which 11 million were files, and 77 million were directories (!).  This
meant that e2fsck needed to allocate around 881 megabytes of memory in
one contiguous array for the dirinfo data structures, and two
(approximately) 500 megabyte contiguous arrays for the icount
abstraction.  

On a 32-bit processor, especially with shared libraries enabled to
futher reduce the amount of available 3GB address space, e2fsck can very
easily fail to have enough memory.  Using a statically-linked e2fsck can
help, as can moving to a 64-bit processor, but you still need a large
amount of memory.

OK, so that's the problem.  What's the solution?   I have a testing
version of e2fsprogs which uses a scratch directory to store the
in-memory databases in a file instead.  So this won't help on a root
filesystem, since a writeable directory is required, but most of the
time the BackupPC archives should be on a separate filesystem.  

To download it, please get e2fsprogs version 1.40-WIP-2007-04-11, which 
can be found here:

http://downloads.sourceforge.net/e2fsprogs/e2fsprogs-1.40-WIP-2007-04-11.tar.gz

After you build it, create an /etc/e2fsck.conf file with the following
contents:

[scratch_files]
        directory = /var/cache/e2fsck

...and then make sure /var/cache/e2fsck exists by running the command
"mkdir /var/cache/e2fsck".

My initial tests show that e2fsck does run approximately 25% slower with
the scratch_files feature enabled, but it should use a significant
smaller amount of memory, and so for people who have had their e2fsck
thrashing due to swap activity, it could run faster.  And certainly for
people where e2fsck was failing altogether due to lack of memory and/or
address space, this should allow them to complete.

But because there is this performance tradeoff with using
[scratch_files] I want to to be able to give tuning advice for when to
use it, and when not to use it.  That's also why we have a
numdirs_threshold parameter in [scratch_files] which can be used to only
use it on filesystems with a large number of directories (this tends to
be a good marker for filesystems that might need this feature; but the
question is what should a good default be?)


So what I'm looking for from testers is to run the following experiment:

1) Using your existing e2fsck (please let me know which version), run
   the command:

	/sbin/e2fsck -nfvttC0 /dev/sdXX

   ... and send me the output.

   Since the e2fsck is run with the -n option, it is ok to run this on a
   mounted filesystem (but you probably want to do this at night or some
   lightly loaded time since it will slow your fileserver down esp. if
   you try this during peak hours).

   If you know your filesystem will cause e2fsck to fail due to lack of
   memory, of course there's no reason to do this.

2) Using the new version of e2fsck from 1.40-WIP-2007-04-07, run the
   same command again, and send me the output:

	e2fsck.new -nfvttC0 /dev/sdXX

   While it is running, when it is running pass #3, could you send me
   the output of "ls -s /var/cache/e2fsck".  I want to see how big the
   scratch files get at their maximum size.

Finally, please let me know how much memory and swap you have
configured, and what sort of processor and a rough idea of the speed of
your disk subsystem if you happen to know that information.

Thanks!!

						- Ted
