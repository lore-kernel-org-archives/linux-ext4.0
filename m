From: Lukas Czerner <lczerner@redhat.com>
Subject: [RFC PATCH 0/2] Add rbtree backend for storing bitmaps
Date: Mon, 10 Jan 2011 16:18:54 +0100
Message-ID: <1294672737-10850-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, lczerner@redhat.com, sandeen@redhat.com,
	adilger@dilger.ca, kalpak@clogeny.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab1AJPTP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Jan 2011 10:19:15 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

as I mentioned a while ago I am working on reducing e2fsprogs memory
utilization. The first thing which need to be addressed is mechanism of
storing bitmaps. So far bitarrays was used for this purpose however today
this approach might hit its limits with todays huge data storage devices,
because of its memory utilization.

Bitarrays stores bitmaps as ..well, as bitmaps. But this is in most
cases highly unefficient because we need to allocate memory even for the
big parts of bitmaps we will never use, resulting in high memory
utilization especially for huge filesystem, when bitmaps might occupy
gigabytes of space.

To address this I have created rbtree backend for storing bitmaps. It stores
just used extents of bitmaps, it means, that it can be more memory efficient
in most cases and also with careful use it might be much faster as well.

Rbtree implementation itself is ripped of linux kernel with some minor changes
to make it work outside kernel. So this should not cause any problems at all
since it has been really extensively tested through out its life.

I have done a lot of testing to validate my new backend and to find as many
bugs as possible. Now it seems to be quite reliable, however since this is the
most crucial part of the e2fsprogs it has to be tested most widely on various
scenarios. So this is my appeal to you guys, please take it, make it and test
it and test it some more, to really make sure this is doing what it is
supposed to.

The other side of the thing is, does it really help with memory utilization ?
So my answer is YES, (...but). Of course there is a "but". That is because one
rbtree node on 64-bit system takes 40B of data, which is 320 bits of
information. So there might be a situation when one single rbtree node does
not cover even 320 bits of bitmap it stores, it this case this node is not
very efficient. In case we have a lot of unefficient nodes we might actually
end up with bigger memory utilization than bitarrays itself and that's bad.

Now, the answer for this problem is benchmarking, to figure out how probable
this situation is and how (and when) bad it can get. We would probably need to
create some fallback switch which will convert bitmaps from one backend
(rbtree) to another (bitarray) depending on which appears more efficient for
the situation, but let's keep it simple for now and lets figure out how bad
the problem actually is.

I have done some limited benchmarking. Limited, because it takes time (a lot
of it) and also huge storages, because we do not really care about memory
utilization differences in megabytes, but rather in hundreds and thousands of
megabytes. So this is my second appeal to you guys, take it, make it, test it
and benchmark it.

For measuring memory utilization I have used valgrind (massif tool to be
specific). All the numbers I will show you are peak memory utilization. So
here is an example how to use massif.

	valgrind --tool=massif ./e2fsck/e2fsck -fn /dev/loop0
	ms_print massif.out.5467 | less

Now, I can show you some (rather optimistic) graphs of e2fsck memory
utilization I have done. Here is the link (description included):

http://people.redhat.com/lczerner/e2fsprogs_memory/graphs.pdf

Now the simple description of the graphs. The first one is showing the e2fsck
memory utilization depending on filesystem size. The benchmark was performed
right after the fs creation so it shows the best scenario for the rbtree
backend. The amount of saved memory grows approx by 8.5MB per 100MB of
filesystem size - this is the best what we can get.

The second graph shows memory utilization per inode depending on inode count.
We can see that with growing number of inodes the Bytes per inode ratio is
dropping significantly, moreover it is dropping faster for bitarrays than for
rbtrees, which tells us that inode count is in fact the main factor which
impact the memory utilization difference between the rbtree and bitattay
backend on the filesystem of constant size. However it strongly depends also
on how are the files created on the filesystem - some loads might be more
rbtree-friendly than others.

The threshold is, when the Bytes per Inode is equal for both backends, this is
the last point where we will need to convert rbtree backend to bitarrays,
because above this threshold rbtree approach is no longer efficient. In my
load (copying content of /usr/share several times) it means that rbtree memory
utilization is growing by 20B per inode, however bitarray mem. util. is
growing by 4B per inode (on 10TB filesystem). So the rbtree memory consumption
is growing 5 times faster then bitarrays.

Let's simplify situation and let's say that the Bytes per Inode growing ratio
will not change with inode count (which is not true, but this is yet to be
tested). In this case we hit the threshold when we fill 33% of inodes, which
means 20% of filesystem size. Not very promising, however is this load the
typical real-life load ? - this we need to find out.

Next graph shows e2fsck memory utilization depending on inode count which is
practically the same thing as in previous graph.

The last two graphs were created on filesystem aged with Impression in default
configuration, rather than copying /usr/share. It should provide more
real-live filesystem images. The filesystem is rather small now, only 312GB.
So the fourth graph shows running times of e2fsck for both backends, rbtree
and bitarrays. We can see that rbtree backend performs quite bad, however I
believe that I know the source of the slowdown. It is the rb_test_bit()
function which need to walk the tree every time e2fsck needs to test the bit
and since this usually happen in sequential order (bit-by-bit), we can easily
improve performance by adding simple cache (similar to write cache in
rb_set_bit()). Also with the little improvement of e2fsck bitmap handling (use
the advantage of extents) we can improve performance even more. But I leave
those optimization to after we are done with memory utilization optimization.

Finally, the last graph shows Memory utilization per inode depending on inode
count. This is the similar graph as the second one, however this one is a bit
more optimistic. The rbtree memory utilization grows by avg. 8B per Inode, and
bitarray grows by avg. 7B per inode, which is quite good and in this scenario
with stable Bytes per inode grow the rbtree backend will be always better than
bitarray. This show us, that it really depends on the type of load as well as
on the size of the filesystem. So we need to test more and more real life
filesystems to see the if the rbtree is really a win for most of the users, or
just some small groupr group, who does not even care about memory utilization
at all (it is clearly numbers from huge filesystems we care about!).


There were some people having OOM problems with e2fsck, It would be great if
those people can try this patches to see if it helps and get back to us to
share the experience. Although I feel that I need to warn you guys, this is
not yet stable, and even though I have not seen any problems, it does not mean
that it is bug free, so at least try it with '-n' option which should be
quite safe.

Please, comments are highly appreciated!

Thanks!
-Lukas


-- 
[PATCH 1/2] e2fsprogs: Add rbtree library
[PATCH 2/2] e2fsprogs: Add rbtree backend for bitmaps, use it instead of bitarrays

 lib/ext2fs/Makefile.in    |   13 +-
 lib/ext2fs/blkmap64_rb.c  |  815 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/bmap64.h       |    1 +
 lib/ext2fs/ext2fsP.h      |    1 +
 lib/ext2fs/gen_bitmap64.c |    3 +
 lib/ext2fs/rbtree.c       |  451 +++++++++++++++++++++++++
 lib/ext2fs/rbtree.h       |  179 ++++++++++
 7 files changed, 1461 insertions(+), 2 deletions(-)
