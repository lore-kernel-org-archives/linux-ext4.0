From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC 1/2] ext4 resize: Mark the added group with
	EXT4_BG_INODE_ZEROED flag
Date: Thu, 27 Nov 2008 17:35:11 -0500
Message-ID: <20081127223511.GA10909@mit.edu>
References: <20081121102309.182113793@bull.net> <20081121102309.507553245@bull.net> <20081127045047.GF14101@mit.edu> <18734.26807.381726.82414@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41140 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbYK0WfP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Nov 2008 17:35:15 -0500
Content-Disposition: inline
In-Reply-To: <18734.26807.381726.82414@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 27, 2008 at 10:30:31AM +0100, Solofo.Ramangalahy@bull.net wrote:
> This was really an RFC, as you also pointed out.
> Regarding this patch, the discussion raised the question of whether
> EXT4_BG_INODE_UNINIT or EXT4_BG_ITABLE_UNINIT would be more coherent
> than EXT4_BG_INODE_ZEROED wrt. EXT4_BG_INODE_UNINIT and
> EXT4_BG_BLOCK_UNINIT.

EXT2_BG_ITABLE_UNINIT (or EXT2_BG_ITABLE_PARTIALLY_UNINIT, to be more
correct) would have been better, yes.  That way legacy filesystems
that didn't enable uninit_bg would have bg_flags == 0, and we would
know that inode table was properly initialized.  Unfortunately we did
it the other way, where EXT2_BG_INODE_ZEROED is set when the inode
table is initialized, instead of the other way around.

> This is also the first use of EXT4_BG_INODE_ZEROED in the kernel, so
> an occasion to revisit the name.

Unfortunately, we've been shipping mke2fs in e2fsprogs that sets the
EXT4_BG_INODE_ZERO for newly created filesystem, and if the
lazy_itable_init configuration parameter is set, it doesn't initialize
the inode table and leaves bg_flags set to EXT2_BG_INODE_UNINIT and
EXT2_BG_BLOCK_UNINIT. 

Distributions are already shipping e2fsprogs with this, and there are
ext4 filesystems out there in the wild, so it is indeed probably way
too late to change this.

					- Ted
