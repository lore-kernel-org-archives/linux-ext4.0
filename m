From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: remove duplicate default values in mke2fs.conf
Date: Thu, 16 Feb 2017 11:28:47 -0500
Message-ID: <20170216162847.5qjwfr6lvy6rdzgv@thunk.org>
References: <20170211151535.3242-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: EXT4 ml <linux-ext4@vger.kernel.org>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39244 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932385AbdBPQ2u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 16 Feb 2017 11:28:50 -0500
Content-Disposition: inline
In-Reply-To: <20170211151535.3242-1-xose.vazquez@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 11, 2017 at 04:15:35PM +0100, Xose Vazquez Perez wrote:
> @@ -12,11 +12,9 @@
>  	}
>  	ext4 = {
>  		features = has_journal,extent,huge_file,flex_bg,uninit_bg,64bit,dir_nlink,extra_isize
> -		inode_size = 256
>  	}
>  	ext4dev = {
>  		features = has_journal,extent,huge_file,flex_bg,uninit_bg,inline_data,64bit,dir_nlink,extra_isize
> -		inode_size = 256
>  		options = test_fs=1
>  	}
>  	small = {

These are duplicate values (although they don't do any harm).

> @@ -47,6 +45,5 @@
>  		blocksize = -1
>  	}
>  	hurd = {
> -	     blocksize = 4096
>  	     inode_size = 128
>  	}

This value *is* required.  The Hurd has a re-implementation of the
ext2/3/4 file system, which is very limited.  One of its limitations
is the block size must be equal to the page size (and it only works on
x86.)   So the "blocksize = 4096" is required so that:

	mke2fs -o hurd /tmp/foo.img 1024

will use a 4k block size even for small file systems.

     	      	    	      - Ted
