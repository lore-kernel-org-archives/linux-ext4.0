From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 00/10] extent-based bitmaps for e2fsprogs
Date: Mon, 19 Dec 2011 09:50:21 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1112190949230.30656@dhcp-27-109.brq.redhat.com>
References: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab1LSIuZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 03:50:25 -0500
In-Reply-To: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 18 Dec 2011, Theodore Ts'o wrote:

> I spent some time playing with Lukas Czerner's rbtree patches.  Here is
> a patch set which is based on the latest e2fsprogs sources, and which
> doesn't break any library ABI's or API's.  I also threw in regression
> tester for bitmaps, and fixed a bug in rb_unmark_bmap() that was found
> by the regression tests.
> 
> My tests on a number of file systems that I had easy access to seems to
> indicate that on pretty much all file systems, using the rbtree based
> implementation is a huge win over the bitarray.  (With memory required
> after patches being as low as 25% of the memory needed beforehand,
> although I believe 40-50% of the memory required in previous releases is
> more realistic.)  The one exception is if there are a huge number of
> directories, which is the reason for the AUTODIR pseudo backend.
> 
> Comments, please!

Hi Ted, it looks great, I am really happy you've resurrected my old
patches, I'll give it a try and take a look at patches.

Thanks!
-Lukas

> 
> 						- Ted
> 
> Lukas Czerner (3):
>   libext2fs: add rbtree library
>   libext2fs: add a bitmap implementation using rbtree's
>   libext2fs: add bitmap statistics
> 
> Theodore Ts'o (7):
>   libext2fs: add default_bitmap_type to the ext2_filsys structure
>   libext2fs: add tests for the bitmap functions
>   libext2fs: add pseudo bitmap backend type EXT2FS_BMAP64_AUTODIR
>   e2fsck: fix pass5 bug when using two different bitmap backends
>   libext2fs: use the rbtree bitmap by default when initializing a file
>     system
>   e2fsck: use different bitmap types as appropriate
>   libext2fs: adjust the description when copying a bitmap
> 
>  e2fsck/e2fsck.h               |   20 +
>  e2fsck/pass1.c                |   62 ++--
>  e2fsck/pass1b.c               |    6 +-
>  e2fsck/pass2.c                |    7 +-
>  e2fsck/pass3.c                |    7 +-
>  e2fsck/pass5.c                |    4 +-
>  e2fsck/unix.c                 |    4 +
>  e2fsck/util.c                 |   61 +++
>  lib/ext2fs/Makefile.in        |   38 ++-
>  lib/ext2fs/bitmaps.c          |   14 +-
>  lib/ext2fs/blkmap64_ba.c      |    8 +
>  lib/ext2fs/blkmap64_rb.c      |  824 +++++++++++++++++++++++++++++++++++++++++
>  lib/ext2fs/bmap64.h           |   33 ++
>  lib/ext2fs/ext2fs.h           |   15 +-
>  lib/ext2fs/ext2fsP.h          |    2 -
>  lib/ext2fs/gen_bitmap64.c     |  158 ++++++++-
>  lib/ext2fs/icount.c           |    4 +-
>  lib/ext2fs/initialize.c       |    1 +
>  lib/ext2fs/rbtree.c           |  451 ++++++++++++++++++++++
>  lib/ext2fs/rbtree.h           |  180 +++++++++
>  lib/ext2fs/tst_bitmaps.c      |  577 ++++++++++++++++++++++++++++
>  lib/ext2fs/tst_bitmaps_cmd.ct |   39 ++
>  lib/ext2fs/tst_bitmaps_cmds   |   46 +++
>  lib/ext2fs/tst_bitmaps_exp    |   92 +++++
>  24 files changed, 2600 insertions(+), 53 deletions(-)
>  create mode 100644 lib/ext2fs/blkmap64_rb.c
>  create mode 100644 lib/ext2fs/rbtree.c
>  create mode 100644 lib/ext2fs/rbtree.h
>  create mode 100644 lib/ext2fs/tst_bitmaps.c
>  create mode 100644 lib/ext2fs/tst_bitmaps_cmd.ct
>  create mode 100644 lib/ext2fs/tst_bitmaps_cmds
>  create mode 100644 lib/ext2fs/tst_bitmaps_exp
> 
> 

-- 
