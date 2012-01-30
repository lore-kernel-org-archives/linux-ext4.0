From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Mon, 30 Jan 2012 14:41:53 -0600
Message-ID: <4F270091.3050000@redhat.com>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab2A3Ul6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jan 2012 15:41:58 -0500
In-Reply-To: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/23/12 6:51 AM, Robin Dong wrote:
> Hi Ted, Andreas and the list,
> 
> After the bigalloc-feature is completed in ext4, we could have much more
> big size of block-group (also bigger continuous space), but the extent
> structure of files now limit the extent size below 128MB, which is not
> optimal.
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
> struct ext4_extent2_idx {
> 	__le64	ei_block;	        /* index covers logical blocks from 'block' */
> 	__le64	ei_leaf;	        /* pointer to the physical block of the next level */
> 	__le32	ei_flags;	        /* flags and future extension */
> 	__le32	ei_unused;	/* padding */
> };
> 
> I think we could keep the structure of ext4_extent_header and add new
> imcompat flag EXT4_FEATURE_INCOMPAT_EXTENTS2.
> 
> The new extent format could support 16TB continuous space and larger volumes.

(larger volumes?)

> What's your opinion?
> 

I think that mailing list drama aside ;) Dave has a decent point that we shouldn't
allow structures to scale out further than the code *using* them can scale.

In other words, if we already have some trouble being efficient with 2^32 blocks
in a file, it is risky and perhaps unwise to allow even larger files, until
those problems are resolved.  At a minimum, I'd suggest that such a change
should not go in until it is demonstrated that ext4 can, in general, handle such
large file sizes efficiently.

It'd be nice to be able to self-host large sparse images for large fs testing,
though.

I suppose bigalloc solves that a little, though with some backing store space
usage penalty.  I suppose if a bigalloc fs is hosted on a bigalloc fs, things
should (?) line up and be reasonable.

-Eric
