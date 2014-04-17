From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Make huge files strictly contiguous (fallocate, bigalloc,
 e4defrag...)
Date: Thu, 17 Apr 2014 11:24:57 -0400
Message-ID: <20140417152457.GE18591@thunk.org>
References: <534F39F6.2000208@ovh.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Contact <neitsab@ovh.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56547 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaDQPZA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 11:25:00 -0400
Content-Disposition: inline
In-Reply-To: <534F39F6.2000208@ovh.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 17, 2014 at 04:18:30AM +0200, Contact wrote:
> 
> I'm trying to create a multiboot medium using Easy2Boot on a 64 GB USB
> key. Easy2Boot [1] is a "software" (well a collection of files really)
> that relies on grub4dos [2] to work and thus requires payload files to
> be strictly contiguous to do its trick. It's supposed to be set up once
> and then one just has to add files to boot from to a folder to modify
> the multiboot setup.
> 
> The ISO files I have are between 230 MB and 2 GB each. I divided my USB
> drive into two partitions : first one, 16 GB ntfs formatted so that
> grub4dos actually works (for some reasons it doesn't with ext4, plus I
> want to be able to use it with other OS); second one 48 GB formatted as
> ext4 with e2fsprogs version 1.42.9 from Archlinux. However when I try
> to boot from those files I systematically get the "file not contiguous"
> error in Easy2Boot.
> 
> Question is: is it possible to make huge files strictly contiguous on
> ex4, and if yes how?

Most of the time, files don't have to be "strictly contiguous", so
that's not something that we've spent a lot of time trying to achieve.

There is a way to do this if you are willing to use the tip of the
e2fsprogs "maint" branch, and then you put something like this into
your mke2fs.conf file:

	easy2boot = {
		features = extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,^resize_inode,sparse_super2
		hash_alg = half_md4
		num_backup_sb = 0
		packed_meta_blocks = 1
		make_hugefiles = 1
		inode_ratio = 4194304
		hugefiles_dir = /
		hugefiles_name = my-big-file
		hugefiles_digits = 0
		hugefiles_size = 16G
		num_hugefiles = 1
		zero_hugefiles = false
	}

Then "mke2fs -T easy2boot /dev/sdc1" will create an ext4 filesystem
with a file called /my-big-file which is guaranteed to be contiguous.

For your particular use case, where you want to create a new
filesystem when you want to create your strictly contiguous file, this
might be the best way to go.

Cheers,

						- Ted

