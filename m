From: Radek Pazdera <rpazdera@redhat.com>
Subject: [RFC 0/9] ext4: An Auxiliary Tree for the Directory Index
Date: Sat,  4 May 2013 23:28:33 +0200
Message-ID: <1367702922-3236-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759224Ab3EDVeV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 17:34:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello everyone,

I am an university student from Brno /CZE/. I decided to try to optimise
the readdir/stat scenario in ext4 as the final project to school. I
posted some test results I got few months ago [1].

I tried to implement an additional tree for ext4's directory index
that would be sorted by inode numbers. The tree then would be used
by ext4_readdir() which should lead to substantial increase of
performance of operations that manipulate a whole directory at once.

The performance increase should be visible especially with large
directories or in case of low memory or cache pressure.

This patch series is what I've got so far. I must say, I originally
thought it would be *much* simpler :).

TLDR
====

The series contains the implementation of the new tree and several
rather small changes to the original directory index. I also added
a new implementation of ext4_readdir() that uses this new tree
instead of the original one.

It applies on 3.9, it is basically working, however, it is highly
experimental at the moment. It doesn't survive XFS tests yet (I
still need to work on that).

DESIGN
======

The tree comes with a new read-only compatible file system feature
called "itree". It is created in a directory at the same time as the
original dx tree -- when the directory file exceeds a signle block of
size. It is indicated by an inode flag.

The tree resides completely outside of the directory file. I am using
64bit block numbers (as suggested by Ted Ts'o), and the pointer to its
root is stored in the end of the dx_root block.

I tried to keep the structure of the tree as close as possible to the
original dx tree. It is a B+ tree with a 64bit long compound key. The
key consists of a inode number and a hash.

The hash is there because of hard links. On ext4 there can be as much
as 65 000 names for a single file which is, from the point of the inode
tree, a collision. It is a very unlikely scenario to crate over 60 000
names for a file from a single directory. But it would be a very serious
problem for readdir() if someone tried to do that, so I decided to add
the hash to the key as well. This reduces the problems of collisions to
the same as of the hash tree.

The depth of the tree is limited by a constant in the code to 3 levels,
but it can be increased anytime.

I decided to keep the directory entries within the leaf nodes sorted,
which might have been a bad idea (and it brought me quite a few
sleepless nights of pointer debugging). However, it is more convenient
for readdir and splits. And in the case of the inode tree, there
shouldn't be that much memmoving, because inodes are allocated linearly,
therefore we're adding to the end most of the time anyway.

I also had to implement coalesce-on-delete. Unlike the hash values,
the inode numbers are not random, so the tree would get fragmented
really easily. For example when a range of inodes would be freed
and allocated somewhere else, that part of the tree would stay empty
forever.

In this implementation I used 8 bits for "node fullness". Neighbour
nodes in the tree are merged as soon as their total fullness is smaller
than maximum fullness. This way, coalescing happens too often. I plan
to reduce it to only 2 bits (25% full, 50% full, 75% full, 100% full).

There are also some optimisations to increase the fullness of blocks
within the tree, because if the file system adds a contiguous sequence
of inodes to a directory and we split the nodes in half, there will be
some tree nodes that will never get another entry and still be only 50%
full. In the current implementation, an append is performed instead of
a split in case the new entry should be added to the end of the full
block.

BENCHMARKS
==========

I did some benchmarks and compared the performance with ext4/htree,
XFS, and btrfs up to 5 000 000 of files in a single directory. Not
all of them are done though (they run for days).

Probably the biggest improvement can be observed with copying files.
I used two physical SATA disks for the test. For 5M files, the itree
implementation is 14x faster. With metadata only, ext4 is even a tiny
bit faster than xfs:

    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/ext4-5M/0B-files/cp.png

With each files 4kB big, the inode tree is 11x faster:

    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/ext4-5M/4096B-files/cp.png

On the other hand, probably the biggest drawback of this implementation
is that it slows down file creates, as we now have to insert the entry
into both trees. The difference gets bigger as both trees grow (and their
blocks get further apart). For 5M directory entries, the creation is
roughly 40% slower. Hopefully, I'll be able to optimise it a bit in the
future:

    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/ext4-5M/0B-files/create.png
    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/ext4-5M/4096B-files/create.png

Deleting entries should also very much benefit from this. However, the
increase of performance in my test is far lower than expected. I think
that is due to my implementation of coalesce-on-delete, which happens
too often and during these massive deletes, it coallesces all the time.
I hope that when I fix that, it will get somewhere close to XFS as well:

    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/ext4-5M/0B-files/delete.png
    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/ext4-5M/4096B-files/delete.png

All of the results have a graph and a table with precise values.
You can always get the table by replacing the suffix of the graph
*.png to *.results in the end of the link.

Full results are available here:
    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/ext4-5M/


I also did some tests on an aged file system (I used the simple 0.8
chance to create, 0.2 to delete a file) where the results of ext4
with itree are much better even than xfs, which gets fragmented:

    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/5M-dirty/cp.png
    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/5M-dirty/readdir-stat.png


There are still some things to be done, the checksums are not yet
finished and I certainly need to do a bit of cleaning up at some
places. But as far as features go, it all should be there already.

I'm working on this along with Lukas Czerner, who acts as my mentor
and helps me with different things (big thanks!).

Any feedback/ideas are greatly appeciated :)!

Cheers,
Radek


Radek Pazdera (9):
  ext4: Adding itree feature and inode flags
  ext4: Allow sorting dx_map by inode as well
  ext4: Adding a link to itree to the dx_root struct
  ext4: Adding itree structures
  ext4: Adding itree implementation I - Core
  ext4: Adding itree implementation II - Inserting
  ext4: Adding itree implementation III - Deleting
  ext4: Make directory operations use itree
  ext4: Make ext4_readdir() use itree if available

 fs/ext4/dir.c   |  177 +++-
 fs/ext4/ext4.h  |   21 +-
 fs/ext4/namei.c | 2442 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 2565 insertions(+), 75 deletions(-)

-- 
1.7.11.7

