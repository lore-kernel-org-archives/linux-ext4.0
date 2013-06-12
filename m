From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Too large value in inode.i_blocks[1]
Date: Wed, 12 Jun 2013 08:59:54 -0400
Message-ID: <20130612125954.GB26388@thunk.org>
References: <loom.20130612T065900-326@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57238 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab3FLM75 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 08:59:57 -0400
Content-Disposition: inline
In-Reply-To: <loom.20130612T065900-326@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 12, 2013 at 05:08:21AM +0000, Felipe Monteiro de Carvalho wrote:
> 
> Continuing in my adventures with ext4, now I am having
> a problem that when reading the root
> inode everything is fine. 
> When reading the inodes of directories placed on the file system root,
> my reading fails, because inode.i_blocks has the following data 
> (for 1 particular subdir for example):
> 
> 127754,
> 4,
> 0,
> 0,
> 1,
> 1366,
> 0,...
> 
> The root works because in its inode i_blocks[1] has a smaller, 
> in-bounds value, but this one has
> the first value completely out of bounds of the filesystem =(
> 
> My ext4 filesystem has 3 incompat flags set: EXT4_FEATURE_INCOMPAT_FILETYPE,
> EXT4_FEATURE_INCOMPAT_EXTENTS, EXT4_FEATURE_INCOMPAT_FLEX_BG

The inode in question has the EXTENTS_FL flag set, which means the
i_blocks[] array needs to get interpreted as the root node of the
extent tree. 127754 is 0x0001F30A, where F30A is the magic number for
the extents header, and 0x0001 means there is a single entry in the
extent node.

I **strongly** discourage people from trying to access the file system
directly.  It's much better to use the libext2fs library, since it
will deal with these sorts of issues for you automatically.  A
program, even one written years ago, which uses the block iterator, or
the directory iterator, or the namei function, or the
ext2fs_file_{open,read,write,llseek}() functions provided by
libext2fs, would have continued working when ext4 appeared, since we
added ext4 support to the libext2fs library in such a way that older
programs would continue working just fine.

A good example of such a user of libext2fs is the e2tools userspace
package.

Regards,

						- Ted
