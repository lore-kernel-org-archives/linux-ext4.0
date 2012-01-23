From: Robin Dong <hao.bigrat@gmail.com>
Subject: [RFC] Add new extent structure in ext4
Date: Mon, 23 Jan 2012 20:51:53 +0800
Message-ID: <CAFZ0FUXT-X146SEAHCcNh-bGARUTgLOSP1dCrqeOrT48REN+ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46451 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969Ab2AWMvy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jan 2012 07:51:54 -0500
Received: by obcva7 with SMTP id va7so2949608obc.19
        for <linux-ext4@vger.kernel.org>; Mon, 23 Jan 2012 04:51:53 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, Andreas and the list,

After the bigalloc-feature is completed in ext4, we could have much more
big size of block-group (also bigger continuous space), but the extent
structure of files now limit the extent size below 128MB, which is not
optimal.

We could solve the problem by creating a new extent format to support
larger extent size, which looks like this:

struct ext4_extent2 {
	__le64	ee_block;	/* first logical block extent covers */
	__le64	ee_start;	        /* starting physical block */
	__le32	ee_len;		/* number of blocks covered by extent */
	__le32	ee_flags;	/* flags and future extension */
};

struct ext4_extent2_idx {
	__le64	ei_block;	        /* index covers logical blocks from 'block' */
	__le64	ei_leaf;	        /* pointer to the physical block of the next level */
	__le32	ei_flags;	        /* flags and future extension */
	__le32	ei_unused;	/* padding */
};

I think we could keep the structure of ext4_extent_header and add new
imcompat flag EXT4_FEATURE_INCOMPAT_EXTENTS2.

The new extent format could support 16TB continuous space and larger volumes.

What's your opinion?

-- 
--
Best Regard
Robin Dong
