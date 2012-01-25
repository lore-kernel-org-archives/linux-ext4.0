From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] Add new extent structure in ext4
Date: Wed, 25 Jan 2012 16:03:09 -0700
Message-ID: <4C9A2CF5-A980-43A0-9D43-56EA45DA096C@dilger.ca>
References: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com> <20120125224847.GT15102@dastard>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Robin Dong <hao.bigrat@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:64804 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2AYXDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jan 2012 18:03:11 -0500
In-Reply-To: <20120125224847.GT15102@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-01-25, at 3:48 PM, Dave Chinner wrote:
> On Mon, Jan 23, 2012 at 08:51:53PM +0800, Robin Dong wrote:
>> Hi Ted, Andreas and the list,
>> 
>> After the bigalloc-feature is completed in ext4, we could have much more
>> big size of block-group (also bigger continuous space), but the extent
>> structure of files now limit the extent size below 128MB, which is not
>> optimal.
>> 
>> We could solve the problem by creating a new extent format to support
>> larger extent size, which looks like this:
>> 
>> struct ext4_extent2 {
>> 	__le64	ee_block;	/* first logical block extent covers */
>> 	__le64	ee_start;	        /* starting physical block */
>> 	__le32	ee_len;		/* number of blocks covered by extent */
>> 	__le32	ee_flags;	/* flags and future extension */
>> };
>> 
>> struct ext4_extent2_idx {
>> 	__le64	ei_block;	        /* index covers logical blocks from 'block' */
>> 	__le64	ei_leaf;	        /* pointer to the physical block of the next level */
>> 	__le32	ei_flags;	        /* flags and future extension */
>> 	__le32	ei_unused;	/* padding */
>> };
>> 
>> I think we could keep the structure of ext4_extent_header and add new
>> imcompat flag EXT4_FEATURE_INCOMPAT_EXTENTS2.
>> 
>> The new extent format could support 16TB continuous space and larger volumes.
>> 
>> What's your opinion?
> 
> Just use XFS.

Thanks for your troll.

If you have something actually useful to contribute, please feel free to post.
Otherwise, this is a list for ext4 development.

I don't encourage XFS users to switch to ext4 (or ZFS, for that matter, since
ZFS can do a lot of things that just aren't possible for XFS, and is now
available for Linux) on your mailing lists, and I'd appreciate the same
courtesy here...

Cheers, Andreas

