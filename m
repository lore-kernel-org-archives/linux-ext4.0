From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Mon, 23 Jan 2012 13:59:33 -0500
Message-ID: <20120123185933.GC9775@thunk.org>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49441 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab2AWS7g (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jan 2012 13:59:36 -0500
Content-Disposition: inline
In-Reply-To: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 23, 2012 at 08:51:53PM +0800, Robin Dong wrote:
> 
> We could solve the problem by creating a new extent format to support
> larger extent size, which looks like this:
> 
> struct ext4_extent2 {
> 	__le64	ee_block;	/* first logical block extent covers */
> 	__le64	ee_start;	        /* starting physical block */
> 	__le32	ee_len;		/* number of blocks covered by extent */
> 	__le32	ee_flags;	/* flags and future extension */
> };
>
> I think we could keep the structure of ext4_extent_header and add new
> imcompat flag EXT4_FEATURE_INCOMPAT_EXTENTS2.

The really unfortunate thing about using a 24 byte on-disk extent
structure is that you can only fit 2 extents in the inode before
needing to spill out to an external header.

So being able to support multiple exent formats in the inode (by using
a different eh_magic number) would probably be a good thing.  In fact,
it might be useful to also have a version which looks like this:

struct ext4_extent_packed {
	__le32	ee_start_lo;
	__le16	ee_start_hi;
	__le16	ee_len;
};

i.e., something which only takes 8 bytes, but which is only used for
non-sparse files in the inode structure, so that you can fit 6 extents
in the inode.

The hard part will be cleaning up and refactoring the extent code to
support multiple on-disk extent formats.  (That's going to be very
messy, though!  So if we're going to go through all of that work, it
would benice if it had advantages not for huge file systems, but also
for desktop workloads.)  Once this investment gets done, supporting a
third extent format should be relatively straight forward.

This would also allow us to make the new extent format be an RO_COMPAT
feature, so that an existing ext4 file system could be converted to
take advantage of the new extent encodings without needing to do a
backup / reformat / restore pass.

	      	    	   	     	     - Ted
