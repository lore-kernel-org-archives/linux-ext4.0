From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Ext4 improvements
Date: Wed, 10 Jan 2007 12:46:04 +0100
Message-ID: <20070110114604.GE15058@harddisk-recovery.com>
References: <45A0CEC9.5060306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:53688 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932439AbXAJLwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jan 2007 06:52:47 -0500
To: Shriramana Sharma <jamadagni@gmail.com>
Content-Disposition: inline
In-Reply-To: <45A0CEC9.5060306@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jan 07, 2007 at 04:13:21PM +0530, Shriramana Sharma wrote:
> Please be patient with my ignorance if what I am asking is meaningless
> in any way. I am not too technically knowledgeable about filesystem
> internals but I am willing to learn. (I thought of posting to linux-ext4
> but did not want to intrude within the technical threads with my layman
> thread.)
> 
> From Wikipedia > ReiserFS article > Design section:
> 
> [quote]ext2 and other Berkeley FFS-like filesystems simply use a fixed
> formula for computing inode locations, hence limiting the number of
> files they may contain. Most such filesystems also store directories as
> simple lists of entries, which makes directory lookups and updates
> linear time operations and degrades performance on very large
> directories. The single B+ tree design in ReiserFS avoids both of these
> problems due to better scalability properties.[/quote]

The large directory problem has been solved by htree dir indexing
(which is already in ext3). Now only the readahead (see other
threads)...

> So will ext4 avoid both of these problems just like ReiserFS? Does it
> use a B+ tree? Or this "dancing B* tree" that Reiser4 is supposed to have?

One of the disadvantages of having inodes all over the disk is that it
makes filesystem repair *extremely* expensive cause you have to read
*every* block of the disk to figure out if it contains inodes. Given
that drives double in size every two to three years but the drive speed
only grows with 50% max in that same period, this will become an even
bigger problem in the future. (FYI: e2fsck on a 1TB volume takes 40
minutes to an hour).

The "limiting number of files" problem is also nonexistent in my
experience: for datarecovery purposes we rebuild multiple complete
filesystem trees for customers on our own machines and *never* ran out
of inodes. Heck, I usually limit the amount of inodes to 12 million
just to limit the waste of inodes.

> Also: I found that a newly created ext3 partition uses 128 MB whereas a
> new reiser3 partition uses only 32 MB. I assume that the 128 MB is the
> space taken for the pre-allocated inodes or such.

No, it's the space taken up by the journal (which is just a special
file you can't see).

> And I now come to know
> that others have this problem much more serious on bigger filesystems -
> [see comment 2 at
> http://linux.wordpress.com/2006/09/27/suse-102-ditching-reiserfs-as-it-default-fs/]. 

That comment is wrong. Space for inodes is already allocated in
ext[234] and doesn't grow. What that poster probably sees is space
taken up by directories and/or lack of tail packing in ext[234].

> If ext4 uses a B+ (or B*?) tree like ReiserFS then this space can be
> reduced, right?

Yes, but from an fsck point of view you don't want that. It is not a
coincidence that ext[234] comes with the best filesystem repair tools.

> P.S: Are there any recommended tutorials for learning filesystem basics?

The linuxfs wiki has some interesting links: http://linuxfs.pbwiki.com/ .

> P.P.S: I just put this post here because I want to convert from reiserfs
> of uncertain future to ext4, which is time-tested.

If you like to live on the edge, ext4 is your filesystem of choice. If
you value your data, you'd rather use ext3. You are of course welcome
to test ext4 on a separate partition.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
