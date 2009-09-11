From: Theodore Tso <tytso@mit.edu>
Subject: Re: flex_bg information initialization and question on resize/bad
	inodes with 48 bits filesystem
Date: Fri, 11 Sep 2009 14:35:40 -0400
Message-ID: <20090911183540.GB28764@mit.edu>
References: <4AAA8F6C.6030206@partition-saving.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Damien Guibouret <damien.guibouret@partition-saving.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43116 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZIKSfj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2009 14:35:39 -0400
Content-Disposition: inline
In-Reply-To: <4AAA8F6C.6030206@partition-saving.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 11, 2009 at 07:57:00PM +0200, Damien Guibouret wrote:
>
> I have looked at the new features provided by ext4 and have a question  
> on flex_bg information initialization:
> into ext4_fill_flex_info function of fs/ext4/super.c (lines 1698, 1700  
> and 1702 for kernel 2.6.31) doesn't the atomic_set calls be atomic_add  
> to sum statistics of each group composing a flex group, or do I  
> misunderstand something ?

Good eye; that's a bug; thanks for pointing that out.

> For the extension to manage 48 bits blocks number, I do not see anything  
> to treat this for resize and bad inodes into kernel or e2fsprogs. For  
> the resize inode, it is perhaps an incompatibility of this feature with  
> 48 bits blocks number, but for the bad inode ?

There is a plan for how to handle online resizing for > 2^32 block
filesystems, but it hasn't been implemented yet.  The basic support
for it is there; that's what the META_BG feature is designed to
support, so existing kernels will be able to deal with resized large
filesystemes.  But the code to actually do the on-line resizing hasn't
been implemented yet.

For the bad block inode, the solution is to make it be extent mapped
inode.  This also hasn't been implemented yet, but this is a much
simpler one to write.  The main reason why we haven't is that modern
disks rarely have system-visible bad blocks; normally the hard drive
has its own bad block remapping layer in hardware so we never see a
bad block until the disk is failing so badly it needs to be replaced
ASAP.

						- Ted
