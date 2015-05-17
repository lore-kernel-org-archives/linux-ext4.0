From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/14] libext2fs: use fallocate for creating journals and
 hugefiles
Date: Sat, 16 May 2015 23:39:25 -0400
Message-ID: <20150517033925.GH4489@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002219.10785.76994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40835 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbbEQDj1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 May 2015 23:39:27 -0400
Content-Disposition: inline
In-Reply-To: <20150514002219.10785.76994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 05:22:19PM -0700, Darrick J. Wong wrote:
> Use the new fallocate API for creating the journal and the mk_hugefile
> feature.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I tried applying patches 9-11, and I found a regression.  If you add
the following stanza to /etc/mke2fs.conf:

	hugefile = {
		features = extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,^resize_inode,sparse_super2
		hash_alg = half_md4
		num_backup_sb = 0
		packed_meta_blocks = 1
		make_hugefiles = 1
		inode_ratio = 4194304
		hugefiles_dir = /store
		hugefiles_name = big-data
		hugefiles_digits = 0
		hugefiles_size = 0
		hugefiles_align = 256M
		num_hugefiles = 1
		zero_hugefiles = false
		flex_bg_size = 262144
	}

... then "mke2fs -Fq -T hugefile /dev/sdXX" should create a file
system with a single file /store/big-data that starts at offset 256M
and consumes the rest of the space.  For example, try the commands

% time mke2fs -Fq -T hugefile /tmp/foo.img 8T
% debugfs -R "extents /store/big-data" /tmp/foo.img

With this patch applied, the file /store/big-data is a zero-length
file, instead of a very big file consuming the whole disk.

Arguably there should have been a test so that this regression would
be detected automatically.  I'll take care of adding it.

(BTW, note how quickly the file /store/big-data is created using the
mk_hugefile code.  Although I understand the new fallocate code is
more general, hopefully this generality doesn't cause performance
regression in terms of the file system layout or CPU time required to
create the big-data file.)

> --- a/tests/r_32to64bit_meta/expect
> +++ b/tests/r_32to64bit_meta/expect
> @@ -35,8 +35,8 @@ Change in FS metadata:
>   Inode count:              65536
>   Block count:              524288
>   Reserved block count:     26214
> --Free blocks:              858
> -+Free blocks:              852
> +-Free blocks:              857
> ++Free blocks:              851
>   Free inodes:              65046
>   First block:              1
>   Block size:               1024

Why these changes?  This implies the new fallocate code isn't creating
an extent tree that isn't quite as efficient as the original code?

   	       	    	  	   	     - Ted
