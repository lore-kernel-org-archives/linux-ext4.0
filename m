From: Lukas Czerner <lczerner@redhat.com>
Subject: Add rbtree backend for storing bitmaps
Date: Thu, 17 Mar 2011 19:50:17 +0100
Message-ID: <1300387821-21705-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab1CQSuk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Mar 2011 14:50:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

this is my second attempt to introduce new e2fsprogs bitmap backed based on
rbtree. In this second version a couple of thing got better. First of all I
have fixed all the bugs I was able to fing in the rbtree backend itself and
now it passed many smoke tests as well as "make check" cleanly.

The second change is that this set of patches does not actually set rbtree
backend as default, but rather introduce new configuration interface (in
PATCH 3) to set backend for each and every one bitmap used by e2fsprogs
individually. This allows us to better see what backend might be more
suitable for what particular bitmap, more sophisticated benchmarking and
testing.

Also to enable even more detailed understanding of how e2fsprogs treats
bitmaps I have iontroduced (in PATCH 4) new macro for enabling statistics
gathering about bitmaps. If the macro is set (in compile time) the code
is enabled and data is gathered. Then, when the bitmap is freed information
is printed to the stderr, so we can clearly compare bitmaps with each other.

So far I have not done any comprehensive benchmarks other than last time 
(http://www.spinics.net/lists/linux-ext4/msg22664.html). Rbtree still has
good results (memory saved) with reasonable filesystems, but it can get much
worse in case of very fragmented filesystem. Also note that enabling rbtree
(for all bitmaps) cause cca 30% (instead of almost 60% in previous version)
performance hit on regular filesystem, but it can really differ.

Important thing is that this commits should not change e2fsprogs behavior in
any way, since neither rbtree backend, nor stats collection is enabled by
default.

If there is anyone with some /unusual/ filesystem (huge, tons of files,
really fragmented, etc..) willing to try it out and share the results it
will be great!

Comments are highly appreciated!

Thanks!
-Lukas

---
[PATCH 1/4] e2fsprogs: Add rbtree library
[PATCH 2/4] e2fsprogs: Add rbtree backend for bitmaps, use it instead of bitarrays
[PATCH 3/4] Add bitmap configuration interface
[PATCH 4/4] Add macro to enable collecting bitmap statistics

 e2fsck/emptydir.c         |    4 +-
 e2fsck/pass1.c            |   18 +-
 e2fsck/pass1b.c           |    2 +-
 e2fsck/pass3.c            |    6 +-
 e2fsck/pass5.c            |    4 +-
 e2fsck/unix.c             |    7 +
 lib/ext2fs/Makefile.in    |   28 ++-
 lib/ext2fs/bitmaps.c      |   21 +-
 lib/ext2fs/blkmap64_ba.c  |    8 +
 lib/ext2fs/blkmap64_rb.c  |  829 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/bmap64.h       |   32 ++
 lib/ext2fs/check_desc.c   |    2 +-
 lib/ext2fs/ext2fs.h       |   40 ++-
 lib/ext2fs/ext2fsP.h      |    7 +-
 lib/ext2fs/gen_bitmap64.c |  248 +++++++++++++-
 lib/ext2fs/icount.c       |    5 +-
 lib/ext2fs/initialize.c   |   18 +-
 lib/ext2fs/rbtree.c       |  451 ++++++++++++++++++++++++
 lib/ext2fs/rbtree.h       |  179 ++++++++++
 lib/ext2fs/rw_bitmaps.c   |   17 +-
 lib/ext2fs/tst_iscan.c    |    6 +-
 misc/e2image.c            |    4 +-
 misc/tune2fs.c            |    2 +-
 resize/resize2fs.c        |    6 +-
 24 files changed, 1869 insertions(+), 75 deletions(-)

