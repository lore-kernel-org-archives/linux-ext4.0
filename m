From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Problems with e4defrag -c
Date: Fri, 24 Dec 2010 16:55:45 -0500
Message-ID: <E1PWFc1-0002cm-QV@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57311 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab0LYDCA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Dec 2010 22:02:00 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've started taking closer a look at e4defrag -c, and I'm a bit troubled
by both its implementation and results that it reports.

On the implementation side, it requires root, and in fact encourages
people to run it as root.  As near as I can tell, it's doing this just
so it can calculate statistics based on the block size, blocks per
group, and flex_bg size (if flex_bg is enabled).   As we'll see in a
bit, I'm not sure these statistics are all that useful.

The code is also sprinkled with rather ugly code style:

	if (current_uid != ROOT_UID &&
		buf->st_uid != current_uid) {
		if (mode_flag & DETAIL) {
			printf("\033[79;0H\033[K[%u/%u] \"%s\"\t\t"
				"  extents: %d -> %d\n", defraged_file_count,
				total_count, file, extents, extents);
			IN_FTW_PRINT_ERR_MSG(
				"File is not current user's file"
				" or current user is not root");
		}
		return -1;
	}

First of all, explicit comparisons against the current uid is bad.  A
non-root user might have read/write access to the raw device where a
file sysem is located.  It's bad to encode an assumption one way or
another into a userspace program.  Secondly, whenever a userspace progam
is explicitly trying to encode permission checking, that's a red flag.
I'm not sure why checking to see if a file's st_uid matches the
current_uid has any validity at all.

In addition, the only reason why root is needed is apparently to
calculate the "best # of extents", which I think is not all that useful
as a statistic.  Certainly it's not worth requiring raw access to read
the file system.

What really matters are the number of extents which are non-tail
extents, and smaller than some threshold (probably around 256 MB for
most HDD's), and not forced by skips in the logical block numbering
(i.e., caused by a file being sparse).  The basic idea here is to go
back to why fragments are bad, which is that they slow down file access.
If every few hundred megabytes, you need to seek to another part of the
disk, it's really not the end of the world.

Furthermore, the "average size of extents" is highly misleading.  If the
directory has a large number of small files, then by definition this
will drag down the average size of the extents.

I tried running e4defrag -c on a scratch partition of mine.   Here's
what it gave as results:

<Fragmented files>                             now/best       size/ext
1. /kbuild/e2fsprogs-64bits/build.static/lib/blkid/tests/tmp/fat32_label_64MB.img.11222
                                                 5/1              4 KB
2. /kbuild/e2fsprogs-64bits/tests/f_badjour_indblks/image
                                                 8/1              6 KB
3. /kbuild/e2fsprogs-64bits/tests/f_16384_block/image.gz
                                                 2/1              4 KB
4. /kbuild/e2fsprogs-64bits/tests/f_8192_block/image.gz
                                                 2/1              4 KB
5. /kbuild/e2fsprogs-64bits/tests/f_badjour_indblks/image.gz
                                                 2/1              4 KB

*These* were the worst fragmented file systems?  Oh, really?  Files #3,
#4, and #5 are just small files that happened to be fragmented.  They're
simply not interesting.  Given the number of seeks that would be needed
to read small files in general (to the directory, to the inode table, to
the data block, etc.), one more seek because an 8k file happened to
be split isn't interesting.

The first one is somewhat interesting:

# filefrag -v  /kbuild/e2fsprogs-64bits/tests/f_badjour_indblks/image
Filesystem type is: ef53
File size of /kbuild/e2fsprogs-64bits/tests/f_badjour_indblks/image is 8388608 (2048 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0  3312640               1 
   1       8  3312648  3312640      2 
   2      17  3312657  3312649      4 
   3      23  3312663  3312660      1 
   4      87  3312727  3312663      2 
   5     152  3312792  3312728      1 
   6     216  3312856  3312792      1 
   7    2047  3310082  3312856      1 eof

As you can see, it's a sparse file.  Git is apparently smart enough to
write files that have large blocks of zero as sparse files.  Great.  So
the fact that this file is sparse means that reading this 8 megabyte
file will be pretty fast, even though the individual blocks are
scattered.

(As an aside, this is one where the file system's block allocation
algorithm is too smart for its own good.  If you look closely at the
phsical blocks, nearly all of them are allocated out of the same chunk
of free space, starting at 3312640.  What happened was ext4 allocated
logical block N using phsyical block 3312640+N just in case this was a
case of a the compiler or linking writing an ELF object section by
section using a random access pattern but which would eventually result
in a fully contiguous, non-sparse file.  In this case git is writing a
sparse file that in practice will never be written into afterwards, so
it would be ideal if ext4 instead allocated block #8 and 9 at 3312641
and 3312642, block #17 at 3312643, and so on.  Unfortunately, without
getting a hint from userspace, it's very hard to do this.  I suppose
what we could do is decide that if we're doing delayed allocation, and
the file handle is closed, that we shouldn't assume a libelf random
write pattern, but rather a "we're writing a sparse file system and
we're done pattern".   Ah, hueristics...)

There's a more general question which is I'm not sure how much the
functionality of e4dfrag -c really belongs in e4defrag.  I'm thinking
perhaps that perhaps this functionality should instead go in filefrag,
and/or in e2fsck, which can do the job much more efficiently since it by
definition has direct access to the file system, so it can scan the
inode tables in order.

What do people think?

						- Ted
