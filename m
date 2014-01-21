From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/12] libext2: optimize ext2fs_new_block2()
Date: Tue, 21 Jan 2014 10:54:22 -0500
Message-ID: <20140121155422.GB31769@thunk.org>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
 <1390197254-14583-10-git-send-email-tytso@mit.edu>
 <85FC5E41-56C5-43A4-8514-CEADC36FE5C3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50451 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbaAUPy2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jan 2014 10:54:28 -0500
Content-Disposition: inline
In-Reply-To: <85FC5E41-56C5-43A4-8514-CEADC36FE5C3@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 20, 2014 at 02:52:43PM -0700, Andreas Dilger wrote:
> On Jan 19, 2014, at 10:54 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > If there are hundreds of thousands of blocks which are in use before
> > the first free block, it is much, MUCH faster to use
> > ext2fs_find_first_zero_block_bitmap2() instead of searching the
> > allocation bitmap bit by bit.
> 
> Excellent.  The libext2fs block allocator has typically been unusable
> for filesystems with allocated blocks, so it is good to see this.

Yes, all of these patches should fix the following e-mail message
question which you raised a while back:

------------
Date: Fri, 28 May 2010 13:25:45 -0600
From: Andreas Dilger <andreas.dilger@oracle.com>
To: "linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
Cc: Zhiqi Tao <zhiqi.tao@oracle.com>
Subject: Huge flex_bg count kills mke2fs
X-Mailer: Apple Mail (2.1078)

We're trying to put all of the static ext4 metadata at the beginning
of the disk to see whether this gives us a performance improvement
(avoid seeking during e2fsck, avoid free space fragmentation).  This
is on a filesystem somewhat smaller than 16TB, and the flex_bg count
131072 would seem large enough to put all of groups into a single flex
group.

However, running the below command spins forever, apparently trying to
allocate the static metadata:

mke2fs -j -b 4096 -G 131072 -J size=1024 -i 65536 \
    -O flex_bg,uninit_bg,extents -I 256 -F /dev/vgost0/lvost0 4294965248
...
-----------

(I found it a while today when I was doing some mail searching.)

> This could be further improved by skipping full groups entirely, but
> that doesn't detract from the benefits of this patch.

Actually, given that we're using a red-black tree for the block
bitmaps these days, it's actually much more efficient than checking
the block counts to see which block groups might be free.  If the
first 4,000 block groups have been fully allocated, there will be a
single entry node in the red-black tree.  :-)

						- Ted
