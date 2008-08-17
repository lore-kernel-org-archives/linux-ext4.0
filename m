From: Theodore Tso <tytso@mit.edu>
Subject: Re: frequent kernel bugs with 2.6.26-gentoo-r1
Date: Sun, 17 Aug 2008 08:11:23 -0400
Message-ID: <20080817121123.GD8774@mit.edu>
References: <609868.63309.qm@web25408.mail.ukl.yahoo.com> <48A76992.7090709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Markus d <supersud501@yahoo.de>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:40017 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752568AbYHQML2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Aug 2008 08:11:28 -0400
Content-Disposition: inline
In-Reply-To: <48A76992.7090709@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2008 at 06:58:10PM -0500, Eric Sandeen wrote:
> > i patched the kernel with
> > ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST-2.6.26/2.6.26-ext4-6.bz2
> > and compiled it successfully.
> > 
> > after a "ssv flags 4" and a "tune2fs -O extents" i could mount one of my
> > ext3 partitions as a ext4dev-drive. first, everything seemed to work,
> > but after some read/write to that drive i got the first kernel oops.

You don't have to use debugfs to set "ssv flags 4" anymore.  If you
are converting an existing ext3 filesystem, "tune2fs -E test_fs -O
extents /dev/sdXXX" works just fine.  Please see:

	http://ext4.wiki.kernel.org/index.php/Ext4_Howto

> > thought it might be because it was an old ext3-drive, so i formated the
> > drive with mkfs.ext4dev. but no change, still the same problems. now i'm
> > nearly always getting a kernel bug on umounting an ext4-drive (and then
> > the device is not accessible/mountable anymore). here's the recent one:
> > 
> > [  830.270166] ------------[ cut here ]------------
> > [  830.270166] kernel BUG at fs/ext4/inode.c:1561!
> > [  830.270166] invalid opcode: 0000 [1] PREEMPT SMP
> 
> 
> <lazy>can you correlate to where this is in the 2.6.26.2 kernel?</lazy>

I'm guessing that it's this BUG_ON in ext4_da_release_space:

    BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);

which was addressed by fix-delalloc-release-block-reservation-for-truncate
in the ex4 patch queue.  

The only thing which is funny is that if this is true, this bug has
only hit ext3 filesysem that had been converted to ext4 --- and
Markus, you said you have hit errors on a filesystem that was freshly
created using mkfs.ext4dev?     

Ah....  I think I know, #1 are you using e2fsprogs 1.41.0, and #2,
I'll bet you compiled from source and didn't install the new
mke2fs.conf file that comes with e2fsprogs 1.41.0.  It is critically
important that mke2fs for 1.41.0 use the mke2fs.conf file that is
shipped with e2fsprogs 1.41.0 as a starting point.  If you don't, and
you use the old mke2fs.conf from previous releases, mkfs.ext4dev won't
actually enable extents, so you don't get the benefits of ext4, and
the bugs trigger when you delete non-extent files when the filesystem
is mounted using ext4dev.

In any case, the two patches that you want are:

	ext4-fix-no-extent-truncate-i_prealloc-bug
	fix-delalloc-release-block-reservation-for-truncate

in the ext4 patch queue[1], or just wait a few days and I'll get a
patchset out versus 2.6.26 quickly.  It would be sooner, but there are
few other patches I'm hoping we can stablize, and I'm currently at a
family reunion in Baltimore for the next few days, so I don't know how
much ext4 hacking time I'll have.

[1] The git repository is at:   http://repo.or.cz/w/ext4-patch-queue.git

BTW, I've updated the Ext4 Howto in the Wiki with this information, so
hopefully it will help other people who are trying out ext4.

	     	       	     	    	    	   - Ted
