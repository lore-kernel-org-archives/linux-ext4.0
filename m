From: Jan Kara <jack@suse.cz>
Subject: Re: Required help for understanding ext4 block allocation
Date: Fri, 16 Mar 2012 10:18:10 +0100
Message-ID: <20120316091810.GB24821@quack.suse.cz>
References: <CA+tw96DSaJH50o1F4sW9XMnmPD8dFO9VCyvK4tbsLFqfgK9CWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Akshay Nehe <akshaynehe785@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab2CPJSL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Mar 2012 05:18:11 -0400
Content-Disposition: inline
In-Reply-To: <CA+tw96DSaJH50o1F4sW9XMnmPD8dFO9VCyvK4tbsLFqfgK9CWQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 15-03-12 18:48:56, Akshay Nehe wrote:
> I am trying to understand the block allocation in ext4 file sytem, I
> have gone through all basic theory and browsing code to do it.
> 
> I am writing a module in which i got ext4 on disk inode, now according
> to theory first 12 bytes of i_block points to ext4_extent_header, so
> can i use this array of i_block[EXT4_N_BLOCKS].
> 
> Means how to fill objects of  struct ext4_extent_header (using first
> 12 byte of i_block) and  struct ext4_extent (using reminder bytes of
> i_block).
  struct ext4_extent_header is just directly stored in the space occupied
by i_block[EXT4_N_BLOCKS]. So for example ext_inode_hdr() does:
  (struct ext4_extent_header *)EXT4_I(inode)->i_data
(where i_data is just one-to-one copy of i_blocks from on disk inode).

And it's the same with struct ext4_extent. See for example macro
EXT_FIRST_EXTENT.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
