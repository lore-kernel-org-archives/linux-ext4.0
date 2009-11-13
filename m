From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: don't swap extent-based journal backup on
	read
Date: Thu, 12 Nov 2009 22:45:19 -0500
Message-ID: <20091113034519.GA11891@mit.edu>
References: <4AF9D0F8.6020609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42788 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbZKMDpP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Nov 2009 22:45:15 -0500
Content-Disposition: inline
In-Reply-To: <4AF9D0F8.6020609@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 10, 2009 at 02:45:44PM -0600, Eric Sandeen wrote:
> The f_illitable_flexbg test was failing on ppc, because
> e2fsck_move_ext3_journal is doing a direct memcmp of i_block with 
> s_jnl_blocks, and failing.
> 
> This is because we don't swap extent data on read from disk; rather
> we do it when we access the extents.  However, ext2fs_swap_super
> was swapping s_jnl_blocks unconditionally, so these didn't match.
> 
> Looks like we need to treat s_jnl_blocks the same as i_block, and
> swap it on access, not on read.  Except for the last i_size bit...
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied to the maint branch, thanks.

							- Ted
