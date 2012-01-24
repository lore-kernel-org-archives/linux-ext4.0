From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Tue, 24 Jan 2012 14:34:36 +0100
Message-ID: <20120124133436.GA18136@quack.suse.cz>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344Ab2AXNej (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jan 2012 08:34:39 -0500
Content-Disposition: inline
In-Reply-To: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Mon 23-01-12 20:51:53, Robin Dong wrote:
> After the bigalloc-feature is completed in ext4, we could have much more
> big size of block-group (also bigger continuous space), but the extent
> structure of files now limit the extent size below 128MB, which is not
> optimal.
  It is not optimal but does it really make difference? I.e. what
improvement do you expect from enlarging extents from 128MB to say 4GB (or
do you expect to be consistently able to allocate continguous chunks larger
than 4GB?)? All you save is a single read of an indirect block... Is that
really worth the complications with another extent format? But maybe I miss
some benefit.

									Honza

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
> 
> What's your opinion?
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
