From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Thu, 26 Jan 2012 09:48:47 +1100
Message-ID: <20120125224847.GT15102@dastard>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:45764 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab2AYWsu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Jan 2012 17:48:50 -0500
Content-Disposition: inline
In-Reply-To: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 23, 2012 at 08:51:53PM +0800, Robin Dong wrote:
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
> 
> What's your opinion?

Just use XFS.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
