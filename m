From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] e2fsprogs: Support for large inode migration.
Date: Thu, 26 Jul 2007 12:13:25 -0400
Message-ID: <20070726161325.GB12895@thunk.org>
References: <bee58d48110eee4d5cd133167245b99644148d96.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <3ae4c55b831a13f9fbb9a187efcd65d29434bf09.1185341470.git.aneesh.kumar@linux.vnet.ibm.com> <20070725143209.GA23613@thunk.org> <46A8895A.5000308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58817 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166AbXGZQN3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Jul 2007 12:13:29 -0400
Content-Disposition: inline
In-Reply-To: <46A8895A.5000308@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 26, 2007 at 05:15:30PM +0530, Aneesh Kumar K.V wrote:
> >Let me guess, you're testing with a filesystem with two block groups,
> >right?  And to date you've tested *only* by doubling the size of the
> >inode.
> 
> I tested this with multiple ( 1 and 7 ) groups. But yes all the
> testing was to change inode size from 128 to 256.

Your patch comments stated "As a part of increasing the inode size we
throw away the free inodes in the last block group."  This is *only*
true if the filesystem has two (and exactly two) block groups.  Hence
my guess that only tested on filesystems with two block groups.

If you tested with larger numbers of block groups, the filesystem must
have been mostly empty, or at least not a large number of directories,
or else you would have noticed that most of the time that your
algorithm wouldn't work.

> I guess Undo I/O manager can go in because I have been using it for
> the ext3 -> ext4 inode migration testing and for testing the above patch.

Well, I really want a valid use case for undo code, and right now the
above patch is IMHO not suitable for merging into mainline, given all
of the problems that it has.

> Why would one need to recover on mkfs. He can very well run mkfs again 
> right ?

The idea is if there is a valid ext2/3 filesystem, and someone runs
mkfs on that filesystem, that it creates an undo file so that if
someone fumble-figured the arguments to mkfs, it becomes possible to
undo it.

In the ideal case the undo file would be copied into blocks that were
not in use by the original file, and placed into the new filesystem,
so that, so that it would be possible to undo the mkfs without needing
a separate file.  But I think it would be acceptable to say, "previous
ext3 filesystem detected; to undo the mke2fs operation, please run the
command 'undoe2fs /var/tmp/XXXX /dev/sdYY' in order to recover".


> >Presumably the only thing we can do is to abort the run and then back
> >out the chnages using what was written out to the undo file.
> >
> 
> I had a FIXME!! in the code which stated it would be nice to use the
> conf file But right now the conffile is e2fsck specific

Actually, e2fsck and mke2fs have their own config files.  An open
issue is whether we should have a separate tune2fs config file, or a
more general e2fsprogs.conf file.  Or we could have tune2fs use the
mke2fs.conf file, which is a bit of UI surprise; OTOH, tune2fs and
mke2fs do share code already, so it does make sense from a progamming
point of view.  I do consider it a UI botch, though.

Another possibility is to merge e2fsck.conf and mke2fs.conf into a
single config file, with symlinks for backwards compatibility.  My
current thinking is to just to add a new e2fsprogs.conf file, and let
tune2fs use it.  But I'm certainly willing to hear arguments for other
ways of handling this.

Or maybe we could just simply add a default of /var/lib/e2fsprogs, and
just leave it be for now.

					- Ted
