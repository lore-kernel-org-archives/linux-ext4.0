From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Make huge files strictly contiguous (fallocate, bigalloc,
 e4defrag...)
Date: Sun, 20 Apr 2014 15:01:46 -0400
Message-ID: <20140420190146.GB29727@thunk.org>
References: <534F39F6.2000208@ovh.fr>
 <20140417152457.GE18591@thunk.org>
 <5350205E.3030403@ovh.fr>
 <alpine.LFD.2.00.1404181042200.2128@localhost.localdomain>
 <5353DBC2.5080708@ovh.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Contact <neitsab@ovh.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50781 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaDTTBv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Apr 2014 15:01:51 -0400
Content-Disposition: inline
In-Reply-To: <5353DBC2.5080708@ovh.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 20, 2014 at 04:37:54PM +0200, Contact wrote:
> While we're at it, how can I do this? I searched the 
> mkfs.ext4/mke2fs.conf/ext4/tune2fs man pages for the option to turn off 
> writing backup superblock you mentioned, however the closest I found is 
> tune2fs -O ^sparse_super which is part of the defaults mke2fs.conf 
> options... Could you point me at it so that I can try to get this 
> source of non-contiguity away?

This requires recompiling e2fsprogs using the tip of the maint branch,
as I had suggested earlier (and which you had ruled out because you
didn't want to build your own e2fsprogs from source).

Once you do this, and you put the following in 

	hugefiles = {
		features = extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,^resize_inode,sparse_super2
		hash_alg = half_md4
		num_backup_sb = 0
		packed_meta_blocks = 1
		flex_bg_size = 262144
		inode_ratio = 4194304
		make_hugefiles = 1
		hugefiles_dir = /boot
		hugefiles_name = contig-files
		hugefiles_digits = 1
		hugefiles_size = 256M
		num_hugefiles = 3
	}

Using the sparse_super2 feature and setting num_backup_sb=0 disables
the backup superblocks.  Then setting flex_bg_size to a very large
value (262144 in this case), will force all of the allocation bitmaps
and inodetables to the very beginning of the file system.

The inode_ratio setting simply radically reduces the number of inodes
in the file system.  That was there because originally I was using
this this command set with the hugefiles_size set to 1 or 2 gigabytes,
and filling the disk with completely with large files (num_hugefiles =
0 means "create as many huge files as necessary to fill the disk). 

The rest of the "hugefiles" related settings are just simply allowing
mke2fs to create the contiguous files for you.

Note that because this uses a new compat feature, "sparse_super2", if
you use the new mke2fs to create such a file system, you will also
need to make sure the file system is checked using a version of e2fsck
that supports this new feature as well.  No kernel changes are
required to support this, though.

Cheers,

					- Ted

