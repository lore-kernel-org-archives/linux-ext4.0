From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Too large value in inode.i_blocks[1]
Date: Wed, 12 Jun 2013 09:52:04 -0400
Message-ID: <20130612135204.GA27403@thunk.org>
References: <loom.20130612T065900-326@post.gmane.org>
 <20130612125954.GB26388@thunk.org>
 <loom.20130612T152507-9@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57249 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab3FLNwH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jun 2013 09:52:07 -0400
Content-Disposition: inline
In-Reply-To: <loom.20130612T152507-9@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 12, 2013 at 01:34:37PM +0000, Felipe Monteiro de Carvalho wrote:
> I see that i_block has 15*4=60 bytes, and with EXTENTS_FL the first 12 bytes 
> of i_block are filled with a ext4_extent_header
> 
> What about the rest of it? I couldn't understand from the wiki page what
> the rest holds exactly, it is not 100% clear ...
> 
> My first guess would be that it has in this order:
> 
> ext4_extent_header, 12 bytes long
> ext4_extent_idx, 12 bytes long:
> ext4_extent, 12 bytes long
> ext4_extent_tail 4 bytes long

The ext4_extent_tail is not used in i_blocks[].  There will be up to 4
ext4_extent structures, or ext4_extent_idx structures, depending on
the depth of the tree.  The ext4_extent_idx structures are used for
the interior inodes of the tree.  The ext4_extent structures are used
for the leaf nodes of the tree.  The ext4_extent_tail is used in
extent tree blocks so we can checksum the metadata if the
metadata_csum feature is enabled.  The entire inode is checksummed, so
we don't need the ext4_extent_tail in i_blocks[].

> Please don't worry that I am not frivolously attempting to access the
> file system directly. My project explictly requires this, it is a
> recovery tool to repair damaged file systems, and it must work in
> Windows and Mac OS X. Maybe libext2fs works outside Linux, not sure, 
> but anyway we already have source code for reading/recovering ext2/3, 
> I am just expanding it to ext4. External dependencies are always
> not ideal.

Libext2fs is designed to be cross OS portable.  It's used for the FUSE
extensions that allow Mac and Windows machines to access ext2/3/4 file
systems.  And libext2fs is designed to work with corrupted file
systems, since after e2fsck is the normal tool most people use to
repair damaged file systems, and debugfs is the command line tool
which is used by people to examine file systems, corrupt fie systems
for e2fsck test cases, and in a few cases, attempt to do manual repair
of file systems in some extreme circumstances.

> I am new in the project, that's why I have so many beginner questions,
> I appologise for it, but I'm thankful that I experienced developers 
> like you answer them so that I can learn about the Linux Ext4
> file system.

Is this a student project, or a commmercial project, out of curiosity?

   	   	  	  	      	- Ted
