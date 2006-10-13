From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Design alternatives for fragments/file tail support in ext4
Date: Fri, 13 Oct 2006 14:48:41 +0200
Message-ID: <20061013124841.GE21842@harddisk-recovery.com>
References: <E1GXeYv-0006rP-RV@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:13040 "HELO abra2.bitwizard.nl")
	by vger.kernel.org with SMTP id S1751666AbWJMMso (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Oct 2006 08:48:44 -0400
To: Theodore Ts'o <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <E1GXeYv-0006rP-RV@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 11, 2006 at 09:55:57AM -0400, Theodore Ts'o wrote:

[...]

> 2.  Increase the ability to be able to read from the disk in contiguous
>     reads and writes.   Modern disks use internal cluster sizes of 32k
>     and up at this point.  Hence, allocating blocks in 32k chunks at a
>     time is extremely helpful.

It's only useful if you can start the partition at such a 32k chunk,
otherwise you end up having the disk reading two such chunks for every
chunk the filesystem reads.

Unfortunately the current linux fdisk implementation insists on putting
partitions on track boundaries cause some other OS thinks that's a good
idea cause it was indeed a good idea back when disks didn't lie about
their physical layout. Right now disks all claim to have 63
sectors/track so we end up having partitions starting at 32k - 512
bytes. By overriding the physical layout in fdisk you can get a better
layout, but unfortunately that behaviour isn't standard.

> Storing the tail as an extended attribute
> =========================================
> 
> Stephen and I have discussed this in the past, and the idea is a simple
> one; simply store the tail as an extended attribute.  There are other
> filesystems that have done this, most notably NTFS (post-Windows 2000).
> However, this approach is a little unsatisfying to me, since it buys us
> nothing if there are no other extended attributes contained by the
> filesystem, and if we are using large inodes to accelerate extended
> attributes, there won't be much space for any but the smallest tails
> (i.e., if we are using 4k blocks, and 512 byte inodes, the largest tail
> that we could store using this method is around 350 bytes or so.)

That isn't very different from NTFS, which usually has 1k sized MFT
records (Master File Table records, which combine inode information but
also store the name of the file) that are usually filled for around 400
to 500 bytes. You can tell mkfs.ntfs (or whatever it is called in
Windows) that you want larger MFT records so you have more room for
inline files or tails.

Although some people claim that Windows uses extended attributes quite
often, we don't see that in practice when we recover data from broken
disks. The last time I've seen extended attributes used was when a
virusscanner put a checksum in an extended attribute. Oh, and there was
a machine which served files for MacOS machines so it had the resource
fork and finder info in separate attributes.

Extended attributes might be used more on Linux, especially because
distributions are moving to selinux so the room in an inode becomes a
lot smaller for storing tail data.

> Using this technique would only require a flag in the inode indicating
> it has a fragment, so the filesystem knows to look for the extended
> attribute.  In theory this could also be done by checking the i_size
> field, and assuming that last block in the file can never normally be a
> hole, but this can be quite fragile.

Better be explicit about fragments, that also makes e2fsck easier.

> Tail merging
> ============

[...]

Another way (and I can't find which filesystem exactly uses it) is to
store all tails within a certain size range in a special file for that
particular range. So for example if your filesystem has a 64k
blocksize, it has files for 512, 1k, 1.5k, 2k till 63.5k. If a tail
falls within 0 and 512 bytes, it's stored in the special file for 512
bytes, it's within 512 and 1k it's stored in the 1k file, etc. The
special files are normal files with a special meaning. Of course you
need to do some bookkeeping for the contents of the special files but
you need that for every way to manage tails you proposed.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
