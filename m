From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] e2fsprogs: Handle rec_len correctly for 64KB blocksize
Date: Tue, 13 Nov 2007 08:08:36 -0700
Message-ID: <20071113150836.GM3966@webber.adilger.int>
References: <20071106113142.GA23689@duck.suse.cz> <20071107160939.GF22214@duck.suse.cz> <20071111003703.GA14815@thunk.org> <20071112095245.GA1465@duck.suse.cz> <20071112145823.GB17462@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:41622 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbXKMPIk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Nov 2007 10:08:40 -0500
Content-Disposition: inline
In-Reply-To: <20071112145823.GB17462@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Nov 12, 2007  09:58 -0500, Theodore Tso wrote:
> On Mon, Nov 12, 2007 at 10:52:45AM +0100, Jan Kara wrote:
> > > Did you test this patch before submitting it?
> >
> >   Argh, stupid me. I've just tested that I didn't break anything for normal
> > block size and thought that I cannot make mistake in such a simple thing
> > ;).
> 
> Could I ask you to perhaps include some 64k blocksize test cases that
> would exercise the new codepaths?

One thing I had done to verify that 64kB rec_len was broken was to always
create lost+found with at least 2 disk blocks, since the second block in
lost+found will not have any dirents in it and will tickle this bug.

Patch attached.

Cheers, Andreas
--
Andreas Dilger
Sr. Software Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="e2fsprogs-large_lpf.patch"

Index: e2fsprogs-cfs/misc/mke2fs.c
===================================================================
--- e2fsprogs-cfs.orig/misc/mke2fs.c
+++ e2fsprogs-cfs/misc/mke2fs.c
@@ -551,7 +551,10 @@ static void create_lost_and_found(ext2_f
 	}
 	
 	for (i=1; i < EXT2_NDIR_BLOCKS; i++) {
-		if ((lpf_size += fs->blocksize) >= 16*1024)
+		/* Ensure that lost+found is at least 2 blocks, so we always
+		 * test large empty blocks for big-block filesystems.  */
+		if ((lpf_size += fs->blocksize) >= 16*1024 &&
+		    lpf_size >= 2 * fs->blocksize)
 			break;
 		retval = ext2fs_expand_dir(fs, ino);
 		if (retval) {

--FL5UXtIhxfXey3p5--
