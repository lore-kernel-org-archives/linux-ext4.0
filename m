From: Theodore Tso <tytso@mit.edu>
Subject: Re: Question on block group allocation
Date: Sun, 26 Apr 2009 22:14:11 -0400
Message-ID: <20090427021411.GA9059@mit.edu>
References: <6601abe90904230941x5cdd590ck2d51410326df2fc5@mail.gmail.com> <20090423190817.GN3209@webber.adilger.int> <6601abe90904231502y393155dbrf8913b728c704320@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39679 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381AbZD0COR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Apr 2009 22:14:17 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90904231502y393155dbrf8913b728c704320@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 23, 2009 at 03:02:05PM -0700, Curt Wohlgemuth wrote:
> > This is likely the "uninit_bg" feature that is causing the allocati=
ons
> > to skip groups which are marked BLOCK_UNINIT. =A0In some sense the =
benefit
> > of skipping the block bitmap read during e2fsck is probably not at =
all
> > beneficial compared to the cost of the extra seeking during IO. =A0=
As the
> > filesystem gets more full, the BLOCK_UNIIT flags would be cleared a=
nyways,
> > so we might as well just keep the early allocations contiguous.

Well, I tried out Andreas' patch, by doing an rsync copy from my SSD
root partition to a 5400 rpm laptop drive, and then ran e2fsck and
dumpe2fs.  The results were interesting:

               Before Patch			  After Patch
	      Time in seconds			Time in seconds
	    Real /  User/  Sys   MB/s	   Real /  User/  Sys    MB/s	  =20
Pass 1      8.52 / 2.21 / 0.46  20.43	   8.84 / 4.97 / 1.11   19.68
Pass 2	   21.16 / 1.02 / 1.86  11.30	   6.54 / 1.77 / 1.78   36.39
Pass 3 	    0.01 / 0.00 / 0.00 139.00	   0.01 / 0.01 / 0.00  128.90
Pass 4	    0.16 / 0.15 / 0.00   0.00	   0.17 / 0.17 / 0.00    0.00
Pass 5	    2.52 / 1.99 / 0.09   0.79	   2.31 / 1.78 / 0.06	 0.86
Total	   32.40 / 5.11 / 2.49  12.81	  17.99 / 8.75 / 2.98	23.01

The surprise is in the gross inspection of the dumpe2fs results:

    	     	       	     Before Patch    After Patch
# of non-contig files  	     	762	        779
# of non-contig directories	571		570
# of BLOCK_UNINIT bg's		307		293
# of INODE_UNINIT bg's		503		503

So the interesting thing is that the patch only "broke open" an
additional 14 block groups (out of a 333 block groups in use when the
filesystem was created with the unpatched kernel).  However, this
allowed the pass 2 directory time to go *down* by over a factor of
three (from 21.2 seconds with the unpatched ext4 code to 6.5 seconds
with the the patch.

I think what the patch did was to diminish allocation pressure on the
first block group in the flex_bg, so we weren't mixing directory and
regular file contents.  This eliminated seeks during pass 2 of e2fsck,
which was actually a Very Good Thing.

> > A simple change to verify this would be something like the followin=
g,
> > but it hasn't actually been tested.
>=20
> Tell you what:  I'll try this out and see if it helps out my test cas=
e.

Let me know what this does for your test case.  Hopefully the patch
also makes things better, since this patch is looking very interesting
right now.

Andreas, can I get a Signed-off-by from you for this patch?=20

Thanks,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
